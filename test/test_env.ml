open Jubalisp.Sexp
module Env = Jubalisp.Env

let parent = 
  let env = Env.make None in
  Env.add env "x" (Integer 1);
  env

let env = 
  let env = Env.make (Some parent) in
  Env.add env "y" (Integer 2);
  env

let%test _ =
  (Env.get env "x") = Integer 1

let%test _ =
  (Env.get env "y") = Integer 2

let%test _ =
  match Env.get env "z" with
    | exception (Env.Unbound_value _) -> true
    | _-> false

let%test _ =
  (Env.get_opt env "x") = Some (Integer 1)

let%test _ =
  (Env.get_opt env "y") = Some (Integer 2)

let%test _ =
  (Env.get_opt env "z") = None

let%test _ =
  Env.is_bound env "x"

let%test _ =
  Env.is_bound env "y"

let%test _ =
  not (Env.is_bound env "z")

let%test _ =
  Env.parent env = Some parent

let%test _ =
  Env.parent parent = None