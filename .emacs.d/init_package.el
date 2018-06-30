;; init package
(package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck flymake js3-mode json magit mew popwin powerline rainbow-delimiters sicp tabbar w3m web-mode yatex org))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(js-doc-author (format "kouichi sumizaki <%s>" js-doc-mail-address))
;;  '(js-doc-mail-address "kouichi.sumizaki@gmail.com")
;;  '(package-selected-packages
;;    (quote
;;     (markdown-mode ac-helm helm popwin rainbow-delimiters js-doc js2-mode powerline color-theme magit))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
;; (powerline-vim-theme)
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; (add-hook 'js2-mode-hook
;;           '(lambda ()
;;              (local-set-key "\C-ci" 'js-doc-insert-function-doc)
;;              (local-set-key "@" 'js-doc-insert-tag)
;;              (setq js2-basic-offset 2
;;                    tab-width        2
;;                    indent-tabs-mode nil
;;                    js2-cleanup-whitespace nil)))

;; (set-face-attribute 'mode-line nil
;;                     :foreground "#fff"
;;                     :background "#FF0066"
;;                     :box nil)

;; (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)


;; manual configuration
;;tabbar-mode from http://idita.blog11.fc2.com/blog-entry-810.html
(require 'tabbar)
(tabbar-mode 1)
(global-set-key "\C-c\C-k" 'tabbar-forward-tab)
;; (global-set-key [(\C-c)(return)] 'tabbar-backward-tab)
;;(global-set-key (kbd "\C-c \C-k") 'tabbar-forward-tab)
;; (global-set-key "\C-j" 'tabbar-backward-tab)
;; (global-unset-key (kbd "RET"))
;; (local-unset-key (kbd "C-j"))
;; (global-set-key "\C-c<RET>" 'tabbar-backward-tab)
(global-set-key "\C-c\C-j" 'tabbar-backward-tab)
(setq tabbar-buffer-groups-function nil)

(defvar my-tabbar-displayed-buffers
	'("*w3m*")
	;; '("*scratch*" "*Messages*" "*Backtrace*" "*Colors*" "*Faces*" "*vc-")
	"*Regexps matches buffer names always included tabs.")

(defun my-tabbar-buffer-list ()
  "Return the list of buffers to show in tabs.
Exclude buffers whose name starts with a space or an asterisk.
The current buffer and buffers matches `my-tabbar-displayed-buffers'
are always included."
  (let* ((hides (list ?\  ?\*))
         (re (regexp-opt my-tabbar-displayed-buffers))
         (cur-buf (current-buffer))
         (tabs (delq nil
                     (mapcar (lambda (buf)
                               (let ((name (buffer-name buf)))
                                 ;; (when  (not (memq (aref name 0) hides))
                                 (when (or (string-match re name)
                                           (not (memq (aref name 0) hides)))
                                   buf)))
                             (buffer-list)))))
    ;; Always include the current buffer.
    (if (memq cur-buf tabs)
        tabs
      (cons cur-buf tabs))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

;; 2011/09/15 from http://d.hatena.ne.jp/tequilasunset/20110103/p1
;; change space between tabs
(setq tabbar-separator '(1))

(set-face-attribute
 'tabbar-default nil
 :background "black"
 :family "Inconsolata"
    :height 1.0)

