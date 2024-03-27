#!/usr/bin/env -S emacs -Q --script

;; This script exports a given org-file to an HTML file with the same name.
;;
;; Usage: ./org-compile.el org-file
;;
;; Requirements: Emacs 27 or newer
;;
;; Reference:
;; - See other .org files in this directory for examples
;; - Visit http://xahlee.info/emacs/emacs/emacs_org_markup.html
;;   or https://nhigham.com/2017/11/02/org-mode-syntax-cheat-sheet/
;; - Read the docs://orgmode.org/worg/dev/org-syntax.html
;;
;; Org is good!

(setq make-backup-files nil) ;; keep emacs from creating backup files like: foo.txt~
(setq user-full-name "Headless Org") ;; so we get an author tag

(let* ((file-name   (elt argv 0))
       (file-exists (ignore-errors (file-exists-p file-name))))
  (cond (file-exists ;; we were given a valid file
         (condition-case cond
             (progn (message "Loading org-mode...")
                    (require 'ox-html)
                    (find-file file-name)
                    (message "Compiling %s..." file-name)
                    (org-html-export-to-html)
                    (message "Compiled %s" (buffer-file-name))
                    (kill-emacs))
           (error (cond) (message "Uh-oh! Something went wrong: %s" cond))))
        ;; if there was an argument, it doesn't refer to any real file...
        (file-name   (message "%s: no such file" file-name)
                     (kill-emacs))
        ;; if there was none, we help
        (t           (message "Usage: ./org-compile.el org-file"))))
