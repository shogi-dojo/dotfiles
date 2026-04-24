;;; platforms/keybindings-linux.el -*- lexical-binding: t; -*-

(global-set-key (kbd "C-c x") 'clipboard-kill-region)
(global-set-key (kbd "C-c c") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-c v") 'clipboard-yank)

(global-set-key (kbd "C-c j") 'crux-top-join-line)
(global-set-key (kbd "C-c k") 'crux-kill-whole-line)
(global-set-key (kbd "C-c w") 'kill-current-buffer)
(global-set-key (kbd "C-c t") 'treemacs)
(global-set-key (kbd "C-c q") 'delete-window)
(global-set-key (kbd "C-c D") '+default/search-project-for-symbol-at-point)
(global-set-key (kbd "C-c r") '+vertico/search-symbol-at-point)
(global-set-key (kbd "C-c y") 'crux-duplicate-current-line-or-region)
(global-set-key (kbd "C-c Y") 'crux-duplicate-and-comment-current-line-or-region)
(global-set-key (kbd "C-c 1") 'delete-other-windows)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c u") #'+fold/toggle)
(global-set-key (kbd "C-c ]") #'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "C-c [") #'indent-rigidly-left-to-tab-stop)
(global-set-key (kbd "C-c l") 'xah-select-line)
(global-set-key (kbd "C-c i") 'xah-select-text-in-quote)
(global-set-key (kbd "C-c d") 'xah-search-current-word)

(defun my/vterm-paste-from-clipboard ()
  "Paste from X11 clipboard into vterm."
  (interactive)
  (vterm-send-string (shell-command-to-string "xclip -selection clipboard -o")))

(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "C-c v") #'my/vterm-paste-from-clipboard))
