;;; platforms/keybindings-linux.el -*- lexical-binding: t; -*-

(global-set-key (kbd "A-x") 'clipboard-kill-region)
(global-set-key (kbd "A-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "A-v") 'clipboard-yank)

(global-set-key (kbd "A-j") 'crux-top-join-line)
(global-set-key (kbd "A-k") 'crux-kill-whole-line)
(global-set-key (kbd "A-w") 'kill-current-buffer)
(global-set-key (kbd "A-t") 'treemacs)
(global-set-key (kbd "A-q") 'delete-window)
(global-set-key (kbd "A-D") '+default/search-project-for-symbol-at-point)
(global-set-key (kbd "A-r") '+vertico/search-symbol-at-point)
(global-set-key (kbd "A-y") 'crux-duplicate-current-line-or-region)
(global-set-key (kbd "A-Y") 'crux-duplicate-and-comment-current-line-or-region)
(global-set-key (kbd "A-1") 'delete-other-windows)
(global-set-key (kbd "A-g") 'magit-status)
(global-set-key (kbd "A-u") #'+fold/toggle)
(global-set-key (kbd "A-]") #'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "A-[") #'indent-rigidly-left-to-tab-stop)
(global-set-key (kbd "A-l") 'xah-select-line)
(global-set-key (kbd "A-i") 'xah-select-text-in-quote)
(global-set-key (kbd "A-d") 'xah-search-current-word)

(defun my/vterm-paste-from-clipboard ()
  "Paste from X11 clipboard into vterm."
  (interactive)
  (vterm-send-string (shell-command-to-string "xclip -selection clipboard -o")))

(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "A-v") #'my/vterm-paste-from-clipboard))
