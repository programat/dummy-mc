#!/bin/sh
set -eu
cd "$(dirname "$0")"

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
app="$stage/Dummy MC.app"
mkdir -p "$app/Contents/MacOS" dist
swiftc -warnings-as-errors main.swift -o "$app/Contents/MacOS/DummyMC"
cp Info.plist "$app/Contents/Info.plist"
codesign --sign - "$app"
ditto "$app" 'dist/Dummy MC.app'
