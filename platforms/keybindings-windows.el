;;; platforms/keybindings-windows.el -*- lexical-binding: t; -*-

;; Reuse the Linux key layout, but use the native Windows GUI clipboard.
(setq my/platform-keybinding-format "C-c %s"
      my/vterm-paste-source 'gui-selection)
