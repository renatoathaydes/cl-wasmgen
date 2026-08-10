(in-package #:wasmgen)

(defun write-u32 (value stream)
  (loop
    for byte = (logand value #x7F)
    do (setf value (ash value -7))
    if (zerop value)
      do (write-byte byte stream)
         (return)
    else
      do (write-byte (logior byte #x80) stream)))

(defun write-name (value stream)
  (write-u32 (length value) stream)
  (write-sequence (map 'list #'char-code value) stream))

(defun write-wasm-header (stream)
  (write-sequence +wasm-magic-number+ stream)
  (write-sequence +wasm-version-1+ stream))

(defmacro write-section
    (section-id name stream section-stream &body body)
  `(progn
     (write-byte ,section-id ,stream)
     (when ,name (write-name ,name ,section-stream))
     ;; the body writes the section itself
     ,@body
     ;; write the section length
     (write-u32 (length (vector-output-stream-vector ,section-stream)) ,stream)
     ;; flush the section
     (drain-to ,section-stream ,stream)
     ;; return the now empty ss for reuse
     ,section-stream))
