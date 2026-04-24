;;; platforms/keybindings-android.el -*- lexical-binding: t; -*-

(setq my/platform-keybinding-format "A-%s"
      my/vterm-paste-source 'gui-selection
      my/platform-extra-keybinding-keys
      '((new-buffer . "A-n")
        (previous-buffer . "<Back>")
        (reload-buffer . "<Reload>")))
