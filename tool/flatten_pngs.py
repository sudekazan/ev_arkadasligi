"""Removes the alpha channel from PNGs; App Store Connect rejects transparency.

Usage: python3 tool/flatten_pngs.py test_screenshots/out
"""
import pathlib
import sys

from PIL import Image

for path in pathlib.Path(sys.argv[1]).rglob("*.png"):
    img = Image.open(path)
    if img.mode != "RGB":
        img.convert("RGB").save(path)
