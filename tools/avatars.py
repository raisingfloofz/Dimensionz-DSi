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
