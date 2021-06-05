;;; add melpa repo
;;; use "M-x package-refresh-contents" before installing a package
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;; emacs customize subsystem
(custom-set-variables
 ;; hide initial start screen
 '(inhibit-startup-screen t)
 
 ;; good builtin theme
 '(custom-enabled-themes '(wombat))

 ;; default of 70 for fci is absurd
 '(fill-column 80)

 ;; add column indicator to modeline
 '(mode-line-format
   '("%e" mode-line-front-space mode-line-mule-info mode-line-client
     mode-line-modified mode-line-remote mode-line-frame-identification
     mode-line-buffer-identification "   " mode-line-position
     (vc-mode vc-mode) "  " mode-line-modes mode-line-misc-info
     mode-line-end-spaces "  %l:%c"))

 ;; currently installed packages
 '(package-selected-packages '(magit paredit geiser-chez)))

;;; slime setup
(global-display-line-numbers-mode)
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
(require 'slime)
(slime-setup)

;;; paredit hooks: https://www.emacswiki.org/emacs/ParEdit
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;;; paredit w/ slime repl
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))
(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))
(add-hook 'slime-repl-mode-hook
	  'override-slime-repl-bindings-with-paredit)

;;; paredit w/ geiser repl
(add-hook 'geiser-repl-mode-hook #'enable-paredit-mode)

;;; auto-reload files
(global-auto-revert-mode)

;;; show 80-char limit
(global-display-fill-column-indicator-mode)

;;; disable toolbar, menubar, scrollbar -- I don't use my mouse
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;;; display battery % in modeline; actually useful because
;;; I use this in full screen a lot
(display-battery-mode 1)
