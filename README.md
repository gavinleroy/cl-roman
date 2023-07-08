# cl-roman

Write Roman Numeral literals in Common Lisp using the `with-roman` macro. This will introduce a binding for all literals used within the body forms.

Example usage at the REPL:

```common-lisp
CL-USER> (ql:quickload "cl-roman")

CL-USER> (cl-roman:with-roman (print (- (+ M M) III)))

MCMXCVII
1997 (11 bits, #x7CD)

CL-USER> (cl-roman:with-roman (eq (* X X) C))
T
```
