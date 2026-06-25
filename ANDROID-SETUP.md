# Doom Emacs on Android (Termux + Emacs APK)

Setup guide for running this unified Doom Emacs config on Android using the standalone [Emacs APK](https://play.google.com/store/apps/details?id=org.gnu.emacs) and [Termux](https://f-droid.org/packages/com.termux/).

## Prerequisites

- **Emacs APK** (`org.gnu.emacs`) — standalone Emacs for Android
- **Termux** — terminal emulator with `git` and `emacs` packages installed
- Shared storage access in Termux via `termux-setup-storage`

## Directory Layout

| Path | Purpose |
|------|---------|
| `/data/data/org.gnu.emacs/files/.emacs.d/` | Doom framework |
| `/data/data/org.gnu.emacs/files/.doom.d/` | This config repo |
| `/data/data/org.gnu.emacs/files/fonts/` | Custom fonts, flat directory |

## Installation Steps

### 1. Install Emacs in Termux

```bash
pkg install emacs git
```

Termux Emacs is used for Doom CLI commands. The Emacs APK is used for the GUI.

### 2. Clone Doom Emacs

```bash
git clone --depth 1 https://github.com/doomemacs/doomemacs \
  /data/data/org.gnu.emacs/files/.emacs.d
```

### 3. Restore Config Files

Clone this repository into Doom's user config directory:

```bash
git clone https://github.com/shogi-dojo/emacs-config.git \
  /data/data/org.gnu.emacs/files/.doom.d
```

The runtime platform detector in `config.el` will load `platforms/android.el` automatically when Termux/Android paths are present.

### 4. Set Up early-init.el

`early-init.el` must be placed in both `.doom.d/` and prepended to Doom's own `.emacs.d/early-init.el`.

It adds Termux binaries to `PATH` and sets `DOOMDIR` when Termux markers are present:

```elisp
(when (or (getenv "TERMUX_VERSION")
          (file-directory-p "/data/data/com.termux"))
  (setenv "PATH" (format "%s:%s" "/data/data/com.termux/files/usr/bin"
                         (getenv "PATH")))
  (push "/data/data/com.termux/files/usr/bin" exec-path)
  (setenv "DOOMDIR" "/data/data/org.gnu.emacs/files/.doom.d"))
```

Prepend this code to `.emacs.d/early-init.el` before Doom's bootstrapper. Do not replace Doom's own file.

### 5. Run Doom Install

```bash
export DOOMDIR=/data/data/org.gnu.emacs/files/.doom.d
yes | /data/data/org.gnu.emacs/files/.emacs.d/bin/doom install
```

The `yes |` pipe handles installer prompts.

### 6. Install Fonts

Fonts must be placed in `~/fonts/` from within the Emacs APK, not Termux, because Android app sandboxes use different UIDs.

Required fonts:

- **JetBrains Mono Nerd Font** — main editor font
- **Symbols Nerd Font Mono** — icon fallback; install with `M-x nerd-icons-install-fonts`
- **NotoSansJP-TTF.ttf** — CJK fallback included in this repo under `fonts/`

Recommended workflow:

1. Download fonts to `/sdcard/Download/`.
2. Open the Emacs APK.
3. Use dired (`C-x d /sdcard/Download/`) to copy fonts to `~/fonts/`.

## PDF and DOCX Support

`pdf-tools` requires building `epdfinfo` from source on Termux:

```bash
pkg install autoconf automake binutils clang libpng poppler zlib make xorgproto pkg-config
cd ~/.emacs.d/.local/straight/build-30.2/pdf-tools/build/server
autoreconf -i && ./configure && make -j4
cp epdfinfo ../../
```

DOCX files are converted to PDF through `pandoc` and `weasyprint` before opening:

```bash
pkg install pandoc
pip install weasyprint
```

## Japanese Input

The `japanese` Doom module is enabled in the unified config. On Android, `config.el` sets `default-input-method` to `japanese`. Use `C-\` to toggle input and `C-u C-\` to switch methods.

## Termux Mirror Selection

After a fresh Termux install, run `termux-change-repo` and choose a nearby mirror before installing large packages. European mirrors like `grimler.se` or `ftp.fau.de` work well from Ukraine.

## Troubleshooting

- **`emacs` command not found during `doom install`**: install Emacs in Termux with `pkg install emacs`.
- **Font errors**: copy fonts from inside the Emacs APK, not from Termux.
- **`emacsclient` cannot find the socket**: Android uses `server-socket-dir` in `platforms/android.el`, pointing to `/data/data/org.gnu.emacs/cache/emacs<UID>/server`.
- **Permission issues**: config files can live under `/data/data/org.gnu.emacs/files/`, but font files must be owned by the Emacs APK user.
