"""Draws the Ödeşelim app icon (house + coin) into assets/icon/.

Run from the project root: python3 tool/make_icons.py
"""
from PIL import Image, ImageDraw

GREEN = (46, 125, 91, 255)      # theme seed 0xFF2E7D5B
WHITE = (255, 255, 255, 255)
GOLD = (244, 196, 48, 255)
GOLD_DARK = (196, 146, 20, 255)
S = 1024
SS = 4  # supersampling for smooth edges


def draw_mark(d: ImageDraw.ImageDraw, size: int, scale: float, ox: float = 0, oy: float = 0):
    """House with a coin in the doorway, centred in a [size] square."""
    def p(x, y):
        return (ox + size / 2 + (x - 512) * scale * size / S,
                oy + size / 2 + (y - 512) * scale * size / S)

    k = scale * size / S
    # Roof and walls.
    d.polygon([p(512, 210), p(830, 470), p(760, 470), p(760, 800), p(264, 800), p(264, 470), p(194, 470)],
              fill=WHITE)
    d.polygon([p(512, 210), p(870, 500), p(830, 540), p(512, 282), p(194, 540), p(154, 500)], fill=WHITE)
    # Coin.
    cx, cy = p(512, 610)
    r = 150 * k
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=GOLD_DARK)
    r2 = 124 * k
    d.ellipse([cx - r2, cy - r2, cx + r2, cy + r2], fill=GOLD)
    # Lira sign (₺) drawn as strokes: no bundled font has the glyph.
    w = 22 * k
    def q(x, y):
        return (cx + x * k, cy + y * k)
    d.line([q(-22, -82), q(-22, 78)], fill=GOLD_DARK, width=int(w))
    d.line([q(-62, -10), q(42, -46)], fill=GOLD_DARK, width=int(w))
    d.line([q(-62, 26), q(42, -10)], fill=GOLD_DARK, width=int(w))
    # Bowl: from the stem foot, curving right and up.
    d.arc([*q(-22 - 70, 8 - 70), *q(-22 + 70, 8 + 70)], start=0, end=90, fill=GOLD_DARK, width=int(w))

def render(bg, scale, path, size=S):
    big = size * SS
    img = Image.new("RGBA", (big, big), bg)
    draw_mark(ImageDraw.Draw(img), big, scale)
    img = img.resize((size, size), Image.LANCZOS)
    if bg[3] == 255:
        img = img.convert("RGB")  # iOS rejects icons with alpha
    img.save(path)


render(GREEN, 1.0, "assets/icon/icon.png")
# Android adaptive foreground; flutter_launcher_icons adds a 16% inset itself.
render((0, 0, 0, 0), 1.0, "assets/icon/icon_foreground.png")
# Android 12 splash icon: only the inner circle (2/3 diameter) is visible.
render((0, 0, 0, 0), 0.62, "assets/icon/splash_android12.png")
# Splash: the mark on transparent, the background colour comes from config.
render((0, 0, 0, 0), 0.9, "assets/icon/splash.png", size=768)
