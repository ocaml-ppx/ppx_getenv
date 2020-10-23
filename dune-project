(lang dune 2.0)
(name ppx_getenv)
(version 2.1)

(formatting disabled)
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
    (ocaml (>= 4.04.0))
    (ppxlib (>= 0.18.0))
    (ounit2 :with-test)
    (odoc :with-doc)))
