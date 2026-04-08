;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Android — always show on-screen keyboard
(setq touch-screen-display-keyboard t)

;;; Appearance

(setq doom-theme 'doom-dracula
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 32))
(add-hook 'after-setting-font-hook
  (lambda ()
    (let ((cjk-font (font-spec :family "Noto Sans JP")))
      (set-fontset-font t 'han cjk-font)
      (set-fontset-font t 'kana cjk-font)
      (set-fontset-font t 'cjk-misc cjk-font))))
(setq-default line-spacing 0)
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)
(setq display-line-numbers-type nil)
(setq-default cursor-type 'bar)
(setq evil-emacs-state-cursor '("purple" bar))
(scroll-bar-mode 1)
(blink-cursor-mode 1)
(context-menu-mode 1)
(tool-bar-mode -1)

(setq doom-modeline-icon t
      doom-modeline-major-mode-icon t
      doom-modeline-major-mode-color-icon t
      doom-modeline-lsp-icon t
      doom-modeline-time-icon t
      doom-modeline-time-live-icon t
      doom-modeline-time-analogue-clock t
      doom-modeline-vcs-max-length 30
      doom-modeline-buffer-file-name-style 'buffer-name)

;;; Behavior

(setq org-directory "~/org/")
(setq evil-default-state 'emacs)
(setq select-enable-clipboard nil)
(delete-selection-mode 1)
(global-subword-mode +1)

(super-save-mode +1)
(setq super-save-auto-save-when-idle t
      auto-save-default nil)

(setq doom-leader-alt-key "M-SPC"
      doom-localleader-alt-key "M-SPC m")

;;; Devil mode

(setq devil-lighter " \U0001F608"
      devil-prompt "\U0001F608 %t")
(global-devil-mode)

;;; Key chords

(key-chord-mode +1)
(key-chord-define-global "jj" 'avy-goto-word-1)
(key-chord-define-global "jk" 'avy-goto-char)
(key-chord-define-global "jl" 'avy-goto-line)
(key-chord-define-global "xx" 'execute-extended-command)
(key-chord-define-global "kk" 'projectile-find-file)
(key-chord-define-global "ww" 'switch-to-buffer)
(key-chord-define-global "JJ" 'crux-switch-to-previous-buffer)
(key-chord-define-global ";;" 'repeat)

;;; Keybindings — navigation

(global-set-key (kbd "A-n") '+default/new-buffer)
(global-set-key (kbd "C-e") 'move-end-of-line)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-0") 'treemacs-select-window)
(global-set-key (kbd "M-<left>") 'subword-backward)
(global-set-key (kbd "M-<right>") 'subword-forward)
(global-set-key (kbd "<Back>") 'crux-switch-to-previous-buffer)
(global-set-key (kbd "<Reload>") 'revert-buffer)

;;; Keybindings — editing

(global-set-key (kbd "C-/") 'comment-line)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-h") 'backward-kill-word)
(add-hook 'doom-after-init-hook
  (lambda ()
    (global-set-key (kbd "C-z") 'undo)
    (global-set-key (kbd "C-S-z") 'undo-redo)))
(global-set-key (kbd "C-.") 'er/expand-region)
(global-set-key (kbd "C-o") 'crux-smart-open-line-above)
(global-set-key (kbd "C-m") 'crux-smart-open-line)
(global-set-key (kbd "C-<return>") 'electric-newline-and-maybe-indent)
(global-set-key (kbd "S-<down-mouse-1>") 'mouse-set-mark)
(global-set-key [remap dabbrev-expand] 'hippie-expand)

;;; Keybindings — C-c prefix

(global-set-key (kbd "C-c c") 'clipboard-kill-ring-save)
(global-set-key (kbd "C-c v") 'clipboard-yank)
(global-set-key (kbd "C-c x") 'clipboard-kill-region)
(global-set-key (kbd "C-c d") 'xah-search-current-word)
(global-set-key (kbd "C-c i") 'xah-select-text-in-quote)
(global-set-key (kbd "C-c j") 'crux-top-join-line)
(global-set-key (kbd "C-c k") 'crux-kill-whole-line)
(global-set-key (kbd "C-c l") 'xah-select-line)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c q") 'delete-window)
(global-set-key (kbd "C-c r") '+vertico/search-symbol-at-point)
(global-set-key (kbd "C-c t") 'treemacs)
(global-set-key (kbd "C-c u") '+fold/toggle)
(global-set-key (kbd "C-c w") 'kill-current-buffer)
(global-set-key (kbd "C-c y") 'crux-duplicate-current-line-or-region)
(global-set-key (kbd "C-c Y") 'crux-duplicate-and-comment-current-line-or-region)
(global-set-key (kbd "C-c D") '+default/search-project-for-symbol-at-point)
(global-set-key (kbd "C-c ]") 'indent-rigidly-right-to-tab-stop)
(global-set-key (kbd "C-c [") 'indent-rigidly-left-to-tab-stop)

;;; Isearch

(define-key isearch-mode-map (kbd "<up>") 'isearch-repeat-backward)
(define-key isearch-mode-map (kbd "<down>") 'isearch-repeat-forward)
(define-key minibuffer-local-isearch-map (kbd "<up>") 'isearch-reverse-exit-minibuffer)
(define-key minibuffer-local-isearch-map (kbd "<down>") 'isearch-forward-exit-minibuffer)

;;; Custom functions

(defun xah-select-line ()
  "Select current line. If region is active, extend selection downward by line.
If `visual-line-mode' is on, consider line as visual line."
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

(defvar xah-brackets '( """" "()" "[]" "{}" "<>" "＜＞" "（）" "［］" "｛｝" "⦅⦆" "〚〛" "⦃⦄" "‹›" "«»" "「」" "〈〉" "《》" "【】" "〔〕" "⦗⦘" "『』" "〖〗" "〘〙" "｢｣" "⟦⟧" "⟨⟩" "⟪⟫" "⟮⟯" "⟬⟭" "⌈⌉" "⌊⌋" "⦇⦈" "⦉⦊" "❛❜" "❝❞" "❨❩" "❪❫" "❴❵" "❬❭" "❮❯" "❰❱" "❲❳" "〈〉" "⦑⦒" "⧼⧽" "﹙﹚" "﹛﹜" "﹝﹞" "⁽⁾" "₍₎" "⦋⦌" "⦍⦎" "⦏⦐" "⁅⁆" "⸢⸣" "⸤⸥" "⟅⟆" "⦓⦔" "⦕⦖" "⸦⸧" "⸨⸩" "｟｠" "||")
  "Matching bracket pairs for `xah-select-text-in-quote'.")

(defun xah-select-text-in-quote ()
  "Select text between the nearest left and right delimiters."
  (interactive)
  (let ((xskipChars (concat "^\"`" (mapconcat #'identity xah-brackets ""))))
    (skip-chars-backward xskipChars)
    (push-mark (point) t t)
    (skip-chars-forward xskipChars)))

(defun xah-search-current-word ()
  "Call `isearch' on current word or selection."
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

(defun copy-relative-file-path-to-clipboard ()
  "Copy the current buffer's relative file path to the clipboard."
  (interactive)
  (if buffer-file-name
      (let ((file-path (substring (+default/yank-buffer-path (doom-project-root)) 13)))
        (with-temp-buffer
          (insert file-path)
          (clipboard-kill-ring-save (point-min) (point-max)))
        (message "Copied to clipboard: %s" file-path))
    (error "Buffer is not visiting a file")))

;;; File associations

(add-to-list 'auto-mode-alist '("\\.env\\..*\\'" . dotenv-mode))

;;; Smooth touchpad scrolling

(pixel-scroll-precision-mode 1)
(setq scroll-margin 0)
(setq jit-lock-defer-time 0.05
      fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t)
;; (require 'touchpad)
;; (setq touchpad-pixel-scroll t)
;; (touchpad-scroll-mode 1)

;;; Agent Shell

(require 'acp)
(require 'agent-shell)

;;; Vterm

(defun my/vterm-paste-from-clipboard ()
  "Paste from system clipboard into vterm."
  (interactive)
  (vterm-send-string (gui-get-selection 'CLIPBOARD 'STRING)))

(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "C-c v") #'my/vterm-paste-from-clipboard))

(setq vterm-max-scrollback 100000)

;;; Minor modes

(define-minor-mode book-mode
    "Make current buffer look like a book — black text on white background."
    :lighter " Book"
    (if book-mode
        (progn
          (face-remap-add-relative 'default
                                   :background "white"
                                   :foreground "black")
          (face-remap-add-relative 'font-lock-keyword-face
                                   :foreground "black")
          (face-remap-add-relative 'font-lock-string-face
                                   :foreground "black")
          (face-remap-add-relative 'font-lock-comment-face
                                   :foreground "gray40")
          (face-remap-add-relative 'font-lock-function-name-face
                                   :foreground "black")
          (face-remap-add-relative 'font-lock-variable-name-face
                                   :foreground "black")
          (face-remap-add-relative 'font-lock-type-face
                                   :foreground "black")
          (face-remap-add-relative 'font-lock-constant-face
                                   :foreground "black")
          (face-remap-add-relative 'font-lock-builtin-face
                                   :foreground "black")
          (face-remap-add-relative 'hl-line
                           :background "gray90")
          (face-remap-add-relative 'cursor
                           :background "black")
          (face-remap-add-relative 'region
                           :background "light blue"
                           :foreground "black")
          ;; bigger font for readability
          (text-scale-set 2))
      ;; turning off — reset
      (text-scale-set 0)
      ;; face remappings are buffer-local and cleared when mode is off
      (face-remap-reset-base 'default)))

