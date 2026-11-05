(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(setq gnutls-verify-error nil)

(setq url-timeout 10)

(package-refresh-contents t)

;; Add the folder containing your script
(add-to-list 'load-path "~/.emacs.d/lisp/")


'(menu-bar-mode -1)

'(tool-bar-mode -1)
 '(warning-suppress-types '((use-package) (use-package)))

;; Display the number lines
;;(global-display-line-numbers-mode 1)

(setq display-line-numbers-type 'absolute)
(global-display-line-numbers-mode t)
(column-number-mode t)


;; MELPA PAGKAGES				     
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;ELPA PACKAGES
(require 'package)
(add-to-list 'package-archives '("elpa"  . "https://elpa.gnu.org/packages/") t)

;; Enable electric-pair-mode for automatic insertion of matching parentheses
(electric-pair-mode 1)

;; Activating windmove to move between the windows 
(windmove-default-keybindings) ;; Shift + arrow key


(setq-default c-default-style "linux")

(setq backward-delete-char-untabify-method 'nil)


;; Set the font
(set-frame-parameter nil 'font "Source Code Pro Semibold-10")

(global-font-lock-mode 1)

;; Checking where Im running emacs
(if (daemonp)
    (message "[CONFIG-INFO] Loading in the daemon!")
  (message "[CONFIG-INFO] Loading in regular Emacs!"))


;;Emacs Transparent

;; To make emacs transparent
(set-frame-parameter nil 'alpha-background 55)
(add-to-list 'default-frame-alist '(alpha-background . 55))

;; Ensure new frames created by the emacsclient also inherit the transparency setting
(defun set-frame-transparency (frame)
(set-frame-parameter frame 'alpha-background 60))

(add-hook 'after-make-frame-functions 'set-frame-transparency)



;; --------------------------------------------------------------------------
;; Key bindings config


;; To compile code or to run commands
(global-set-key [f5] 'compile)


;; Shell command to be saved
(defvar previous-shell-command nil
  "Variable to store the previous shell command.")

(defun my/async-shell-command-with-previous ()
  "Run `async-shell-command` with the previously used command, if any."
  (interactive)
  (let ((command (read-shell-command "Shell command: " previous-shell-command)))
    (setq previous-shell-command command)
    (async-shell-command command)))

;; To run commands with input and output streams
(global-set-key [f6] 'my/async-shell-command-with-previous)

;; dired
;; To add a new file to the current listed direcotry 
(defun my/dired-add-file-here ()
  "Add a new file in the current directory in Dired mode."
  (interactive)
  (let ((dir (dired-current-directory)))
    (find-file (expand-file-name (read-string "New file name: " nil nil "new_file") dir))))

(global-set-key (kbd "C-+") 'my/dired-add-file-here)


(defun my-rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'my-rc/duplicate-line)


(defun my/open-init-file ()
  "Open my init.el quickly."
  (interactive)
  (find-file "~/.emacs"))

;; -------------------------------------------------------------------------------------------
;; Native Packages

;; ido - To autocomplete the buffers names
;; https://www.gnu.org/software/emacs/manual/html_mono/ido.html#Overview
(require 'ido)
(ido-mode t)

;; org mode 
;; My rg mode configuration for taking notes
;; https://orgmode.org/worg/org-contrib/babel/languages/ob-doc-python.html
(use-package org
  :ensure nil
  :config
  ;; For listing the sessions:
  ;; M-x list-processes

  ;; Enable org-tempo (<s TAB etc.)
  (require 'org-tempo)

  ;; Enable Python in org-babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)))

  ;; Enable latex in org-babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((latex . t)))

  ;; Enable shifts  selects
  (setq org-support-shift-select t)
 
  ;; The size of the latex fragments
  (setq org-format-latex-options
	(plist-put org-format-latex-options :scale 2.0))

  ;; No confirmation before executing
  (setq org-confirm-babel-evaluate nil)

  ;; Default Python settings
  (setq org-babel-default-header-args:python
        '((:session . "main")))

  ;; Render the latex automatically the latex
  (setq org-startup-with-latex-preview t)

  ;; For latex
  ;; <l [TAB], for latex
  ;; C-c C-x C-l, for rendering or run the command (org-toggle-latex-fragment)
  ;; NOTE!!!!: you must to have `sudo pacman -S texlive-most` installed latex

  
  ;; Custom template for Python block
  ;; <py [TAB] -  for putting a python block
  (add-to-list 'org-structure-template-alist
               '("py" . "src python :session main :results output"))

  ;; <as [TAB] -  for putting a python async block 
  (add-to-list 'org-structure-template-alist
               '("as" . "src python :session main :results output :async yes"))

  ;; <plt [TAB] - for putting a plot
  (add-to-list 'org-structure-template-alist
               '("plt" . "src python :session main :results file link :file plot.png"))

  ;; <table [TAB] -  for putting a python block
  (add-to-list 'org-structure-template-alist
               '("table" . "src python :session main :results table"))
  ;; <m [TAB] - for latex
  (add-to-list 'org-structure-template-alist
             '("m" . "latex"))

  ;; To show inline images 
  (setq org-startup-with-inline-images t)
  (add-hook 'org-mode-hook
            (lambda ()
              (setq-local electric-pair-inhibit-predicate
                          (lambda (c)
                            (if (eq c ?<)
				t
                              (electric-pair-default-inhibit c))))))
  )



;; Doxygen
;; https://github.com/pniedzielski/doxymacs
(use-package doxymacs
  :vc (:url "https://github.com/pniedzielski/doxymacs.git"
            :rev :newest
            :lisp-dir "lisp/")
  :hook (c-mode-common-hook . doxymacs-mode)
  :bind (:map c-mode-base-map
              ;; Lookup documentation for the symbol at point.
              ("C-c d ?" . doxymacs-lookup)
              ;; Rescan your Doxygen tags file.
              ("C-c d r" . doxymacs-rescan-tags)
              ;; Prompt you for a Doxygen command to enter, and its
              ;; arguments.
              ("C-c d RET" . doxymacs-insert-command)
              ;; Insert a Doxygen comment for the next function.
              ("C-c d f" . doxymacs-insert-function-comment)
              ;; Insert a Doxygen comment for the current file.
              ("C-c d i" . doxymacs-insert-file-comment)
              ;; Insert a Doxygen comment for the current member.
              ("C-c d ;" . doxymacs-insert-member-comment)
              ;; Insert a blank multi-line Doxygen comment.
              ("C-c d m" . doxymacs-insert-blank-multiline-comment)
              ;; Insert a blank single-line Doxygen comment.
              ("C-c d s" . doxymacs-insert-blank-singleline-comment)
              ;; Insert a grouping comments around the current region.
              ("C-c d @" . doxymacs-insert-grouping-comments))
  :custom
    ;; Configure source code <-> Doxygen tag file <-> Doxygen HTML
    ;; documentation mapping:
    ;;   - Files in /home/me/project/foo/ have their tag file at
    ;;     http://someplace.com/doc/foo/foo.xml, and HTML documentation
    ;;     at http://someplace.com/doc/foo/.
    ;;   - Files in /home/me/project/bar/ have their tag file at
    ;;     ~/project/bar/doc/bar.xml, and HTML documentation at
    ;;     file:///home/me/project/bar/doc/.
    ;; This must be configured for Doxymacs to function!
    (doxymacs-doxygen-dirs
     '(("^/home/hespinozas/Documentos/miCarpeta/projects/foo"
        "http://someplace.com/doc/foo/foo.xml"
         "http://someplace.com/doc/foo/")
       ("^/home/me/project/bar/"
        "~/project/bar/doc/bar.xml"
        "file:///home//project/bar/doc/"))))


;; -------------------------------------------------------------------------------------------
;; General package configs


;; company
;; https://company-mode.github.io/
(use-package company
  :hook (prog-mode . company-mode)
  :bind
  (:map company-active-map
        ("<tab>" . company-complete-selection)
        ("<escape>" . company-abort))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  (company-tooltip-limit-20)
  :ensure t
  )

;; yasnippet-snippets
;; https://github.com/AndreaCrotti/yasnippet-snippets
;; https://andreacrotti.pro/yasnippet-snippets/snippets
(use-package yasnippet-snippets
  :ensure t)
(require 'yasnippet)
(setq yas-snippet-dirs '("~/.emacs.d/snippets")) ; Path to your custom templates
(yas-global-mode 1)       


;; super-save: Save automatically the files when switching between buffer
;; https://github.com/bbatsov/super-save
(use-package super-save
  :ensure t
  :config
  (super-save-mode 1)
  (setq super-save-auto-save-when-idle t)) ;; Save when idle


;; yasnippet
;; Code snippets to a lot of languages 
;; https://github.com/joaotavora/yasnippet
(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

;; multiple-cursors
;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :ensure t
  ;; When you want to add multiple cursors not based on continuous lines,
  ;; but based on keywords in the buffer, use:
  ;; `C-g` To remove all the cursos
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi-deuteranopia))
 '(gnus-logo-color-style 'storm)
 '(package-selected-packages
   '(company dashboard diredfl doxymacs multiple-cursors
	     rainbow-delimiters super-save yasnippet-snippets))
 '(package-vc-selected-packages
   '((doxymacs :url "https://github.com/pniedzielski/doxymacs.git"
	       :lisp-dir "lisp/")))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



;;rainbows delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :ensure t)

















