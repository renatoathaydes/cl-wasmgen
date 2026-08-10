(in-package #:wasmgen/tests)

(defun make-stream () (make-instance 'wasmgen::vector-output-stream))

(defparameter +tests+ nil)

(defclass test-instance ()
  ((name :accessor test-name :initarg :name)
   (body :accessor test-body :initarg :body)))

(defmethod eval-test ((test test-instance))
  "Evaluate this test.
   Return a LIST containing :OK to pass, or something else to fail.
   The CAR of the returned LIST is expected to be the test status."
  (let ((result (eval (test-body test))))
    (if (not result)
        (list :ok)
        (list :failed (format nil "~A ~A" result (cdr (test-body test)))))))

(defmacro add-test (name &body body)
  "Add a test to the framework.
   The body should return NIL to pass. Use an assertion macro to set up proper error messages."
  `(push (make-instance 'test-instance :name ,name :body '(progn ,@body)) +tests+))


;;;;;; test assertions ;;;;;;;

(defmacro stream-contains (expected &key after)
  "Introduces a stream variable to the scope the after form runs.
   Passes if, after the AFTER form is evaluated, the stream's vector EQUALPs EXPECTED."
  `(let ((stream (make-stream)))
     (progn
       ,after
       (with-slots ((actual vector)) stream
         (unless (equalp ,expected actual)
           (format nil "actual not equal: ~A" actual))))))
