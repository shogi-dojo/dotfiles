;;; platforms/ios/init.el --- Standalone iOS Emacs reader profile  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  shogi-dojo
;;
;; This file is the entry-point for the *standalone* iOS Emacs instance.
;; It does NOT load Doom, Evil, use-package, or any package-manager.
;; Only Emacs built-ins, the portable reader layer (reader.el), and the
;; vendored nov.el / esxml.el / esxml-query.el are used.
;;
;; Deployment:  ~/.emacs.d/ios/init.el
;; Loaded via:  ~/.emacs.d/init.el shim that checks IS-IOS flag.
;;
;; See platforms/ios/README.md for setup instructions.

;;; ----------------------------------------------------------------
;;; 0.  Paths
;;; ----------------------------------------------------------------

(defconst ios/profile-dir
  (file-name-directory (or load-file-name buffer-file-name))
  "Directory containing this init.el (…/platforms/ios/).")

(defconst ios/vendor-dir
  (expand-file-name "vendor" ios/profile-dir)
  "Directory containing vendored Elisp (nov.el, esxml*.el).")

;; Add vendor to load-path so (require 'nov) works.
(add-to-list 'load-path ios/vendor-dir)
;; Add profile dir to load-path so (require 'reader) works.
(add-to-list 'load-path ios/profile-dir)

;;; ----------------------------------------------------------------
;;; 1.  Core UI
;;; ----------------------------------------------------------------

;; Disable all chrome that serves no purpose in a terminal.
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)   (tool-bar-mode   -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No startup screen; open Books dir.
(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      initial-major-mode 'dired-mode
      initial-buffer-choice (expand-file-name "~/Books"))

;; Sane defaults for a small terminal.
(setq-default fill-column 80
              truncate-lines nil
              word-wrap t)

;; Persist minibuffer history across sessions.
(savehist-mode 1)

;; Persist bookmarks (reading positions stored there by nov.el).
(setq bookmark-default-file
      (expand-file-name "~/.emacs.d/ios/bookmarks"))

;;; ----------------------------------------------------------------
;;; 2.  Portable reader layer
;;; ----------------------------------------------------------------

(require 'reader)

;; Hide mode-line entirely on iOS (single tiny terminal window).
(setq ios/reader-compact-mode-line nil)

;;; ----------------------------------------------------------------
;;; 3.  Vendor: esxml + nov.el
;;; ----------------------------------------------------------------

(require 'esxml)
(require 'esxml-query)
(require 'nov)

;; Point nov at the Procursus rootless unzip.
(setq nov-unzip-program "/var/jb/usr/bin/unzip")

;; Terminal-friendly nov settings: no images, no SVG, wrapped text.
(setq nov-text-width          t    ; wrap at window width
      nov-header-line-format  nil  ; no header (reader.el hides it anyway)
      nov-variable-pitch       nil ; use monospace terminal font
      nov-render-html-function #'nov-render-html-shr
      shr-use-colors           nil ; don't try to set colours via ANSI
      shr-use-fonts            nil ; no variable-pitch in terminal
      shr-inhibit-images        t  ; no images
      shr-max-image-proportion  0) ; belt-and-suspenders

;; Persistent reading positions via nov-places.
(setq nov-save-place-file
      (expand-file-name "~/.emacs.d/ios/nov-places"))

;; Auto-open .epub files with nov-mode.
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; Apply the reading face and layout whenever nov-mode activates.
(add-hook 'nov-mode-hook #'ios/reading-mode)

;;; ----------------------------------------------------------------
;;; 4.  Org and Markdown read-only readers
;;; ----------------------------------------------------------------

(defun ios/org-reader-setup ()
  "Open Org buffer in read-only mode with reading layout."
  (ios/reading-mode 1))

(defun ios/md-reader-setup ()
  "Open Markdown-ish text in read-only mode with outline folding."
  (outline-minor-mode 1)
  (ios/reading-mode 1))

;; .org  -> built-in org-mode, then reading mode
(add-hook 'org-mode-hook #'ios/org-reader-setup)

;; .md / .markdown -> text-mode + outline reading mode
(add-to-list 'auto-mode-alist '("\\.md\\'"       . text-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . text-mode))
(add-hook    'text-mode-hook  #'ios/md-reader-setup)

;;; ----------------------------------------------------------------
;;; 5.  Global keybindings
;;; ----------------------------------------------------------------

;; C-c r: toggle reading mode from either state.
(global-set-key (kbd "C-c r") #'ios/reading-mode)

;; e: leave read-only for editing (inside reading-mode buffers).
(define-key (make-sparse-keymap) (kbd "e") #'ios/reading-mode-leave-edit)

;; Wire up nov navigation keys.
(with-eval-after-load 'nov
  (define-key nov-mode-map (kbd "SPC")   #'scroll-up-command)
  (define-key nov-mode-map (kbd "DEL")   #'scroll-down-command)
  (define-key nov-mode-map (kbd "n")     #'nov-next-document)
  (define-key nov-mode-map (kbd "p")     #'nov-previous-document)
  (define-key nov-mode-map (kbd "t")     #'nov-goto-toc)
  (define-key nov-mode-map (kbd "/")     #'isearch-forward)
  (define-key nov-mode-map (kbd "g")     #'beginning-of-buffer)
  (define-key nov-mode-map (kbd "G")     #'end-of-buffer)
  (define-key nov-mode-map (kbd "m")     #'ios/reading-mode-toggle-modeline)
  (define-key nov-mode-map (kbd "e")     #'ios/reading-mode-leave-edit)
  (define-key nov-mode-map (kbd "C-c r") #'ios/reading-mode)
  (define-key nov-mode-map (kbd "q")     #'kill-current-buffer))

;;; ----------------------------------------------------------------
;;; 6.  Mode-line toggle helper
;;; ----------------------------------------------------------------

(defun ios/reading-mode-toggle-modeline ()
  "Toggle between the compact progress mode-line and no mode-line."
  (interactive)
  (setq-local mode-line-format
              (if mode-line-format
                  nil
                ios/reader-compact-mode-line))
  (force-mode-line-update))

;;; ----------------------------------------------------------------
;;; 7.  Startup: open ~/Books in Dired
;;; ----------------------------------------------------------------

(defun ios/open-books-dir ()
  "Open ~/Books in Dired on startup; create if absent."
  (let ((books (expand-file-name "~/Books")))
    (unless (file-directory-p books)
      (make-directory books t))
    (dired books)))

(add-hook 'emacs-startup-hook #'ios/open-books-dir)

(provide 'ios-init)
;;; init.el ends here
