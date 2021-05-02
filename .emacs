;;No tabs !
(setq-default c-basic-indent 2)
(setq-default tab-width 4)
(setq indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)
(setq show-trailing-whitespace t)
(setq-default show-trailing-whitespace t)
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; Loading plugins
;;(load "~/.emacs.d/std.el")
;;(load "~/.emacs.d/std_comment.el")

(load "~/.emacs.d/web-mode.el")
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;; Tweeks
(column-number-mode 1)
(setq column-number-mode t)

;; Line  numbers
(load "~/.emacs.d/linum.el")
(require 'linum)
(setq linum-format "%4d \u2502")
(global-linum-mode 1)

;; Coffee-script
(load "~/.emacs.d/coffee-mode.el")
(require 'coffee-mode)
(custom-set-variables '(coffee-tab-width 4))

;;Yaml-Mode
(load "~/.emacs.d/yaml-mode.el")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))


;; Shortcuts
(global-set-key (kbd "<f1>") 'linum-mode)
(global-set-key (kbd "<f12>") 'iwb)

;; Allows to delete selection with Suppr key
(delete-selection-mode 1)

;; Cua-mode allows using 'Ctrl-v', 'Ctrl-c', 'Ctrl-Z' and 'Ctrl-x'
(cua-mode t)

(put 'scroll-left 'disabled nil)
