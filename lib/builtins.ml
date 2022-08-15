open Sexp

let print =
  let print env value =
    let print = function
      | Integer i -> Printf.printf "%d\n" i
      | String s -> Printf.printf "%s\n" s
      | _ -> Printf.printf "%s\n" (to_string value)
    in
    let value = Vm.eval env value in
    print value;
    value
  in
  Builtin print

let define =
  let body id env body =
    let body = Vm.eval env body in
    let value = Vm.eval env body in
    Env.add env id value;
    value
  in
  let id _env id = Builtin (body (unbox_id id)) in
  Builtin id

let binop op type_ =
  let eval_operand env operand = Vm.eval env operand |> unbox_integer in
  let right left env right = type_ (op left (eval_operand env right)) in
  let left env left = Builtin (right (eval_operand env left)) in
  Builtin left
