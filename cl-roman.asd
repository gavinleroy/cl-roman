(defsystem "cl-roman"
  :version "0.1.0"
  :author "Gavin Gray"
  :license "MIT"
  :depends-on (#:let-over-lambda)
  :components ((:file "package")
               (:file "cl-roman"))
  :description "Write Roman Numeral literals in CL."
  :in-order-to ((test-op (test-op "cl-roman/tests"))))
