;; [[file:doom-emacs.org::*packages.el - package management (custom)][packages.el - package management (custom):1]]
;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;; (package! some-package)
(unpin! org-roam)
(package! org-roam-ui)
;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

(package! gnuplot)

(package! cider)

(package! csv-mode)

(package! deadgrep)

(package! org-habit-stats)

(package! ebuku)

(package! fish-mode)

(package! org-ql)

(package! org-roam-ql)

(package! exec-path-from-shell) ;; Makes sure to use system shell. Nix had locked me into bash once.

(package! typst-ts-mode
  :recipe (:host codeberg :repo "meow_king/typst-ts-mode"))

(package! org-contacts)

(package! nov)

(package! ox-epub)

(package! empv)

(package! org-super-agenda)

(package! org-modern)

(package! olivetti)

(package! all-the-icons)

(package! org-web-tools)

(package! eat
  :recipe (:host codeberg :repo "akib/emacs-eat"))

(package! jinx)

(package! alert
  :recipe (:host github :repo "jwiegley/alert"))

(package! everforest
  :recipe (:repo "https://github.com/Theory-Of-Everything/everforest-emacs.git"))

(package! anki-editor
  :recipe (:host github :repo "anki-editor/anki-editor"))

(package! flexoki-themes)

(package! transient-showcase
  :recipe (:host github :repo "positron-solutions/transient-showcase"))

(package! sudo-edit)

(package! alarm-clock)

(package! mpdel)

(package! wttrin)

(package! ox-typst
  :recipe (:host github :repo "jmpunkt/ox-typst"))

(package! janet-ts-mode
  :recipe (:host github :repo "sogaiu/janet-ts-mode"))

(package! yeetube)

(package! fretboard
  :recipe (:type git :host github :repo "skyefreeman/fretboard.el" :branch "main" :files ("*.el")))

(package! just-mode)

(package! justl)

(package! listen)

;; Quarto editing
(package! polymode)
(package! poly-markdown)
(package! quarto-mode
  :recipe (:type git :host github :repo "quarto-dev/quarto-emacs" :branch "main" :files ("*.el")))

;; Multicursor
(package! multiple-cursors)

(package! org-sliced-images)
;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;; (package! this-package
;;   :recipe (:host github :repo "username/repo"
;;            :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;; (package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;; (package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;; (unpin! pinned-package)
;; ...or multiple packages
;; (unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;; (unpin! t)
;; packages.el - package management (custom):1 ends here
