;; Remove welcome page
(setq inhibit-startup-message 1)

;; Remove menus
(tool-bar-mode -1)
(menu-bar-mode -1)

;;remove scrollbar
(scroll-bar-mode -1)

;;remove bell sound
(setq visible-bell 1)

;;line number
;;(global-linum-mode t)
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;;load theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/dracula/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/monokai-emacs")
(load-theme 'dracula t)
(load-theme 'monokai t)
(enable-theme 'dracula)
;;(load-theme 'tango-dark)

;;enable mouse over ssh
(xterm-mouse-mode 1)

;;load includes
(load "~/.emacs.d/org-bullets")
(load "~/.emacs.d/markdown-mode")
(load "~/.emacs.d/dimmer.el/dimmer")
(load "~/.emacs.d/indent-guide/indent-guide")

;;vterm
(use-package vterm
  :load-path  "~/.emacs.d/emacs-libvterm/")

;; tabs and spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;;backups
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 2               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 2               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 30              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 300            ; number of keystrokes between auto-saves (default: 300)
      )

;;org mode hide emphasis
(setq org-hide-emphasis-markers t)

;;emacs tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;;more org mode configs
(font-lock-add-keywords 'org-mode
			'(("^ +\\([-*]\\) "
			    (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-bullets)
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(org-mode)
    (org-toggle-pretty-entities)
    (setq org-id-track-globally t)

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   ))

;; limit column to 79 in org mode
(add-hook 'org-mode-hook '(lambda () (setq fill-column 79)))
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;;add ruler into column 79 to prog mode
;;;###autoload
(define-minor-mode display-fill-column-indicator-mode
  "Toggle display of `fill-column' indicator.
This uses `display-fill-column-indicator' internally.
To change the position of the column displayed by default
customize `display-fill-column-indicator-column'.  You can change the
character for the indicator setting `display-fill-column-indicator-character'.
The globalized version is `global-display-fill-column-indicator-mode',
which see.
See Info node `Displaying Boundaries' for details."
  :lighter nil
  (if display-fill-column-indicator-mode
      (progn
        (setq display-fill-column-indicator t)
        (unless display-fill-column-indicator-character
          (setq display-fill-column-indicator-column 79)
          (setq display-fill-column-indicator-character
                (if (and (char-displayable-p ?\u2502)
                         (or (not (display-graphic-p))
                             (eq (aref (query-font (car (internal-char-font nil ?\u2502))) 0)
                                 (face-font 'default))))
                    ?\u2502
                  ?|))))
    (setq display-fill-column-indicator nil)))

(defun display-fill-column-indicator--turn-on ()
  "Turn on `display-fill-column-indicator-mode'."
  (unless (or (minibufferp)
              (and (daemonp) (null (frame-parameter nil 'client))))
    (display-fill-column-indicator-mode)))

;;;###autoload
(define-globalized-minor-mode global-display-fill-column-indicator-mode
  display-fill-column-indicator-mode display-fill-column-indicator--turn-on
)

(provide 'display-fill-column-indicator)
(add-hook 'prog-mode-hook #'display-fill-column-indicator--turn-on)
;(setq display-fill-column-indicator-column 80)
;(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;;show column number
(setq column-number-mode t)

;;python folding
(add-hook 'python-mode-hook 'outline-minor-mode)

;;neotree keybindings with evil mode

;;load markdown
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode))

(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;;packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)

    (global-auto-complete-mode t)))

(use-package all-the-icons
  :ensure t)

(use-package magit
  :ensure t
  :config (setq magit-git-executable "/grid/common/pkgsData/git-v2.31.1/Linux/RHEL8.0-2019-x86_64/bin/git")
  :bind (("C-x g" . magit)))

(use-package neotree
  :ensure t
  :config
  (progn
    (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))
  :bind (("C-\\" . 'neotree-toggle))) ;;vscode shortcut

(add-hook 'neotree-mode-hook
            (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
            (define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
            (define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
            (define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
            (define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)))


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode t)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (custom-set-variables
 '(flycheck-python-flake8-executable "/grid/common/pkgs/python/v3.7.2/bin/python3.7")
 '(flycheck-python-pycompile-executable "/grid/common/pkgs/python/v3.7.2/bin/python3.7")
 '(flycheck-python-pylint-executable "/grid/common/pkgs/python/v3.7.2/bin/python3.7"))
  )


(use-package evil
  :ensure t
  :init 
  (setq evil-want-C-i-jump nil)
  (evil-mode 1))

;;ensure C-r pulls history in terminals

(defun bb/setup-term-mode ()
  (evil-local-set-key 'insert (kbd "C-r") 'bb/send-C-r))
(defun bb/send-C-r ()
  (interactive)
  (term-send-raw-string "\C-r"))
(add-hook 'term-mode-hook 'bb/setup-term-mode)
(add-hook 'vterm-mode-hook 'bb/setup-term-mode)

(font-lock-add-keywords 'org-mode
                            '(("^ +\\([-*]\\) "
                               (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(use-package all-the-icons
  :if (display-graphic-p))
(use-package page-break-lines
  :ensure t)
(use-package projectile
  :ensure t)
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-agenda-release-buffers t))

(use-package pulsar
  :ensure t)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings 'ctrl))

(require 'dimmer)
 (dimmer-configure-which-key)
 (dimmer-configure-helm)
 (dimmer-mode t)

(require 'indent-guide)
 (indent-guide-global-mode)

(use-package rainbow-delimiters)
 :ensure t
 :init
 (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(use-package dumb-jump)
 :ensure t
 :init
 (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

;;org-roam
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  (setq org-agenda-files '("~/RoamNotes/agenda/2023"))
  :custom
  (org-roam-directory "~/RoamNotes")
  ;; agenda files
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-id-get-create)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))

;; jira integration
(use-package jiralib2
  :load-path "~/.emacs.d/jiralib2/"
  :init
)
(use-package ejira
  :load-path "~/.emacs.d/ejira/"
  :init
  (setq jiralib2-url              "https://jira.cadence.com"
        jiralib2-auth             'basic
        jiralib2-user-login-name  "tiagof"
        jiralib2-token            nil

        ;; NOTE, this directory needs to be in `org-agenda-files'`
        ejira-org-directory       "~/jira"
        ejira-projects            '("EJ" "JL2")

        ejira-priorities-alist    '(("Highest" . ?A)
                                    ("High"    . ?B)
                                    ("Medium"  . ?C)
                                    ("Low"     . ?D)
                                    ("Lowest"  . ?E))
        ejira-todo-states-alist   '(("To Do"       . 1)
                                    ("In Progress" . 2)
                                    ("Done"        . 3)))
  :config
  ;; Tries to auto-set custom fields by looking into /editmeta
  ;; of an issue and an epic.
  (add-hook 'jiralib2-post-login-hook #'ejira-guess-epic-sprint-fields)

  ;; They can also be set manually if autoconfigure is not used.
  ;; (setq ejira-sprint-field       'customfield_10001
  ;;       ejira-epic-field         'customfield_10002
  ;;       ejira-epic-summary-field 'customfield_10004)

  (require 'ejira-agenda)

  ;; Make the issues visisble in your agenda by adding `ejira-org-directory'
  ;; into your `org-agenda-files'.
  (add-to-list 'org-agenda-files ejira-org-directory)

  ;; Add an agenda view to browse the issues that
  (org-add-agenda-custom-command
   '("j" "My JIRA issues"
     ((ejira-jql "resolution = unresolved and assignee = currentUser()"
                 ((org-agenda-overriding-header "Assigned to me")))))))

;;clippety -> copy and paste working from wsl tmux
(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode))

;; emacs server
(server-start)
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

;;transparency
(set-frame-parameter (selected-frame) 'alpha '(90 . 50))
(add-to-list 'default-frame-alist '(alpha . (90 . 50)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Insert Cadence header to current file
;; (Python)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun insert-header ()
  "Insert Cadence corporate header on file"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (string-match "^#!/" (thing-at-point 'line))
        ;; Jump one line if there is a '#!' string at top
        (progn
          (end-of-line)
          (newline)))
    (insert-file-contents "~/.emacs.d/cadence_header.py")
    (nonincremental-re-search-forward "File +:")
    (insert (format " %s" (current-buffer)))))
(global-set-key (kbd "C-c h") 'insert-header)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Insert python header for sections
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun make-header ()
  (interactive)
  (insert "#!/grid/common/pkgs/python/v3.7.2/bin/python3.7"))

(setq org-todo-keywords
        '((sequence "TODO(t)" "STARTED(s!)" "WAITING(w!)" "|" "DONE(d!)" "CANCELLED(c!)")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-message-face 'default)
 '(custom-safe-themes
   '("37c8c2817010e59734fe1f9302a7e6a2b5e8cc648cf6a6cc8b85f3bf17fececf" default))
 '(fci-rule-color "#3C3D37")
 '(flycheck-flake8rc "~/.config/flake8")
 '(flycheck-python-flake8-executable "/home/tiagof/.local/bin/flake8")
 '(flycheck-python-pycompile-executable "python2")
 '(flycheck-python-pylint-executable "python2")
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
 '(magit-diff-use-overlays nil)
 '(org-agenda-files
   '("~/RoamNotes/agenda/2023/2023-04-10~2023-04-14.org" "/home/tiagof/RoamNotes/agenda/2023/2023-04-03~2023-04-07.org" "/home/tiagof/RoamNotes/agenda/2023/2023-03-27~2023-03-31.org" "/home/tiagof/RoamNotes/agenda/2023/2023-01-02~2023-01-06.org" "/home/tiagof/RoamNotes/agenda/2023/2023-01-09~2023-01-13.org" "/home/tiagof/RoamNotes/agenda/2023/2023-01-23~2023-01-27.org" "/home/tiagof/RoamNotes/agenda/2023/2023-01-30~2023-02-03.org" "/home/tiagof/RoamNotes/agenda/2023/2023-02-06~2023-02-10.org" "/home/tiagof/RoamNotes/agenda/2023/2023-02-13~2023-02-17.org" "/home/tiagof/RoamNotes/agenda/2023/2023-02-20~2023-02-24.org" "/home/tiagof/RoamNotes/agenda/2023/2023-03-06~2023-03-10.org" "/home/tiagof/RoamNotes/agenda/2023/2023-03-13~2023-03-17.org" "/home/tiagof/RoamNotes/agenda/2023/2023-03-20~2023-03-25.org"))
 '(org-export-backends '(ascii html icalendar latex md odt confluence))
 '(package-selected-packages
   '(htmlize restclient language-detection ox-jira request f org-roam-ui magit vterm dracula-theme org dumb-jump rainbow-delimiters org-bullets all-the-icons neotree auto-complete which-key try use-package))
 '(pos-tip-background-color "#FFFACE")
 '(pos-tip-foreground-color "#272822")
 '(python-shell-interpreter "/grid/common/pkgs/python/v3.7.2/bin/python3.7")
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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
