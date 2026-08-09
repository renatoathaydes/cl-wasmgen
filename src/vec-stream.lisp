(in-package #:wasmgen)

(defun make-byte-vector (size)
  (make-array
   size
   :element-type '(unsigned-byte 8)
   :adjustable T
   :fill-pointer 0))

(defclass vector-output-stream
    (gst:fundamental-binary-output-stream)
  ((vector :initarg :vector
           :initform (make-byte-vector 64)
           :type (vector (unsigned-byte 8))
           :accessor vector-output-stream-vector)))

(defmethod stream-element-type
    ((o vector-output-stream))
  '(unsigned-byte 8))

(defmethod gst:stream-clear-output
    ((o vector-output-stream))
  (with-slots ((vec vector)) o
    (setf (fill-pointer vec) 0))
  nil)

(defmethod gst:stream-write-sequence
    ((o vector-output-stream) seq start end &key &allow-other-keys)
  (with-slots ((vec vector)) o
    (loop for index from start below (or end (length seq))
          for item = (elt seq index)
          do (vector-push-extend item vec)))
  seq)

(defmethod gst:stream-write-byte
    ((o vector-output-stream) byte)
  (with-slots ((vec vector)) o
    (vector-push-extend byte vec))
  byte)

(defmethod drain-to
    ((o vector-output-stream) other-stream)
  "Drain the contents of a vector-output-stream into another stream.
   After this call, this stream becomes empty."
  (with-slots ((vec vector)) o
    (write-sequence vec other-stream))
  (clear-output o))
