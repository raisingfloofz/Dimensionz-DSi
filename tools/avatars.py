from pathlib import Path
from PIL import Image, ImageOps
import json

lines = ['/* Generated portraits. */']
entries = []
for folder, prefix in [('Contact images', ''), ('USERS', 'USER:')]:
    for p in sorted(Path(folder).glob('*')):
        if p.suffix.lower() not in ('.png', '.jpg', '.jpeg'):
            continue
        try:
            with Image.open(p) as im:
                im = ImageOps.fit(ImageOps.exif_transpose(im).convert('RGB'), (64, 64) if prefix else (28, 28), centering=(0.5, 0.0) if prefix and p.stem.lower() == "bia" else (0.5, 0.5))
                values = [0x8000 | (r >> 3) | ((g >> 3) << 5) | ((b >> 3) << 10) for r,g,b in im.getdata()]
        except (OSError, ValueError) as exc:
            print(f'::warning::Skipping unreadable portrait {p}: {exc}')
            continue
        i = len(entries)
        entries.append((prefix + p.stem, i))
        lines.append('static const unsigned short portrait_%d[%d]={%s};' % (i, len(values), ','.join(map(str, values))))
lines.append('static const unsigned short *avatar(const char *name){')
for name, i in entries:
    lines.append('if(!strcasecmp(name,%s))return portrait_%d;' % (json.dumps(name), i))
lines.append('return NULL;}')
Path('source').mkdir(exist_ok=True)
Path('source/avatars.h').write_text('\n'.join(lines)+'\n')
print(f'Generated {len(entries)} portraits.')

# Embed repository WAV files in the existing generated header artifact.
import wave, struct
audio = ['#define DZ_AUDIO 1']
rows = []
for name in ('typing', 'received', 'sent'):
    try:
        with wave.open(str(Path('Sounds') / (name + '.wav')), 'rb') as w:
            if (w.getnchannels(), w.getsampwidth(), w.getframerate(), w.getcomptype()) != (1, 2, 22050, 'NONE'):
                raise ValueError('Expected mono 16-bit PCM WAV at 22050 Hz')
            raw = w.readframes(w.getnframes())
        if not raw or len(raw) > 440000:
            raise ValueError('Empty or too long (maximum 10 seconds)')
        raw += bytes((-len(raw)) % 4)
        values = struct.unpack('<' + 'h' * (len(raw)//2), raw)
        audio.append('static const short sfx_%s[] __attribute__((aligned(32))) = {%s};' % (name, ','.join(map(str, values))))
        rows.append('{sfx_%s,sizeof(sfx_%s)}' % (name,name))
        print('Embedded sound:', name)
    except (OSError, ValueError, EOFError, wave.Error) as exc:
        print(f'::warning::Skipping sound {name}: {exc}')
        rows.append('{NULL,0}')
audio.append('static const struct {const short *data; unsigned bytes;} dz_audio[] = {' + ','.join(rows) + '};')
with Path('source/avatars.h').open('a') as out:
    out.write('\n'.join(audio)+'\n')
