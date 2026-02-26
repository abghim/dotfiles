(setq backup-directory-alist `(("." . "~/.emacs.d/.saves")))
(add-hook 'prog-mode-hook
          (lambda ()
            (font-lock-add-keywords
             nil
             '(("\\_<[0-9]+\\(?:\\.[0-9]+\\)?\\_>" 
                0 'font-lock-number-face keep)))))

(add-to-list 'custom-theme-load-path
             (expand-file-name "themes" user-emacs-directory))
(load-theme 'jeju-one-dark t)
(xterm-mouse-mode 1)

(mouse-wheel-mode 1)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control) . nil))
	        mouse-wheel-progressive-speed nil
			      mouse-wheel-follow-mouse t)
(setq scroll-step 1
	        scroll-conservatively 10000
			      scroll-preserve-screen-position t) 

(setq scroll-margin 4)

(setq next-screen-context-lines 1)

(require 'package)

;; Add MELPA (and optionally GNU ELPA & others)
;; (setq package-archives
;;      '(("gnu"   . "https://elpa.gnu.org/packages/")
;;        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(menu-bar-mode -1)
(set-face-attribute 'mode-line nil
                    :background "#291733"
                    :foreground "#dbbfef"
		    :box nil)
(set-face-attribute 'mode-line-inactive nil
                    :background "#291733"
                    :foreground "#dbbfef"
		    :box nil)

(setq-default left-margin-width 2)
(require 'generic-x)
