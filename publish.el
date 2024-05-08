;;; publish.el --- To publish my org site -*- lexical-binding: t; -*-

;; Author: Kanishak Vaidya <kanishak@gmail>
;; Maintainer: Kanishak Vaidya <kanishak@gmail>
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Final goal is to make a 'tags' file that list
;;  all filetags and the posts containing those
;;  filetags
;;
;;; Code:

(defun kpv/sitemap (file style project)
  (concat (format-time-string "%Y-%m-%d" (org-publish-find-date file project)) " - [[./" file "][" (org-publish-find-title file project) "]]"  (mapconcat 'identity (org-publish-find-property file :CATEGORY project) ",")))

(require 'org)

(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-export-with-timestamps nil
      org-export-time-stamp-file nil
      org-html-head "<link rel=\"stylesheet\" href=\"/style.css\" />")

(setq org-publish-project-alist
   '(
     ("phd-progress"
      :exclude "blogs/.*"
      :base-directory "~/doc/repos/phd-progress/org"
      :base-extension "org"
      :publishing-directory "~/doc/repos/phd-progress/html"
      :time-stamp-file "~/doc/repo/phd-progress/.timestamps/phd-progress.cache"
      :recursive t
      :with-author nil
      :html-validation-link nil
      :publishing-function org-html-publish-to-html)
     ("blogs"
      :base-directory "~/doc/repos/phd-progress/org/blogs"
      :base-extension "org"
      :publishing-directory "~/doc/repos/phd-progress/html/blogs"
      :recursive t
      :time-stamp-file "~/doc/repo/phd-progress/.timestamps/blogs.cache"
      :auto-sitemap t
      :sitemap-style list
      :sitemap-format-entry kpv/sitemap
      ;; :sitemap-function kvd/org-publish-custom-sitemap
      :html-validation-link nil
      :publishing-function org-html-publish-to-html)
     ("phd-progress-static"
      :exclude "docs/.*"
      :base-directory "~/doc/repos/phd-progress/org"
      :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|svg\\|ttf"
      :publishing-directory "~/doc/repos/phd-progress/html/"
      :time-stamp-file "~/doc/repo/phd-progress/.timestamps/static.cache"
      :recursive t
      :publishing-function org-publish-attachment)
     ("phd" :components ("phd-progress" "blogs" "phd-progress-static"))))

(org-publish-project "phd")

;; (provide 'publish)
;;; publish.el ends here

