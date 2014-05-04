(* used in tests *)
let _ =
  Unix.putenv "PPX_GETENV_CHECK" "42"

(* OASIS_START *)
(* OASIS_STOP *)
Ocamlbuild_plugin.dispatch dispatch_default;;
