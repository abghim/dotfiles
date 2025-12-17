(defun my-backup-file-on-save ()
  "Copy the current buffer's file to ~/.emacs_backups with a timestamp."
  (when buffer-file-name
    (let* ((backup-dir (expand-file-name "~/.emacs_backups/"))
           (filename (file-name-nondirectory buffer-file-name))
           (timestamp (format-time-string "%Y%m%d-%H%M%S"))
           (backup-name (concat backup-dir filename "." timestamp ".bak")))
      (unless (file-exists-p backup-dir)
        (make-directory backup-dir t))
      (copy-file buffer-file-name backup-name t)
      )))

(add-hook 'after-save-hook #'my-backup-file-on-save)

(defun my-backup-all-buffers-on-exit ()
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and buffer-file-name (buffer-modified-p))
        (my-backup-file-on-save)))))

(add-hook 'kill-emacs-hook #'my-backup-all-buffers-on-exit)

(add-hook 'prog-mode-hook
          (lambda ()
            (font-lock-add-keywords
             nil
             '(("\\_<[0-9]+\\(?:\\.[0-9]+\\)?\\_>"  ; integers & floats
                0 'font-lock-number-face keep)))))

(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" user-emacs-directory))
(load-theme 'jeju-one-dark t)      ; ‘t’ = load w/o query
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0c15dbe23dcf0fe0d1cee808d27553fa17868cc9daf19ce5c36c7871cd3ad9a2"
     "ffc4609ecd34ee966cbaf790ff1fa6507fd03d6fc39c64b9bbfd447f94910467"
     default))
 '(package-selected-packages '(eat enlight rust-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-number-face ((t (:foreground "#94dff7")))))

(xterm-mouse-mode 1)

(mouse-wheel-mode 1)



;; Wheel: 1 line per tick; Shift = 5; no acceleration; scroll window under pointer
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control) . nil))
	        mouse-wheel-progressive-speed nil
			      mouse-wheel-follow-mouse t)

;; Line-by-line, no page "cut" jumps when point hits window edge
(setq scroll-step 1                        ; move a line at a time when near edge
	        scroll-conservatively 10000         ; never recenter aggressively
			      scroll-preserve-screen-position t)  ; keep point near its visual spot

(setq scroll-margin 4)

(setq next-screen-context-lines 1)

(require 'package)

;; Add MELPA (and optionally GNU ELPA & others)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;; Initialize package.el
(package-initialize)


