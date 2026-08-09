; 0000000: 0061 736d              ; WASM_BINARY_MAGIC
; 0000004: 0100 0000              ; WASM_BINARY_VERSION

(in-package #:wasmgen)

(defun main ()
  (with-open-file (stream "first.wasm"
                          :direction :output
                          :element-type '(unsigned-byte 8)
                          :if-exists :supersede)

    ;; write the magic number + WASM binary version
    (write-sequence
     (list #x00 #x61 #x73 #x6d
           #x01 #x00 #x00 #x00)
     stream)

    ;; a custom section called hello
    (write-section +section-id/custom+ "hello" stream (ss)
      (write-byte #x42 ss)
      (write-byte #x51 ss))

    ;; function section
    (write-section +section-id/type+ nil stream (ss)
      (write-u32 1 ss) ; number of types
      (write-byte +type/func+ ss) ; a function type
      (write-u32 2 ss) ; 2 args
      (write-byte +type/i32+ ss)
      (write-byte +type/i32+ ss)
      (write-u32 1 ss) ; 1 result
      (write-byte +type/i64+ ss))
      
    
    ))
