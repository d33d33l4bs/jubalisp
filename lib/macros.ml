open Sexp

let if_ =
  let else_ env test then_ _env else_ =
    match Vm.eval env test with
      | Boolean true -> Vm.eval env then_
      | Boolean false -> Vm.eval env else_
      | _ -> failwith "if macro error"
  in
  let then_ env test _env then_ = Builtin (else_ env test then_) in
  let test env test = Builtin (then_ env test) in
  Builtin test

let closure builtin env =
  Builtin (fun _ arg -> builtin env arg)

let lambda =
  let apply param body parent_env arg =
    let arg = Vm.eval parent_env arg in
    let env = Env.make (Some parent_env) in
    Env.add env param arg;
    match Vm.eval env body with
      | Builtin b -> closure b env
      | result -> result
  in
  let body param _env body = Builtin (apply param body) in
  let param _env param = Builtin (body (unbox_id param)) in
  Builtin param
