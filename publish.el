;;; publish.el --- To publish my org site -*- lexical-binding: t; -*-

;; Author: Kanishak Vaidya <kanishak@gmail>
;; Maintainer: Kanishak Vaidya <kanishak@gmail>
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;; Code:

;; (org-export-define-derived-backend 'my-custom-backend 'html
;;   :options-alist
;;   '((:keywords "keywords" nil nil split)
;;     (:filetags "filetags" nil nil split)))

(defun kpv/sitemap (file style project)
  (concat (format-time-string "%Y-%m-%d" (org-publish-find-date file project)) " ; [[./" file "][" (org-publish-find-title file project) "]] ; " (mapconcat 'identity (org-publish-find-property file :filetags project) ":")))

(defun kvp/sitefunc (title input-list)
  "Parse INPUT-LIST and generate an Org file content."
  (let ((date-link-tags (mapcar (lambda (item)
                                  (let ((parts (split-string (car item) " ; ")))
                                    (list (nth 0 parts) (nth 1 parts) (nth 2 parts))))
                                (cdr input-list)))
        (tag-links (make-hash-table :test 'equal))
        org-output)

    ;; First part of the Org file: date - link - tags
    (setq org-output
          (concat
           (mapconcat (lambda (item)
                        (let ((date (nth 0 item))
                              (link (nth 1 item))
                              (tags (or (nth 2 item) "")))
                          (concat " - " date " - " link)))
                          ;; (concat " - " date " - " link " - " tags)))
                      date-link-tags "\n")
           "\n\n"))

    ;; Populate the hash table with tags and their corresponding links
    (dolist (item date-link-tags)
      (let ((link (nth 1 item))
            (tags (split-string (or (nth 2 item) "") ":")))
        (dolist (tag tags)
          (when (not (string= tag ""))
            (puthash tag
                     (append (gethash tag tag-links) (list link))
                     tag-links)))))

    ;; Second part of the Org file: tags and their corresponding links
    (setq org-output
	  (concat org-output
		  "** Blogs by categories\n\n"))

    (let ((sorted-tags (sort (hash-table-keys tag-links) 'string<)))
      ;; Second part of the Org file: tags and their corresponding links
      (dolist (tag sorted-tags)
        (setq org-output
              (concat org-output
		      "*** " tag "\n"
                      (mapconcat (lambda (link) (concat "- " link))
                                 (gethash tag tag-links) "\n")
                      "\n"))))

    ;; Return the final Org file content
    org-output))

(require 'org)

(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-export-with-timestamps nil
      org-export-time-stamp-file nil
      org-html-head "<link rel=\"stylesheet\" href=\"/style.css\" />"
      org-html-preamble t
      org-html-preamble-format '(("en" 
				  "<ul class=\"sidebar\" id=\"mySideNav\">
  <a id=\"menu\" href=\"javascript:void(0);\" class=\"icon\" onclick=\"myFunction()\"><b>MENU</b></a>
  <a id=\"home\" href=\"/index.html\">Home</a>
  <a id=\"research\" href=\"/research-topics/index.html\">Research</a>
  <a id=\"publications\" href=\"/publications.html\">Publications</a>
  <a id=\"blogs\" href=\"/blogs/index.html\">Blogs</a>
  <a id=\"projects\" href=\"/projects/index.html\">Projects</a>
  <a id=\"bio\" href=\"/bio.html\">Bio</a>
  </ul>
<script>
function myFunction() {
  var x = document.getElementById(\"mySideNav\");
  if (x.className === \"sidebar\") {
    x.className += \" responsive\";
  } else {
    x.className = \"sidebar\";
  }
}
</script> "))
      org-html-postamble-format '(("en" "<p class=\"author\">Author: %a</p>
<p class=\"date\">Date: %d</p>
<p class=\"creator\">%c</p>")))
;; (f-read-text "~/doc/repos/kanishakvaidya.github.io/org/static/sidenav.html"))))


(setq org-publish-project-alist
   '(
     ("kanishakvaidya.github.io"
      :exclude "blogs/.*"
      :base-directory "~/doc/repos/kanishakvaidya.github.io/org"
      :base-extension "org"
      :publishing-directory "~/doc/repos/kanishakvaidya.github.io/docs"
      :recursive t
      :auto-sitemap t
      :with-author nil
      :html-validation-link nil
      :publishing-function org-html-publish-to-html)
     ("blogs"
      :base-directory "~/doc/repos/kanishakvaidya.github.io/org/blogs"
      :base-extension "org"
      :publishing-directory "~/doc/repos/kanishakvaidya.github.io/docs/blogs"
      :recursive t
      :auto-sitemap t
      :sitemap-sort-files anti-chronologically
      :sitemap-style list
      :sitemap-function kvp/sitefunc
      :sitemap-format-entry kpv/sitemap
      :html-validation-link nil
      :publishing-function org-html-publish-to-html)
     ("kanishakvaidya.github.io-static"
      :exclude "docs/.*"
      :base-directory "~/doc/repos/kanishakvaidya.github.io/org"
      :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|svg\\|ttf"
      :publishing-directory "~/doc/repos/kanishakvaidya.github.io/docs/"
      :recursive t
      :publishing-function org-publish-attachment)
     ("portfolio" :components ("kanishakvaidya.github.io" "blogs" "kanishakvaidya.github.io-static"))))

(org-publish-project "portfolio")

;; (provide 'publish)
;;; publish.el ends here

