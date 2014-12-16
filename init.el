(require 'cask "/Users/jvkersch/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(setq user-full-name "Joris Vankerschaver"
      user-email-address "Joris.Vankerschaver@gmail.com")

(server-start)



(setq frame-title-format "Emacs: %f")
(setq inhibit-splash-screen t)
(fset 'yes-or-no-p 'y-or-n-p)

(set-face-attribute 'default nil :height 160)

(when (display-graphic-p)
  (if (> (x-display-pixel-width) 1280)
      (add-to-list 'default-frame-alist (cons 'width 100))
    (add-to-list 'default-frame-alist (cons 'width 80))))

(setq exec-path 
      (append exec-path '("/usr/local/bin/")))



;;; Packages bundled with Emacs
(cua-selection-mode t)


; Visual mode for text files
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

(setq line-number-mode t)
(setq column-number-mode t)
(setq-default fill-column 79)

; \n toevoegen wanneer er geen te vinden is op de laatste regel
(setq require-final-newline t)


;;;; Color themes
;(load-theme 'solarized-dark t)
(load-theme 'sanityinc-tomorrow-eighties t)

; Stolen from howardism
(defun org-src-color-blocks-dark ()
  "Colors the block headers and footers to make them stand out more for dark themes"
  (interactive)
  (custom-set-faces
   '(org-block-begin-line
     ((t (:foreground "#008ED1" :background "#002E41"))))
   '(org-block-background
     ((t (:background "#111111"))))
   '(org-block-end-line
     ((t (:foreground "#008ED1" :background "#002E41"))))

   '(mode-line-buffer-id ((t (:foreground "black" :bold t))))
   '(which-func ((t (:foreground "green")))))
)
(org-src-color-blocks-dark)


;;;; Local packages and customization
(require 'use-package)
;;; Enable ido mode
(use-package ido
  :init (ido-mode t))
(use-package cython-mode
  :mode (("\\.spyx" . cython-mode)
         ("\\.pyx" . cython-mode)))

(require 'hungry-delete)


(setq whitespace-style '(face empty tabs tab-mark lines-tail))
(defun coding-hook ()
  "Enable things that are convenient across all coding buffers."
  (column-number-mode t)
  (setq indent-tabs-mode nil)
  ;(auto-fill-mode)
  (whitespace-mode)
  (hungry-delete-mode)
  ;(flycheck-mode)
  ;(fci-mode)
  )

(add-hook 'c-mode-common-hook   'coding-hook)
(add-hook 'sh-mode-hook         'coding-hook)
(add-hook 'js-mode-hook         'coding-hook)
(add-hook 'java-mode-hook       'coding-hook)
(add-hook 'lisp-mode-hook       'coding-hook)
(add-hook 'emacs-lisp-mode-hook 'coding-hook)
(add-hook 'makefile-mode-hook   'coding-hook)
(add-hook 'latex-mode-hook      'coding-hook)
(add-hook 'python-mode-hook     'coding-hook)


;;; Python-specific customizations.
(add-hook 'python-mode-hook     'flycheck-mode)
;;; Run nosetests from within Emacs
;;; Code from https://bitbucket.org/durin42/nosemacs
(require 'nose)
(add-hook 'python-mode-hook
          (lambda ()
            (local-set-key "\C-ca" 'nosetests-all)
            (local-set-key "\C-cm" 'nosetests-module)
            (local-set-key "\C-c." 'nosetests-one)
            (local-set-key "\C-cpa" 'nosetests-pdb-all)
            (local-set-key "\C-cpm" 'nosetests-pdb-module)
            (local-set-key "\C-cp." 'nosetests-pdb-one)))

;;; Lisp-specific
;; Keep M-TAB for `completion-at-point'
(add-hook 'lisp-mode-hook
          (lambda ()
            (define-key flyspell-mode-map "\M-\t" nil)
            ;; Pretty-print eval'd expressions.
            (define-key emacs-lisp-mode-map "\C-x\C-e" 'pp-eval-last-sexp)))


;; Haskell mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)


(defun c-hook ()
  "Styling for C and C++ modes."
  (c-toggle-auto-hungry-state t)
  (c-set-style "stroustrup")
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'inline-open 0))

(add-hook 'c-mode-hook   'c-hook)
(add-hook 'c++-mode-hook 'c-hook)

;;; Load my etags files.
(setq tags-table-list '("~/.etags"))


(require 'use-package)
(use-package undo-tree
  :init
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

;; Aangepast van http://www.jesshamrick.com/2013/03/31/macs-and-emacs/
;; Forward search from PDF to LaTeX document is
;; gebaseerd op http://www.cs.berkeley.edu/~prmohan/emacs/latex.html
;; Voor backward search gebruik ik Skim, en stel ik de editor in de
;; preferences in als '/usr/local/bin/emacsclient' met als opties
;; '--no-wait +%line "%file"'
(require 'tex-site)
(use-package tex-site
  :init
  (progn
    (setq LaTeX-command "latex -synctex=1")
    (setq TeX-PDF-mode t)
    (setq TeX-view-program-list
          (quote
           (("Skim"
             (concat "/Applications/Skim.app/"
                     "Contents/SharedSupport/displayline"
                     " %n %o %b")))))
    (setq TeX-view-program-selection
          (quote (
                  (output-pdf "Skim")
                  )))
    (setq TeX-source-correlate-method 'synctex)
    (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)))


;;;;; ORG mode
;; Org-mode
(add-hook 'org-mode-hook
          (lambda ()
            (setq-default indent-tabs-mode nil)))

(setq org-base-folder (expand-file-name "~/Dropbox/Documents/org"))

(setq org-todo-keywords
          '((sequence "TODO" "IN-PROGRESS" "PENDING" "DONE")))
(setq org-todo-keyword-faces
          '(("TODO" . (:foreground "red"))
                ("IN-PROGRESS" . (:foreground "orange")) 
                ("PENDING" . (:foreground "yellow"))
                ("DONE" . (:foreground "green"))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (sh . t)
   (python . t)
   (R . t)
   (ruby . t)
   (sqlite . t)
   (perl . t)
   ))

(require 'org-install)  ;; What does this do again?
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-log-done t)

(setq org-default-notes-file (concat org-base-folder "/notes.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
             "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
                 "* %?\nEntered on %U\n  %i\n  %a")))

; org clock mode.
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)


;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))
