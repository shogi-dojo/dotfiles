;;; platforms/android.el -*- lexical-binding: t; -*-

(setq my/font-size 32
      my/line-spacing 0
      touch-screen-display-keyboard t
      server-socket-dir (format "/data/data/org.gnu.emacs/cache/emacs%d" (user-uid))
      doc-view-resolution 1200)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(add-hook 'doom-after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))

(defun my/docx-to-pdf ()
  "Convert current .docx file to PDF asynchronously and open it."
  (when (and buffer-file-name
             (string-match-p "\\.docx\\'" buffer-file-name))
    (let* ((docx-file buffer-file-name)
           (pdf-file (concat (file-name-sans-extension docx-file) ".pdf"))
           (buf (current-buffer)))
      (message "Converting %s to PDF..." (file-name-nondirectory docx-file))
      (set-process-sentinel
       (start-process "docx2pdf" "*docx2pdf*" "pandoc"
                      docx-file "--pdf-engine=weasyprint" "-o" pdf-file)
       (lambda (_proc event)
         (when (string-match-p "finished" event)
           (message "Conversion done. Opening PDF...")
           (with-current-buffer buf
             (find-alternate-file pdf-file))))))))

(add-to-list 'auto-mode-alist '("\\.docx\\'" . fundamental-mode))
(add-hook 'find-file-hook #'my/docx-to-pdf)
