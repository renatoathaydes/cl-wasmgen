(defpackage #:wasmgen/main
  (:use #:cl #:wasmgen)
  (:local-nicknames
   (#:writers #:wasmgen/writers))
  (:export #:main))

(in-package #:wasmgen/main)

(defun main ()
  (wasm-to-file "first.wasm" (stream)
    ;; write the magic number + WASM binary version
    (writers:write-wasm-header stream)

    ;; a custom section called hello
    (writers:write-section +section-id/custom+ "hello" stream (ss)
      (write-byte #x42 ss)
      (write-byte #x51 ss))

    ;; function types section
    (writers:write-section +section-id/type+ nil stream (ss)
      (writers:write-u32 1 ss) ; number of types
      (writers:write-function-type
       (list +type/i32+ +type/i32+ +type/i32+ +type/i32+) ;; params
       (list +type/i32+) ;; results
       ss))
    
    ;; imports section;
    (writers:write-section +section-id/import+ nil stream (ss)
      (writers:write-u32 1 ss) ;; number of imports
      (writers:write-import "wasi_snapshot_preview1" "fd_write" +kind/function+ 0 ss))

    ))
