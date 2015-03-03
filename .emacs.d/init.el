(package-initialize)
(require 'use-package)

(add-to-list 'load-path "~/.emacs.d/lisp/")

(setq c-default-style '((java-mode . "java")
                        (c-mode . "bsd")
                        (c++-mode . "bsd")
                        (awk-mode . "awk")
                        (other . "gnu")))

(setq-default c-basic-offset 4
                  tab-width 4
                  indent-tabs-mode t)

(setq-default indent-tabs-mode nil)

(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
     (define-key global-map "\C-cc" 'org-capture)

(setq
 python-shell-interpreter "C:\\Python34\\python.exe"
 python-shell-interpreter-args
 "-i C:\\Python34\\Scripts\\ipython.exe")

(use-package ipython)
(use-package python-mode
  :config
  (progn
    (add-to-list 'auto-mode-alist '("\.py\'" . python-mode))
  )
)

(use-package lambda-mode
  :config
  (progn
    (add-hook 'python-mode-hook #'lambda-mode 1)
    (setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))
  )
)

(use-package python-pep8)
(use-package python-pylint)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package anything)
(use-package anything-ipython)
(when (require 'anything-show-completion nil t)
(use-anything-show-completion 'anything-ipython-complete
'(length initial-pattern)))

(use-package yasnippet
  :config
  (progn
    (yas/initialize)
    (yas/load-directory "~/.emacs.d/my-snippets/")
  )
)

(use-package comint
  :config
  (progn
    (define-key comint-mode-map (kbd "M-") 'comint-next-input)
    (define-key comint-mode-map (kbd "M-") 'comint-previous-input)
    (define-key comint-mode-map [down] 'comint-next-matching-input-from-input)
    (define-key comint-mode-map [up] 'comint-previous-matching-input-from-input)
    )
)

(autoload 'autopair-global-mode "autopair" nil t)
(autopair-global-mode)
(add-hook 'lisp-mode-hook #'(lambda () (setq autopair-dont-activate t)))

(add-hook 'python-mode-hook #'(lambda () (push '(?' . ?')
(getf autopair-extra-pairs :code))
(setq autopair-handle-action-fns
(list #'autopair-default-handle-action #'autopair-python-triple-quote-action))))


(use-package ispell
  :config
  (progn
    (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
    (setq ispell-program-name "aspell")
    (setq ispell-personal-dictionary "C:/Home/Gazooli/.ispell")
  )
)

(use-package expand-region
  :bind (("C-t" . er/expand-region)
         ("C-S-t" . er/contract-region)))

(use-package god-mode
 :bind ("<escape>" . god-mode-all)
  :config
  (progn
    (defun my-update-cursor ()
    (setq cursor-type (if (or god-local-mode buffer-read-only)
                        'box
                      'bar)))

    (add-hook 'god-mode-enabled-hook 'my-update-cursor)
    (add-hook 'god-mode-disabled-hook 'my-update-cursor)
  )
)

(use-package org
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda))
  :config
  (progn
    (setq org-log-done t)
  )
)

(require 'python-mode)
    (add-to-list 'auto-mode-alist '("\.py\'" . python-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(column-number-mode t)
 '(cua-mode nil nil (cua-base))
 '(custom-enabled-themes (quote (deeper-blue)))
 '(dired-isearch-filenames (quote dwim))
 '(jabber-account-list (quote (("wade.dallon" (:network-server . "talk.google.com") (:port . 5223) (:connection-type . ssl)))))
 '(package-archives (quote (("marmalade" . "https://marmalade-repo.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/") ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(py-shell-name "C:/Python34/python"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#181a26" :foreground "gray80" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "outline" :family "Inconsolata Medium")))))
