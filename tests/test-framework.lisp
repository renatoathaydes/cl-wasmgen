(in-package #:wasmgen/tests)

(defun make-stream () (make-instance 'wasmgen::vector-output-stream))

(defun char-codes (chars)
  (mapcar #'char-code chars))

;;;;;; test assertions ;;;;;;;

(defmacro stream-contains (expected &key after)
  "Introduces a stream variable to the scope the after form runs.
   Passes if, after the AFTER form is evaluated, the stream's vector EQUALPs EXPECTED."
  `(let ((stream (make-stream)))
     (progn
       ,after
       (with-slots ((actual vector)) stream
         (assert (equalp ,expected actual))))))
