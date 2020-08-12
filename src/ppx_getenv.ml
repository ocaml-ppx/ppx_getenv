open Ppxlib
open Ppxlib.Ast_helper

let getenv s = try Sys.getenv s with Not_found -> ""

let expander ~loc ~path:_ = function
  | (* Should have a single structure item, which is evaluation of a constant string. *)
    PStr [{ pstr_desc =
            Pstr_eval ({ pexp_loc  = loc;
                         pexp_desc = Pexp_constant (Pconst_string (sym, None)); _ }, _); _ }] ->
      (* Replace with a constant string with the value from the environment. *)
      Exp.constant ~loc (Pconst_string (getenv sym, None))
  | _ ->
      Location.raise_errorf ~loc "[%%getenv] accepts a string, e.g. [%%getenv \"USER\"]"

let extension =
  Context_free.Rule.extension
    (Extension.declare "getenv" Expression Ast_pattern.(__) expander)

let () = Ppxlib.Driver.register_transformation ~rules:[extension] "ppx_getenv"
