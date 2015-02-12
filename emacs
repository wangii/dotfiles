;;; package -- Summary
;;; Commentary:
;;; Code:

;; (let ((benchmark-init.el "~/benchmark-init-el/benchmark-init.el"))
;;     (when (file-exists-p benchmark-init.el)
;; 	      (load benchmark-init.el)))

;;===========================================================================
;; packages
;;===========================================================================
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-initialize)

;; install packages
;; http://stackoverflow.com/questions/10092322/how-to-automatically-install-emacs-packages-by-specifying-a-list-of-package-name
;; (setq url-http-attempt-keepalives nil)
;; (require 'cl)

;;  (defvar prelude-packages
;; '(ac-dabbrev ac-helm popup auto-complete popup helm async ac-html auto-complete popup ac-js2 skewer-mode js2-mode simple-httpd js2-mode auto-complete-auctex auto-complete popup yasnippet auto-complete-c-headers auto-complete popup auto-complete-chunk auto-complete popup auto-complete-clang auto-complete popup dash-at-point evil-leader evil goto-chg undo-tree evil-nerd-commenter evil-org org evil goto-chg undo-tree evil-paredit paredit evil goto-chg undo-tree evil-surround evil-visual-mark-mode dash evil goto-chg undo-tree evil-visualstar evil goto-chg undo-tree flycheck-rust dash flycheck let-alist pkg-info epl dash go-autocomplete auto-complete popup go-mode golint helm-cmd-t helm-css-scss helm async helm-flycheck helm async flycheck let-alist pkg-info epl dash dash highlight-current-line json-mode json-snatcher json-reformat json-reformat json-rpc json-snatcher less-css-mode let-alist magit git-rebase-mode git-commit-mode markdown-mode monokai-theme nodejs-repl org org-ac yaxception log4e auto-complete-pcmp yaxception log4e auto-complete popup paredit pkg-info epl popup powerline-evil powerline evil goto-chg undo-tree react-snippets yasnippet skewer-mode js2-mode simple-httpd smart-mode-line rich-minority dash undo-tree visual-regexp web-mode yasnippet yaxception)

;;    "A list of packages to ensure are installed at launch.")

;;  (defun prelude-packages-installed-p ()
;;    (loop for p in prelude-packages
;;          when (not (package-installed-p p)) do (return nil)
;;          finally (return t)))

;;  (unless (prelude-packages-installed-p)
;;    ;; check for new packages (package versions)
;;    (message "%s" "Emacs Prelude is now refreshing its package database...")
;;    (package-refresh-contents)
;;    (message "%s" " done.")
;;    ;; install the missing packages
;;    (dolist (p prelude-packages)
;;      (when (not (package-installed-p p))
;;        (package-install p))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ;; ("c5a044ba03d43a725bd79700087dea813abcb6beb6be08c7eb3303ed90782482" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default))))
    ("6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" default))))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

(put 'narrow-to-region 'disabled nil)

;;===========================================================================
;; general
;;===========================================================================
(setq redisplay-dont-pause t)

;; performance
(setq gc-cons-threshold 150000000)

;; turn off bell
(setq ring-bell-function 'ignore)

;; Linux
(if (eq 'gnu/linux system-type)
    (progn
      (setq x-meta-keysym 'super
            x-super-keysym 'meta)
      (menu-bar-mode -1)
      (toggle-frame-fullscreen)
      ))

;; mac
(if (eq 'darwin system-type)
    (setq mac-option-key-is-meta nil
          mac-command-key-is-meta t
          mac-command-modifier 'meta
          mac-option-modifier 'none))

;; windows
(if (eq 'windows-nt system-type)
    (setq w32-lwindow-modifier 'meta
          w32-rwindow-modifier 'meta))

;; no backup
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; ido
(require 'ido)
(ido-mode 1)
(setq ido-separator "\n")
(setq ido-enable-flex-matching t)

;;===========================================================================
;; window ops
;;===========================================================================

(global-set-key (kbd "M-o") 'other-window)

(if (eq 'gnu/linux system-type)
    (global-set-key (kbd "M-9") 'delete-window))

(if (eq 'darwin system-type)
    (global-set-key (kbd "M-0") 'delete-window))

(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-right)

(global-unset-key (kbd "C-x o"))
(global-unset-key (kbd "C-x 0"))
(global-unset-key (kbd "C-x 1"))
(global-unset-key (kbd "C-x 2"))
(global-unset-key (kbd "C-x 3"))

(global-set-key (kbd "C->") 'evil-window-increase-width)
(global-set-key (kbd "C-<") 'evil-window-decrease-width)

;;===========================================================================
;; UI
;;===========================================================================

(tool-bar-mode -1)
(scroll-bar-mode -1)

;; OPTMZ
;; (global-linum-mode 1)
;; (setq linum-format "%4d \u2502 ")
;; Preset width nlinum
(add-hook 'nlinum-mode-hook
          (lambda ()
            (setq nlinum--width
              (length (number-to-string
                       (count-lines (point-min) (point-max)))))))
(require 'nlinum)
(nlinum-mode)

(require 'highlight-current-line)
(set-face-background 'highlight-current-line-face "darkslategray")
(highlight-current-line-on t)

;;===========================================================================
;; theme
;;===========================================================================

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'monokai t)
(set-face-background 'fringe (face-background 'default))

;;===========================================================================
;; Powerline
;;===========================================================================
(require 'powerline)
;; (powerline-evil-vim-color-theme)
(powerline-center-theme)
;; (display-time-mode t)

;;===========================================================================
;; smart mode line:
;;===========================================================================
;; (require 'smart-mode-line)
;; (sml/setup)
;; (sml/apply-theme 'dark)

;;===========================================================================
;; font
;;===========================================================================
(if (eq 'gnu/linux system-type)
    (set-face-attribute 'default nil :font "Consolas-16"))

(if (eq 'darwin system-type)
    (set-face-attribute 'default nil :font "Droid Sans Mono-16"))

;; (set-face-attribute 'default nil :font "Anonymous Pro-15")
;; (set-face-attribute 'default nil :font "Inconsolata\-g-15")
;; (set-face-attribute 'default nil :font "Liberation Mono-15")
;; (set-face-attribute 'default nil :font "Bitstream Versa Sans Mono-15")
;; (set-face-attribute 'default nil :font "Lucida Mono-15")
;; (set-face-attribute 'default nil :font "TextMateJ-15")
;; (set-face-attribute 'default nil :font "TheSansMono\-ExtraLight-15")
;; (set-face-attribute 'default nil :font "InputMono-15")
;; (set-face-attribute 'default nil :font "Akkurat\-Mono-15")
;; (set-face-attribute 'default nil :font "Ubuntu Mono-16")
;; (set-face-attribute 'default nil :font "BPMono-15")
;; (set-face-attribute 'default nil :font "Source Code Pro-16")
;; (set-face-attribute 'default nil :font "Aurulent Sans Mono-15")

;;==================================================
;; Coding related;
;;==================================================
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; OPTMZ
;; ;; flycheck
;; ;;==================================================
;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; paren
(show-paren-mode 1)
(electric-pair-mode 1)

;; tab
;;
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;;==================================================
;; dash
;;==================================================
(if (eq 'darwin system-type)
    (progn
      (require 'dash-at-point)
      (global-set-key (kbd "M-i") 'dash-at-point)))

;;==================================================
;; evil
;;==================================================
(evil-mode 1)
(global-evil-visualstar-mode t)

;; escape!
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; cursor
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

;; comment
(global-set-key (kbd "M-/") 'evilnc-comment-or-uncomment-lines)
(global-set-key (kbd "C-c l") 'evilnc-quick-comment-or-uncomment-to-the-line)
(global-set-key (kbd "C-c c") 'evilnc-copy-and-comment-lines)
(global-set-key (kbd "C-c p") 'evilnc-comment-or-uncomment-paragraphs)

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-key
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "\\" 'evilnc-comment-operator
  )

;; the missing gp
(define-key evil-normal-state-map (kbd "g p") (kbd "` [ v ` ]"))

;; surround
(require 'evil-surround)
(global-evil-surround-mode 1)

;;==================================================
;; auto-complete, yas
;;==================================================
(require 'yasnippet)
(yas-global-mode 1)

(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")

(require 'auto-complete-config)
(ac-config-default)

;; auto-complete html
(add-hook 'html-mode-hook 'ac-html-enable)

;; toggle window split
(defun toggle-frame-split ()
  "If the frame is split vertically, split it horizontally or vice versa.
Assumes that the frame is only split into two."
  (interactive)
  (unless (= (length (window-list)) 2) (error "Can only toggle a frame split in two"))
  (let (
        (split-vertically-p (window-combined-p))
       )
       (delete-window) ; closes current window
       (if split-vertically-p
           (split-window-horizontally)
           (split-window-vertically)
       ) ; gives us a split with the other window twice
       (switch-to-buffer nil)
  ))
 ; restore the original window in this part of the frame

;; I don't use the default binding of 'C-x 5', so use toggle-frame-split instead
(global-set-key (kbd "M-g") 'toggle-frame-split)

;;===========================================================================
;; magit
;;===========================================================================
(global-set-key (kbd "M-m") 'magit-status)

;;===========================================================================
;; language specifics
;;===========================================================================
;; lisp
;;===========================================================================
;; https://bitbucket.org/lyro/evil/issue/360/possible-evil-search-symbol-forward
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq evil-symbol-word-search t)
            (local-set-key (kbd "M-e") 'eval-region)))

;;===========================================================================
;; js
;;===========================================================================
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-mode))

(add-hook 'js2-mode-hook 'ac-js2-mode)

;; http://truongtx.me/2014/03/10/emacs-setup-jsx-mode-and-jsx-syntax-checking/

;; (require 'flycheck)
;; (flycheck-define-checker jsxhint-checker
;;   "A JSX syntax and style checker based on JSXHint."

;;   :command ("jsxhint" source)
;;   :error-patterns
;;   ((error line-start (1+ nonl) ": line " line ", col " column ", " (message) line-end))
;;   :modes (js2-mode))

;; (defun lw-narrow(start end)
;;   (web-mode))

;; (add-hook 'js2-mode-hook (lambda ()
;;                            (if (string-match "\\.jsx$" (buffer-name (current-buffer)))
;;                                (progn
;;                                  (ac-js2-mode)
;;                                  ;; (flycheck-select-checker 'jsxhint-checker)
;;                                  ;; (flycheck-mode)
;;                                  ))))

;;===========================================================================
;; node repl
;;===========================================================================
;; OPTMZ
;; (require 'nodejs-repl)
;; (setq nodejs-repl-command "/usr/local/bin/node")

;;===========================================================================
;; org
;;===========================================================================
(setq org-agenda-files (list "~/Documents/org/work.org"
                             "~/Documents/org/home.org"))
(server-mode)

;; (cd "~/Documents/work")
(if (eq 'windows-nt system-type)
    (setq command-line-default-directory "~/Documents/GitHub")
    (setq command-line-default-directory "~/Documents/work"))

;;===========================================================================
;; My funcs
;;===========================================================================
;; Using popup menu to fast switch buffer and file
;;===========================================================================

(require 'popup)

(define-key popup-isearch-keymap [escape] 'popup-isearch-cancel)

;;
;; get the dir where .git resides in
;; return nil if not found
;;
(defun lw/git-root (fn)
  (let ((dir (file-name-directory fn))
        (ret nil)
        (found nil))

    (while (not found)
      (message dir)
      (if (string= dir "/")
          (setq found t)
        (if (file-exists-p (concat dir ".git"))
          (progn
            (setq found t)
            (setq ret (substring dir 0 -1)))

        (setq dir (file-name-directory (substring dir 0 -1))))))
    ret))

(defun lw/popup-switch-file()
  (interactive)
  (let ((root-dir (lw/git-root (buffer-file-name (current-buffer)))))
       (if root-dir
           (let* (
                  (cmd (format "cd %s && git ls-files" root-dir))
                  (fs (split-string (shell-command-to-string cmd) "\n"))
                  (fn (format "%s/%s" root-dir (popup-menu* fs :isearch t)))
                  ;; see if the file already opened in a buffer. avoid multiple buffers for one file.
                  (bs (-select (lambda (x) (eq fn (buffer-file-name x))) (buffer-list)) ))
             (if bs
                 (switch-to-buffer (car bs))
                 (find-file fn)))
           (message "Not a git directory!"))))

(global-set-key (kbd "M-t") 'lw/popup-switch-file)

(defun lw/popup-switch-buffer()
  (interactive)
  (let (
        (bn (popup-menu* (mapcar 'buffer-name (remove (current-buffer) (buffer-list))) :isearch t))
       )
       (switch-to-buffer (get-buffer bn))
  )
)

(global-set-key (kbd "M-b") 'lw/popup-switch-buffer)

;; list-files
(defun lw/list-files()
  (interactive)
  (when (buffer-file-name)
        (split-window-horizontally)
        (dired (file-name-directory (buffer-file-name)))
  )
)

(evil-ex-define-cmd "fs" 'lw/list-files)

;; timestamp
(defun lw/insert-time-stamp()
    (interactive)
    (insert (current-time-string)))
(evil-ex-define-cmd "ts" 'my-insert-time-stamp)

;; list-buffer
(defun lw/list-buffers()
  (interactive)
  (split-window-horizontally)
  (buffer-menu))

(evil-ex-define-cmd "bs" 'lw/list-buffers)
;; (provide '.emacs)
;;; .emacs ends here
