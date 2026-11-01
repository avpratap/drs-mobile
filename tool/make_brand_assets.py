#!/usr/bin/env python3
"""Renders the DRS launcher-icon and splash source art (branding/*).

Matches the web storefront's brand (drs-web `src/app/icon.svg` and the
`StoreLogo` lockup): deep green #0D4C3C, antique gold #C5A253, ivory cream
#F4EADE; Montserrat ExtraBold "DRS" mark, Poppins "DAIRY / PURE HERITAGE".

Small-size rule: launcher icons are the plain solid mark (green field, ivory
"DRS", no gold keyline). The splash uses the full on-dark lockup (keyline
tile + wordmark). Dev builds add a burgundy DEV band.

Re-run after a brand change, then tool/launcher_assets/generate.sh.
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
FONTS = ROOT / "packages/drs_ui/assets/fonts"
OUT = ROOT / "branding"
GREEN = (0x0D, 0x4C, 0x3C, 255)
GOLD = (0xC5, 0xA2, 0x53, 255)
CREAM = (0xF4, 0xEA, 0xDE, 255)
BURGUNDY = (0x3B, 0x0A, 0x1E, 255)
S = 1024


def font(name, px):
    return ImageFont.truetype(str(FONTS / name), round(px))


def spaced_text(d, x, baseline, text, f, fill, tracking):
    """Draws [text] left-aligned at [x] with CSS-style letter spacing (after
    each glyph) on the alphabetic [baseline]. Returns the advance width."""
    asc, _ = f.getmetrics()
    cx = x
    for ch in text:
        d.text((cx, baseline - asc), ch, font=f, fill=fill)
        cx += d.textlength(ch, font=f) + tracking
    return cx - x


def text_width(d, text, f, tracking):
    return sum(d.textlength(c, font=f) for c in text) + tracking * (len(text) - 1)


def mark(size, *, field=True, keyline=True, scale_from=48):
    """The web tile (viewBox 0 0 48 48): rounded green square, optional gold
    keyline, ivory DRS centred on x=24 with its baseline at y=30.5."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    k = size / scale_from
    if field:
        d.rounded_rectangle([2 * k, 2 * k, 46 * k, 46 * k], radius=12 * k, fill=GREEN)
    if keyline:
        d.rounded_rectangle(
            [5.5 * k, 5.5 * k, 42.5 * k, 42.5 * k],
            radius=8.5 * k,
            outline=GOLD,
            width=max(1, round(1.3 * k)),
        )
    f = font("Montserrat-ExtraBold.ttf", 13.5 * k)
    w = text_width(d, "DRS", f, 0.6 * k)
    spaced_text(d, 24 * k - w / 2, 30.5 * k, "DRS", f, CREAM, 0.6 * k)
    return img


def solid_icon(text_px, *, fill=CREAM, background=GREEN, size=S, baseline=None):
    """Plain solid mark for launcher icons: green field, centred DRS (the web
    icon.svg proportions: 15/48 type, baseline at 31/48)."""
    img = Image.new("RGBA", (size, size), background)
    d = ImageDraw.Draw(img)
    f = font("Montserrat-ExtraBold.ttf", text_px)
    track = text_px * 0.4 / 15
    w = text_width(d, "DRS", f, track)
    asc, _ = f.getmetrics()
    # Optical centre: cap height ~0.70 em sits centred vertically.
    base = baseline if baseline is not None else (size + text_px * 0.70) / 2
    spaced_text(d, (size - w) / 2, base, "DRS", f, fill, track)
    return img


def dev_band(img):
    d = ImageDraw.Draw(img)
    h = S * 0.19
    d.rectangle([0, S - h, S, S], fill=BURGUNDY)
    f = font("Poppins-Bold.ttf", h * 0.5)
    w = d.textlength("DEV", font=f)
    asc, _ = f.getmetrics()
    d.text(((S - w) / 2, S - h / 2 - asc * 0.62), "DEV", font=f, fill=CREAM)
    return img


def lockup(tile_px, *, on_dark=True):
    """Full lockup (web StoreLogo proportions at a 44 px tile, scaled)."""
    k = tile_px / 44
    probe = ImageDraw.Draw(Image.new("RGBA", (1, 1)))
    f1 = font("Poppins-Bold.ttf", 17 * k)
    f2 = font("Poppins-Medium.ttf", 9 * k)
    w1 = text_width(probe, "DAIRY", f1, 17 * k * 0.16)
    w2 = text_width(probe, "PURE HERITAGE", f2, 9 * k * 0.24)
    width = round(tile_px + 10 * k + max(w1, w2) + 2)
    img = Image.new("RGBA", (width, round(tile_px)), (0, 0, 0, 0))
    tile = mark(round(tile_px), field=not on_dark, keyline=True)
    img.alpha_composite(tile, (0, 0))
    d = ImageDraw.Draw(img)
    primary = CREAM if on_dark else GREEN
    secondary = (0xF4, 0xEA, 0xDE, 191) if on_dark else (0x1E, 0x1A, 0x1E, 166)
    # Two lines, leading-none, 3px apart, vertically centred on the tile.
    block = 17 * k + 3 * k + 9 * k
    top = (tile_px - block) / 2
    x = tile_px + 10 * k
    spaced_text(d, x, top + 17 * k * 0.80, "DAIRY", f1, primary, 17 * k * 0.16)
    spaced_text(d, x, top + 17 * k + 3 * k + 9 * k * 0.80, "PURE HERITAGE", f2, secondary, 9 * k * 0.24)
    return img


def main():
    for app in ("customer", "delivery"):
        out = OUT / app
        out.mkdir(parents=True, exist_ok=True)
        # Launcher (iOS + legacy Android): plain solid mark, full bleed.
        icon = solid_icon(S * 15 / 48)
        icon.convert("RGB").save(out / "icon.png")
        dev_band(icon.copy()).convert("RGB").save(out / "icon_dev.png")
        # Adaptive foreground (the generated XML insets it 16%): DRS sized so
        # it stays inside the 66 dp safe zone; background colour = green.
        fg = solid_icon(S * 0.30, background=(0, 0, 0, 0))
        fg.save(out / "foreground.png")
        fg_dev = fg.copy()
        dd = ImageDraw.Draw(fg_dev)
        f = font("Poppins-Bold.ttf", S * 0.075)
        tw = dd.textlength("DEV", font=f)
        pad = S * 0.02
        y = S * 0.64
        dd.rounded_rectangle(
            [(S - tw) / 2 - pad * 2, y - pad, (S + tw) / 2 + pad * 2, y + S * 0.075 + pad],
            radius=S * 0.02, fill=BURGUNDY,
        )
        dd.text(((S - tw) / 2, y - S * 0.012), "DEV", font=f, fill=CREAM)
        fg_dev.save(out / "foreground_dev.png")
        # Android 13 themed icon: single colour, system tints it.
        solid_icon(S * 0.30, fill=(255, 255, 255, 255), background=(0, 0, 0, 0)).save(
            out / "monochrome.png"
        )
        # Splash (pre-Android-12 + iOS): the on-dark lockup on deep green.
        lockup(176, on_dark=True).save(out / "splash.png")
        # Android 12+ splash icon: the keyline tile, inside the inner circle.
        a12 = Image.new("RGBA", (960, 960), (0, 0, 0, 0))
        a12.alpha_composite(mark(480, field=False, keyline=True), (240, 240))
        a12.save(out / "splash_android12.png")
        print("wrote", out)


if __name__ == "__main__":
    main()
