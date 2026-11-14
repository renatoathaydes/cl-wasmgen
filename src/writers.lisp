(in-package #:wasmgen)

(declaim (ftype (function ((unsigned-byte 32) stream) null)
                write-u32))
(defun write-u32 (value stream)
  "Writes an unsigned integer of 32 bits in LEB128 format to STREAM."
  (loop
    for byte = (logand value #x7F)
    do (setf value (ash value -7))
    if (zerop value)
      do (write-byte byte stream)
         (return)
    else
      do (write-byte (logior byte #x80) stream)))

(declaim (ftype (function (string stream) t) write-name))
(defun write-name (value stream)
  (write-u32 (length value) stream)
  (write-sequence (map 'list #'char-code value) stream))

(declaim (ftype (function (stream) t) write-wasm-header))
(defun write-wasm-header (stream)
  (write-sequence +wasm-magic-number+ stream)
  (write-sequence +wasm-version-1+ stream))

(defmacro write-section
    (section-id name stream (section-stream) &body body)
  `(let ((,section-stream (make-instance 'vector-output-stream)))
     (write-byte ,section-id ,stream)
     (when ,name (write-name ,name ,section-stream))
     ;; the body writes the section itself
     ,@body
     ;; write the section length
     (write-u32 (length (vector-output-stream-vector ,section-stream)) ,stream)
     ;; flush the section
     (drain-to ,section-stream ,stream)
     ;; return nothing
     nil))

(declaim (ftype (function (bytes bytes stream) null)
                write-function-type))
(defun write-function-type (params returns stream)
  "Writes a single function type (should be within the Type Section).
The output is as follows:
     0x60
     parameter_count: u32
     parameter_types: valtype[]
     return_count: u32
     return_types: valtype[]"
  (write-u32 #x60 stream)
  (write-u32 (length params) stream)
  (loop for param in params
        do (write-byte param stream))
  (write-u32 (length returns) stream)
  (loop for ret in returns
        do (write-byte ret stream)))
