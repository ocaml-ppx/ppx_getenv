(lang dune 2.0)
(name ppx_getenv)
(version 2.0)

(generate_opam_files true)

(maintainers "whitequark <whitequark@whitequark.org>")
(authors "whitequark <whitequark@whitequark.org>")
(license "Public domain")
(source (github ocaml-ppx/ppx_getenv))

(package
  (name ppx_getenv)
  (synopsis "A sample syntax extension using OCaml's new extension points API")
  (tags ("syntax"))
  (depends
    (ocaml (>= 4.02.0))
    (ocaml-migrate-parsetree (>= 1.7.0))
    (ounit2 :with-test)
    (odoc :with-doc)))
