#!/usr/bin/env ocaml
#directory "pkg"
#use "topkg.ml"

let () =
  let oc = open_out "src_test/_tags" in
  output_string oc (if Env.native then "<*.ml>: ppx_native" else "<*.ml>: ppx_byte");
  close_out oc

let () =
  Pkg.describe "ppx_getenv" ~builder:`OCamlbuild [
    Pkg.lib "pkg/META";
    Pkg.bin ~auto:true "src/ppx_getenv" ~dst:"../lib/ppx_getenv/ppx_getenv";
    Pkg.doc "README.md";
    Pkg.doc "LICENSE.txt"]
