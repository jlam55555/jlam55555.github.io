(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;;; TODO: use use-package to install/configure packages automatically.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#272822" "#F92672" "#A6E22E" "#E6DB74" "#66D9EF" "#FD5FF0" "#A1EFE4" "#F8F8F2"])
 '(ansi-term-color-vector
   [unspecified "#2d2a2e" "#ff6188" "#a9dc76" "#ffd866" "#78dce8" "#ab9df2" "#a1efe4" "#fcfcfa"])
 '(column-number-mode t)
 '(compilation-message-face 'default)
 '(custom-enabled-themes '(leuven))
 '(custom-safe-themes
   '("e3a1b1fb50e3908e80514de38acbac74be2eb2777fc896e44b54ce44308e5330" "b6269b0356ed8d9ed55b0dcea10b4e13227b89fd2af4452eee19ac88297b0f99" "b02eae4d22362a941751f690032ea30c7c78d8ca8a1212fdae9eecad28a3587f" "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7" "fb83a50c80de36f23aea5919e50e1bccd565ca5bb646af95729dc8c5f926cbf3" "78e6be576f4a526d212d5f9a8798e5706990216e9be10174e3f3b015b8662e27" "24168c7e083ca0bbc87c68d3139ef39f072488703dcdd82343b8cab71c0f62a7" default))
 '(dumb-jump-selector 'ivy)
 '(fci-rule-color "#3C3D37")
 '(highlight-changes-colors '("#FD5FF0" "#AE81FF"))
 '(highlight-tail-colors
   '(("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100)))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(line-number-display-limit nil)
 '(line-number-display-limit-width 2000000)
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   '(vterm projectile-ripgrep ripgrep treemacs-perspective perspective treemacs-tab-bar use-package treemacs-icons-dired treemacs-magit treemacs-all-the-icons treemacs-projectile treemacs projectile lsp-ui pug-mode xclip slime-company slime flycheck lsp-mode cargo-mode markdown-mode format-all highlight-indent-guides yaml-mode pdf-tools company-quickhelp xref ivy-xref counsel counsel counsel counsel-mode ivy dumb-jump company-ghci haskell-mode company geiser-chez geiser cargo all-the-icons-dired all-the-icons solaire-mode magit expand-region rust-mode paredit auctex monokai-pro-theme nyan-mode))
 '(persp-mode t)
 '(pos-tip-background-color "#FFFACE")
 '(pos-tip-foreground-color "#272822")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   '((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0")))

;;; Load theme
;; (load-theme 'monokai-pro t)

;;; Windmove commands
(global-set-key (kbd "M-<left>")  'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<up>")    'windmove-up)
(global-set-key (kbd "M-<down>")  'windmove-down)

;;; Paredit (https://www.emacswiki.org/emacs/ParEdit)
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'geiser-repl-mode-hook      #'enable-paredit-mode)

;;; Expand region keyboard shortcut
(global-set-key (kbd "C-\\") 'er/expand-region)

;;; Dired keyboard shortcuts
(defun find-in-subtree (filename)
  (interactive "sFilename: ")
  (find-name-dired "" filename))
(add-hook 'dired-mode-hook
          (lambda ()
            (local-set-key (kbd "f") 'find-in-subtree)
            (local-set-key (kbd "c") 'find-file-other-window)))
(put 'dired-find-alternate-file 'disabled nil)

;;; Kill the other window easily
(defun kill-buffer-in-other-window ()
  (interactive)
  "I just find this handy sometimes when working in two windows."
  (other-window 1)
  (kill-buffer)
  (other-window -1))
(global-set-key (kbd "C-x c") 'kill-buffer-in-other-window)

;;; NYAAAAAA
(define-globalized-minor-mode global-nyan-mode nyan-mode
  (lambda () (nyan-mode 1)))
(global-nyan-mode 1)

;;; Turn off extras
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;;; Highlight current line
(global-hl-line-mode 1)

;;; dumb-jump: useful for grepping within a directory quickly
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

;;; solaire-mode: Makes contrast for menus a little better
(solaire-global-mode +1)

;;; all-the-icons: Makes dired prettier
(require 'all-the-icons)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;;; company mode: Autocompletion backend
(add-hook 'after-init-hook 'global-company-mode)

;;; Make company autocomplete more responsive
;;; see: https://emacs.stackexchange.com/a/23937
(setq company-idle-delay 0)

;;; define-word: Dictionary time
(global-set-key (kbd "C-c d") 'define-word-at-point)
(global-set-key (kbd "C-c D") 'define-word)

;;; new ivy/counsel/swiper config
(use-package counsel
  :after ivy
  :config (counsel-mode)
  :bind (("C-x b" . persp-counsel-switch-buffer)))

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

;; (use-package ivy-rich
;;   :after ivy
;;   :custom
;;   (ivy-virtual-abbreviate 'full
;;                           ivy-rich-switch-buffer-align-virtual-buffer t
;;                           ivy-rich-path-style 'abbrev)
;;   :config
;;   (ivy-set-display-transformer 'ivy-switch-buffer
;;                                'ivy-rich-switch-buffer-transformer))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

;;; ivy/swiper: Autocompletion frontend
;; (ivy-mode)
;; (setq ivy-use-virtual-buffers t)
;; (setq enable-recursive-minibuffers t)
;; (global-set-key "\C-s" 'swiper)
;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "<f6>") 'ivy-resume)
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c k") 'counsel-ag)
;; (global-set-key (kbd "C-x l") 'counsel-locate)
;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;; (global-set-key (kbd "C-x b") 'persp-counsel-switch-buffer)
;; (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

;; ;;; ivy overlay
;; ;;; https://github.com/abo-abo/swiper/wiki/ivy-display-function
;; (setq ivy-display-function 'ivy-display-function-overlay)

;; ;;; ivy completion type; https://oremacs.com/swiper/#completion-styles
;; ;;; use default emacs completion (fuzzy)
;; (setq ivy-re-builders-alist
;;       '((t . ivy--regex-plus)
;;         (t . ivy--regex-fuzzy)))

;; ;;; dumb-jump with completing-read
;; (setq xref-show-definitions-function #'xref-show-definitions-completing-read)

;; ;;; from https://github.com/alexmurray/ivy-xref
;; (require 'ivy-xref)
;; (when (>= emacs-major-version 27)
;;   (setq xref-show-definitions-function #'ivy-xref-show-defs))
;; (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)

;;; format-all
(add-hook 'prog-mode-hook 'format-all-mode)
(add-hook 'format-all-mode-hook 'format-all-ensure-formatter)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; backup/autosave from https://stackoverflow.com/a/2020954
(defvar backup-dir (expand-file-name "~/.emacs.d/backup/"))
(defvar autosave-dir (expand-file-name "~/.emacs.d/autosave/"))
(setq backup-directory-alist (list (cons ".*" backup-dir)))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))

(require 'lsp-mode)
(add-hook 'prog-mode-hook #'lsp)

(setq neo-theme 'icons)

;; (projectile-mode +1)
;; (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-perspective
  :after (treemacs perspective)
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

;; (use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
;;   :after (treemacs)
;;   :ensure t
;;   :config (treemacs-set-scope-type 'Tabs))

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))  ; pick your own prefix key here
  :init
  (persp-mode))

(push '(emacs-lisp-mode . "lisp") lsp-language-id-configuration)

(add-hook 'vterm-mode-hook
          (lambda ()
            (local-set-key (kbd "M-<left>")  'windmove-left)
            (local-set-key (kbd "M-<right>") 'windmove-right)
            (local-set-key (kbd "M-<up>")    'windmove-up)
            (local-set-key (kbd "M-<down>")  'windmove-down)))

;;; override paredit details
(eval-after-load "paredit"
  '(progn
     (define-key paredit-mode-map (kbd "M-<left>") nil)
     (define-key paredit-mode-map (kbd "M-<right>") nil)
     (define-key paredit-mode-map (kbd "M-<up>") nil)
     (define-key paredit-mode-map (kbd "M-<down>") nil)))

;;; Improve interactive performance of vterm. Default is 0.1s.
;;; I don't really need to do many bulk transfers, so this shouldn't hurt performance.
(setq vterm-timer-delay 0.01)
