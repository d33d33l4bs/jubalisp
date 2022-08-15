open Sexp

(* Utils *)

(** An operator to bind a monade in an iterative way. *)
let (let*) =
  Option.bind

(** A simple alias for `Option.map`. *)
let map_to =
  Option.map

(** Return monadic operator. *)
let return o =
  Some o

(** Dot composition operator. *)
let (>>) f g v =
  g (f v)


(* Predicates *)

let is_char c = function
   | x when x = c -> true
   | _ -> false

let is_digit = function
  | '0' .. '9' -> true
  | _ -> false

let is_space = function
  | ' ' | '\t' | '\n' | '\r' -> true
  | _ -> false

let is_alpha = function
  | 'a'..'z'
  | 'A'..'Z' -> true
  | _ -> false

let is_alphanum = function
  | '0'..'9'
  | 'a'..'z'
  | 'A'..'Z' -> true
  | _ -> false

let is_op = function
  | '=' | '<' | '>' | '|'
  | '+' | '-' | '*' | '/' -> true
  | _ -> false


(* Parsers *)

let parse_char expected stream =
  match Stream.peek stream with
    | Some c when c = expected -> Some (Stream.next stream |> String.make 1)
    | _ -> None

let parse_chars expected stream =
  let len = String.length expected in
  let chars = List.init (String.length expected) (String.get expected) in
  if Stream.npeek len stream = chars then begin
    for _ = 1 to len do
      Stream.junk stream
    done;
    Some expected
  end
  else
    None

let parse_pred pred stream =
  match Stream.peek stream with
    | Some c when pred c -> Some (Stream.next stream |> String.make 1)
    | _
    | exception Stream.Failure -> None

let rec one_of parsers stream =
  match parsers with
    | [] -> None
    | parser :: parsers -> (
      match parser stream with
        | None -> one_of parsers stream
        | result -> result
    )

let parse_while parser fold acc stream =
  let rec extract acc =
    match parser stream with
      | Some item -> extract (fold acc item)
      | None -> acc
  in
  extract acc

let parse_open_par =
  parse_char '('

let parse_close_par =
  parse_char ')'

let parse_digit =
  parse_pred is_digit

let parse_alpha =
  parse_pred is_alpha

let parse_id =
  parse_pred (fun b -> is_alpha b || is_op b)

let parse_alphanum =
  parse_pred is_alphanum

let parse_space =
  parse_pred is_space

let fold_str acc item =
  match acc with
    | None -> Some item
    | Some acc -> Some (acc ^ item)

let fold_list acc item =
  match acc with
    | None -> Some [item]
    | Some acc -> Some (item :: acc)

let parse_comment stream =
  let parse_return = parse_char '\n' in
  let parse_not_return = parse_pred ((<>) '\n') in
  let parse_until_return = parse_while parse_not_return fold_str (Some "") in
  let* _ = parse_char ';' stream in
  let* comment = parse_until_return stream in
  let* _ = parse_return stream in
  return comment

let rec discard_useless stream =
  let parsers = one_of [parse_space; parse_comment] in
  match parsers stream with
    | None -> stream
    | _ -> discard_useless stream

let parse_unit stream =
  let* _ = parse_chars "unit" stream in
  return Unit

let parse_boolean stream =
  let* value = one_of [parse_chars "true"; parse_chars "false"] stream in
  return (value |> bool_of_string |> boolean)

let parse_integer stream =
  stream
  |> parse_while parse_digit fold_str None
  |> map_to int_of_string
  |> map_to integer

let parse_string stream =
  let parse_not_double_quote =
    parse_pred ((<>) '"')
  in
  (* parse the first double quote *)
  let* _ = parse_char '"' stream in
  (* extract the string contents *)
  let* contents = parse_while parse_not_double_quote fold_str (Some "") stream in
  (* parse the last final double quote *)
  let* _ = parse_char '"' stream in
  (* return the string contents *)
  return (String contents)

let parse_id stream =
  stream
  |> parse_while parse_id fold_str None
  |> map_to id

let parse_exp =
  one_of [
    parse_unit;
    parse_boolean;
    parse_integer;
    parse_string;
    parse_id;
  ]

let rec parse_sexp stream =
  let parse_sexp_or_exp =
    one_of [
      discard_useless >> parse_exp;
      discard_useless >> parse_sexp]
  in
  (* parse the open parenthesis *)
  let* _ = stream |> discard_useless |> parse_open_par in
  (* retrieve the sexp body *)
  let* body =
    stream
    |> discard_useless
    |> parse_while parse_sexp_or_exp fold_list (Some [])
  in
  (* parse the final parenthesis *)
  let* _ = stream |> discard_useless |> parse_close_par in
  (* return a new sexp *)
  return (Sexp (List.rev body))
