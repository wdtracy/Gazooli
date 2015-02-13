(require 'use-package)

(setq c-default-style '((java-mode . "java")
                        (c-mode . "bsd")
                        (c++-mode . "bsd")
                        (awk-mode . "awk")
                        (other . "gnu")))

(setq-default c-basic-offset 4
                  tab-width 4
                  indent-tabs-mode t)

(setq-default indent-tabs-mode nil)

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
  :bind (("C-c C-l" . org-store-link)
         ("C-c C-a" . org-agenda))
  :config
  (progn
    (setq org-log-done t)
  )
)
 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(cua-mode nil nil (cua-base))
 '(custom-enabled-themes (quote (deeper-blue)))
 '(dired-isearch-filenames (quote dwim))
 '(jabber-account-list (quote (("wade.dallon" (:network-server . "talk.google.com") (:port . 5223) (:connection-type . ssl)))))
 '(package-archives (quote (("marmalade" . "https://marmalade-repo.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/") ("melpa" . "http://melpa.milkbox.net/packages/")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#181a26" :foreground "gray80" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "outline" :family "Inconsolata Medium")))))
