;; .emacs
;;
;; last-modified: <2013-12-17 12:09:48 golden@asterix>
;;=====================================================================================================================

(toggle-scroll-bar -1)
(tool-bar-mode     -1)
(menu-bar-mode     -1)

;;{{{ toggle-fullscreen      .......................................................................................

;; (defun toggle-fullscreen ()
;;   (interactive)
;;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
;;   (x-send-client-message nil 0 nil "_NET_WM_STATE" 32 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))

;; (toggle-fullscreen)

;;}}}
;;{{{ custom                 .......................................................................................

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . ".~"))))
 '(column-number-mode t)
 '(develock-max-column-plist (quote (emacs-lisp-mode t lisp-interaction-mode t change-log-mode t texinfo-mode t c-mode t c++-mode t java-mode t jde-mode t html-mode t cperl-mode t perl-mode t mail-mode t message-mode t cmail-mail-mode t tcl-mode t ruby-mode t)))
 '(dired-listing-switches "-al")
 '(display-time-mode t)
 '(fill-column 120)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(indent-tabs-mode nil)
 '(indicate-buffer-boundaries (quote left))
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(org-directory "~/Lab/journal")
 '(org-modules (quote (org-bbdb org-bibtex org-checklist org-docview org-git-link org-gnus org-habit org-info org-irc org-jsinfo org-mew org-mhe org-rmail org-vm org-w3m org-wl)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(tool-bar-mode nil)
 '(truncate-lines t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 68 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;;}}}
;;{{{ start server           .......................................................................................

(server-start)


;;}}}
;;{{{ org mode               .......................................................................................

;;[[file:~/notes.org][notes file]]

(require 'org)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key "\C-cL" 'org-insert-link-global)
(global-set-key "\C-co" 'org-open-at-point-global)

(setq org-log-done 'time)
(setq org-log-done 'note)

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

(setq org-default-notes-file (concat org-directory "/default.org"))
(define-key global-map "\C-cc" 'org-capture)

;;}}}
;;{{{ folding mode           .......................................................................................

(load "folding" 'nomessage 'noerror)
(folding-add-to-marks-list 'css-mode "/* {{{ " "/* }}} */" " */")
(folding-add-to-marks-list 'html-mode  "<!-- {{{ "  "<!-- }}} -->"  " -->"  t )

(folding-mode-add-find-file-hook)

;;}}}
;;{{{ time-stamp mode        ..........................................................................................

(load "time-stamp" 'nomessage 'noerror)
(add-hook 'before-save-hook 'time-stamp)

(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %u@%h"   )
(setq time-stamp-start  "[lL]ast-[mM]odified:[ 	]+\\\\?[\"<]+" )

;;}}}
;;{{{ cc-mode                .......................................................................................

;; create golden style
(defconst golden-c-style
  '((c-tab-always-indent        . t)
    (c-comment-only-line-offset . 4)
    (c-hanging-braces-alist     . ((substatement-open after)
                                   (brace-list-open)))
    (c-hanging-colons-alist     . ((member-init-intro before)
                                   (inher-intro)
                                   (case-label after)
                                   (label after)
                                   (access-label after)))
    (c-cleanup-list             . (scope-operator
                                   empty-defun-braces
                                   defun-close-semi))
    (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
                                   (substatement-open . 0)
                                   (substatement-open . 0)
                                   (inline-open       . 0)
                                   (comment-intro     . 0)
                                   (block-open        . 0)
                                   (knr-argdecl-intro . -)))
    (c-echo-syntactic-information-p . t))
  "Rick Golden's cc-mode style")
(c-add-style "golden" golden-c-style)

;; Customizations for all modes in CC Mode.
(defun golden-c-mode-common-hook ()
  ;; set my personal style for the current buffer
  (c-set-style "golden")

  ;; other customizations
  (setq tab-width 4

        ;; this will make sure spaces are used instead of tabs
        indent-tabs-mode nil)

  ;; use auto-newline, but not hungry-delete
  (c-toggle-auto-newline 1))

(add-hook 'c-mode-common-hook 'golden-c-mode-common-hook)

;;}}}
;;{{{ javascript (mozrepl)   .......................................................................................

;; mozrepl - https://github.com/bard/mozrepl/wiki

(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(defun javascript-custom-setup ()
  (moz-minor-mode 1))

(add-hook 'javascript-mode-hook 'javascript-custom-setup)

;;}}}

;; rg-commands ........................................................................................................

;;{{{ rg-set-registers       .......................................................................................

(fset 'rg-set-registers

      (lambda ()

        "Set registers a, e, l and p for current line." 

        (interactive)

        (point-to-register ?p)                                         ;; p = point

        (move-beginning-of-line nil)
        (point-to-register ?a)                                         ;; a = beginning of line

        (folding-end-of-line nil)
        (point-to-register ?e)                                         ;; e = end of line

        (jump-to-register  ?p)                                         ;; return to starting point (p)

        (set-register ?l (- (get-register ?e) (get-register ?a)) )     ;; l = length of line

        ))

;;}}}
;;{{{ rg-expand-char-to-fill .......................................................................................

(fset 'rg-expand-char-to-fill

      (lambda ()

        "Expand the character under the cursor to fill the line."

        (interactive)

        (rg-set-registers)                                             ;; set registers for current line

        (let* ((line-length   (get-register ?l)           )            ;; line length from register 'l'
               (missing-count (- fill-column line-length) )            ;; characters need to fill line
               (missing-count (- missing-count
                                 (if (not folding-mode) 0 3)) ))       ;; if necessary, leave room for folds

          (dotimes (i  missing-count)                                  ;; fill line with character under point
            (insert (char-before) ))

          (jump-to-register  ?p)                                       ;; return to starting point (p)

          )))

;;}}}
;;{{{ rg-move-up-folds       .......................................................................................

(fset 'rg-move-up-folds

      (lambda ()

        "Close the current fold. Open the previous fold." 

        (interactive)

        (and (folding-mark-look-at) (folding-hide-current-entry))
        (search-backward "{{{")
        (folding-show-current-entry)
        (recenter 13)
        ))

;;}}}
;;{{{ rg-move-down-folds     .......................................................................................

(fset 'rg-move-down-folds

      (lambda ()

        "Close the current fold. Open the next fold." 

        (interactive)

        (folding-hide-current-entry)
        (forward-line 1)
        (search-forward "{{{")
        (folding-show-current-entry)
        (recenter 13)
        ))

;;}}}
;;{{{ rg-switch-buffer-left  .......................................................................................

(fset 'rg-switch-buffer-left

      (lambda ()

        "Switch to the buffer on the left in a two column view." 

        (interactive)

        (other-window -1)
        ))

;;}}}
;;{{{ rg-switch-buffer-right .......................................................................................

(fset 'rg-switch-buffer-right

      (lambda ()

        "Switch to the buffer on the right in a two column view." 

        (interactive)

        (other-window 1)
        ))

;;}}}

;;{{{ rg-define-keys         .......................................................................................

(fset 'rg-define-keys

      (lambda ()

        "Define user key map." 

        (interactive)

        ;; user keys ('C-x #' key map)
        (setq rg-map (make-sparse-keymap))                                 ;; create a key map

        ;; global keys (key maps)
        (global-set-key (kbd "C-x #"     ) rg-map            )             ;; define key map 'C-x #'

        ;; global keys (keypad keys)
        (global-set-key (kbd "<kp-begin>" ) 'folding-toggle-show-hide )    ;; <kp-down> : move down a fold
        (global-set-key (kbd "<kp-up>"    ) 'rg-move-up-folds         )    ;; <kp-up>   : move up a fold
        (global-set-key (kbd "<kp-down>"  ) 'rg-move-down-folds       )    ;; <kp-down> : move down a fold

        (global-set-key (kbd "<C-left>"   ) 'rg-switch-buffer-left    )    ;; <C-left>  : switch buffer left
        (global-set-key (kbd "<C-right>"  ) 'rg-switch-buffer-right   )    ;; <C-right> : switch buffer right

        ;; rg-map keys
        (define-key rg-map "0" 'rg-set-registers)                          ;; 0 - set registers
        (define-key rg-map "_" 'rg-expand-char-to-fill)                    ;; _ - expand to fill

        ;; folding-mode-prefix-map keys
        (define-key folding-mode-prefix-map (kbd "<up>"  ) 'rg-move-up-folds   )  ;; C-x @ <up>   : move up a fold
        (define-key folding-mode-prefix-map (kbd "<down>") 'rg-move-down-folds )  ;; C-x @ <down> : move down a fold

        ))

(rg-define-keys)

;;}}}

;;=====================================================================================================================

(defalias 'list-buffers 'ibuffer)

(setq display-time-24hr-format t)
(display-time-mode t)

(setq frame-title-format '(:eval (concat "emacs: " (buffer-name))))

;; Local Variables:
;; mode: emacs-lisp
;; mode: folding
;; End:
