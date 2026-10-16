"""Draws the app icon (a small planner grid on ink blue) at every size the site and Android app need.
Run once: python3 scripts/make-icons.py   (outputs are committed)"""
from PIL import Image, ImageDraw
import glob, os

INK, PAPER, RULE = (53, 92, 140), (246, 248, 251), (214, 221, 231)
PASTEL = {'r': (242, 195, 190), 'g': (196, 227, 198), 'b': (188, 216, 244), 'p': (219, 203, 239)}
# 4 rows x 6 cells, like an hour row of 10-minute boxes
PATTERN = ['rrr...', '..gggg', 'bbbb..', '...ppp']

def mark(size, bg=True, scale=1.0, radius=0.22):
    S = 1024
    im = Image.new('RGBA', (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    if bg:
        d.rounded_rectangle([0, 0, S - 1, S - 1], radius=int(S * radius), fill=INK)
    cw, ch = 0.64 * S * scale, 0.56 * S * scale           # paper card
    x0, y0 = (S - cw) / 2, (S - ch) / 2
    d.rounded_rectangle([x0, y0, x0 + cw, y0 + ch], radius=int(S * 0.05 * scale), fill=PAPER)
    pad = 0.06 * S * scale
    gx, gy, gw, gh = x0 + pad, y0 + pad, cw - 2 * pad, ch - 2 * pad
    cols, rows, gap = 6, 4, 0.012 * S * scale
    cwid, chei = (gw - gap * (cols - 1)) / cols, (gh - gap * (rows - 1)) / rows
    for r, line in enumerate(PATTERN):
        for c, ch_ in enumerate(line):
            cx, cy = gx + c * (cwid + gap), gy + r * (chei + gap)
            d.rounded_rectangle([cx, cy, cx + cwid, cy + chei], radius=int(S * 0.012 * scale),
                                fill=PASTEL.get(ch_, RULE))
    return im.resize((size, size), Image.LANCZOS)

def silhouette(size):
    """White notification icon: grid outline on transparent."""
    S = 1024
    im = Image.new('RGBA', (S, S), (0, 0, 0, 0)); d = ImageDraw.Draw(im)
    for r, line in enumerate(PATTERN):
        for c, ch_ in enumerate(line):
            x, y = 120 + c * 132, 200 + r * 160
            if ch_ != '.': d.rounded_rectangle([x, y, x + 112, y + 136], radius=18, fill=(255, 255, 255, 255))
            else: d.rounded_rectangle([x + 40, y + 52, x + 72, y + 84], radius=8, fill=(255, 255, 255, 255))
    return im.resize((size, size), Image.LANCZOS)

os.makedirs('public/icons', exist_ok=True)
mark(192).save('public/icons/icon-192.png'); mark(512).save('public/icons/icon-512.png')
mark(180, radius=0).save('public/icons/apple-touch-icon.png'); mark(64).save('public/icons/favicon.png')
mark(512, scale=0.8, radius=0).save('public/icons/icon-maskable-512.png')

res = 'android/app/src/main/res'
for dpi, n in {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}.items():
    mark(int(48 * n)).save(f'{res}/mipmap-{dpi}/ic_launcher.png')
    m = Image.new('RGBA', (int(48 * n),) * 2, (0, 0, 0, 0)); circ = mark(int(48 * n), radius=0.5); m.paste(circ, (0, 0), circ)
    m.save(f'{res}/mipmap-{dpi}/ic_launcher_round.png')
    mark(int(108 * n), bg=False, scale=0.62).save(f'{res}/mipmap-{dpi}/ic_launcher_foreground.png')
    os.makedirs(f'{res}/drawable-{dpi}', exist_ok=True)
    silhouette(int(24 * n)).save(f'{res}/drawable-{dpi}/ic_stat_planner.png')

for path in glob.glob(f'{res}/drawable*/splash.png'):
    w, h = Image.open(path).size
    sp = Image.new('RGB', (w, h), (242, 244, 247))
    icon = mark(int(min(w, h) * 0.28)); sp.paste(icon, ((w - icon.width) // 2, (h - icon.height) // 2), icon)
    sp.save(path)
print('icons done')
