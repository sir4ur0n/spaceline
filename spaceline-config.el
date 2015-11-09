;;; spaceline-config.el --- Spaceline themes

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file contains ready-to-use modeline themes for powerline.

;;; Code:

(require 'spaceline-segments)

(defun spaceline-spacemacs-theme (&rest additional-segments)
  "Install the modeline used by Spacemacs.

ADDITIONAL-SEGMENTS are inserted on the right, between `global' and
`buffer-position'."
  (spaceline-install

   '(((persp-name
       workspace-number
       window-number)
      :fallback evil-state
      :separator "|"
      :face highlight-face)
     anzu
     auto-compile
     (buffer-modified buffer-size buffer-id remote-host)
     major-mode
     ((flycheck-error flycheck-warning flycheck-info)
      :when active)
     (((minor-modes :separator spaceline-minor-modes-separator)
       process)
      :when active)
     (erc-track :when active)
     (version-control :when active)
     (org-pomodoro :when active)
     (org-clock :when active)
     nyan-cat)

   `((battery :when active)
     selection-info
     ((buffer-encoding-abbrev
       point-position
       line-column)
      :separator " | ")
     (global :when active)
     ,@additional-segments
     buffer-position
     hud)))

(defun spaceline-emacs-theme (&rest additional-segments)
  "Install a modeline close to the one used by Spacemacs, but which
looks better without third-party dependencies.

ADDITIONAL-SEGMENTS are inserted on the right, between `global' and
`buffer-position'."
  (spaceline-install

   '((((((persp-name :fallback workspace-number)
         window-number) :separator "|")
       buffer-modified
       buffer-size)
      :face highlight-face)
     anzu
     (buffer-id remote-host)
     major-mode
     ((flycheck-error flycheck-warning flycheck-info)
      :when active)
     (((minor-modes :separator spaceline-minor-modes-separator)
       process)
      :when active)
     (erc-track :when active)
     (version-control :when active)
     (org-pomodoro :when active)
     (org-clock :when active)
     nyan-cat)

   `((battery :when active)
     selection-info
     ((buffer-encoding-abbrev
       point-position
       line-column)
      :separator " | ")
     (global :when active)
     ,@additional-segments
     buffer-position
     hud)))

;; Helm custom mode
;; ================

(defun spaceline-helm (source &optional force)
  "Set up a custom helm modeline."
  (setq spaceline--helm-current-source source
        mode-line-format '("%e" (:eval (spaceline--prepare
                                        '(helm-buffer-id
                                          helm-number
                                          helm-follow
                                          helm-prefix-argument)
                                        '(helm-help)))))
  (when force (force-mode-line-update)))

(define-minor-mode spaceline-helm-mode
  "Customize the mode-line in helm."
  :init-value nil
  :global t
  (if spaceline-helm-mode
      (advice-add 'helm-display-mode-line :after 'spaceline-helm)
    (advice-remove 'helm-display-mode-line 'spaceline-helm)))

;; Info custom mode
;; ================

(defun spaceline-info ()
  "Set up a custom info modeline."
  (if (featurep 'info+)
      (let* ((nodes (s-split " > " mode-line-format))
             (topic (prog2
                        (string-match "(\\(.+\\))\\(.+\\)" (car nodes))
                        (propertize (concat "INFO "
                                            (match-string 1 (car nodes)))
                                    'face 'bold)
                      (setcar nodes (match-string 2 (car nodes))))))
        (setq-local mode-line-format
                    `("%e" (:eval (spaceline--prepare
                                   '((,topic :face highlight-face)
                                     ,@nodes)
                                   nil)))))
    (message "info+ is not available: spaceline-info-mode disabled")
    (spaceline-info-mode -1)))

(define-minor-mode spaceline-info-mode
  "Customize the mode-line in info.
This minor mode requires info+."
  :init-value nil
  :global t
  (if spaceline-info-mode
      (advice-add 'Info-set-mode-line :after 'spaceline-info)
    (advice-remove 'Info-set-mode-line 'spaceline-info)))

(provide 'spaceline-config)

;;; spaceline-config.el ends here
