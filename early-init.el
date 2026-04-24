(when (or (getenv "TERMUX_VERSION")
          (file-directory-p "/data/data/com.termux"))
  (setenv "PATH" (format "%s:%s" "/data/data/com.termux/files/usr/bin"
                         (getenv "PATH")))
  (push "/data/data/com.termux/files/usr/bin" exec-path)
  (setenv "DOOMDIR" "/data/data/org.gnu.emacs/files/.doom.d"))
