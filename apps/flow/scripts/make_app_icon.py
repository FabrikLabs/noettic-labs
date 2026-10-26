#!/usr/bin/env python3
"""Render the Noettic Flow app icon set (macOS squircle, navy-to-cyan gradient, waveform mark).

Usage: python3 scripts/make_app_icon.py [output appiconset dir]
Requires Pillow. Writes icon-<size>@<scale>.png for every entry in Contents.json.
"""
import json
import math
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

CANVAS = 1024
SQUIRCLE = 832          # Apple's macOS icon grid: 824-832 px artwork on a 1024 canvas
RADIUS = int(SQUIRCLE * 0.2237)
NAVY = (10, 14, 26)
DEEP = (15, 19, 38)
BLUE = (59, 130, 246)
CYAN = (6, 182, 212)


def lerp(a, b, t):
    return tuple(int(round(a[i] + (b[i] - a[i]) * t)) for i in range(3))


def gradient_tile(size):
    """Diagonal gradient: deep navy at top-left through blue to cyan at bottom-right."""
    img = Image.new("RGB", (size, size))
    px = img.load()
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * (size - 1))
            if t < 0.55:
                colour = lerp(DEEP, BLUE, t / 0.55)
            else:
                colour = lerp(BLUE, CYAN, (t - 0.55) / 0.45)
            px[x, y] = colour
    return img


def squircle_mask(size, radius):
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, size - 1, size - 1), radius=radius, fill=255)
    return mask


def render_base():
    canvas = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
    offset = (CANVAS - SQUIRCLE) // 2

    # Soft shadow under the squircle, as Apple's template icons carry.
    shadow = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (offset, offset + 18, offset + SQUIRCLE, offset + SQUIRCLE + 18), radius=RADIUS, fill=(0, 0, 0, 110)
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(28))
    canvas.alpha_composite(shadow)

    body = gradient_tile(SQUIRCLE).convert("RGBA")
    # Top highlight sheen.
    sheen = Image.new("RGBA", (SQUIRCLE, SQUIRCLE), (0, 0, 0, 0))
    sheen_px = sheen.load()
    for y in range(SQUIRCLE):
        alpha = int(70 * max(0.0, 1 - y / (SQUIRCLE * 0.55)) ** 2)
        for x in range(SQUIRCLE):
            sheen_px[x, y] = (255, 255, 255, alpha)
    body.alpha_composite(sheen)
    body.putalpha(squircle_mask(SQUIRCLE, RADIUS))
    canvas.alpha_composite(body, (offset, offset))

    # Waveform mark: five rounded bars, symmetric, centred.
    draw = ImageDraw.Draw(canvas)
    centre = CANVAS / 2
    heights = [0.26, 0.46, 0.70, 0.46, 0.26]
    bar_w = SQUIRCLE * 0.075
    gap = SQUIRCLE * 0.062
    total_w = len(heights) * bar_w + (len(heights) - 1) * gap
    x = centre - total_w / 2
    for h in heights:
        bar_h = SQUIRCLE * h
        top = centre - bar_h / 2
        draw.rounded_rectangle((x, top, x + bar_w, top + bar_h), radius=bar_w / 2, fill=(255, 255, 255, 242))
        x += bar_w + gap
    return canvas


def main():
    out_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[1] / "Sources/Fluid/Assets.xcassets/AppIcon.appiconset"
    contents = json.loads((out_dir / "Contents.json").read_text())
    base = render_base()
    for entry in contents["images"]:
        points = int(entry["size"].split("x")[0])
        scale = int(entry["scale"].rstrip("x"))
        pixels = points * scale
        resized = base.resize((pixels, pixels), Image.LANCZOS)
        resized.save(out_dir / entry["filename"], optimize=True)
        print(f"wrote {entry['filename']} ({pixels}px)")


if __name__ == "__main__":
    main()
