;; [[file:doom-emacs.org::*Intro][Intro:1]]
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; Intro:1 ends here

;; [[file:doom-emacs.org::*Font][Font:1]]
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 16)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 26))
(after! doom-theme
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;; Font:1 ends here

;; [[file:doom-emacs.org::*Theme][Theme:1]]
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'everforest-hard-dark)
;; Theme:1 ends here

;; [[file:doom-emacs.org::*Line number][Line number:1]]
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'visual)
;; Line number:1 ends here

;; [[file:doom-emacs.org::*Splash screen][Splash screen:1]]
(setq fancy-splash-image "/home/lucas/.config/doom/assets/emacs_logo.svg")
(setq +doom-dashboard-menu-sections nil)
(defun doom-dashboard-widget-shortmenu ())
(defun doom-dashboard-widget-footer ())
(defun doom-dashboard-widget-loaded ()
  (when doom-init-time
    (insert
     ""
     (propertize
      (+doom-dashboard--center
       +doom-dashboard--width
       "Liberty, Vitality, Beauty")
      'face 'doom-dashboard-loaded)
     "\n")))
;; Splash screen:1 ends here

;; [[file:doom-emacs.org::*Basic setup][Basic setup:1]]
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-scheduled-past-days 0)
(add-to-list 'org-emphasis-alist
             '("*" (bold :foreground "orange")))
;; Basic setup:1 ends here

;; [[file:doom-emacs.org::*Roam][Roam:1]]
(setq org-roam-directory (file-truename "~/org/roam/"))
(org-roam-db-autosync-mode)
(use-package! websocket
  :after org-roam)
(use-package! org-roam-ui
  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))
(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)))
(defun my-org-roam-extract-subtree-format ()
  "Ensure the extracted file has properties above the title and a clean title."
  (when (derived-mode-p 'org-mode)
    (goto-char (point-min))
    ;; Adjust the file title
    (when (re-search-forward "^#\\+title:.*" nil t)
      (replace-match (concat "#+title: " (org-get-heading t t t t))))
    ;; Move properties block to the top of the file
    (when (re-search-forward "^:PROPERTIES:" nil t)
      (let ((props (buffer-substring-no-properties
                    (match-beginning 0)
                    (progn (re-search-forward "^:END:" nil t) (point)))))
        (delete-region (match-beginning 0) (point))
        (goto-char (point-min))
        (insert props "\n")))))

(advice-add 'org-roam-extract-subtree :after #'my-org-roam-extract-subtree-format)
;; Roam:1 ends here

;; [[file:doom-emacs.org::*Define a global keymap for the agenda command][Define a global keymap for the agenda command:1]]
(setq org-agenda-files '("~/org/agenda/todo.org" "~/org/agenda/calendar.org" "~/org/agenda/uni-calendar.org"))
(define-key global-map (kbd "C-c a") 'org-agenda)
;; Define a global keymap for the agenda command:1 ends here

;; [[file:doom-emacs.org::*Create all the necessary keywords][Create all the necessary keywords:1]]
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "PROJ(p)" "HOLD(h)" "EVNT(e)" "|" "DONE(d)" "PAST(s)")))
;; Create all the necessary keywords:1 ends here

;; [[file:doom-emacs.org::*Log creation, activation, and done time][Log creation, activation, and done time:1]]
(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)
(setq org-log-done 'time)
;; Log creation, activation, and done time:1 ends here

;; [[file:doom-emacs.org::*Custom agenda views][Custom agenda views:1]]
(setq org-agenda-custom-commands
      '(("n" "NEXT items"
	 ((todo "NEXT")))
	("g" "General agenda"
	 ((agenda ""
		  ((org-agenda-start-day "+0d")
                   (org-agenda-deadline-leaders
                    '("" "" "%2d d. ago: "))
                   (org-agenda-start-on-weekday 0)
                   (org-agenda-span 'week)
		   (org-deadline-warning-days 0)))))
	("d" "Diffuse time"
	 ((tags "%diffuse")))
        ("r" "Random Review"
         ((tags-todo "CATEGORY=\"quest\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Quests")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"spiritual\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Spiritual")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"social\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Social")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"physical\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Physical")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"studies\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Studies")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"organization\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Organization")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"diffuse\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Diffuse")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"aesthetical\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Aesthetical")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"financial\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Financial")
                      (org-agenda-max-entries 5)))
          (tags-todo "CATEGORY=\"technological\"+TODO=\"TODO\"-SCHEDULED={.+}-DEADLINE={.+}"
                     ((org-agenda-overriding-header "Technological")
                      (org-agenda-max-entries 5)))
          )
         )
        ))
(setq org-agenda-tags-column 0)
;; Custom agenda views:1 ends here

;; [[file:doom-emacs.org::*Beautify with icons][Beautify with icons:1]]
(defun gk-nerd-agenda-icons (fun prefix alist)
  "Makes an org agenda alist"
  (mapcar (pcase-lambda (`(,category . ,icon))
            `(,category
              (,(funcall fun (concat prefix icon) :height 1.0))))
          alist))

(setq org-agenda-category-icon-alist
      (append
       (gk-nerd-agenda-icons #'nerd-icons-faicon "nf-fa-"
			     '(("inbox" . "inbox")
			       ("uni-calendar" . "university")
			       ("calendar" . "calendar")
			       ("quest" . "person_hiking")
                               ("spiritual" . "cross")
                               ("social" . "group")
                               ("physical" . "dumbbell")
                               ("studies" . "book_open")
                               ("organization" . "compass_drafting")
                               ("aesthetical" . "music")
                               ("financial" . "money")
                               ("technological" . "laptop")
                               ))
       '(("" '(space . (:width (11)))))))
;; Beautify with icons:1 ends here

;; [[file:doom-emacs.org::*Beautify prefix format][Beautify prefix format:1]]
(setq org-agenda-prefix-format '((agenda . " %-2i %?-12t %s ")
                                 (todo .   " %-2i ")
                                 (tags .   " %-2i ")
                                 (search . " %-2i ")))
;; Beautify prefix format:1 ends here

;; [[file:doom-emacs.org::*Capture templates][Capture templates:1]]
(setq org-capture-templates
      `(("i" "Task Inbox" entry (file+headline "~/org/agenda/todo.org" "Inbox")
         ,(concat "* TODO %? \n"
                  "/Entered on/ %U"))
        ("@" "Task Inbox [mu4e]" entry (file+headline "~/org/agenda/todo.org" "Inbox")
         ,(concat "* TODO Process \"%a\" %?\n"
                  "/Entered on/ %U"))
        ("e" "Event Inbox" entry (file+headline "~/org/agenda/calendar.org" "Once")
         ,(concat "* EVNT %? \n"
                  "/Entered on/ %U"))
        ("a" "Anki Russian Card" entry (file+headline "~/org/roam/20250730210718-r_a_russian_a1_vocabulary.org" "A1 vocab")
         ,(concat "** %(progn (setq my-capture-text (read-string \"Russian word: \")) my-capture-text)\n"
                  ":PROPERTIES:\n"
                  ":ANKI_NOTE_TYPE: lang\n"
                  ":END:\n"
                  "*** Front\n"
                  "%(bound-and-true-p my-capture-text)\n"
                  "*** Sentence\n"
                  "\"%^{example sentence}\"\n"
                  "*** Back\n"
                  "%^{translation}\n\n"
                  "\(%^{translation class}\)\n\n"
                  "\"%^{translation sentence}\"\n"))))
(define-key global-map (kbd "C-c c") 'org-capture)
;; Capture templates:1 ends here

;; [[file:doom-emacs.org::*Org link parameters][Org link parameters:1]]
(org-link-set-parameters
 "yt"
 :follow (lambda (path)
           (async-shell-command (format "mpv %s" path)))
 "ytl"
 :follow (lambda (path)
           (async-shell-command (format "mpv --ytdl-format=worst %s" path)))
 "qute"
 :follow (lambda (path)
           (async-shell-command (format "qutebrowser %s" path)))
 "copy"
 :follow (lambda (path)
           (async-shell-command (format "echo \"%s\" \| xclip -selection clipboard" path))))
;; Org link parameters:1 ends here

;; [[file:doom-emacs.org::*Rest][Rest:1]]
(setq org-modern-fold-stars
      '(("▶" . "▼")
        ("▷" . "▽")
        ;; ("⯈" . "⯆")
        ("▷" . "▽")
        ("▹" . "▿")
        ("▸" . "▾"))
      )



;; Org timer and alarm
(setq org-clock-sound "~/Downloads/ding-36029.wav")

(defun jl-notify-send (message)
  "Send notification with notify-send."
  (start-process "notify" nil "notify-send" "Emacs" message))

(setq org-show-notification-handler 'jl-notify-send)

(setq alarm-clock-sound-file "~/Downloads/alarm_MP3WRAP.mp3")

;; Tangle
(setq org-babel-tangle-use-relative-file-links t)

;; PDF
(setq +latex-viewers '(pdf-tools))

;; TeX
(after! tex
  (add-to-list 'TeX-command-list
               '("LaTeX with shell escape"
                 "pdflatex -shell-escape %s"
                 TeX-run-command t t :help "Run pdflatex with -shell-escape")))

(add-to-list 'load-path "/home/lucas/.config/emacs/.local/straight/repos/fretboard.el/")

(require 'fretboard)
(after! fretboard
  ;; First ensure the keymap exists
  (defvar fretboard-mode-map (make-sparse-keymap))

  ;; Then use map! to bind keys to that specific keymap
  (map! :map fretboard-mode-map
        :n "n" #'fretboard-next
        :n "p" #'fretboard-previous
        :n "k" #'fretboard-next-type
        :n "j" #'fretboard-previous-type
        :n "," #'fretboard-next-mode
        :n "m" #'fretboard-previous-mode
        :n "d" #'fretboard-toggle-display-type
        :n "t" #'fretboard-toggle-tuning-type
        :n "r" #'fretboard-toggle-relative-notes
        :n "s" #'fretboard-switch-to-scale
        :n "c" #'fretboard-switch-to-chord
        :n "q" #'fretboard-quit-all))
;; Email
;; https://macowners.club/posts/email-emacs-mu4e-macos/
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
;; (use-package! mu4e
;;   :ensure nil
;;   :config
;;   (setq mu4e-change-filenames-when-moving t)

;;   (setq mu4e-update-interval (* 10 60))
;;   (setq mu4e-get-mail-command "mbsync -a")
;;   (setq mu4e-maildir "~/.local/share/mail")
;;   (setq mu4e-contexts
;;         (list
;;          ;; Work account
;;          (make-mu4e-context
;;           :name "University"
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (string-prefix-p "/jlng3@alu.ua.es" (mu4e-message-field msg :maildir))))
;;           :vars '((user-mail-address . "jlng3@alu.ua.es")
;;                   (user-full-name    . "Lucas Galdino")
;;                   (mu4e-drafts-folder  . "/jlng3@alu.ua.es/Drafts")
;;                   (mu4e-sent-folder  . "/jlng3@alu.ua.es/Sent")
;;                   (mu4e-trash-folder  . "/jlng3@alu.ua.es/Trash")))
;;          (make-mu4e-context
;;           :name "Gmail"
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (string-prefix-p "/jucasngaldino@gmail.com" (mu4e-message-field msg :maildir))))
;;           :vars '((user-mail-address . "jlucasngaldino@gmail.com")
;;                   (user-full-name    . "Lucas Galdino")
;;                   (mu4e-drafts-folder  . "/jlucasngaldino@gmail.com/[Gmail]/Drafts")
;;                   (mu4e-refile-folder . "/jlucasngaldino@gmail.com/[Gmail/All Mail]")
;;                   (mu4e-sent-folder  . "/jlucasngaldino@gmail.com/[Gmail]/Sent Mail")
;;                   (mu4e-trash-folder  . "/jlucasngaldino@gmail.com/[Gmail]/Trash")))
;;          (make-mu4e-context
;;           :name "Personal"
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (string-prefix-p "/lucasgaldino@disroot.org" (mu4e-message-field msg :maildir))))
;;           :vars '((user-mail-address . "lucasgaldino@disroot.org")
;;                   (user-full-name    . "Lucas Galdino")
;;                   (mu4e-drafts-folder  . "/lucasgaldino@disroot.org/Drafts")
;;                   (mu4e-sent-folder  . "/lucasgaldino@disroot.org/Sent")
;;                   (mu4e-trash-folder  . "/lucasgaldino@disroot.org/Trash")))
;;          (make-mu4e-context
;;           :name "Business"
;;           :match-func
;;           (lambda (msg)
;;             (when msg
;;               (string-prefix-p "/lucas@lucasgaldino.com" (mu4e-message-field msg :maildir))))
;;           :vars '((user-mail-address . "lucas@lucasgaldino.com")
;;                   (user-full-name    . "Lucas Galdino")
;;                   (mu4e-drafts-folder  . "/lucas@lucasgaldino.com/Drafts")
;;                   (mu4e-sent-folder  . "/lucas@lucasgaldino.com/Sent")
;;                   (mu4e-refile-folder . "/lucas@lucasgaldino.com/Archive")
;;                   (mu4e-trash-folder  . "/lucas@lucasgaldino.com/Trash")))))
;;   (setq mu4e-maildir-shortcuts
;;         '((:maildir "/jlng3@alu.ua.es/INBOX" :key ?u)
;;           (:maildir "/jlucasngaldino@gmail.com/INBOX" :key ?g)
;;           (:maildir "/lucasgaldino@disroot.org/INBOX" :key ?p)
;;           (:maildir "/lucas@lucasgaldino.com/INBOX" :key ?b))))

;; (after! yeetube
;;   ;; First ensure the keymap exists
;;   (defvar yeetube-mode-map (make-sparse-keymap))

;;   ;; Then use map! to bind keys to that specific keymap
;;   (map! :map yeetube-mode-map
;;         :n "c" #'yeetube-copy-url
;;         :n "p" #'yeetube-play
;;         :n "s" #'yeetube-search
;;         :n "D" #'yeetube-download-change-directory
;;         :n "d" #'yeetube-download-video))
;; (map! :leader
;;       :desc "Open yeetube" "e y" #'yeetube-search)

;; ;; Buku
;; (setq ebuku-buku-path "~/.local/bin/buku")

;; Ellama
;; (use-package! ellama
;;   :bind ("C-c e" . ellama-transient-main-menu)
;;   :init
;;   ;; setup key bindings
;;   ;; (setopt ellama-keymap-prefix "C-c e")
;;   ;; language you want ellama to translate to
;;   (setopt ellama-language "English")
;;   ;; could be llm-openai for example
;;   (require 'llm-ollama)
;;   (setopt ellama-provider
;;           (make-llm-ollama
;;            ;; this model should be pulled to use it
;;            ;; value should be the same as you print in terminal during pull
;;            :chat-model "llama3.2"
;;            :embedding-model "nomic-embed-text"
;;            :default-chat-non-standard-params '(("num_ctx" . 8192))))
;;   (setopt ellama-summarization-provider
;;           (make-llm-ollama
;;            :chat-model "llama3.2"
;;            :embedding-model "nomic-embed-text"
;;            :default-chat-non-standard-params '(("num_ctx" . 32768))))
;;   (setopt ellama-coding-provider
;;           (make-llm-ollama
;;            :chat-model "llama3.2"
;;            :embedding-model "nomic-embed-text"
;;            :default-chat-non-standard-params '(("num_ctx" . 32768))))
;;   ;; Predefined llm providers for interactive switching.
;;   ;; You shouldn't add ollama providers here - it can be selected interactively
;;   ;; without it. It is just example.
;;   (setopt ellama-providers
;;           '(("zephyr" . (make-llm-ollama
;;                          :chat-model "zephyr:7b-beta-q6_K"
;;                          :embedding-model "zephyr:7b-beta-q6_K")) ("mistral" . (make-llm-ollama
;;                           :chat-model "mistral:7b-instruct-v0.2-q6_K"
;;                           :embedding-model "mistral:7b-instruct-v0.2-q6_K"))
;;             ("mixtral" . (make-llm-ollama
;;                           :chat-model "mixtral:8x7b-instruct-v0.1-q3_K_M-4k"
;;                           :embedding-model "mixtral:8x7b-instruct-v0.1-q3_K_M-4k"))))
;;   ;; Naming new sessions with llm
;;   (setopt ellama-naming-provider
;;           (make-llm-ollama
;;            :chat-model "llama3.2"
;;            :embedding-model "nomic-embed-text"
;;            :default-chat-non-standard-params '(("stop" . ("\n")))))
;;   (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
;;   ;; Translation llm provider
;;   (setopt ellama-translation-provider
;;           (make-llm-ollama
;;            :chat-model "llama3.2"
;;            :embedding-model "nomic-embed-text"
;;            :default-chat-non-standard-params
;;            '(("num_ctx" . 32768))))
;;   ;; customize display buffer behaviour
;;   ;; see ~(info "(elisp) Buffer Display Action Functions")~
;;   (setopt ellama-chat-display-action-function #'display-buffer-full-frame)
;;   (setopt ellama-instant-display-action-function #'display-buffer-at-bottom)
;;   :config
;;   ;; send last message in chat buffer with C-c C-c
;;   (add-hook 'org-ctrl-c-ctrl-c-hook #'ellama-chat-send-last-message)
;;   (setq ellama-sessions-directory "~/org/assets/ellama-sessions/"
;;         ellama-sessions-auto-save t))

(use-package! ox-typst
  :after org)

(setq auto-mode-alist
      (append '((".*\\.epub\\'" . nov-mode))
              auto-mode-alist))

(define-derived-mode astro-mode web-mode "astro")
(setq auto-mode-alist
      (append '((".*\\.astro\\'" . astro-mode))
              auto-mode-alist))

(after! eglot
  (add-to-list 'eglot-server-programs
               '(typst-ts-mode . ("tinymist")))
  (add-to-list 'eglot-server-programs
               '(astro-mode . ("astro-ls" "--stdio"
                               :initializationOptions
                               (:typescript (:tsdk "./node_modules/typescript/lib"))))))


;; Install Janet Tree-sitter grammar at startup
(setq treesit-language-source-alist
      (append treesit-language-source-alist
              (if (eq 'windows-nt system-type)
                  '((janet-simple
                     . ("https://github.com/sogaiu/tree-sitter-janet-simple"
                        nil nil "gcc.exe")))
                '((janet-simple
                   . ("https://github.com/sogaiu/tree-sitter-janet-simple"))))))

;; Install the grammar if not available
(when (not (treesit-language-available-p 'janet-simple))
  (treesit-install-language-grammar 'janet-simple))

;; Configure janet-ts-mode
(use-package! janet-ts-mode
  :mode "\\.janet\\'")

(after! epa
  (setq epa-pinentry-mode 'loopback)
  (setq epa-file-cache-passphrase-for-symmetric-encryption nil))

;; Languagetool
(setq lsp-log-io t)
;; (use-package! languagetool
;;   :config
;;   (setq languagetool-java-arguments '("-Dfile.encoding=UTF-8")
;;         languagetool-console-command "~/.languagetool/LanguageTool-6.5/languagetool-commandline.jar"
;;         languagetool-server-command "~/.languagetool/LanguageTool-6.5/languagetool-server.jar"))

;; Sysman
(defun emacs-sysman ()
  "Run sysman from Emacs."
  (interactive)
  (let* ((script-path "sm")
         (options '("install"
                    "list unmanaged"
                    "--help"))
         (choice (completing-read "select an option: " options nil t)))
    (async-shell-command (concat (shell-quote-argument script-path) " " choice))))

(map! :leader
      :desc "Configure emacs" "e c e" (lambda () (interactive) (find-file "~/syma/doom-emacs.org")))

(map! :leader
      :desc "Configure system packages" "e c p" (lambda () (interactive) (find-file "~/system-manager/metapac.org")))

(map! :leader
      :desc "Open sm" "e x" #'emacs-sysman)

(map! :leader
      :desc "Open beancount ledger" "l" (lambda () (interactive) (find-file "~/Documents/30-39--Finances/34--ledgers/2025.beancount")))

(map! :leader
      :desc "Find file with consult" "e f f" #'consult-find)

(map! :leader
      :desc "Rg files with consult" "e f r" #'consult-ripgrep)

(map! :prefix "C-c m"
      :desc "Toggle play/pause" "SPC" #'libmpdel-playback-play-pause
      :desc "Next track"        "n"   #'libmpdel-playback-next
      :desc "Previous track"    "p"   #'libmpdel-playback-previous
      :desc "Stop"              "s"   #'libmpdel-stop
      :desc "Open playlist"     "l"   #'mpdel-playlist-open
      :desc "Browse library"    "b"   #'mpdel-browser-open
      :desc "Current song"      "v"   #'mpdel-song-open
      :desc "Volume up"         "+"   #'mpdel-core-volume-increase
      :desc "Volume down"       "-"   #'mpdel-core-volume-decrease
      :desc "Seek"      "f"   #'libmpdel-playback-seek
      :desc "Connect profile"   "C"   #'mpdel-core-connect-profile)



(use-package! mpdel
  :config
  (defun setup-mpdel-keybindings ()
    "Set up keybindings for mpdel buffers"
    ;; Navigation
    (local-set-key (kbd "n") 'next-line)
    (local-set-key (kbd "p") 'previous-line)
    (local-set-key (kbd "RET") 'mpdel-browser-open)
    (local-set-key (kbd "^") 'mpdel-browser-open-parent)
    (local-set-key (kbd "C-x C-j") 'mpdel-dired-open)

    ;; Playlist actions
    (local-set-key (kbd "a") 'mpdel-playlist-add)
    (local-set-key (kbd "A") 'mpdel-playlist-add-to-stored-playlist)
    (local-set-key (kbd "r") 'mpdel-playlist-replace)
    (local-set-key (kbd "R") 'mpdel-playlist-replace-stored-playlist)
    (local-set-key (kbd "P") 'mpdel-core-play)

    ;; Playback control (mirror global bindings)
    (local-set-key (kbd "SPC") 'mpdel-core-toggle-play-pause)
    (local-set-key (kbd "M-n") 'mpdel-core-next)
    (local-set-key (kbd "M-p") 'mpdel-core-previous)
    (local-set-key (kbd "s") 'mpdel-core-stop)

    ;; Volume
    (local-set-key (kbd "+") 'mpdel-core-volume-increase)
    (local-set-key (kbd "-") 'mpdel-core-volume-decrease)

    ;; View/info
    (local-set-key (kbd "v") 'mpdel-song-open)
    (local-set-key (kbd "C") 'mpdel-core-connect-profile))

  ;; Apply keybindings to all relevant mpdel modes
  (add-hook 'mpdel-playlist-mode-hook #'setup-mpdel-keybindings)
  (add-hook 'mpdel-browser-mode-hook #'setup-mpdel-keybindings)
  (add-hook 'mpdel-song-mode-hook #'setup-mpdel-keybindings)
  (add-hook 'mpdel-tablist-mode-hook #'setup-mpdel-keybindings))

;; Yewtube
(defun yewtube()
  "Run Yewtube from Emacs."
  (async-shell-command "~/.local/bin/yt"))

(setq shell-file-name (executable-find fish))
(setq explicit-shell-file-name shell-file-name)
(use-package! exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-envs '("PATH" "SHELL"))))

(setq eshell-aliases-file (expand-file-name "eshell/aliases" doom-user-dir))

(setq org-contacts-files '("~/org/agenda/address-book.org"))

(setq diary-file "~/org/agenda/diary")
(setq diary-date-forms diary-iso-date-forms)

;; EMPV
(setq empv-invidious-instance "https://invidious.f5.si/api/v1")
(map! :map empv-youtube-results-mode-map
      :n [return] #'empv-youtube-results-play-current
      :n "RET"    #'empv-youtube-results-play-current)

;; Nice look
(with-eval-after-load 'org (global-org-modern-mode))

;; Center things
(defun org-agenda-open-hook ()
  (olivetti-mode))
(add-hook 'org-agenda-mode-hook 'org-agenda-open-hook)
(setq olivetti-body-width 120)

;; wttrin
(setq wttrin-default-cities '("Alicante" "Spain"))

;; Jinx
(use-package! jinx
  :hook (after-init . global-jinx-mode))

;; Anki editor
(use-package! anki-editor)

(setq truncate-lines nil)

(defun my/clean-downloads ()
  "Run the Fish `clean-downloads` script natively from Emacs."
  (interactive)
  (shell-command "clean-downloads.fish"))

(defun my/anki-renumber-clozes-under-heading ()
  "Renumber all {{cN::...}} clozes sequentially within the current Org subtree."
  (interactive)
  (unless (derived-mode-p 'org-mode)
    (user-error "This command only works in org-mode buffers"))
  (save-excursion
    ;; Narrow to the current heading
    (org-back-to-heading t)
    (org-narrow-to-subtree)
    (goto-char (point-min))
    (let ((counter 1)
          (regexp "{{c[0-9]+::"))
      (while (re-search-forward regexp nil t)
        (replace-match (format "{{c%d::" counter) nil nil)
        (setq counter (1+ counter))))
    (widen)
    (message "Renumbered %d clozes under heading: %s"
             (1- counter)
             (nth 4 (org-heading-components)))))



;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; Rest:1 ends here
