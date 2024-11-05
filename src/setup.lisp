(in-package choons)

(defparameter *sc-port* 48800)

(defun sc-setup (&key (port *sc-port*) just-connect-p)
  (setf *s* (make-external-server "localhost"
                                  :port port
                                  :just-connect-p just-connect-p))
  (server-boot *s*)
  (jack-connect))

(defun sc-quit ()
  (server-quit *s*))
