# Doom Emacs Config

This repository tracks the Doom Emacs configuration in this directory:

- `config.el`
- `init.el`
- `packages.el`
- `custom.el`

## Scope

This repo is for Emacs/Doom configuration only. It is not currently structured
as a general-purpose dotfiles repository.

## Shell Integration

The `e` and `ec` commands are shell aliases, so they are managed outside this
repo in shell startup files.

Current aliases:

```bash
alias e='emacsclient -n -a "emacs"'
alias ec='emacsclient -n -c -a "emacs"'
```

At the moment they live in `~/.bash_profile`.
