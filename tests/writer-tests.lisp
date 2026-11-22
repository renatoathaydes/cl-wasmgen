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
  (stream-contains (concatenate 'vector #(6) (char-codes #\s #\i #\m #\p #\l #\e))
                   :after (write-name "simple" stream)))

(lt:define-test "write-section (custom empty)" (writer)
  (stream-contains (vector 0 2 1 (char-code #\A))
                   :after (write-section +section-id/custom+ "A" stream (ss))))

(lt:define-test "write-function-type" (writer)
  (stream-contains (vector #x60 2 #x7f #x7c 1 #x7e)
                   :after (write-function-type
                           (list +type/i32+ +type/f64+)
                           (list +type/i64+)
                           stream)))

(lt:define-test "write-import" (writer)
  (stream-contains (concatenate 'vector
                                #(3) (char-codes #\e #\n #\v)         ; Module name: "env"
                                #(5) (char-codes #\p #\r #\i #\n #\t) ; Field name: "print"
                                #(0)                                  ; Function import
                                #(0))                                 ; Type index 0
                   :after (write-import "env" "print" +kind/function+ 0 stream)))

(lt:define-test "write-table (min-only)" (writer)
  (stream-contains #(#x70 0 10)
                   :after (write-table +absheaptype/func+ 10 nil stream)))

(lt:define-test "write-table (min-max)" (writer)
  (stream-contains #(#x70 1 10 11)
                   :after (write-table +absheaptype/func+ 10 11 stream)))

(lt:define-test "write-memory (min-only)" (writer)
  (stream-contains #(0 2)
                   :after (write-memory 2 nil stream)))

(lt:define-test "write-memory (min-max)" (writer)
  (stream-contains #(1 2 4)
                   :after (write-memory 2 4 stream)))

(lt:define-test "write-global" (writer)
  (stream-contains
   #(#x7c 0 #xff)
   :after
   (flet ((write-expr ()
            (write-byte #xff stream)))
     (write-global +type/f64+ 0 #'write-expr stream))))
