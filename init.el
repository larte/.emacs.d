(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
      '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)
(require 'org)
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
 '(custom-safe-themes
   (quote
    ("604ac011fc9bd042bc041330b3a5e5a86e764a46f7e9fe13e2a1f9f83bf44327" "9fe9a86557144c43f9008daaf4bbee29498e30a3d957f6cf42b63b35cf598fd1" default)))
 '(org-confirm-babel-evaluate nil)
 '(org-directory "~/org")
 '(org-export-html-postamble nil)
 '(org-hide-leading-stars t)
 '(org-src-fontify-natively t)
 '(org-startup-folded (quote overview))
 '(org-startup-indented t)
 '(package-selected-packages
   (quote
    (yasnippet-snippets restclient grip-mode markdown-preview-eww projectile try lsp-java default-text-scale lsp-ui-doc lsp-ui lsp-clangd virtualenvwrapper company-lsp go-mode ruby-mode company lsp-mode circe-notifications circe org-gcal mu4e-alert htmlize org-bullets which-key posframe counsel use-package spinner))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lsp-ui-doc-background ((t (:background nil))))
 '(lsp-ui-doc-header ((t (:inherit (font-lock-string-face italic))))))
