(in-package #:wasmgen/tests)

(lt:define-test "write-byte" (writer)
  (stream-contains #(12) :after (write-byte 12 stream)))

(lt:define-test "write-u32" (writer)
  (stream-contains #(#x2A) :after (write-u32 42 stream))
  (stream-contains #(#xE5 #x8E #x26) :after (write-u32 624485 stream)))

(lt:define-test "write-u32 (multiple calls)" (writer)
  (stream-contains #(#x2A #xE5 #x8E #x26)
                   :after (progn
                            (write-u32 42 stream)
                            (write-u32 624485 stream))))

(lt:define-test "write-name (empty string)" (writer)
  (stream-contains #(0) :after (write-name "" stream)))

(lt:define-test "write-name (simple)" (writer)
  (stream-contains (concatenate 'vector #(6) (char-codes '(#\s #\i #\m #\p #\l #\e)))
                   :after (write-name "simple" stream)))

(lt:define-test "write-section (custom empty)" (writer)
  (stream-contains (vector 0 2 1 (char-code #\A))
                   :after (let ((section-stream (make-stream)))
                            (write-section wasmgen::+section-id/custom+ "A" stream (ss)))))
