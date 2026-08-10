(in-package #:wasmgen/tests)

(defun run-tests ()
  (when (null +tests+) (error "No tests added"))
  (format T "== WASMGEN TESTS ==~%Running ~A test(s).~%" (length +tests+))
  (let ((ok-count 0)
        (fail-count 0)
        (error-count 0))
    (dolist (test +tests+)
      (let ((result
              (handler-case (eval-test test)
                (error (e) (list :error e)))))
        (case (car result)
          (:ok
           (incf ok-count)
           (format T "OK: ~A~%" (test-name test)))
          (:error
           (incf error-count)
           (format T "ERROR: ~A ~A~%" (test-name test) (cdr result)))
          (T
           (incf fail-count)
           (format T "~A: ~A ~A~%" (car result) (test-name test) (cdr result))))))
    (format T "Success: ~A, Failures: ~A, Errors: ~A~%" ok-count fail-count error-count)))
