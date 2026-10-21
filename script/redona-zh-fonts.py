#!/usr/bin/env python3
"""Build the Chinese fonts for the Redona page, trimmed to the characters it uses.

Every Chinese glyph on /redona/zh/ comes from a font shipped with the site; the
page never relies on whatever Chinese font the reader's phone has. Full CJK
fonts are megabytes, so this script downloads the pinned upstream fonts, fixes
variable fonts to the weights the page uses, keeps only the characters found in
src/redona/zh/index.erb, renames the results as the OFL requires for modified
fonts, and writes WOFF2 files beside the Italian fonts. It also records the
character list in zh-glyphs.txt so the contract test fails when new copy uses a
character the subsets lack.

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
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer

ROOT = Path(__file__).resolve().parent.parent
PAGE = ROOT / "src/redona/zh/index.erb"
FONTS = ROOT / "src/redona/fonts"

GF = "https://raw.githubusercontent.com/google/fonts"
HUANGYOU = f"{GF}/7f1b83ecdae8ccb7507fa6e06396e57bc0a5665d/ofl/zcoolqingkehuangyou"
NOTO_SANS = f"{GF}/a85815a42757630ce188fdad368c2dfc444d4773/ofl/notosanssc"
NOTO_SERIF = f"{GF}/8b0a1d0f5983c89bc2b93f1b5fb55f9e252744b5/ofl/notoserifsc"
SMILEY = "https://github.com/atelier-anchor/smiley-sans/releases/download/v2.0.1/smiley-sans-v2.0.1.zip"
SMILEY_LICENSE = "https://raw.githubusercontent.com/atelier-anchor/smiley-sans/v2.0.1/LICENSE"

# (source key, weight to pin on a variable font or None, output name, characters)
# None for characters means "every Chinese character on the page".
SWITCH = "中文"  # the language switch on the Italian page; it must not pull a full body font
OUTPUTS = [
    ("huangyou", None, "rb-zh-display", None),
    ("smiley", None, "rb-zh-note", None),
    ("sans", 400, "rb-zh-sans-400", None),
    ("sans", 700, "rb-zh-sans-700", None),
    ("serif", 400, "rb-zh-serif-400", None),
    ("sans", 700, "rb-zh-switch", SWITCH),
]


def fetch(url):
    with urllib.request.urlopen(url) as response:
        return response.read()


def is_cjk(ch):
    code = ord(ch)
    return (0x3000 <= code <= 0x303F or 0x4E00 <= code <= 0x9FFF
            or 0xFF00 <= code <= 0xFFEF or code in (0x201C, 0x201D))


def download(tmp):
    sources = {}
    sources["huangyou"] = tmp / "huangyou.ttf"
    sources["huangyou"].write_bytes(fetch(f"{HUANGYOU}/ZCOOLQingKeHuangYou-Regular.ttf"))
    with zipfile.ZipFile(io.BytesIO(fetch(SMILEY))) as archive:
        sources["smiley"] = tmp / "smiley.ttf"
        sources["smiley"].write_bytes(archive.read("SmileySans-Oblique.ttf"))
    sources["sans"] = tmp / "sans.ttf"
    sources["sans"].write_bytes(fetch(f"{NOTO_SANS}/NotoSansSC%5Bwght%5D.ttf"))
    sources["serif"] = tmp / "serif.ttf"
    sources["serif"].write_bytes(fetch(f"{NOTO_SERIF}/NotoSerifSC%5Bwght%5D.ttf"))
    return sources


def build(source, weight, name, chars):
    options = subset.Options()
    options.flavor = "woff2"
    options.layout_features = ["*"]
    font = TTFont(str(source))
    if weight is not None:
        # subset first so the instancer only works on the glyphs we keep
        pre = subset.Subsetter(subset.Options(layout_features=["*"]))
        pre.populate(text="".join(chars))
        pre.subset(font)
        font = instancer.instantiateVariableFont(font, {"wght": weight})
    subsetter = subset.Subsetter(options)
    subsetter.populate(text="".join(chars))
    subsetter.subset(font)
    # OFL: a modified font must not keep a Reserved Font Name; ship neutral names
    names = {1: name, 3: f"{name};subset", 4: name, 6: name,
             16: name, 17: "Regular", 21: name, 22: "Regular"}
    for record in font["name"].names:
        if record.nameID in names:
            record.string = names[record.nameID]
    target = FONTS / f"{name}.woff2"
    subset.save_font(font, str(target), options)
    covered = {chr(code) for code in font.getBestCmap()}
    missing = "".join(ch for ch in chars if ch not in covered)
    print(f"{target.name}: {target.stat().st_size} bytes, missing {missing or 'none'}")
    return not missing


def main():
    chars = sorted({ch for ch in PAGE.read_text(encoding="utf-8") if is_cjk(ch)})
    with tempfile.TemporaryDirectory() as tmp:
        sources = download(Path(tmp))
        complete = [build(sources[key], weight, name, sorted(only) if only else chars)
                    for key, weight, name, only in OUTPUTS]

    (FONTS / "ZCOOLQingKeHuangYou-OFL.txt").write_bytes(fetch(f"{HUANGYOU}/OFL.txt"))
    (FONTS / "SmileySans-OFL.txt").write_bytes(fetch(SMILEY_LICENSE))
    (FONTS / "NotoSansSC-OFL.txt").write_bytes(fetch(f"{NOTO_SANS}/OFL.txt"))
    (FONTS / "NotoSerifSC-OFL.txt").write_bytes(fetch(f"{NOTO_SERIF}/OFL.txt"))
    (FONTS / "zh-glyphs.txt").write_text("".join(chars) + "\n", encoding="utf-8")
    print(f"{len(chars)} characters")
    if not all(complete):
        raise SystemExit("a font lacks characters the page uses")


if __name__ == "__main__":
    main()
