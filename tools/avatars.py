from pathlib import Path
from PIL import Image, ImageOps
import json
folder=Path('Contact images')
lines=['/* Generated contact portraits. */']
entries=[]
for p in sorted(folder.glob('*')):
    if p.suffix.lower() not in ('.png','.jpg','.jpeg'): continue
    with Image.open(p) as im:
        im=ImageOps.fit(ImageOps.exif_transpose(im).convert('RGB'),(28,28))
        values=[0x8000|(r>>3)|((g>>3)<<5)|((b>>3)<<10) for r,g,b in im.getdata()]
    i=len(entries); entries.append((p.stem,i))
    lines.append('static const unsigned short portrait_%d[784]={%s};'%(i,','.join(map(str,values))))
lines.append('static const unsigned short *avatar(const char *name){')
for name,i in entries: lines.append('if(!strcasecmp(name,%s))return portrait_%d;'%(json.dumps(name,ensure_ascii=False),i))
lines.append('return NULL;}')
Path('source/avatars.h').write_text('\n'.join(lines)+'\n')
