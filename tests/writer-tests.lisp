(in-package #:wasmgen/tests)

(lt:define-test "write-byte" (writer)
  (stream-contains #(12) :after (write-byte 12 stream)))

(lt:define-test "write-sequence (empty)" (writer)
  (stream-contains #() :after (wasmgen::write-sequence #() stream)))

(lt:define-test "write-sequence (non-empty)" (writer)
  (stream-contains #(1 2 3) :after (wasmgen::write-sequence #(1 2 3) stream)))

(lt:define-test "write-sequence (multiple calls)" (writer)
  (stream-contains #(1 2 3 4 5)
                   :after (progn
                            (wasmgen::write-sequence #(1 2) stream)
                            (wasmgen::write-sequence #(3 4 5) stream))))

(lt:define-test "write-name (empty string)" (writer)
  (stream-contains #(0) :after (wasmgen::write-name "" stream)))

(lt:define-test "write-name (simple)" (writer)
  (stream-contains #(6 115 105 109 112 108 101) :after (wasmgen::write-name "simple" stream)))

(lt:define-test "write-section (custom empty)" (writer)
  (stream-contains #(0 2 1 65)
                   :after (let ((section-stream (make-stream)))
                            (wasmgen::write-section wasmgen::+section-id/custom+ "A" stream section-stream))))
