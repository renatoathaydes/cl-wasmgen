(defpackage #:wasmgen
  (:use #:cl)
  (:local-nicknames
   (#:gst #:trivial-gray-streams))
  (:export #:main
           #:write-u32
           #:write-name
           #:write-wasm-header
           #:write-section
           #:write-function-type))
