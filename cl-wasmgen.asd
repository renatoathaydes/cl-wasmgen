(asdf:defsystem "cl-wasmgen"
  :description "Common Lisp WASM Generation."
  :version "0.1.0"
  :author "Renato Athaydes"
  :license "Apache-2.0"
  :depends-on ("trivial-gray-streams")
  :build-operation asdf:program-op
  :entry-point "wasmgen:main"
  :pathname "src"
  :components ((:file "package")
               (:file "types" :depends-on ("package"))
               (:file "vec-stream" :depends-on ("package"))
               (:file "constants" :depends-on ("package"))
               (:file "writers" :depends-on ("types" "constants"))
               (:file "main" :depends-on ("writers")))
  :in-order-to ((asdf:test-op (asdf:test-op "cl-wasmgen/tests"))))

(asdf:defsystem "cl-wasmgen/tests"
  :author "Renato Athaydes"
  :license "GPL"
  :depends-on ("cl-wasmgen" "format-ansi" "cl-lustre-tests")
  :pathname "tests"
  :components ((:file "package")
               (:file "test-framework" :depends-on ("package"))
               (:file "writer-tests" :depends-on ("test-framework")))
  :description "Test system for cl-wasmgen"
  :perform (asdf:test-op (op c)
                    (uiop:symbol-call :lustre-tests :test)))
