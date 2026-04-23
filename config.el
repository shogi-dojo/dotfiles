;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; (setq ns-command-modifier 'control)
;; (setq ns-control-modifier 'super)

;; Hlissner
;;
(setq doom-theme 'doom-dracula
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15))

;; CJK + Nerd icon font setup (matching android-config branch)
(add-hook 'after-setting-font-hook
  (lambda ()
    (let ((cjk-font (font-spec :family "Noto Sans JP"))
          (nerd-font (font-spec :family "Symbols Nerd Font Mono")))
      (set-fontset-font t 'han cjk-font)
      (set-fontset-font t 'kana cjk-font)
      (set-fontset-font t 'cjk-misc cjk-font)
      (set-fontset-font t '(#xf0000 . #xf9999) nerd-font))))

;; Org-mode: use Sarasa Mono J for perfect table alignment (monospaced CJK)
(add-hook 'org-mode-hook
  (lambda ()
    (setq-local face-remapping-alist
                '((default :family "Sarasa Mono J" :height 210)))))

(setq-default line-spacing 3)

;; Treemacs: also copy yanked paths to system clipboard
(after! treemacs
  (dolist (fn '(treemacs-copy-absolute-path-at-point
                treemacs-copy-relative-path-at-point
                treemacs-copy-project-path-at-point))
    (advice-add fn :after
      (lambda (&rest _)
        (when-let ((path (current-kill 0 t)))
          (gui-set-selection 'CLIPBOARD path))))))

(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
;; Whether display the lsp icon. It respects option `doom-modeline-icon'.
(setq doom-modeline-lsp-icon t)

;; Whether display the time icon. It respects option `doom-modeline-icon'.
(setq doom-modeline-time-icon t)

;; Whether display the live icons of time.
;; It respects option `doom-modeline-icon' and option `doom-modeline-time-icon'.
(setq doom-modeline-time-live-icon t)

;; Whether to use an analogue clock svg as the live time icon.
;; It respects options `doom-modeline-icon', `doom-modeline-time-icon', and `doom-modeline-time-live-icon'.
(setq doom-modeline-time-analogue-clock t)

(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)

(setq mac-right-option-modifier 'meta)
;; (setq mac-command-modifier 'super)
;; (setq mac-control-modifier 'control)

(super-save-mode +1)
(setq super-save-auto-save-when-idle t)
(setq auto-save-default nil)
(setq doom-modeline-vcs-max-length 30)
;; (setq doom-modeline-buffer-file-name-style 'truncate-with-project)
(setq doom-modeline-buffer-file-name-style 'buffer-name)
(scroll-bar-mode 1)

(setq-default cursor-type 'bar)
(blink-cursor-mode 1)
(context-menu-mode 1)
;(global-tab-line-mode 1)
(tool-bar-mode 1)
(setq evil-emacs-state-cursor  '("purple" bar))

(add-to-list 'exec-path "/opt/homebrew/bin")

;; Start the Emacs server so `emacsclient` can attach to this GUI instance.
(use-package! server
  :config
  (unless (server-running-p)
    (server-start)))

;; `ultra-scroll` exercises unusual redisplay paths and is the most likely
;; culprit for the fullscreen hang. Keep the conservative scrolling settings,
;; but disable the mode until fullscreen behavior is stable again.
(setq scroll-conservatively 101
      scroll-margin 0)



(setq evil-default-state 'emacs)
(key-chord-mode +1)
(global-subword-mode +1)

(defun my-evil-emacs-to-normal-hook ()
  "Function to run when switching from Emacs state to Normal state."
  ;(message "Switched from Emacs state to Normal state")
  ;; Add your custom code here
  (key-chord-unset-global "jj")
  (key-chord-unset-global "xx")
  (key-chord-unset-global "vv")
  (key-chord-unset-global "kk")
  (key-chord-unset-global "ww")
  (key-chord-unset-global "JJ")
  (key-chord-unset-global ";;")
  (key-chord-unset-global "jl")
  (key-chord-unset-global "jk")
  ;; (key-chord-unset-global "qq")
)

(defun my-evil-normal-to-emacs-hook ()
  "Function to run when switching from Normal state to Emacs state."
  ;(message "Switched from Emacs state to Normal state")
  ;; Add your custom code here
  (key-chord-define-global "jj" 'avy-goto-word-1)
  (key-chord-define-global "xx" 'execute-extended-command)
  (key-chord-define-global "vv" 'evil-execute-in-normal-state)
  (key-chord-define-global "kk" 'projectile-find-file)
  (key-chord-define-global "ww" 'switch-to-buffer)
  (key-chord-define-global "JJ" 'evil-switch-to-windows-last-buffer)
  (key-chord-define-global ";;" 'repeat)
  (key-chord-define-global "jl" 'avy-goto-line)
  (key-chord-define-global "jk" 'avy-goto-char)
  ;; (key-chord-define-global "qq" "\C-g")
)

(key-chord-define-global "jj" 'avy-goto-word-1)
(key-chord-define-global "xx" 'execute-extended-command)
;; (key-chord-define-global "vv" 'evil-execute-in-normal-state)
(key-chord-define-global "kk" 'projectile-find-file)
(key-chord-define-global "ww" 'switch-to-buffer)
(key-chord-define-global "JJ" 'crux-switch-to-previous-buffer)
(key-chord-define-global ";;" 'repeat)
(key-chord-define-global "jl" 'avy-goto-line)
(key-chord-define-global "jk" 'avy-goto-char)

(setq doom-leader-alt-key "M-SPC")
(setq doom-localleader-alt-key "M-SPC m")

;; Add the hook to run when switching from Emacs state to any other state
;; (add-hook 'evil-emacs-state-exit-hook 'my-evil-emacs-to-normal-hook)
;; (add-hook 'evil-emacs-state-entry-hook 'my-evil-normal-to-emacs-hook)

;(key-chord-define-global "jj" 'avy-goto-word-1)
;(key-chord-define-global "xx" 'execute-extended-command)
;(key-chord-define-global "vv" 'evil-execute-in-normal-state)
;(key-chord-define-global "kk" 'projectile-find-file)
;(key-chord-define-global "ww" 'switch-to-buffer)
;(key-chord-define-global "JJ" 'evil-switch-to-windows-last-buffer)
;(key-chord-define-global ";;" 'repeat)
;
;(key-chord-define-global "jl" 'avy-goto-line)
;(key-chord-define-global "jk" 'avy-goto-char)
;(key-chord-define-global "JJ" 'crux-switch-to-previous-buffer)
;(key-chord-define-global "uu" 'undo-tree-visualize)
;(key-chord-define-global "xx" 'execute-extended-command)
;;(key-chord-define-global "YY" 'browse-kill-ring)
;(key-chord-define-global "kk" 'projectile-find-file)
;(key-chord-define-global "vv" 'evil-execute-in-normal-state)
;(key-chord-define-global "ww" 'switch-to-buffer)
;;(key-chord-define-global "qq" 'keyboard-escape-quit)
;; Scrolling

;; (setq scroll-conservatively 101
;;       scroll-margin 0
;;       next-screen-context-lines 3)

;; (pixel-scroll-precision-mode)

;; (require 'devil)
(setq devil-lighter " \U0001F608")
(setq devil-prompt "\U0001F608 %t")
(global-devil-mode)

;; Also trigger devil with Ukrainian "б" (same physical key as ",")
(define-key devil-mode-map (kbd "б") #'devil)
(add-to-list 'devil-special-keys `("б б" . ,(devil-key-executor "б")))
(setq devil-translations '(("б" . "C-")
                            (", ," . ",")
                            ("б б" . "б")
                            ("," . "C-")))

(delete-selection-mode 1)

;; (setq telega-use-docker t)
;(setq writeroom-fullscreen-effect t)

;; (global-set-key (kbd "s-c") 'kill-ring-save)
(map! :nvi "C-e" #'move-end-of-line)
(setq select-enable-clipboard nil)
(map! "s-x" #'clipboard-kill-region)
(map! "s-c" #'clipboard-kill-ring-save)
(map! "s-v" #'clipboard-yank)
;; (map! "s-g" #'doom/escape)
;(map! "s-w" #'kill-current-buffer)
;(map! "s-j" #'avy-goto-word-1)
(map! "M-0" #'treemacs-select-window)
(map! "M-n" #'evil-forward-paragraph)
(map! "M-p" #'evil-backward-paragraph)
;(map! "C-RET" #'crux-smart-open-line)
;(map! "S-RET" #'crux-smart-open-line-above)
;;(map! "TAB" #'evil-jump-item)
;; (setq doom-font (font-spec :family "Iosevka Nerd Font" :size 15))
(global-set-key (kbd "C-.") 'er/expand-region)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-h") 'backward-kill-word)
(global-set-key (kbd "C-o") 'crux-smart-open-line-above)
(global-set-key (kbd "C-m") 'crux-smart-open-line)
(global-set-key (kbd "s-j") 'crux-top-join-line)
(global-set-key (kbd "s-k") 'crux-kill-whole-line)
(global-set-key (kbd "s-w") 'kill-current-buffer)
(global-set-key (kbd "s-t") 'treemacs)
(global-set-key (kbd "C-'") 'undo-redo)
;; (global-set-key (kbd "s-m") 'evil-jump-item)
;; (global-set-key (kbd "s-q") '+workspace/close-window-or-workspace)
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
;; (global-set-key (kbd "s-d") #'evil-ex-search-word-forward)
(global-set-key (kbd "S-<down-mouse-1>") #'mouse-set-mark)
(global-set-key [remap dabbrev-expand] 'hippie-expand)

(global-set-key (kbd "M-<left>") 'subword-backward)
(global-set-key (kbd "M-<right>") 'subword-forward)
(global-set-key (kbd "S-<return>") 'electric-newline-and-maybe-indent)

;;; Garbage collect when idle

;; (setq gcmh-idle-delay 'auto
;;       gcmh-auto-idle-delay-factor 10
;;       gcmh-high-cons-threshold (* 32 1024 1024))

;; (gcmh-mode)

;; ;; (hide-minor-mode 'gcmh-mode)

;; ;;; Performance

;; (setq-default bidi-paragraph-direction 'left-to-right)
;; (setq bidi-inhibit-bpa t
;;       auto-window-vscroll nil
;;       fast-but-imprecise-scrolling t
;;       redisplay-skip-fontification-on-input t
;;       auto-mode-case-fold nil
;;       pgtk-wait-for-event-timeout 0.001
;;       read-process-output-max (* 1024 1024)
;;       process-adaptive-read-buffering nil
;;       command-line-ns-option-alist nil
;;       remote-file-name-inhibit-cache 60)

;; (global-so-long-mode)




;; Xah

(defun xah-select-line ()
  "Select current line. If region is active, extend selection downward by line.
If `visual-line-mode' is on, consider line as visual line.

URL `http://xahlee.info/emacs/emacs/emacs_select_line.html'
Version: 2017-11-01 2023-07-16 2023-11-14"
  (interactive)
  (if (region-active-p)
      (if visual-line-mode
          (let ((xp1 (point)))
            (end-of-visual-line 1)
            (when (eq xp1 (point))
              (end-of-visual-line 2)))
        (progn
          (forward-line 1)
          (end-of-line)))
    (if visual-line-mode
        (progn (beginning-of-visual-line)
               (push-mark (point) t t)
               (end-of-visual-line))
      (progn
        (push-mark (line-beginning-position) t t)
        (end-of-line)))))

;; (defun mark-line (&optional arg)
;;   (interactive "p")
;;   (if (not mark-active)
;;       (progn
;;         (beginning-of-line)
;;         (push-mark)
;;         (setq mark-active t)))
;;   (forward-line arg))


(global-set-key (kbd "s-l") 'xah-select-line)


(defvar xah-brackets '( "“”" "()" "[]" "{}" "<>" "＜＞" "（）" "［］" "｛｝" "⦅⦆" "〚〛" "⦃⦄" "‹›" "«»" "「」" "〈〉" "《》" "【】" "〔〕" "⦗⦘" "『』" "〖〗" "〘〙" "｢｣" "⟦⟧" "⟨⟩" "⟪⟫" "⟮⟯" "⟬⟭" "⌈⌉" "⌊⌋" "⦇⦈" "⦉⦊" "❛❜" "❝❞" "❨❩" "❪❫" "❴❵" "❬❭" "❮❯" "❰❱" "❲❳" "〈〉" "⦑⦒" "⧼⧽" "﹙﹚" "﹛﹜" "﹝﹞" "⁽⁾" "₍₎" "⦋⦌" "⦍⦎" "⦏⦐" "⁅⁆" "⸢⸣" "⸤⸥" "⟅⟆" "⦓⦔" "⦕⦖" "⸦⸧" "⸨⸩" "｟｠" "||")
 "A list of strings, each element is a string of 2 chars, the left bracket and a matching right bracket.
Used by `xah-select-text-in-quote' and others.")

(defun xah-select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters here includes QUOTATION MARK, GRAVE ACCENT, and anything in variable `xah-brackets'.
This command ignores nesting. For example, if text is
「(a(b)c▮)」
the selected char is 「c」, not 「a(b)c」.

URL `http://xahlee.info/emacs/emacs/emacs_select_quote_text.html'
Created: 2020-11-24
Version: 2023-11-14"
  (interactive)
  (let ((xskipChars (concat "^\"`" (mapconcat #'identity xah-brackets ""))))
    (skip-chars-backward xskipChars)
    (push-mark (point) t t)
    (skip-chars-forward xskipChars)))

(defun copy-relative-file-path-to-clipboard ()
  "Copy the current buffer's file path to the clipboard.
If the buffer isn't visiting a file, show an error message."
  (interactive)
  (if buffer-file-name
      (let ((file-path (substring (+default/yank-buffer-path (doom-project-root)) 13)))
        (with-temp-buffer
          (insert file-path)
          (clipboard-kill-ring-save (point-min) (point-max)))
        (message "Copied to clipboard: %s" file-path))
    (error "Buffer is not visiting a file")))

(global-set-key (kbd "s-i") 'xah-select-text-in-quote)

(defun xah-search-current-word ()
  "Call `isearch' on current word or selection.
“word” here is A to Z, a to z, and hyphen [-] and lowline [_], independent of syntax table.

URL `http://xahlee.info/emacs/emacs/modernization_isearch.html'
Created: 2010-05-29
Version: 2025-02-05"
  (interactive)
  (let (xbeg xend)
    (if (region-active-p)
        (setq xbeg (region-beginning) xend (region-end))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq xbeg (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq xend (point))))
    (when (< xbeg (point)) (goto-char xbeg))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties xbeg xend))))

(progn
  ;; set arrow keys in isearch. left/right is backward/forward, up/down is history. press Return to exit
  ;; (define-key isearch-mode-map (kbd "M-p") 'isearch-ring-retreat )
  ;; (define-key isearch-mode-map (kbd "M-n") 'isearch-ring-advance )

  (define-key isearch-mode-map (kbd "<up>") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "<down>") 'isearch-repeat-forward)

  (define-key minibuffer-local-isearch-map (kbd "<up>") 'isearch-reverse-exit-minibuffer)
  (define-key minibuffer-local-isearch-map (kbd "<down>") 'isearch-forward-exit-minibuffer))

(global-set-key (kbd "s-d") 'xah-search-current-word)

;; (defun move-line-up ()
;;   "Move current line up one line."
;;   (interactive)
;;   (transpose-lines 1)
;;   (forward-line -2)
;;   (indent-according-to-mode))

;; (defun move-line-down ()
;;   "Move current line down one line."
;;   (interactive)
;;   (forward-line 1)
;;   (transpose-lines 1)
;;   (forward-line -1)
;;   (indent-according-to-mode))

;; (global-set-key [(super shift up)] 'move-line-up)
;; (global-set-key [(super shift down)] 'move-line-down)

;; (after! drag-stuff
;;   (drag-stuff-global-mode -1))

;; Add Homebrew paths to Emacs exec-path so it can find zstd and other tools
(setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))
(add-to-list 'exec-path "/opt/homebrew/bin")

(defun my/vterm-paste-from-clipboard ()
  "Paste from macOS system clipboard into vterm."
  (interactive)
  (vterm-send-string (shell-command-to-string "pbpaste")))
(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "s-v") #'my/vterm-paste-from-clipboard))
