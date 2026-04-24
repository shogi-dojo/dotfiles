;;; platforms/linux.el -*- lexical-binding: t; -*-

(setq my/font-size 14
      scroll-margin 0
      jit-lock-defer-time 0.05
      fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      vterm-max-scrollback 100000)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(use-package! server
  :config
  (unless (server-running-p)
    (server-start)))

(when (require 'touchpad nil t)
  (setq touchpad-pixel-scroll t)
  (touchpad-scroll-mode 1))
