#! /bin/sh

sbcl --script /dev/stdin <<'EOF'
(require "asdf")

#-ocicl
(when (probe-file #P"~/.local/share/ocicl/ocicl-runtime.lisp")
  (load #P"~/.local/share/ocicl/ocicl-runtime.lisp"))
(asdf:initialize-source-registry
  (list :source-registry (list :directory (uiop:getcwd)) :inherit-configuration))

(load "cl-wasmgen.asd")
(asdf:make "cl-wasmgen")
EOF
