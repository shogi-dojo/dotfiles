;;; platforms/keybindings-macos.el -*- lexical-binding: t; -*-

(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-v") 'clipboard-yank)

(global-set-key (kbd "s-j") 'crux-top-join-line)
(global-set-key (kbd "s-k") 'crux-kill-whole-line)
(global-set-key (kbd "s-w") 'kill-current-buffer)
(global-set-key (kbd "s-t") 'treemacs)
(global-set-key (kbd "s-q") 'delete-window)
(global-set-key (kbd "s-D") '+default/search-project-for-symbol-at-point)
(global-set-key (kbd "s-r") '+vertico/search-symbol-at-point)
(global-set-key (kbd "s-y") 'crux-duplicate-current-line-or-region)
(global-set-key (kbd "s-Y") 'crux-duplicate-and-comment-current-line-or-region)
(global-set-key (kbd "s-1") 'delete-other-windows)
(global-set-key (kbd "s-g") 'magit-status)
(global-set-key (kbd "s-u") #'+fold/toggle)
(global-set-key (kbd "s-]") #'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "s-[") #'indent-rigidly-left-to-tab-stop)
(global-set-key (kbd "s-l") 'xah-select-line)
(global-set-key (kbd "s-i") 'xah-select-text-in-quote)
(global-set-key (kbd "s-d") 'xah-search-current-word)

(defun my/vterm-paste-from-clipboard ()
  "Paste from macOS system clipboard into vterm."
  (interactive)
  (vterm-send-string (shell-command-to-string "pbpaste")))

(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "s-v") #'my/vterm-paste-from-clipboard))
