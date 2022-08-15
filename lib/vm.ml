open Sexp

let rec eval env value =
  match value with
    | Unit
    | Boolean _
    | Integer _
    | String _
    | Builtin _ -> value
    | Id id -> Env.get env id
    | Sexp [callable; arg] -> begin
      match eval env callable with
        | Builtin f -> f env arg
        | _ -> failwith "callable eval error"
    end
    | _ -> failwith "eval error"
