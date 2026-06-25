;;; platforms/macos.el -*- lexical-binding: t; -*-

(setq my/font-size 15
      mac-right-option-modifier 'meta
      scroll-conservatively 101)

(dolist (path (reverse
               (delq nil
                     (list "/opt/homebrew/opt/ruby/bin"
                           (car (last (sort (file-expand-wildcards
                                             "/opt/homebrew/lib/ruby/gems/*/bin")
                                            #'string<)))
                           "/opt/homebrew/bin"))))
  (when (file-directory-p path)
    (setenv "PATH" (concat path path-separator (or (getenv "PATH") "")))
    (add-to-list 'exec-path path)))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode 1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode 1))

(use-package! server
  :config
  (unless (server-running-p)
    (server-start)))
