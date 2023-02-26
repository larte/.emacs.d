;; increase gc threshold to speedup starting up
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum)
(require 'package)

(setq package-enable-at-startup nil)
(package-initialize)
(require 'org)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")))
;; add melpa stable
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq babel-file (expand-file-name "~/.emacs.d/README.org"))

;; Compile helpers
(defun elc-name (name)
  (replace-regexp-in-string "\\.el$" ".elc" name)
  )

(defun babel-el-name (name)
  (replace-regexp-in-string "\\.org$" ".el" name)
  )

  (defun compile-if-newer (name)
  "Try to compile given .el file if changes were made."
  (if (file-exists-p (elc-name name))
      (if (file-newer-than-file-p name (elc-name name))
          (byte-compile-file name)
        )
    (byte-compile-file name)
    )
  )

(defun tangle-if-newer (name)
  "Try to tangle README.org if there's changes"
  (setq output (babel-el-name name))
  (if (file-exists-p output)
      (if (file-newer-than-file-p name output)
          ;; do tangle please
          (org-babel-tangle-file name output)
        )
    (org-babel-tangle-file name output)
    )
  )

(defun compile-and-load (name)
  "Try to compile given .el file if changes were made. load file."
  (compile-if-newer name)
  (load (elc-name name))
  )

(tangle-if-newer babel-file)
;;(load-file (babel-el-name babel-file))
(compile-and-load (babel-el-name babel-file))
