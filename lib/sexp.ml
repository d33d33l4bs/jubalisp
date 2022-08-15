type t =
  | Unit
  | Boolean of bool
  | Integer of int
  | String of string
  | Id of string
  | Builtin of (t Env.t -> t -> t)
  | Sexp of t list

let boolean b =
  Boolean b

let integer i =
  Integer i

let string s =
  String s

let id s =
  Id s

let builtin b =
  Builtin b

let sexp s =
  Sexp s

let type_of = function
  | Unit -> `UNIT
  | Boolean _ -> `BOOLEAN
  | Integer _ -> `INTEGER
  | String _ -> `STRING
  | Id _ -> `ID
  | Builtin _ -> `BUILTIN
  | Sexp _ -> `SEXP

let string_of_type = function
  | `UNIT -> "unit"
  | `BOOLEAN -> "boolean"
  | `INTEGER -> "integer"
  | `STRING -> "string"
  | `ID -> "id"
  | `BUILTIN -> "builtin"
  | `SEXP -> "sexp"

let unbox_boolean = function
  | Boolean b -> b
  | _ -> failwith "unbox_boolean error"

let unbox_integer = function
  | Integer i -> i
  | _ -> failwith "unbox_integer error"

let unbox_string = function
  | String s -> s
  | _ -> failwith "unbox_string error"

let unbox_id = function
  | Id i -> i
  | _ -> failwith "unbox_id error"

let rec to_string = function
  | Unit -> "unit"
  | Boolean b -> Printf.sprintf "%b" b
  | Integer i -> Printf.sprintf "%d" i
  | String s -> Printf.sprintf "\"%s\"" s
  | Id i -> Printf.sprintf "%s" i
  | Builtin _ -> "<builtin>"
  | Sexp s ->
      s
      |> List.map to_string
      |> String.concat " "
      |> Printf.sprintf "(%s)"
