(in-package :cl-roman)

(defun make-hash (&rest args)
  (let ((ht (make-hash-table)))
    (loop for (key . value) in (group args 2)
          do (setf (gethash key ht) (car value)))
    ht))

(defconstant roman-hash
  #.(make-hash #\M 1000
               #\D 500
               #\C 100
               #\L 50
               #\X 10
               #\V 5
               #\I 1))

(defconstant dec-hash
  #.(make-hash 1    "I"
               4    "IV"
               5    "V"
               9    "IX"
               10   "X"
               40   "XL"
               50   "L"
               90   "XC"
               100  "C"
               400  "CD"
               500  "D"
               900  "CM"
               1000 "M"))

(defun roman-symbol-p (sym)
  (if (symbolp sym)
      (let ((chars (coerce (symbol-name sym) 'list)))
        (null
         (remove-if
          (lambda (c) (gethash c roman-hash))
          chars)))))

(defun roman->number (sym)
  (nlet-tail self ((acc 0)
                       (nums (mapcar
                              (lambda (c) (gethash c roman-hash))
                              (coerce (symbol-name sym) 'list))))
    (cond
      ((null nums) acc)
      ((null (cdr nums)) (+ (car nums) acc))
      (t
       (if (>= #1=(car nums) #2=(cadr nums))
           (self (+ acc #1#) (cdr nums))
           (self (+ acc (- #2# #1#)) (cddr nums)))))))

(defun number->roman (n)
  (if (zerop n)
      (error "ZERO cannot be represented by a roman numeral"))
  (labels ((max-numeral (x)
             (let ((mk (loop for k being the hash-keys in dec-hash
                             when (<= k x)
                             maximize k)))
               (when mk
                 (values mk (gethash mk dec-hash))))))
    (let (numerals)
      (nlet-tail self ((n n))
        (if (not (zerop n))
            (multiple-value-bind (x v)
                (max-numeral n)
              (push v numerals)
              (self (- n x)))))
      (intern
       (apply #'concatenate 'string
              (reverse numerals))))))

(defun roman-printer (stream object)
  (format stream "~A" (number->roman object)))

(defmacro with-roman (&rest forms)
  `(let ((*print-pretty* t)
         (*print-pprint-dispatch* (copy-pprint-dispatch))
         ,@(mapcar
             (lambda (roman) `(,roman ,(roman->number roman)))
             (remove-duplicates
              (remove-if-not
               #'roman-symbol-p
               (flatten forms)))))
     (set-pprint-dispatch 'integer #'roman-printer)
     ,@forms))
