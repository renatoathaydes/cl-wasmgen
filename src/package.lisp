(defpackage #:wasmgen
  (:use #:cl)
  (:local-nicknames
   (#:gst #:trivial-gray-streams))
  (:export #:main
           #:write-u32
           #:write-name
           #:write-wasm-header
           #:write-section
           #:write-function-type
           #:write-import
           ;; constants
           #:+wasm-magic-number+
           #:+wasm-version-1+
           #:+section-id/custom+
           #:+section-id/type+
           #:+section-id/import+
           #:+section-id/function+
           #:+section-id/table+
           #:+section-id/memory+
           #:+section-id/global+
           #:+section-id/export+
           #:+section-id/start+
           #:+section-id/element+
           #:+section-id/code+
           #:+section-id/data+
           #:+section-id/data-count+
           #:+section-id/tag+
           #:+type/array+
           #:+type/struct+
           #:+type/func+
           #:+type/f64+
           #:+type/f32+
           #:+type/i64+
           #:+type/i32+
           #:+kind/function+
           #:+kind/table+
           #:+kind/memory+
           #:+kind/global+))
