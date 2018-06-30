;; use \C-h as back space
(global-set-key "\C-h" 'delete-backward-char)

;; truncate
(setq-default truncate-lines t)
(setq-default truncate-partial-width-windows nil) ;; setting for partial windows made by \C-x 3 or \C-x 2

;; emphasis parenthesis
(show-paren-mode 1)

;; hide scroll bar
(scroll-bar-mode nil)

;; hide tool bar
(tool-bar-mode nil)

;; setting for GDB from http://d.hatena.ne.jp/higepon/20090505/p1
(setq gdb-many-windows t)
(add-hook 'gdb-mode-hook '(labmda () (gud-tooltip-mode t)))
(setq gdb-use-separate-io-buffer t)
(setq gud-tooltip-echo-area t)

;; share clipboard with x11
(setq x-select-enable-clipboard t)

;; setting for tab-width
(setq-default tab-width 2)

;; setting for encoding
;; mac book air
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
;; setting from http://yohshiy.blog.fc2.com/blog-entry-273.html
;; (set-terminal-coding-system 'mule-utf-8-unix)
;; (set-keyboard-coding-system 'mule-utf-8-unix)
;; (set-buffer-file-coding-system 'mule-utf-8-unix)
;; (setq file-name-coding-system 'utf-8)
;; (setq default-buffer-file-coding-system 'mule-utf-8-unix)

(line-number-mode 1)
(column-number-mode 1)

(define-key isearch-mode-map "\C-w" 'isearch-kill-region)
(define-key isearch-mode-map "\C-f" 'isearch-yank-word-or-char)
(defun isearch-kill-region ()
	(interactive "*")
	(if isearch-other-end
			(if (< isearch-other-end (point))	; isearch-forward?
					(kill-region isearch-other-end (point))
				(kill-region (point) isearch-other-end))
		()
		)
	(isearch-exit)
	)

;; setting for backup and auto-save files
(setq backup-inhibited t)

;; shell-script mode indentation but sh-mode-hook
(add-hook
 'sh-mode-hook
 (lambda()
	 (setq sh-basic-offset 2
				 sh-indentation 2)))

(setq inhibit-startup-message t)

;; another show line number left of lines from http://blog.soi33.org/archives/184
;; http://d.hatena.ne.jp/kitokitoki/20100714/p1
(require 'linum)
(setq linum-format "%5d ")
(defvar my-linum-file-extension nil)
;; (setq my-linum-file-extension '("c" "C" "h" "java"))
(defun my-linum-file-extension ()
  (linum-mode t))
  ;; (when (member (file-name-extension (buffer-file-name)) my-linum-file-extension)
	;; 	(linum-mode t)))
(add-hook 'find-file-hook 'my-linum-file-extension)

(setq scroll-step 1)



;; 2011/07/29 use spaces for indent instead of tab
(setq-default indent-tabs-mode nil)

;; 2011/09/12
(global-set-key "\C-c\C-c" 'compile)

;; 2011/09/16 from http://d.hatena.ne.jp/rubikitch/20100210/emacs
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(setq-default c-basic-offset 2)

;; do not show menu bar
(menu-bar-mode 0)

(setq-default show-trailing-whitespace t)


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ciel js-doc edit-indirect markdown-mode flycheck flymake js3-mode json magit mew popwin powerline rainbow-delimiters sicp tabbar w3m web-mode org))))
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

(powerline-vim-theme)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook
          '(lambda ()
             (local-set-key "\C-ci" 'js-doc-insert-function-doc)
             (local-set-key "@" 'js-doc-insert-tag)
             (setq js2-basic-offset 2
                   tab-width        2
                   indent-tabs-mode nil
                   js2-cleanup-whitespace nil)))

(set-face-attribute 'mode-line nil
                    :foreground "#fff"
                    :background "#FF0066"
                    :box nil)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(require 'cl-lib)
(require 'color)
(defun rainbow-delimiters-using-stronger-colors ()
  (interactive)
  (cl-loop
   for index from 1 to rainbow-delimiters-max-face-count
   do
   (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
     (cl-callf color-saturate-name (face-foreground face) 30))))
(add-hook 'emacs-startup-hook 'rainbow-delimiters-using-stronger-colors)

(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(push '("*interpretation*" :position right :width 70) popwin:special-display-config)

;;w3m
;; (add-to-list 'load-path "~/.emacs.d/w3m")
;; (require 'w3m-load)
;; (setq w3m-home-page "http://localhost/~kouichi/side_bar.html")

;; web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.php" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js" . web-mode))
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset   2)
  (setq web-mode-html-offset   2)
  (setq web-mode-style-padding 2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2)
  (setq web-mode-tag-auto-close-style 2))
(add-hook 'web-mode-hook 'web-mode-hook)

;; markdown mode
(add-to-list 'auto-mode-alist'("\\.md\\'" . markdown-mode))

;; hatena blog mode
(add-to-list 'load-path "~/.emacs.d/hatena-blog-mode/")
(load "~/.emacs.d/hatena-blog-conf.el")
; don't add conf file to repository
; conf file contains hatena-id, hatena-blog-id and hatena-blog-api-key
(require 'hatena-blog-mode)
(setq hatena-blog-editing-mode "md")
(setq hatena-blog-backup-dir "~/hatena/backup")

;; ciel
(require 'ciel)
(global-set-key "\C-ci" 'ciel-ci)
(global-set-key "\C-co" 'ciel-co)
