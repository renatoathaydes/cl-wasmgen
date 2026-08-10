(in-package #:wasmgen/tests)

(add-test "write-byte"
  (stream-contains #(12) :after (write-byte 12 stream)))

(add-test "write-sequence (empty)"
  (stream-contains #() :after (wasmgen::write-sequence #() stream)))

(add-test "write-sequence (non-empty)"
  (stream-contains #(1 2 3) :after (wasmgen::write-sequence #(1 2 3) stream)))

(add-test "write-sequence (multiple calls)"
  (stream-contains #(1 2 3 4 5) :after (progn
                                         (wasmgen::write-sequence #(1 2) stream)
                                         (wasmgen::write-sequence #(3 4 5) stream))))
