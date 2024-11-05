(in-package choons)

(sc-setup)

(play (sin-osc.ar 320 0 .2))

(play (sin-osc.kr 220)) ; no sound
(play (sin-osc.ar (+ 220 (sin-osc.kr 1 0 20))))

(play (lf-noise0 ))

;; Attempt to plot in CL, based on:
;;   https://github.com/byulparan/cl-collider/issues/81
(defun plot (syn &key (seconds 1) (bin-width 64))
  (let* ((sr (cl-collider::sample-rate *s*))
         (buff (buffer-alloc (* seconds sr))))
    (unwind-protect
         (buffer-free buff)
      (proxy :plot
             (* 0 (buf-wr.ar syn
                             buff
                             (line.ar 0
                                      (buf-frames.kr buff)
                                      seconds
                                      :act :free))))
      (let ((xs
              (loop for x in (buffer-get-to-list buff)
                    for i from 0
                    when (zerop (mod i bin-width))
                      collect x)))
        (format t "Got: ~a~%" xs)
        (vgplot:axis (list 0 (/ sr bin-width)
                           (apply #'min xs) (apply #'max xs)))
        (vgplot:plot xs)))))

;; Also tried:
;; Run in IDE.
#|
(
o = ServerOptions.new;
o.maxLogins = 2;

t = Server(\Local, NetAddr("127.0.0.1", 48800), o);
t.makeWindow;
t.boot;
)
|#

(defsynth pulse ((freq 300) (width .5))
  (out.ar 0 (lf-pulse.ar freq 0 width)))

(defvar *x*)
(setf *x* (synth 'pulse))

(widgets:slider "freq" 300 200 400 (lambda (v) (ctrl *x* :freq v)))
(widgets:slider "width" .5 .01 2. (lambda (v) (ctrl *x* :width v)))
(widgets:init-panel)
