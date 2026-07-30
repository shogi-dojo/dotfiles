;;; platforms/ios/reader.el --- Portable reading mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  shogi-dojo

;; This file is part of the shogi-dojo emacs-config repository.
;; It is used unchanged by both the desktop Doom configuration and the
;; standalone iOS Emacs profile, so it must never require Doom, Evil,
;; or any external package beyond Emacs built-ins.

;;; Commentary:

;; Provides `ios/reading-mode', a buffer-local minor mode that:
;;
;;   - saves and restores: read-only state, header-line-format,
;;     mode-line-format, visual-line-mode, and line-spacing
;;   - switches to wrapped text with a comfortable line spacing
;;   - suppresses the header and condenses the mode-line to a compact
;;     progress indicator (or hides it entirely on iOS)
;;   - applies a high-contrast face suitable for terminal book reading
;;
;; Keybindings for EPUB (nov-mode) are wired up by ios/init.el, not
;; here, so that this file stays Doom-loadable without nov being
;; installed.
;;
;; Usage in Doom config.el (replaces the old `book-mode' minor mode):
;;
;;   (require 'platforms/ios/reader)   ; or add to load-path
;;   (add-hook 'nov-mode-hook #'ios/reading-mode)

;;; Code:

(defgroup ios/reader nil
  "Portable reading-mode settings."
  :group 'text
  :prefix "ios/reader-")

(defcustom ios/reader-line-spacing 0.15
  "Line spacing applied when reading mode is active."
  :type 'number
  :group 'ios/reader)

(defcustom ios/reader-compact-mode-line
  "[ %p | %l/%L ]"
  "Mode-line format string shown in reading mode.
Set to nil to hide the mode-line entirely (recommended on iOS)."
  :type '(choice string (const nil))
  :group 'ios/reader)

;; Per-buffer saved state -----------------------------------------------

(defvar-local ios/reader--saved-read-only nil)
(defvar-local ios/reader--saved-header-line nil)
(defvar-local ios/reader--saved-mode-line nil)
(defvar-local ios/reader--saved-visual-line nil)
(defvar-local ios/reader--saved-line-spacing nil)
(defvar-local ios/reader--face-cookies nil
  "List of `face-remap-add-relative' cookies to be removed on exit.")

(defun ios/reader--apply-faces ()
  "Apply high-contrast reading faces; store cookies for cleanup."
  (setq ios/reader--face-cookies
        (list
         (face-remap-add-relative 'default
                                  :background "black" :foreground "#e8e8e0")
         (face-remap-add-relative 'font-lock-keyword-face     :foreground "#e8e8e0")
         (face-remap-add-relative 'font-lock-string-face      :foreground "#e8e8e0")
         (face-remap-add-relative 'font-lock-comment-face     :foreground "#888888")
         (face-remap-add-relative 'font-lock-function-name-face :foreground "#e8e8e0")
         (face-remap-add-relative 'font-lock-variable-name-face :foreground "#e8e8e0")
         (face-remap-add-relative 'font-lock-type-face        :foreground "#e8e8e0")
         (face-remap-add-relative 'font-lock-constant-face    :foreground "#e8e8e0")
         (face-remap-add-relative 'font-lock-builtin-face     :foreground "#e8e8e0")
         (face-remap-add-relative 'region     :background "#444444" :foreground "#e8e8e0")
         (face-remap-add-relative 'hl-line    :background "#1a1a1a"))))

(defun ios/reader--remove-faces ()
  "Remove all face-remap cookies stored during reading-mode entry."
  (dolist (cookie ios/reader--face-cookies)
    (face-remap-remove-relative cookie))
  (setq ios/reader--face-cookies nil))

;;;###autoload
(define-minor-mode ios/reading-mode
  "Distraction-free reading mode (Doom-independent).

Saves and restores read-only state, header/mode-line, visual-line-mode,
and line-spacing.  Toggle with \\[ios/reading-mode] or `C-c r'."
  :lighter " Read"
  :group 'ios/reader
  (if ios/reading-mode
      ;; --- Enable --------------------------------------------------
      (progn
        ;; Save state
        (setq ios/reader--saved-read-only    buffer-read-only
              ios/reader--saved-header-line  header-line-format
              ios/reader--saved-mode-line    mode-line-format
              ios/reader--saved-visual-line  visual-line-mode
              ios/reader--saved-line-spacing line-spacing)
        ;; Apply reading layout
        (setq-local header-line-format nil)
        (setq-local mode-line-format   ios/reader-compact-mode-line)
        (setq-local line-spacing       ios/reader-line-spacing)
        (unless visual-line-mode (visual-line-mode 1))
        (setq buffer-read-only t)
        (ios/reader--apply-faces))
    ;; --- Disable -------------------------------------------------
    (ios/reader--remove-faces)
    (setq buffer-read-only    ios/reader--saved-read-only
          header-line-format  ios/reader--saved-header-line
          mode-line-format    ios/reader--saved-mode-line
          line-spacing        ios/reader--saved-line-spacing)
    (unless ios/reader--saved-visual-line
      (visual-line-mode -1))))

;;;###autoload
(defun ios/reading-mode-leave-edit ()
  "Leave read-only mode for editing without disabling `ios/reading-mode'.
Bound to `e' in reading mode.  `C-c r' fully toggles reading mode."
  (interactive)
  (if (bound-and-true-p ios/reading-mode)
      (setq buffer-read-only nil)
    (message "Not in reading mode.")))

(provide 'reader)
;;; reader.el ends here
