(defpackage :choons-asd
  (:use :cl :asdf))

(in-package :choons-asd)

(defsystem choons
  :license "MIT"
  :author "Kevin Galligan"
  :description "Electronic music."
  :depends-on (:cl-collider :ltk :arrows)
  :pathname "src"
  :serial t
  :components ((:file "package")
               (:file "setup")
               (:file "widgets")
               ))
