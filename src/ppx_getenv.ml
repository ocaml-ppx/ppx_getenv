open Ppxlib

let getenv s = try Sys.getenv s with Not_found -> ""

let getenv_strict ~loc s =
  try Sys.getenv s
  with Not_found -> Location.raise_errorf ~loc "[%%getenv_strict] not set: %s" s

let expander ~strict ~loc ~path:_ = function
  | (* Should have a single structure item, which is evaluation of a constant string. *)
    PStr [{ pstr_desc =
            Pstr_eval ({ pexp_loc  = loc;
                         pexp_desc = Pexp_constant (Pconst_string (sym, _, None)); _ }, _); _ }] ->
      (* Replace with a constant string with the value from the environment. *)
      Ast_builder.Default.estring ~loc (if strict then getenv_strict ~loc sym else getenv sym)
  | _ ->
      Location.raise_errorf ~loc "[%%getenv] accepts a string, e.g. [%%getenv \"USER\"]"

let extension =
  Context_free.Rule.extension
    (Extension.declare "getenv" Expression Ast_pattern.(__) (expander ~strict:false))

let extension_strict =
  Context_free.Rule.extension
    (Extension.declare "getenv_strict" Expression Ast_pattern.(__) (expander ~strict:true))

let () = Ppxlib.Driver.register_transformation ~rules:[extension] "ppx_getenv"
let () = Ppxlib.Driver.register_transformation ~rules:[extension_strict] "ppx_getenv_strict"
