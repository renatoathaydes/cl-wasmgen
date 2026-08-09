(asdf:defsystem "cl-wasmgen"
  :description "Common Lisp WASM Generation."
  :version "0.1.0"
  :author "Renato Athaydes"
  :license "Apache-2.0"
  :depends-on ("trivial-gray-streams")
  :build-operation program-op
  :entry-point "wasmgen:main"
  :serial t
  :components ((:file "src/package")
               (:file "src/vec-stream")
               (:file "src/constants")
               (:file "src/writers")
               (:file "src/main")))
