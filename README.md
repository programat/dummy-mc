# Dummy MC

[![Swift](https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=swift&logoColor=white)](main.swift)
[![Release](https://img.shields.io/github/v/release/programat/dummy-mc?style=for-the-badge)](https://github.com/programat/dummy-mc/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-lightgrey?style=for-the-badge&logo=apple)](#quick-start)

Zoom out in macOS Mission Control. Smaller previews leave more room between windows, so you can scan a busy desktop and spot the one you want.

| Off | Moderate | Strong |
| :---: | :---: | :---: |
| ![Standard Mission Control](screenshots/off.jpg) | ![Mission Control with smaller window previews](screenshots/moderate.jpg) | ![Mission Control with the smallest window previews](screenshots/strong.jpg) |


## Quick start

Build from the repository folder with the Xcode Command Line Tools installed.

```sh
./build.sh
open 'dist/Dummy MC.app'
```

Choose **Moderate** or **Strong** from the window icon in the menu bar, then press **Control + ↑**. Choose **Off** to go back to the normal layout.

## The bug

I hit a [Playwright bug](https://github.com/microsoft/playwright/issues/42265) where a headless WebKit window far outside the screen shrank every preview in Mission Control. I turned that bug into a feature by creating a 1 × 1 point AppKit window and putting it thousands of points off-screen. macOS includes it when laying out Mission Control. The bigger area makes the previews smaller.

Tested on macOS 26.3.1 on Apple silicon. The amount of zoom depends on your window layout and display setup.
