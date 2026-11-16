(in-package #:wasmgen)

(defmacro wasm-to-file (file (stream) &body body)
  "A macro that helps writing a WASM file."
  `(with-open-file (,stream ,file
                            :direction :output
                            :element-type '(unsigned-byte 8)
                            :if-exists :supersede)
     ,@body))
