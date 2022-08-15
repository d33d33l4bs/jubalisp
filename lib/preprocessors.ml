open Sexp

(** Convert a flat call like `(+ 1 2)` into a valid nested call like `((+ 1) 2)` *)
let nested_call = function
  | callable :: tl ->
    let arg = List.hd tl in
    let args = List.tl tl in
    List.fold_left (fun acc arg -> Sexp [acc; arg]) (Sexp [callable; arg]) args
  | _ -> failwith "sugar error"

(** A preprocessor that makes some syntactic sugar transformations on an AST (sexp). *)
let rec sugar value =
  match value with
    | Sexp ((_ :: _ :: _) as call) ->
      (* The pattern above only match on calls with more than one parameter. *)
      let call = List.map sugar call in
      nested_call call
    | _ -> value
