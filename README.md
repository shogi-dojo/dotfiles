# Doom Emacs Config

Unified Doom Emacs configuration for macOS, Linux, and Android/Termux.

The config uses runtime platform detection in `config.el`, then loads a small platform overlay from `platforms/`. The goal is one branch and one shared config instead of separate branch-per-platform copies.

## File Structure

| Path | Purpose |
|------|---------|
| `config.el` | Shared Doom config, common UI, behavior, key chords, functions, and file associations |
| `platforms/macos.el` | macOS-only paths, server startup, scrolling, toolbar, and font size |
| `platforms/linux.el` | Linux-only server startup, touchpad scrolling, toolbar, and font size |
| `platforms/android.el` | Android/Termux server socket, touch keyboard, DOCX/PDF setup, scrolling, and font size |
| `platforms/keybindings-macos.el` | macOS `s-` keybindings and vterm paste via `pbpaste` |
| `platforms/keybindings-linux.el` | Linux `C-c` prefix keybindings and vterm paste via `xclip` |
| `platforms/keybindings-android.el` | Android `A-` keybindings, hardware keys, and vterm clipboard paste |
| `init.el` | Doom module superset used by all platforms |
| `packages.el` | Package superset used by all platforms |
| `custom.el` | Emacs Customize output; do not edit manually |
| `early-init.el` | Android Termux PATH/DOOMDIR bootstrap snippet |
| `ANDROID-SETUP.md` | Android setup guide |
| `fonts/NotoSansJP-TTF.ttf` | Android-compatible CJK fallback font |

## Platform Detection

`config.el` sets `my/platform` to:

| Platform | Detection |
|----------|-----------|
| `macos` | `system-type` is `darwin` |
| `android` | `system-type` is `gnu/linux` and Termux markers are present |
| `linux` | other `gnu/linux` systems |

Each platform file sets `my/font-size` before the common font config runs. Android also sets `my/line-spacing` to `0`; other platforms use the common default of `3`.

## Keybindings

Common bindings live in `config.el`. Platform modifier bindings live in `platforms/keybindings-*.el`.

| Platform | System modifier bindings |
|----------|--------------------------|
| macOS | `s-` prefix, matching Command-style shortcuts |
| Linux | `C-c` prefix |
| Android | `A-` prefix plus `<Back>` and `<Reload>` hardware keys |

Clipboard integration keeps `select-enable-clipboard` disabled, so the Emacs kill ring remains separate from the system clipboard. Use platform bindings such as `s-c`/`s-v` on macOS, `C-c c`/`C-c v` on Linux, or `A-c`/`A-v` on Android for system clipboard operations.

## Editing Guidance

Put shared behavior in `config.el`. Put OS-specific behavior in `platforms/<platform>.el`. Put modifier-specific keybindings in `platforms/keybindings-<platform>.el`.

Changes to `config.el` can usually be reloaded in Emacs. Changes to `init.el` or `packages.el` require:

```bash
doom sync
```

Then restart Emacs.

## Shell Integration

The `e` and `ec` commands are shell aliases managed outside this repo.

```bash
alias e='emacsclient -n -a "emacs"'
alias ec='emacsclient -n -c -a "emacs"'
```

They currently live in `~/.bash_profile`.
