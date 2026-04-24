# Doom Emacs on Android (Termux + Emacs APK)

Setup guide for running Doom Emacs on Android using the standalone [Emacs APK](https://play.google.com/store/apps/details?id=org.gnu.emacs) and [Termux](https://f-droid.org/packages/com.termux/).

## Prerequisites

- **Emacs APK** (`org.gnu.emacs`) — standalone Emacs for Android
- **Termux** — terminal emulator with `git` and `emacs` packages installed
- Grant Termux access to shared storage: `termux-setup-storage`

## Directory Layout

| Path | Purpose |
|------|---------|
| `/data/data/org.gnu.emacs/files/.emacs.d/` | Doom framework (cloned here) |
| `/data/data/org.gnu.emacs/files/.doom.d/` | User config (config.el, init.el, etc.) |
| `/data/data/org.gnu.emacs/files/fonts/` | Custom fonts (flat directory, no subdirs) |

## Installation Steps

### 1. Install Emacs in Termux (for CLI tools)

```bash
pkg install emacs git
```

The Termux Emacs is used for `doom` CLI commands (sync, install, doctor). The APK Emacs is used for the GUI.

### 2. Clone Doom Emacs

```bash
git clone --depth 1 https://github.com/doomemacs/doomemacs \
  /data/data/org.gnu.emacs/files/.emacs.d
```

### 3. Restore config files

Clone this repo and copy config files to the Doom user directory:

```bash
git clone -b android-config https://github.com/shogi-dojo/dotfiles.git /tmp/dotfiles
mkdir -p /data/data/org.gnu.emacs/files/.doom.d
cp /tmp/dotfiles/{config.el,init.el,packages.el,custom.el} \
   /data/data/org.gnu.emacs/files/.doom.d/
```

### 4. Set up early-init.el

The `early-init.el` must be placed in **both** `.doom.d/` and prepended to Doom's own `early-init.el` in `.emacs.d/`.

It adds Termux binaries to `PATH` and sets `DOOMDIR`:

```elisp
(setenv "PATH" (format "%s:%s" "/data/data/com.termux/files/usr/bin"
                       (getenv "PATH")))
(push "/data/data/com.termux/files/usr/bin" exec-path)
(setenv "DOOMDIR" "/data/data/org.gnu.emacs/files/.doom.d")
```

Prepend this to `.emacs.d/early-init.el` (before Doom's bootstrapper code). Do NOT replace the file — Doom's own early-init.el is required for bootstrapping.

### 5. Run Doom install

```bash
export DOOMDIR=/data/data/org.gnu.emacs/files/.doom.d
yes | /data/data/org.gnu.emacs/files/.emacs.d/bin/doom install
```

The `yes |` pipe is needed because the installer prompts interactively.

### 6. Install fonts

Fonts must be placed in `~/fonts/` **from within the Emacs APK** (not Termux), due to Android app sandboxing — files created by Termux are owned by a different UID.

**Workflow:**

1. Download fonts to shared storage (`/sdcard/Download/`)
2. Open Emacs APK
3. Use dired (`C-x d /sdcard/Download/`) to copy font files to `~/fonts/`

**Required fonts:**

- **JetBrains Mono Nerd Font** — main editor font. Download from [Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases) (`JetBrainsMono.tar.xz`)
- **Nerd icons** — run `M-x nerd-icons-install-fonts` from within Emacs
- **NotoSansJP-TTF.ttf** — CJK font for Japanese/Chinese/Korean characters. Included in `fonts/` directory. **Important:** Emacs Android's `sfntfont-android` driver only supports TrueType outlines (`glyf` tables). Standard Noto CJK fonts use CFF outlines and won't work. This file was converted from CFF→TrueType using fonttools

### 7. Sync after config changes

After modifying `init.el` or `packages.el`:

```bash
export DOOMDIR=/data/data/org.gnu.emacs/files/.doom.d
/data/data/org.gnu.emacs/files/.emacs.d/bin/doom sync
```

## PDF & DOCX Support

### pdf-tools (sharp PDF rendering)

pdf-tools requires building `epdfinfo` from source on Termux:

```bash
pkg install autoconf automake binutils clang libpng poppler zlib make xorgproto pkg-config
cd ~/.emacs.d/.local/straight/build-30.2/pdf-tools/build/server
autoreconf -i && ./configure && make -j4
cp epdfinfo ../../
```

### DOCX viewing

DOCX files are converted to PDF via pandoc+weasyprint (async), then opened in pdf-tools:

```bash
pkg install pandoc
pip install weasyprint
```

## Japanese Input

The `japanese` Doom module is enabled (ddskk). Use `C-\` to toggle input, `C-u C-\` to switch between methods (`japanese`, `japanese-katakana`, etc.).

## Android-Specific Config Changes

The following modules/packages from the linux-config branch were disabled for Android compatibility:

| Item | Reason |
|------|--------|
| `ligatures` module | Not supported on Android |
| `touchpad-scroll-mode` package | Requires desktop touchpad; crashes on Android |
| `Monaco for Powerline` font | Replaced with JetBrains Mono Nerd Font (easier to install) |

## Termux Mirror Selection

After a fresh install, Termux may auto-select a slow or unreliable mirror (e.g. a Chinese CDN). Run `termux-change-repo` to pick a closer mirror before installing packages. European mirrors like `grimler.se` or `ftp.fau.de` work well from Ukraine. Large packages like `openjdk-17` (~95 MB) will fail on slow mirrors.

## Troubleshooting

- **"emacs" command not found during `doom install`**: Install Emacs in Termux (`pkg install emacs`)
- **Font errors ("Wrong type argument: font")**: Font not installed from within Emacs APK — copy via dired from `/sdcard/`
- **emacsclient "can't find socket"**: The APK's `libemacsclient.so` hardcodes `/data/data/org.gnu.emacs/cache` as its TMPDIR, so it looks for the socket at `/data/data/org.gnu.emacs/cache/emacs<UID>/server`. But `early-init.el` adds Termux to PATH, causing Emacs to pick up Termux's TMPDIR and create the socket at `/data/data/com.termux/files/usr/var/run/emacs<UID>/server` instead. Fix: set `server-socket-dir` in config.el before `server-start`:
  ```elisp
  (setq server-socket-dir
        (format "/data/data/org.gnu.emacs/cache/emacs%d" (user-uid)))
  ```
- **Permission issues with config files**: Termux and Emacs APK run as different Android users. Cross-app file access works for `/data/data/org.gnu.emacs/files/` directories but font files specifically need to be owned by the Emacs APK user
