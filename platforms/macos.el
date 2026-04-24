;;; platforms/macos.el -*- lexical-binding: t; -*-

(setq my/font-size 15
      mac-right-option-modifier 'meta
      scroll-conservatively 101
      scroll-margin 0)

(setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))
(add-to-list 'exec-path "/opt/homebrew/bin")

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode 1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode 1))

(use-package! server
  :config
  (unless (server-running-p)
    (server-start)))
