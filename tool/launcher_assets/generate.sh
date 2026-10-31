#!/usr/bin/env bash
# Regenerates launcher icons + native splash for both apps from branding/*.
#
# flutter_launcher_icons / flutter_native_splash can't live in the workspace
# (their cli_util pin conflicts with Melos), so they run from a throwaway
# Flutter project that mirrors each app's android/ + ios/ folders; the
# generated files are copied back and committed.
#
#   python3 tool/make_brand_assets.py   # only after changing the art
#   tool/launcher_assets/generate.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

for app in customer delivery; do
  src="$ROOT/apps/${app}_app"
  gen="$WORK/$app"
  mkdir -p "$gen"
  cat > "$gen/pubspec.yaml" <<YAML
name: gen_$app
publish_to: none
environment:
  sdk: ^3.8.0
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_launcher_icons: ^0.14.4
  flutter_native_splash: ^2.4.7
YAML
  cp -R "$src/android" "$src/ios" "$gen/"
  mkdir -p "$gen/branding"
  cp -R "$ROOT/branding/$app" "$gen/branding/"
  cp "$ROOT/tool/launcher_assets/splash-$app.yaml" "$gen/flutter_native_splash.yaml"
  (
    cd "$gen"
    flutter pub get >/dev/null
    # Prod/default first. The tool switches to "flavor mode" as soon as any
    # flutter_launcher_icons-<flavor>.yaml exists, so add the dev one after.
    cp "$ROOT/tool/launcher_assets/icons-$app.yaml" flutter_launcher_icons.yaml
    dart run flutter_launcher_icons
    rm flutter_launcher_icons.yaml
    cp "$ROOT/tool/launcher_assets/icons-$app-dev.yaml" flutter_launcher_icons-dev.yaml
    dart run flutter_launcher_icons   # -> src/dev/res, AppIcon-dev
    dart run flutter_native_splash:create
  )
  # Copy back only what the generators own.
  for set in "$gen"/android/app/src/*/; do
    name="$(basename "$set")"
    for res in "$set"res/mipmap-* "$set"res/drawable* "$set"res/values*; do
      [ -d "$res" ] || continue
      mkdir -p "$src/android/app/src/$name/res"
      cp -R "$res" "$src/android/app/src/$name/res/"
    done
  done
  cp -R "$gen/ios/Runner/Assets.xcassets/." "$src/ios/Runner/Assets.xcassets/"
  cp "$gen/ios/Runner/Base.lproj/LaunchScreen.storyboard" "$src/ios/Runner/Base.lproj/"
  # Info.plist is NOT copied back: the splash tool only re-indents it.
  echo "updated $src"
done
