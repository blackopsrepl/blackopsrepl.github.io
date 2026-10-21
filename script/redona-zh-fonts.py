#!/usr/bin/env python3
"""Subset the Chinese display fonts to the characters the Chinese Redona page uses.

Full CJK fonts are megabytes; the page needs a few hundred glyphs. This script
downloads the pinned upstream fonts, keeps only the characters found in
src/redona/zh/index.erb, writes WOFF2 files beside the Italian fonts, and
records the character list in zh-glyphs.txt so the contract test can fail when
new copy uses a character the subset lacks.

Run after editing the Chinese copy (needs fonttools and brotli):

    python3 -m venv /tmp/ft && /tmp/ft/bin/pip install fonttools brotli
    /tmp/ft/bin/python script/redona-zh-fonts.py
"""
import io
import tempfile
import urllib.request
import zipfile
from pathlib import Path

from fontTools import subset

ROOT = Path(__file__).resolve().parent.parent
PAGE = ROOT / "src/redona/zh/index.erb"
FONTS = ROOT / "src/redona/fonts"

GOOGLE_FONTS = "https://raw.githubusercontent.com/google/fonts/7f1b83ecdae8ccb7507fa6e06396e57bc0a5665d/ofl/zcoolqingkehuangyou"
SMILEY = "https://github.com/atelier-anchor/smiley-sans/releases/download/v2.0.1/smiley-sans-v2.0.1.zip"
SMILEY_LICENSE = "https://raw.githubusercontent.com/atelier-anchor/smiley-sans/v2.0.1/LICENSE"


def fetch(url):
    with urllib.request.urlopen(url) as response:
        return response.read()


def is_cjk(ch):
    code = ord(ch)
    return (0x3000 <= code <= 0x303F or 0x4E00 <= code <= 0x9FFF
            or 0xFF00 <= code <= 0xFFEF or code in (0x201C, 0x201D))


def main():
    chars = sorted({ch for ch in PAGE.read_text(encoding="utf-8") if is_cjk(ch)})
    text = "".join(chars)

    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        huangyou = tmp / "huangyou.ttf"
        huangyou.write_bytes(fetch(f"{GOOGLE_FONTS}/ZCOOLQingKeHuangYou-Regular.ttf"))
        with zipfile.ZipFile(io.BytesIO(fetch(SMILEY))) as archive:
            smiley = tmp / "smiley.ttf"
            smiley.write_bytes(archive.read("SmileySans-Oblique.ttf"))

        for source, target in ((huangyou, "rb-zh-display.woff2"), (smiley, "rb-zh-note.woff2")):
            options = subset.Options()
            options.flavor = "woff2"
            options.layout_features = ["*"]
            font = subset.load_font(str(source), options)
            subsetter = subset.Subsetter(options)
            subsetter.populate(text=text)
            subsetter.subset(font)
            # Both fonts are OFL; Smiley Sans reserves its name, so a subset is
            # a modified version and must ship under a different family name.
            family = target.removesuffix(".woff2")
            names = {1: family, 3: f"{family};subset", 4: family, 6: family,
                     16: family, 17: "Regular", 21: family, 22: "Regular"}
            for record in font["name"].names:
                if record.nameID in names:
                    record.string = names[record.nameID]
            subset.save_font(font, str(FONTS / target), options)
            covered = {chr(code) for code in font.getBestCmap()}
            missing = [ch for ch in chars if ch not in covered]
            print(f"{target}: {(FONTS / target).stat().st_size} bytes, missing {''.join(missing) or 'none'}")

    (FONTS / "ZCOOLQingKeHuangYou-OFL.txt").write_bytes(fetch(f"{GOOGLE_FONTS}/OFL.txt"))
    (FONTS / "SmileySans-OFL.txt").write_bytes(fetch(SMILEY_LICENSE))
    (FONTS / "zh-glyphs.txt").write_text(text + "\n", encoding="utf-8")
    print(f"{len(chars)} characters")


if __name__ == "__main__":
    main()
