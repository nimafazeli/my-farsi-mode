;;; my-farsi-mode.el --- Minor mode for Farsi typing in Evil mode -*- lexical-binding: t; -*-

;; Author: Your Name <your.email@example.com>
;; Keywords: languages, convenience
;; Version: 0.8
;; Package-Requires: ((emacs "25.1") (evil "1.0") (olivetti "2.0") (evil-escape "1.0"))
;; URL: https://github.com/yourusername/my-farsi-mode

;;; Commentary:

;; This package provides a minor mode for convenient Farsi typing in Evil mode.
;; It includes Farsi input method, modified Evil keybindings for RTL text,
;; and Olivetti mode for better text viewing.

;;; Code:

(require 'evil)
(require 'olivetti)
(require 'evil-escape)

(defgroup my-farsi-mode nil
  "Customization group for my-farsi-mode."
  :group 'languages)

(defvar my-original-evil-escape-key-sequence evil-escape-key-sequence
  "Original value of `evil-escape-key-sequence` before `my-farsi-mode` is enabled.")

(defvar my-original-evil-escape-delay evil-escape-delay
  "Original value of `evil-escape-delay` before `my-farsi-mode` is enabled.")

(defun my/toggle-evil-rtl-bindings (enable)
  "Toggle key bindings for Evil mode in a right-to-left context."
  (if enable
      (progn
        (evil-local-set-key 'motion (kbd "h") 'evil-forward-char)
        (evil-local-set-key 'motion (kbd "l") 'evil-backward-char)
        (evil-local-set-key 'motion (kbd "$") 'evil-beginning-of-line)
        (evil-local-set-key 'motion (kbd "^") 'evil-end-of-line)
        (evil-local-set-key 'normal (kbd "a")
                            (lambda ()
                              (interactive)
                              (evil-backward-char)
                              (evil-append 1))))
    (progn
      (evil-local-set-key 'motion (kbd "h") 'evil-backward-char)
      (evil-local-set-key 'motion (kbd "l") 'evil-forward-char)
      (evil-local-set-key 'motion (kbd "$") 'evil-end-of-line)
      (evil-local-set-key 'motion (kbd "^") 'evil-beginning-of-line)
      (evil-local-set-key 'normal (kbd "a") 'evil-append))))

(defun my/toggle-evil-escape-key-sequence (enable)
  "Toggle `evil-escape-key-sequence` between the original and Farsi-specific sequence locally."
  (if enable
      (progn
        ;; Make evil-escape-key-sequence buffer-local
        (make-local-variable 'evil-escape-key-sequence)
        ;; Save the original sequence if not already saved
        (setq my-original-evil-escape-key-sequence evil-escape-key-sequence)
        ;; Set the Farsi sequence
        (setq evil-escape-key-sequence "فد"))
    ;; Restore the original sequence in the current buffer
    (setq evil-escape-key-sequence my-original-evil-escape-key-sequence)))

;;;###autoload
(define-minor-mode my-farsi-mode
  "Minor mode for Farsi-specific Evil key bindings and settings.

This mode provides:
- Farsi input method (farsi-transliterate-banan)
- Modified Evil keybindings for easier Farsi typing in RTL context
- Olivetti mode for better text viewing

Toggle with \\[my-farsi-mode].

Evil keybindings are modified for RTL text when the mode is active,
and restored to their default behavior when the mode is deactivated."
  :init-value nil
  :lighter " Farsi"
  :group 'my-farsi-mode
  (if my-farsi-mode
      (progn
        (set-input-method "farsi-transliterate-banan")
        (olivetti-mode 1)
        (evil-escape-mode 1)
        (my/toggle-evil-rtl-bindings t)
        (my/toggle-evil-escape-key-sequence t))
    (progn
      (set-input-method nil)
      (olivetti-mode -1)
      (my/toggle-evil-rtl-bindings nil)
      (my/toggle-evil-escape-key-sequence nil))))

(provide 'my-farsi-mode)

;;; my-farsi-mode.el ends here
