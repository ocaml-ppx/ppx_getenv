open Migrate_parsetree.OCaml_411.Ast
let ocaml_version = Migrate_parsetree.Versions.ocaml_411

open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let getenv s = try Sys.getenv s with Not_found -> ""

let getenv_mapper _config _cookies =
  (* Our getenv_mapper only overrides the handling of expressions in the default mapper. *)
  { default_mapper with
    expr = fun mapper expr ->
      match expr with
      (* Is this an extension node? *)
      | { pexp_desc =
          (* Should have name "getenv". *)
          Pexp_extension ({ txt = "getenv"; loc }, pstr); _ } ->
        begin match pstr with
        | (* Should have a single structure item, which is evaluation of a constant string. *)
          PStr [{ pstr_desc =
                  Pstr_eval ({ pexp_loc  = loc;
                               pexp_desc = Pexp_constant (Pconst_string (sym, s_loc, None)); _ }, _); _ }] ->
          (* Replace with a constant string with the value from the environment. *)
          Exp.constant ~loc (Pconst_string (getenv sym, s_loc, None))
        | _ ->
          raise (Location.Error (
                  Location.error ~loc "[%getenv] accepts a string, e.g. [%getenv \"USER\"]"))
        end
      (* Delegate to the default mapper. *)
      | x -> default_mapper.expr mapper x;
  }

let () = Migrate_parsetree.Driver.register ~name:"getenv" ocaml_version getenv_mapper
