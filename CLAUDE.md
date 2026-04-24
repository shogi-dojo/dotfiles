# Doom Emacs Config

Repo: `shogi-dojo/emacs-config`.

This repository now uses a unified runtime configuration for macOS, Linux, and Android/Termux. Do not recreate branch-per-platform copies of `config.el`.

## Architecture

- `config.el` contains shared behavior only: platform detection, theme/font setup, modeline, evil/devil/key-chord defaults, common keybindings, helper functions, file associations, Treemacs advice, and common package setup.
- `platforms/<platform>.el` contains OS-specific settings that must run before common font/display setup.
- `platforms/keybindings-<platform>.el` contains modifier-specific keybindings and platform clipboard/vterm paste behavior. These files load at the end of `config.el`, after shared helper functions are defined.
- `init.el` is the Doom module superset for all platforms.
- `packages.el` is the package superset for all platforms.
- `custom.el` is Emacs Customize output; avoid manual edits unless explicitly requested.

## Platform Detection

`my/platform` is set in `config.el`:

- `macos` when `system-type` is `darwin`.
- `android` when `system-type` is `gnu/linux` and Termux markers exist.
- `linux` for other GNU/Linux systems.

The platform file is loaded with:

```elisp
(load! (format "platforms/%s" my/platform))
```

The keybinding file is loaded at the bottom with:

```elisp
(load! (format "platforms/keybindings-%s" my/platform))
```

## Platform Responsibilities

macOS:

- `my/font-size` is `15`.
- Homebrew `/opt/homebrew/bin` is added to `PATH` and `exec-path`.
- `mac-right-option-modifier` is `meta`.
- Server starts through `use-package! server`.
- Toolbar and scrollbar stay enabled.
- Keybindings use `s-`; vterm paste uses `pbpaste`.

Linux:

- `my/font-size` is `14`.
- Toolbar is disabled.
- Server starts through `use-package! server`.
- Pixel scrolling and `touchpad-scroll-mode` are enabled when available.
- `vterm-max-scrollback` is `100000`.
- Keybindings use `A-`; vterm paste uses `xclip`.

Android:

- `my/font-size` is `32`.
- `my/line-spacing` is `0`.
- `touch-screen-display-keyboard` is enabled.
- `server-socket-dir` points to `/data/data/org.gnu.emacs/cache/emacs<UID>/server`.
- Server starts on `doom-after-init-hook`.
- Toolbar is disabled.
- Pixel scrolling and DOCX-to-PDF support are enabled.
- `doc-view-resolution` is `1200`.
- `vterm-max-scrollback` is `100000`.
- Keybindings use `A-`, with Android `<Back>` and `<Reload>` hardware keys.

## Keybinding Model

Common non-platform bindings stay in `config.el`: `C-e`, `M-n`, `M-p`, `M-0`, subword movement, `C-/`, `C-h`, `M-h`, `C-.`, `C-o`, `C-m`, `C-<return>`, `C-z`, `C-S-z`, isearch arrows, mouse mark, and dabbrev remap.

Platform modifier bindings stay in `platforms/keybindings-*.el`:

- macOS uses `s-x`, `s-c`, `s-v`, `s-j`, `s-k`, `s-w`, `s-t`, `s-q`, `s-D`, `s-r`, `s-y`, `s-Y`, `s-1`, `s-g`, `s-u`, `s-]`, `s-[`, `s-l`, `s-i`, and `s-d`.
- Linux and Android use the same commands with `A-`.
- Android also has `A-n`, `<Back>`, and `<Reload>`.

## Fonts

- Primary font: `JetBrainsMono Nerd Font`, size from `my/font-size`.
- CJK fallback: `Noto Sans JP`.
- Nerd icons fallback: `Symbols Nerd Font Mono`.
- Org mode uses `Sarasa Mono J` for CJK table alignment.
- Android includes `fonts/NotoSansJP-TTF.ttf` because the Android font driver needs TrueType outlines.

## Ukrainian Keyboard Layout Support

macOS keeps Ukrainian layout support in the shared config under `(when (eq my/platform 'macos) ...)`.

- Devil mode translates `б` to the comma-triggered control prefix.
- Key-chord cannot see multibyte characters through `input-method-function`, so Ukrainian double-tap chords are detected through `post-self-insert-hook`.
- Do not use the untracked `key-chord/` clone unless explicitly requested; the active config uses the packaged `key-chord`.

## Android Notes

See `ANDROID-SETUP.md` for installation details. `early-init.el` is an Android bootstrap snippet that must be copied into `.doom.d/` and prepended to Doom's `.emacs.d/early-init.el` on Android.

DOCX support converts files to PDF with `pandoc` and `weasyprint`, then opens the generated PDF.

## Workflow

- Shared config changes go in `config.el`.
- OS-specific changes go in `platforms/<platform>.el`.
- Modifier/keymap changes go in `platforms/keybindings-<platform>.el`.
- Doom module or package changes require `doom sync` and an Emacs restart.
- Keep `.gitignore` from the macOS branch unless there is a concrete cross-platform reason to change it.
