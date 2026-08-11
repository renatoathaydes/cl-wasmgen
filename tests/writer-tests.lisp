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

(add-test "write-name (empty string)"
  (stream-contains #(0) :after (wasmgen::write-name "" stream)))

(add-test "write-name (simple)"
  (stream-contains #(6 115 105 109 112 108 101) :after (wasmgen::write-name "simple" stream)))

(add-test "write-section (custom empty)"
  (stream-contains #(0 2 1 65)
                   :after (let ((section-stream (make-stream)))
                            (wasmgen::write-section wasmgen::+section-id/custom+ "A" stream section-stream))))
