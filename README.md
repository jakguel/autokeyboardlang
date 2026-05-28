# autokeyboardlang

Automatically switches your macOS keyboard input source (language/layout) when you switch between physical keyboards.

## Requirements

| | |
|---|---|
| **macOS** | 15 Sequoia or 26 Tahoe |
| **Hardware** | Apple Silicon (M1 or newer) — Intel Macs not supported |
| **Architecture** | arm64 only |

> If you are on an older macOS version or Intel Mac, this project will not work.

## Installation

### Homebrew (recommended)

```sh
brew tap jakguel/autokeyboardlang
brew install --cask autokeyboardlang
```

### Direct download

Download the latest `.dmg` from the [Releases page](https://github.com/jakguel/autokeyboardlang/releases/latest), open it and drag `autokeyboardlang.app` to `/Applications/`.

> **Note:** The app is ad-hoc signed. On first launch macOS may show a security warning — go to System Settings → Privacy & Security → **Open Anyway**.

Open `/Applications/autokeyboardlang.app` — the tray icon guides you through Input Monitoring setup and autostart.

### Upgrade

```sh
brew upgrade --cask autokeyboardlang
```

### Build from source

Requires a full Xcode.app installation:

```sh
git clone https://github.com/jakguel/autokeyboardlang
cd autokeyboardlang
swift build --configuration release
```

## Getting started

1. Type a few keys on your first keyboard so it becomes the **active** keyboard
2. Switch to the desired layout via the menu bar or <kbd>🌐</kbd>
3. Repeat for each keyboard you use

The layout switches **after** the first keystroke when changing keyboards.

## CLI

```sh
autokeyboardlang list                        # show all known devices and their status
autokeyboardlang enable <device>             # enable switching for a device
autokeyboardlang disable <device>            # disable switching for a device
autokeyboardlang clear                       # reset all stored mappings
```

`<device>` is either the number from `list` or the full device identifier.

Options: `--verbose 1|2` (debug/trace output), `--location` (include USB port in device ID)

## Troubleshooting

**Not switching after install**

Autostart is managed by the tray menu. Click **Autostart disabled — click to enable** in the tray menu to enable launch-at-login.

If Input Monitoring permission is needed, add the app under System Settings → Privacy & Security → Input Monitoring:
`/Applications/autokeyboardlang.app/Contents/MacOS/autokeyboardlang`

**Logitech device not detected correctly**

Some Logitech devices misidentify as keyboard or mouse. Use `autokeyboardlang enable` or `autokeyboardlang disable` to correct this manually.

**Not compatible with:**

- macOS "Automatically switch to a document's input source" (System Settings → Keyboard → Input Sources → Edit…)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) — proxies keyboard events, hiding the real device from autokeyboardlang

## Acknowledgements

Originally developed by [Jean Helou](https://github.com/jeantil/autokbisw). Extended by [ohueter](https://github.com/ohueter/autokbisw).
