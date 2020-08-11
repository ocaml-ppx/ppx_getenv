open Ppxlib
open Ppxlib.Ast_helper

let getenv s = try Sys.getenv s with Not_found -> ""

let traverse =
  object
    inherit Ppxlib.Ast_traverse.map as super

    method! expression = function
      | { pexp_desc =
          (* Should have name "getenv". *)
          Pexp_extension ({ txt = "getenv"; loc }, pstr); _ } ->
        begin match pstr with
        | (* Should have a single structure item, which is evaluation of a constant string. *)
          PStr [{ pstr_desc =
                  Pstr_eval ({ pexp_loc  = loc;
                               pexp_desc = Pexp_constant (Pconst_string (sym, None)); _ }, _); _ }] ->
          (* Replace with a constant string with the value from the environment. *)
          Exp.constant ~loc (Pconst_string (getenv sym, None))
        | _ ->
          Location.raise_errorf ~loc "[%%getenv] accepts a string, e.g. [%%getenv \"USER\"]"
        end
      (* Delegate to the default mapper. *)
      | expr -> super#expression expr
  end

let () = Ppxlib.Driver.register_transformation ~impl:traverse#structure "ppx_getenv"
