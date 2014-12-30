;; packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(package-initialize)           

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("c5a044ba03d43a725bd79700087dea813abcb6beb6be08c7eb3303ed90782482" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" default))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(linum ((t (:inherit (shadow default) :background "knobColor" :foreground "highlightColor")))))
)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'classic t)
(set-face-background 'fringe (face-background 'default))

(require 'powerline)
(powerline-evil-vim-color-theme)
(display-time-mode t)

;; UI
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; (menu-bar-mode -1)

(global-linum-mode 1)

;; (set-fringe-mode '(0 . 0))

;; (cua-mode 1)
(show-paren-mode 1)

;; font
;;
(set-face-attribute 'default nil :font "Aurulent Sans Mono-16")


;; tab
;;
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; mac
(setq mac-option-key-is-meta nil
    mac-command-key-is-meta t
    mac-command-modifier 'meta
    mac-option-modifier 'none)

;; backup
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; evil
(evil-mode 1)

;; missing gp
(define-key evil-normal-state-map (kbd "g p") (kbd "` [ v ` ]"))

(defun my-list-buffers()
  (interactive)
  (split-window-horizontally)
  (buffer-menu))
(evil-ex-define-cmd "bs" 'my-list-buffers)

(global-set-key (kbd "M-t") 'anything)
(defun my-list-files()
  (interactive)
  (when (buffer-file-name)
    (split-window-horizontally)
    (dired (file-name-directory (buffer-file-name))))
)
(evil-ex-define-cmd "fs" 'my-list-files)

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

;; js2
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; auto-complete
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete-config)
(ac-config-default)

;; auto-complete html   
(add-hook 'html-mode-hook 'ac-html-enable)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; smart mode line:
(require 'smart-mode-line)
(sml/setup)
(sml/apply-theme 'dark)

;; ace-jump
(global-set-key (kbd "M-p") 'ace-window)

;; ido
(require 'ido)
(ido-mode 1)
(setq ido-enable-flex-matching t)
