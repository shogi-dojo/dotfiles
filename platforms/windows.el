;;; platforms/windows.el -*- lexical-binding: t; -*-

;; Prefer fonts already installed for this Windows profile.  The common
;; configuration still supplies Symbols Nerd Font Mono for icon glyphs.
(setq my/font-size 32
      my/font-family "Iosevka NF"
      my/cjk-font-family "MS Gothic"
      my/org-font-family "MS Gothic")

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(add-hook 'doom-after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))
