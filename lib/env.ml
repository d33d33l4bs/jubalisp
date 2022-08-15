type 'a t = {
  parent: 'a t option;
  env: (string, 'a) Hashtbl.t;
}

exception Unbound_value of string

let not_found name =
  let hint = Printf.sprintf "unbound value '%s'" name in
  raise (Unbound_value hint)

let make parent = {
  parent;
  env = Hashtbl.create 10;
}

let parent env =
  env.parent

let rec get env name =
  match Hashtbl.find_opt env.env name with
    | Some sexp -> sexp
    | None -> begin
      match env.parent with
        | Some parent -> get parent name
        | None -> not_found name
    end

let get_opt env name =
  match get env name with
    | sexp -> Some sexp
    | exception Unbound_value _ -> None

let is_bound env name =
  get_opt env name <> None

let add env name sexp =
  Hashtbl.add env.env name sexp