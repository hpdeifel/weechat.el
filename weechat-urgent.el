;;; weechat-urgent --- Set urgency hint on weechat events -*- lexical-binding: t -*-

;; Copyright (C) 2015 Hans-Peter Deifel

;; Author: Hans-Peter Deifel <hpd@hpdeifel.de>
;; Created: 20 Jun 2015

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;; Set the X11 window's urgency hint on weechat notifications

;;; In many window managers, this has the effect of highlighting the virtual
;;; desktop that Emacs is on, or making the window blink in the window list.

;;; Code:

(require 'weechat)

(defun weechat-urgent-handler (_type &optional _sender _text _date _buffer-ptr)
  "Notification handler setting the X11 window's urgent hint."
  (when (eq window-system 'x)
    (let* ((frame default-minibuffer-frame)
           ;; See http://tronche.com/gui/x/icccm/sec-4.html
           ;; under the section 4.1.2.4 WM_HINTS Property
           (wm-hints (x-window-property
                      "WM_HINTS" frame "WM_HINTS"
                      nil nil t))
           (flags (aref wm-hints 0)))
      (when wm-hints
        (aset wm-hints 0 (logior flags 256))
        (x-change-window-property "WM_HINTS" (append wm-hints nil) frame
                                  "WM_HINTS" 32 t)))))


(add-hook 'weechat-notification-handler-functions
          #'weechat-urgent-handler)

(provide 'weechat-urgent)

;;; weechat-urgent.el ends here
