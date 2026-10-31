#!/usr/bin/env python3
"""Adds dev/prod flavors to a Flutter iOS project (idempotent).

For every build configuration list it duplicates Debug/Release/Profile into
`<Config>-dev` and `<Config>-prod` (what `flutter build ios --flavor X`
expects), sets the per-flavor bundle id, display name and app icon on the
Runner target, writes `dev`/`prod` schemes and maps the configs in the
Podfile.

usage: ios_flavors.py <app>/ios <bundle-id> "<prod name>" "<dev name>"
"""
import hashlib
import re
import sys
from pathlib import Path

FLAVORS = ("dev", "prod")
BASES = ("Debug", "Release", "Profile")


def new_id(seed: str) -> str:
    return hashlib.sha1(seed.encode()).hexdigest()[:24].upper()


def set_setting(block: str, key: str, value: str) -> str:
    line = f"\t\t\t\t{key} = {value};\n"
    if re.search(rf"^\t\t\t\t{key} = .*;$", block, re.M):
        return re.sub(rf"^\t\t\t\t{key} = .*;\n", line, block, flags=re.M)
    return block.replace("\t\t\tbuildSettings = {\n", "\t\t\tbuildSettings = {\n" + line, 1)


def main(ios_dir: str, bundle_id: str, prod_name: str, dev_name: str) -> None:
    ios = Path(ios_dir)
    pbx = ios / "Runner.xcodeproj" / "project.pbxproj"
    text = pbx.read_text()
    if "Debug-dev" in text:
        print(f"{pbx}: flavors already present")
        return

    section = re.search(
        r"/\* Begin XCBuildConfiguration section \*/\n(.*?)/\* End XCBuildConfiguration section \*/",
        text,
        re.S,
    )
    blocks = {
        m.group(1): m.group(0)
        for m in re.finditer(
            r"\t\t([0-9A-F]{24}) /\* (\w+) \*/ = \{\n\t\t\tisa = XCBuildConfiguration;.*?\n\t\t\};\n",
            section.group(1),
            re.S,
        )
    }
    names = {i: re.search(r"/\* (\w+) \*/", b).group(1) for i, b in blocks.items()}

    def is_runner_app(block: str) -> bool:
        return f"PRODUCT_BUNDLE_IDENTIFIER = {bundle_id};" in block

    def runner_settings(block: str, flavor: str) -> str:
        suffix = ".dev" if flavor == "dev" else ""
        block = set_setting(block, "PRODUCT_BUNDLE_IDENTIFIER", f"{bundle_id}{suffix}")
        block = set_setting(block, "ASSETCATALOG_COMPILER_APPICON_NAME", f'"AppIcon-{flavor}"')
        name = dev_name if flavor == "dev" else prod_name
        return set_setting(block, "DRS_DISPLAY_NAME", f'"{name}"')

    new_blocks = []
    new_ids = {}  # old id -> [(new id, name)]
    for old_id, block in blocks.items():
        base = names[old_id]
        if base not in BASES:
            continue
        # Plain configs (no --flavor) keep building as prod.
        if is_runner_app(block):
            patched = set_setting(block, "DRS_DISPLAY_NAME", f'"{prod_name}"')
            text = text.replace(block, patched)
            block = patched
        for flavor in FLAVORS:
            name = f"{base}-{flavor}"
            nid = new_id(f"{bundle_id}:{old_id}:{name}")
            b = block.replace(f"{old_id} /* {base} */", f"{nid} /* {name} */", 1)
            b = b.replace(f"\t\t\tname = {base};\n", f'\t\t\tname = "{name}";\n')
            if is_runner_app(block):
                b = runner_settings(b, flavor)
            new_blocks.append(b)
            new_ids.setdefault(old_id, []).append((nid, name))

    text = text.replace(
        "/* End XCBuildConfiguration section */",
        "".join(new_blocks) + "/* End XCBuildConfiguration section */",
    )
    for old_id, items in new_ids.items():
        line = re.search(rf"\t\t\t\t{old_id} /\* \w+ \*/,\n", text).group(0)
        extra = "".join(f"\t\t\t\t{i} /* {n} */,\n" for i, n in items)
        text = text.replace(line, line + extra, 1)
    pbx.write_text(text)

    # Info.plist: display name per configuration.
    plist = ios / "Runner" / "Info.plist"
    p = plist.read_text()
    p = re.sub(
        r"(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)",
        r"\1$(DRS_DISPLAY_NAME)\2",
        p,
    )
    plist.write_text(p)

    # Schemes.
    schemes = ios / "Runner.xcodeproj" / "xcshareddata" / "xcschemes"
    runner = (schemes / "Runner.xcscheme").read_text()
    for flavor in FLAVORS:
        s = re.sub(
            r'buildConfiguration = "(Debug|Release|Profile)"',
            lambda m: f'buildConfiguration = "{m.group(1)}-{flavor}"',
            runner,
        )
        (schemes / f"{flavor}.xcscheme").write_text(s)

    # Podfile mapping (harmless while the project uses SwiftPM only).
    podfile = ios / "Podfile"
    if podfile.exists():
        pf = podfile.read_text()
        mapping = "".join(
            f"  '{b}-{f}' => :{'debug' if b == 'Debug' else 'release'},\n"
            for f in FLAVORS
            for b in BASES
        )
        pf = pf.replace("  'Release' => :release,\n", "  'Release' => :release,\n" + mapping, 1)
        podfile.write_text(pf)
    print(f"{pbx}: added {len(new_blocks)} configurations")


if __name__ == "__main__":
    main(*sys.argv[1:5])
