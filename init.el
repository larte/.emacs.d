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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(column-number-mode t)
 '(custom-safe-themes
   '("4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "93ed23c504b202cf96ee591138b0012c295338f38046a1f3c14522d4a64d7308" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "f4876796ef5ee9c82b125a096a590c9891cec31320569fc6ff602ff99ed73dca" "16ce45f31cdea5e74ca4d27519d7ebe998d69ec3bf7df7be63c5ffdb5638b387" default))
 '(package-selected-packages '(tide magit use-package))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Droid Sans Mono Slashed for Powerline" :foundry "1ASC" :slant normal :weight normal :height 122 :width normal)))))
