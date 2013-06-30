;;; wacs-util.el

;; Copyright © 2013 Emanuel Evans

;; Author: Emanuel Evans <emanuel.evans@gmail.com>

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Utility functions and macros for wacspace.el.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'dash)
(require 'cl-lib)

(defun wacs--eval-aux-cond (aux-cond)
  "Evaluate AUX-COND.

If passed a symbol, evaluate the symbol as a variable.  If passed
an inline lambda, funcall the lambda.  If passed a (:var VAR)
pair, evaluate VAR as a variable.  If passed a (:fn FN) pair,
funcall FN."
  (if (consp aux-cond)
      (let ((cond-val (cadr aux-cond)))
        (cl-case (car aux-cond)
          (:fn (funcall cond-val))
          (:var (when (boundp cond-val)
                  (symbol-value cond-val)))
          (t (funcall aux-cond))))
    (when (boundp aux-cond)
      (symbol-value aux-cond))))

(defun wacs--switch-to-window-with-buffer (buffer)
  "Switch to the window with BUFFER."
  (-each-while (window-list)
               (lambda (_) (not (equal (window-buffer) buffer)))
               (lambda (_) (other-window 1))))

(defun wacs--list->dotted-pair (list)
  "Change the current LIST pair and sub-list pair into dotted pairs."
  (let ((snd (cadr list)))
    (if (and (listp snd) (= (length snd) 2))
        (cons (car list) (wacs--list->dotted-pair snd))
      (cons (car list) (cadr list)))))

(defmacro wacs--alist-delete (key alist)
  "Delete KEY from alist ALIST."
  `(setq ,alist
         (cl-remove-if (lambda (entry)
                         (equal (car entry) ,key))
                       ,alist)))

(defmacro wacs--alist-put (key val alist)
  "Push (KEY . VAL) into alist ALIST.

If KEY already exists as a key in ALIST, delete the entry."
  `(progn (wacs--alist-delete ,key ,alist)
          (push (cons ,key ,val) ,alist)))

(defun wacs--alist-get (key alist)
  "Get element associated with KEY from ALIST."
  (cdr (assoc key alist)))

(defun wacs--u-prefix? (arg)
  "Test whether ARG is universal prefix argument."
  (equal arg '(4)))

(provide 'wacs-util)

;;; wacs-util.el ends here
