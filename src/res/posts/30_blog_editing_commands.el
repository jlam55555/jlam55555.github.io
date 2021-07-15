(setq website-base "~/Documents/jonathan-lam-website")
(defun website-npm-run (target)
  (format "cd %s;npm run %s" website-base target))

(defun website-serve ()
  "Serve the website locally"
  (interactive)
  (async-shell-command (website-npm-run "serve") "npm-serve"))

(defun website-build ()
  "Start an NPM build and hide window in the background"
  (interactive)
  (async-shell-command (website-npm-run "build") "npm-build")
  (let ((current-window (selected-window)))
    (select-window (get-buffer-window "npm-build"))
    (read-only-mode)
    (select-window current-window)))

(defun website-terminate ()
  "Stop the NPM server and kill the build buffer"
  (interactive)
  (kill-buffer "npm-serve")
  (kill-buffer "npm-build"))

(defun website-new-post (post-title)
  "New blog post for website"
  (interactive "MPost title: ")
  (shell-command
   (format "cd %s;echo '%s'|npm run new-post" website-base post-title)
   "npm-new-post")
  (set-window-buffer (selected-window) "npm-new-post")
  (re-search-forward "id=\\([[:digit:]]+\\)" nil t)
  (message (substring-no-properties (match-string 1)))
  (find-file (format "%s/src/posts/%s.pug"
		     website-base
		     (substring-no-properties (match-string 1)))))

(defun website-edit ()
  "Goto website source directory (dired)"
  (interactive)
  (find-file (format "%s/src" website-base)))

;;; keybindings
(global-set-key (kbd "C-c C-w e") 'website-edit)
(global-set-key (kbd "C-c C-w s") 'website-serve)
(global-set-key (kbd "C-c C-w b") 'website-build)
(global-set-key (kbd "C-c C-w t") 'website-terminate)
(global-set-key (kbd "C-c C-w n") 'website-new-post)
