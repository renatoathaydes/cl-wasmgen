; 0000000: 0061 736d              ; WASM_BINARY_MAGIC
; 0000004: 0100 0000              ; WASM_BINARY_VERSION

(in-package #:wasmgen)

(defun main ()
  (with-open-file (stream "first.wasm"
                          :direction :output
                          :element-type '(unsigned-byte 8)
                          :if-exists :supersede)

    ;; write the magic number + WASM binary version
    (write-wasm-header stream)

    ;; a custom section called hello
    (write-section +section-id/custom+ "hello" stream (ss)
      (write-byte #x42 ss)
      (write-byte #x51 ss))

    ;; function types section
    (write-section +section-id/type+ nil stream (ss)
      (write-u32 1 ss) ; number of types
      (write-function-type
       (list +type/i32+ +type/i32+) ;; params
       (list +type/i64+) ;; results
       ss))))
