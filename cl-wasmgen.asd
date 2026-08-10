(asdf:defsystem "cl-wasmgen"
  :description "Common Lisp WASM Generation."
  :version "0.1.0"
  :author "Renato Athaydes"
  :license "Apache-2.0"
  :depends-on ("trivial-gray-streams")
  :build-operation asdf:program-op
  :entry-point "wasmgen:main"
  :serial t
  :components ((:file "src/package")
               (:file "src/vec-stream")
               (:file "src/constants")
               (:file "src/writers")
               (:file "src/main"))
  :in-order-to ((asdf:test-op (asdf:test-op "cl-wasmgen/tests"))))


(asdf:defsystem "cl-wasmgen/tests"
  :author "Renato Athaydes"
  :license "GPL"
  :depends-on ("cl-wasmgen")
  :pathname "tests"
  :components ((:file "package")
               (:file "test-framework" :depends-on ("package"))
               (:file "writer-tests" :depends-on ("test-framework"))
               (:file "main" :depends-on ("writer-tests")))
  :description "Test system for cl-wasmgen"
  :perform (asdf:test-op (op c)
                    (uiop:symbol-call :wasmgen/tests :run-tests)))
