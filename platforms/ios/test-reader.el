;;; platforms/ios/test-reader.el --- ERT tests for ios/reading-mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  shogi-dojo

;; Run with:
;;   emacs -Q --batch -L platforms/ios -l ert -l test-reader.el -f ert-run-tests-batch-and-exit

;;; Commentary:

;; Tests the portable ios/reading-mode layer in isolation — no Doom,
;; no Evil, no external packages.

;;; Code:

(require 'ert)

;; Load reader.el from the same directory as this test file.
(load (expand-file-name "reader"
                        (file-name-directory
                         (or load-file-name buffer-file-name (buffer-file-name)))))

;;; ----------------------------------------------------------------
;;; Helpers
;;; ----------------------------------------------------------------

(defmacro ios/test-with-buffer (&rest body)
  "Run BODY inside a temporary buffer with a clean reading-mode slate."
  (declare (indent 0))
  `(with-temp-buffer
     (insert "Test content\nLine 2\nLine 3\n")
     ,@body))

;;; ----------------------------------------------------------------
;;; 1.  State save / restore
;;; ----------------------------------------------------------------

(ert-deftest ios/reader-test-saves-read-only ()
  "Enabling reading mode saves the current read-only state."
  (ios/test-with-buffer
    (setq buffer-read-only nil)
    (ios/reading-mode 1)
    (should (eq ios/reader--saved-read-only nil))
    (ios/reading-mode -1)))

(ert-deftest ios/reader-test-restores-read-only ()
  "Disabling reading mode restores the original read-only state."
  (ios/test-with-buffer
    (setq buffer-read-only nil)
    (ios/reading-mode 1)
    (ios/reading-mode -1)
    (should (eq buffer-read-only nil))))

(ert-deftest ios/reader-test-saves-header-line ()
  "Enabling reading mode saves the header-line-format."
  (ios/test-with-buffer
    (setq header-line-format "original-header")
    (ios/reading-mode 1)
    (should (equal ios/reader--saved-header-line "original-header"))
    (ios/reading-mode -1)))

(ert-deftest ios/reader-test-restores-header-line ()
  "Disabling reading mode restores header-line-format."
  (ios/test-with-buffer
    (setq header-line-format "original-header")
    (ios/reading-mode 1)
    (ios/reading-mode -1)
    (should (equal header-line-format "original-header"))))

(ert-deftest ios/reader-test-saves-mode-line ()
  "Enabling reading mode saves mode-line-format."
  (ios/test-with-buffer
    (setq mode-line-format '("%b"))
    (ios/reading-mode 1)
    (should (equal ios/reader--saved-mode-line '("%b")))
    (ios/reading-mode -1)))

(ert-deftest ios/reader-test-restores-mode-line ()
  "Disabling reading mode restores mode-line-format."
  (ios/test-with-buffer
    (setq mode-line-format '("%b"))
    (ios/reading-mode 1)
    (ios/reading-mode -1)
    (should (equal mode-line-format '("%b")))))

;;; ----------------------------------------------------------------
;;; 2.  Layout state
;;; ----------------------------------------------------------------

(ert-deftest ios/reader-test-enables-read-only ()
  "Reading mode makes the buffer read-only."
  (ios/test-with-buffer
    (setq buffer-read-only nil)
    (ios/reading-mode 1)
    (should buffer-read-only)
    (ios/reading-mode -1)))

(ert-deftest ios/reader-test-suppresses-header ()
  "Reading mode sets header-line-format to nil."
  (ios/test-with-buffer
    (setq header-line-format "some header")
    (ios/reading-mode 1)
    (should (null header-line-format))
    (ios/reading-mode -1)))

(ert-deftest ios/reader-test-sets-line-spacing ()
  "Reading mode applies ios/reader-line-spacing."
  (ios/test-with-buffer
    (setq line-spacing nil)
    (ios/reading-mode 1)
    (should (eq line-spacing ios/reader-line-spacing))
    (ios/reading-mode -1)))

(ert-deftest ios/reader-test-restores-line-spacing ()
  "Disabling reading mode restores original line-spacing."
  (ios/test-with-buffer
    (setq line-spacing 0.5)
    (ios/reading-mode 1)
    (ios/reading-mode -1)
    (should (eql line-spacing 0.5))))

;;; ----------------------------------------------------------------
;;; 3.  Face cookies
;;; ----------------------------------------------------------------

(ert-deftest ios/reader-test-face-cookies-set ()
  "Enabling reading mode populates ios/reader--face-cookies."
  (ios/test-with-buffer
    (ios/reading-mode 1)
    (should ios/reader--face-cookies)
    (ios/reading-mode -1)))

(ert-deftest ios/reader-test-face-cookies-cleared ()
  "Disabling reading mode removes all face cookies."
  (ios/test-with-buffer
    (ios/reading-mode 1)
    (ios/reading-mode -1)
    (should (null ios/reader--face-cookies))))

;;; ----------------------------------------------------------------
;;; 4.  Leave-edit helper
;;; ----------------------------------------------------------------

(ert-deftest ios/reader-test-leave-edit-drops-read-only ()
  "`ios/reading-mode-leave-edit' clears read-only while mode stays on."
  (ios/test-with-buffer
    (ios/reading-mode 1)
    (should buffer-read-only)
    (ios/reading-mode-leave-edit)
    (should-not buffer-read-only)
    ;; Reading mode itself is still on.
    (should ios/reading-mode)
    (ios/reading-mode -1)))

;;; ----------------------------------------------------------------
;;; 5.  Double-toggle idempotency
;;; ----------------------------------------------------------------

(ert-deftest ios/reader-test-double-toggle ()
  "Toggling reading mode on and off twice leaves state clean."
  (ios/test-with-buffer
    (let ((orig-ro   buffer-read-only)
          (orig-hl   header-line-format)
          (orig-ml   mode-line-format)
          (orig-ls   line-spacing))
      (ios/reading-mode 1)
      (ios/reading-mode -1)
      (ios/reading-mode 1)
      (ios/reading-mode -1)
      (should (eq buffer-read-only orig-ro))
      (should (equal header-line-format orig-hl))
      (should (equal mode-line-format orig-ml))
      (should (eql line-spacing orig-ls)))))

;;; ----------------------------------------------------------------
;;; 6.  Vendor loading (sanity check)
;;; ----------------------------------------------------------------

(ert-deftest ios/reader-test-provider ()
  "reader.el provides the 'reader feature."
  (should (featurep 'reader)))

;;; ----------------------------------------------------------------
;;; Run
;;; ----------------------------------------------------------------

(when noninteractive
  (ert-run-tests-batch-and-exit))

;;; test-reader.el ends here
