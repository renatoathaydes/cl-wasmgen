(in-package #:wasmgen)

(defun byte? (b)
  (typep b '(unsigned-byte 8)))

(defun list-of-bytes? (list)
  (and (listp list)
       (every (lambda (n) (byte? n)) list)))

(deftype bytes ()
  `(satisfies list-of-bytes?))

(deftype import-kind ()
  `(and
    (unsigned-byte 8)
    (member ,+kind/function+ ,+kind/table+ ,+kind/memory+ ,+kind/global+)))
