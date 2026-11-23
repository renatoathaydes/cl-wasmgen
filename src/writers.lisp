;;; This file contains the low-level writer functions.
;;; They are used to write everything the WASM standard defines.
;;; No help is provided regarding the WASM module's structure itself.
;;; Use the high-level API, which is built on top of these writers,
;;; to write
(defpackage #:wasmgen/writers
  (:use #:cl #:wasmgen)
  (:export #:write-u32
           #:write-name
           #:write-wasm-header
           #:write-section
           #:write-function-type
           #:write-import
           #:write-table
           #:write-memory
           #:write-global
           #:write-export))

(in-package #:wasmgen/writers)

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
  `(let ((,section-stream (make-instance 'wasmgen:vector-output-stream)))
     (write-byte ,section-id ,stream)
     (when ,name (write-name ,name ,section-stream))
     ;; the body writes the section itself
     ,@body
     ;; write the section length
     (write-u32 (length (vector-output-stream-vector ,section-stream)) ,stream)
     ;; flush the section
     (wasmgen::drain-to ,section-stream ,stream)
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
  (write-u32 +type/func+ stream)
  (write-u32 (length params) stream)
  (loop for param in params
        do (write-byte param stream))
  (write-u32 (length returns) stream)
  (loop for ret in returns
        do (write-byte ret stream)))

(declaim (ftype (function (string string import-kind (unsigned-byte 32) stream) t) write-import))
(defun write-import (module-name field-name kind type-index stream)
  "Writes an import within the Import Section.
The output is as follows:
    module_name: name
    field_name: name
    import_kind: byte
    type_index: u32"
  (write-name module-name stream)
  (write-name field-name stream)
  (write-byte kind stream)
  (write-u32 type-index stream))

(declaim (ftype (function (wasmgen:reftype
                           (unsigned-byte 32)
                           (or null (unsigned-byte 32))
                           stream)
                          t)
                write-table))
(defun write-table (type min max stream)
  "writes a table within the table section.
The output is as follows:
    element_type: reftype
    flags: u32     (0 if min only, 1 if min and max)
    minimum: u32
    maximum?: u32"
  (write-u32 type stream)
  (write-byte (if max 1 0) stream)
  (write-u32 min stream)
  (when max (write-u32 max stream)))

(declaim (ftype (function ((unsigned-byte 32)
                           (or null (unsigned-byte 32))
                           stream)
                          t)
                write-memory))
(defun write-memory (min max stream)
  "Write a memory limits within the memory section.
The output is as follows:
    flags: u32     (0 if min only, 1 if min and max)
    minimum: u32
    maximum?: u32"
  (write-byte (if max 1 0) stream)
  (write-u32 min stream)
  (when max (write-u32 max stream)))

(declaim (ftype (function ((unsigned-byte 8)
                           (unsigned-byte 1)
                           (function () t)
                           stream)
                          t)
                write-global))
(defun write-global (type mutability write-init-expr stream)
  "Write a global declaration within the global section.
The initial value of the global is written by calling
the provided WRITE-INIT-EXPR function.
The output is as follows:
    type: u8
    mutable: u8 (0 or 1)
    expression: expr"
  (write-byte type stream)
  (write-byte mutability stream)
  (funcall write-init-expr))

(declaim (ftype (function (string
                           wasmgen:extern-index
                           (unsigned-byte 32)
                           stream)
                          t)
                write-export))
(defun write-export (name kind index stream)
  "Write an export within the export section.
The output is as follows:
    name: string
    kind: u8
    index: u32"
  (write-name name stream)
  (write-byte kind stream)
  (write-u32 index stream))
