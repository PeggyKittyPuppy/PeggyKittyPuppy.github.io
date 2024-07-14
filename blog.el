;;; blog.el --- generate and deploy settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(package-initialize)
(require 'ox-html)
(require 'ox-publish)

; How to remove message `Indentation setup for shell type sh`
; https://emacs.stackexchange.com/q/52846
(advice-add 'sh-set-shell :around
            (lambda (orig-fun &rest args)
              (let ((inhibit-message t))
                (apply orig-fun args))))

;; Set html layout
(setq org-html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"/main.css\"/><style type=\"text/css\">  #content { text-align: left; } </style>"
      org-html-preamble  "<header><nav></nav></header>"
      org-html-postamble "<script>var toc = document.getElementById('table-of-contents'); document.querySelector('nav').appendChild(toc);</script>")

;; Generate
(setq org-publish-project-alist
  (list (list "PeggyKittyDoggy"
              :base-directory "."
              :publishing-directory "."
              :recursive t
              :publishing-function 'org-html-publish-to-html)))

(org-publish-project "PeggyKittyDoggy" t)

(provide 'blog)
;;; blog.el ends here
