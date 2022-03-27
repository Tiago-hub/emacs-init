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
(global-linum-mode t)

(load-theme 'tango-dark)

(load "~/.emacs.d/org-bullets")

;;org mode hide emphasis
(setq org-hide-emphasis-markers t)

;;more org mode configs
(font-lock-add-keywords 'org-mode
                        '(("^ +\\([-*]\\) "
                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-bullets)
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(org-mode)
    (org-toggle-pretty-entities)

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   ))


(add-hook 'org-mode-hook '(lambda () (setq fill-column 80)))
(add-hook 'org-mode-hook 'turn-on-auto-fill)
;;packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
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

(use-package neotree
  :ensure t
  :config
  (progn
    (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))
  :bind (("C-\\" . 'neotree-toggle))) ;;vscode shortcut

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode t))

(use-package evil
  :ensure t
  :init
  (setq evil-want-C-i-jump nil)
  (evil-mode 1))

(font-lock-add-keywords 'org-mode
                            '(("^ +\\([-*]\\) "
                               (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
