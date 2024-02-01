(setq package-enable-at-startup nil)

(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum)

(setq inhibit-startup-message t)

(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (horizontal-scroll-bars)
        (vertical-scroll-bars)))

(setq native-comp-async-report-warnings-errors 'silent)


(defmacro on-hook (name &rest body)
  (declare (indent defun))
  (let (found hook)
    (setq name (if (string-match "-hook\\'" (symbol-name `,name))
                   `,name
                 (intern (concat (symbol-name name) "-hook"))))
    (setq body (nreverse body))
    (dolist (hook init-file-hooks)
      (when (equal (symbol-name (car hook)) (symbol-name name))
        (dolist (sexp (nreverse (cdr hook)))
          (add-to-list 'body sexp))
        (setcdr hook body)
        (setq found t)))
    (unless found
      (add-to-list 'init-file-hooks (cons name body)))
        (ignore)))

(provide 'early-init)
