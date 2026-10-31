#!/usr/bin/env python3
"""Renders the DRS launcher-icon and splash source art (branding/*).

Deep green #0D4C3C field, antique-gold #C5A253 Montserrat ExtraBold wordmark.
Customer: milk drop over the wordmark. Delivery: wordmark over a route arrow.
Dev builds add a burgundy "DEV" band so they can't be mistaken for prod.
Re-run after a brand change, then `dart run flutter_launcher_icons` and
`dart run flutter_native_splash:create` in each app.
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
FONT = ROOT / "packages/drs_ui/assets/fonts/Montserrat-ExtraBold.ttf"
OUT = ROOT / "branding"
GREEN = (0x0D, 0x4C, 0x3C, 255)
GOLD = (0xC5, 0xA2, 0x53, 255)
CREAM = (0xF4, 0xEA, 0xDE, 255)
BURGUNDY = (0x3B, 0x0A, 0x1E, 255)
S = 1024


def font(px):
    return ImageFont.truetype(str(FONT), px)


def drop(d, cx, top, h, fill):
    """A milk drop: circle with a pointed top."""
    r = h * 0.36
    cy = top + h - r
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=fill)
    d.polygon([(cx, top), (cx - r * 0.93, cy - r * 0.35), (cx + r * 0.93, cy - r * 0.35)], fill=fill)


def arrow(d, cx, y, w, fill, t):
    half = w / 2
    d.rounded_rectangle([cx - half, y - t / 2, cx + half - t * 1.2, y + t / 2], radius=t / 2, fill=fill)
    d.polygon([(cx + half, y), (cx + half - t * 2.2, y - t * 1.6), (cx + half - t * 2.2, y + t * 1.6)], fill=fill)


def glyph(app, scale, color, size=S):
    """Transparent layer with the app's mark, centred, `scale` of the canvas."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    box = size * scale
    f = font(int(box * 0.42))
    text = "DRS"
    tw = d.textlength(text, font=f)
    asc, desc = f.getmetrics()
    th = asc * 0.72  # cap height approximation
    cx = size / 2
    if app == "customer":
        dh = box * 0.30
        gap = box * 0.07
        total = dh + gap + th
        top = (size - total) / 2
        drop(d, cx, top, dh, color)
        ty = top + dh + gap
    else:
        gap = box * 0.10
        t = box * 0.055
        total = th + gap + t
        top = (size - total) / 2
        ty = top
        arrow(d, cx, top + th + gap + t / 2, tw * 0.92, color, t)
    # Pillow draws text from the ascender line; shift by (ascent - cap height).
    d.text((cx - tw / 2, ty - (asc - th)), text, font=f, fill=color)
    return img


def dev_band(img):
    d = ImageDraw.Draw(img)
    h = S * 0.19
    d.rectangle([0, S - h, S, S], fill=BURGUNDY)
    f = font(int(h * 0.55))
    tw = d.textlength("DEV", font=f)
    asc, _ = f.getmetrics()
    d.text(((S - tw) / 2, S - h / 2 - asc * 0.62), "DEV", font=f, fill=CREAM)
    return img


def main():
    for app in ("customer", "delivery"):
        out = OUT / app
        out.mkdir(parents=True, exist_ok=True)
        # Full-bleed icon (iOS + legacy Android), mark at ~62%.
        base = Image.new("RGBA", (S, S), GREEN)
        full = Image.alpha_composite(base, glyph(app, 0.62, GOLD))
        full.convert("RGB").save(out / "icon.png")
        dev_band(full.copy()).convert("RGB").save(out / "icon_dev.png")
        # Adaptive foreground (the generated XML insets it 16%, so ~46% of the
        # 108dp canvas: inside the 66dp safe zone).
        fg = glyph(app, 0.68, GOLD)
        fg.save(out / "foreground.png")
        fg_dev = fg.copy()
        dd = ImageDraw.Draw(fg_dev)
        f = font(int(S * 0.075))
        tw = dd.textlength("DEV", font=f)
        pad = S * 0.02
        y = S * 0.76
        dd.rounded_rectangle([(S - tw) / 2 - pad * 2, y - pad, (S + tw) / 2 + pad * 2, y + S * 0.075 + pad],
                             radius=S * 0.02, fill=BURGUNDY)
        dd.text(((S - tw) / 2, y - S * 0.012), "DEV", font=f, fill=CREAM)
        fg_dev.save(out / "foreground_dev.png")
        # Android 13 themed icon (single colour, system tints it).
        glyph(app, 0.68, (255, 255, 255, 255)).save(out / "monochrome.png")
        # Splash: gold mark on transparent (background colour comes from config).
        glyph(app, 0.80, GOLD, size=768).save(out / "splash.png")
        # Android 12+ splash icon: content within the inner 2/3 circle.
        glyph(app, 0.55, GOLD, size=960).save(out / "splash_android12.png")
        print("wrote", out)


if __name__ == "__main__":
    main()
