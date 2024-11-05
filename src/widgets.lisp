(defpackage :widgets
  (:use :cl)
  (:export
   :slider
   :button
   :init-panel
   :clear-widgets))

(in-package widgets)

(defgeneric init-widget (w))

(defclass button ()
  ((label :initarg :label :reader label)
   (action :initarg :action :reader action)))

(defmethod init-widget ((w button))
  (ltk:pack (make-instance 'ltk:button
                           :master nil
                           :text (label w)
                           :command (action w))))

(defclass slider ()
  ((label :initarg :label :reader label)
   (action :initarg :action :reader action)
   (low :initarg :low :reader low)
   (high :initarg :high :reader high)
   (resolution :initarg :resolution :reader resolution)
   (initial-value :initarg :initial-value :reader initial-value)))

(defmethod init-widget ((w slider))
  (let* ((f (make-instance 'ltk:frame))
            (val-label (make-instance 'ltk:label :master f :text "0"))
            (scale (make-instance
                    'ltk:scale
                    :master f
                    :from (low w)
                    :to (high w)
                    :command (lambda (v)
                               (let ((v-rounded-as-str
                                       (format nil "~v$" (resolution w) v)))
                                 (setf (ltk:text val-label) v-rounded-as-str)
                                 (funcall (action w)
                                          ;; Ugly way of doing rounding.
                                          (read-from-string v-rounded-as-str nil nil)))))))
       (setf (ltk:value scale) (initial-value w))
       (setf (ltk:text val-label) (initial-value w))
       (ltk:pack f)
       (ltk:pack (make-instance 'ltk:label
                                :master f
                                :text (label w))
                 :side :left)
       (ltk:pack scale :side :left)
       (ltk:pack val-label :side :left)))

(defvar *widgets* nil)

(defun init-panel ()
  (ltk:with-ltk ()
    (map nil #'init-widget *widgets*)))

(defun add-widget (w)
  (setf *widgets* (nreverse *widgets*))
  (push w *widgets*)
  (setf *widgets* (nreverse *widgets*)))

(defun clear-widgets ()
  (setf *widgets* nil))

(defun button (label action)
  (add-widget (make-instance 'button :label label :action action)))

(defun slider (label initial-value low high action &key (resolution 2))
  (add-widget
   (make-instance 'slider
                  :label label
                  :initial-value initial-value
                  :low low
                  :high high
                  :resolution resolution
                  :action action)))
