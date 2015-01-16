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
(load-theme 'gnome2 t)
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
(set-face-attribute 'default nil :font "Inconsolata-16")
;; (set-face-attribute 'default nil :font "Aurulent Sans Mono-16")


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

;; the missing gp
(define-key evil-normal-state-map (kbd "g p") (kbd "` [ v ` ]"))

(defun my-list-buffers()
  (interactive)
  (split-window-horizontally)
  (buffer-menu))
(evil-ex-define-cmd "bs" 'my-list-buffers)

(defun my-insert-time-stamp()
    (interactive)
    (insert (current-time-string)))
(evil-ex-define-cmd "ts" 'my-insert-time-stamp)
    
;; cmd-t
;; (require 'textmate)
;; (require 'peepopen)
;; (textmate-mode)
;; (global-set-key (kbd "M-t") 'helm-M-x)
(require 'helm-cmd-t)
(global-set-key (kbd "M-t") 'helm-cmd-t)

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
;; (setq evil-emacs-state-cursor '("red" box))
;; (setq evil-normal-state-cursor '("green" box))
;; (setq evil-visual-state-cursor '("orange" box))
;; (setq evil-insert-state-cursor '("red" bar))
;; (setq evil-replace-state-cursor '("red" bar))
;; (setq evil-operator-state-cursor '("red" hollow))

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

;; toggle window split
(defun toggle-frame-split ()
  "If the frame is split vertically, split it horizontally or vice versa.
Assumes that the frame is only split into two."
  (interactive)
  (unless (= (length (window-list)) 2) (error "Can only toggle a frame split in two"))
  (let ((split-vertically-p (window-combined-p)))
    (delete-window) ; closes current window
    (if split-vertically-p
        (split-window-horizontally)
      (split-window-vertically)) ; gives us a split with the other window twice
    (switch-to-buffer nil))) ; restore the original window in this part of the frame

;; I don't use the default binding of 'C-x 5', so use toggle-frame-split instead
(global-set-key (kbd "M-g") 'toggle-frame-split)

;; ido
(require 'ido)
(ido-mode 1)
(setq ido-enable-flex-matching t)

;; org
(setq org-agenda-files (list "~/Documents/org/work.org"
                             "~/Documents/org/home.org"))
(server-mode)

(cd "~/Documents/work")
;; Installed packages;
;; (auto-complete popup auto-complete popup popup ace-window ace-jump-mode ace-window flycheck let-alist pkg-info epl dash flycheck flycheck-rust dash flycheck let-alist pkg-info epl dash flycheck-rust helm async helm magit git-rebase-mode git-commit-mode magit org-context org-context ac-dabbrev ac-helm popup auto-complete popup helm async ac-html auto-complete popup ac-js2 skewer-mode js2-mode simple-httpd js2-mode ace-window ace-jump-mode bliss-theme evil-leader evil goto-chg undo-tree evil-nerd-commenter evil-org org evil goto-chg undo-tree evil-tutor evil goto-chg undo-tree flycheck-rust dash flycheck let-alist pkg-info epl dash flymake-css flymake-easy flymake-go flymake flymake-json flymake-easy flymake-less less-css-mode flymake-ruby flymake-easy flymake-rust flymake-easy flymake-sass flymake-easy go-autocomplete auto-complete popup go-direx direx go-mode golint helm-cmd-t helm-css-scss helm async helm-flycheck helm async flycheck let-alist pkg-info epl dash dash helm-flymake helm async helm-google google helm async helm-rb helm-ag-r helm async helm async json-mode json-snatcher json-reformat json-reformat json-snatcher less-css-mode let-alist magit git-rebase-mode git-commit-mode markdown-mode monokai-theme nyan-mode org-ac yaxception log4e auto-complete-pcmp yaxception log4e auto-complete popup org-agenda-property org-autolist org-blog org-bullets org-caldav org org-cliplink org-context pkg-info epl popup powerline-evil powerline evil goto-chg undo-tree qml-mode ruby-additional rust-mode skewer-mode js2-mode simple-httpd smart-mode-line rich-minority dash undo-tree visual-regexp yasnippet yaxception)
