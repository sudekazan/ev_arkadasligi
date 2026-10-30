"""Draws Ödeşelim logos for the web, social media and press into assets/brand/.

The App Store and Google Play take the app icon from the build; these files
are for everywhere else. Run from the project root: PYTHONPATH=tool python3 tool/make_logos.py
"""
import os
import shutil

from PIL import Image, ImageDraw, ImageFont

from make_icons import GREEN, SS, draw_mark

DARK = (27, 77, 56, 255)
WHITE = (255, 255, 255, 255)
OUT = "assets/brand"


def roboto_bold() -> str:
    """Roboto ships with the Flutter SDK."""
    flutter = os.path.realpath(shutil.which("flutter"))
    root = os.path.dirname(os.path.dirname(flutter))
    return os.path.join(root, "bin", "cache", "artifacts", "material_fonts", "Roboto-Bold.ttf")


def rounded_icon(size: int) -> Image.Image:
    """The app icon with iOS-like rounded corners on transparent."""
    big = size * SS
    img = Image.new("RGBA", (big, big), GREEN)
    draw_mark(ImageDraw.Draw(img), big, 1.0)
    mask = Image.new("L", (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, big - 1, big - 1], radius=int(big * 0.225), fill=255)
    img.putalpha(mask)
    return img.resize((size, size), Image.LANCZOS)


def horizontal(text_colour, path: str, height: int = 600):
    """Icon on the left, the name on the right, transparent background."""
    font = ImageFont.truetype(roboto_bold(), int(height * 0.56) * SS)
    name = "Ödeşelim"
    probe = ImageDraw.Draw(Image.new("RGBA", (1, 1)))
    left, top, right, bottom = probe.textbbox((0, 0), name, font=font)
    h = height * SS
    gap = int(h * 0.18)
    w = h + gap + (right - left)
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    img.alpha_composite(rounded_icon(height).resize((h, h), Image.LANCZOS))
    # Centre the text's ink box on the icon.
    y = (h - (bottom - top)) // 2 - top
    ImageDraw.Draw(img).text((h + gap - left, y), name, font=font, fill=text_colour)
    img.resize((w // SS, height), Image.LANCZOS).save(path)


if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    rounded_icon(1024).save(f"{OUT}/logo_icon_1024.png")
    horizontal(DARK, f"{OUT}/logo_horizontal.png")
    horizontal(WHITE, f"{OUT}/logo_horizontal_white.png")
