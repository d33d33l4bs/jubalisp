
let default_env =
  let open Jubalisp in
  let open Jubalisp.Builtins in
  let open Jubalisp.Macros in
  let open Jubalisp.Sexp in
  let env = Env.make None in
  Env.add env "print" print;
  Env.add env "+" (binop (+) integer);
  Env.add env "-" (binop (-) integer);
  Env.add env "*" (binop ( * ) integer);
  Env.add env "/" (binop (/) integer);
  Env.add env "<" (binop (<) boolean);
  Env.add env ">" (binop (>) boolean);
  Env.add env "<=" (binop (<=) boolean);
  Env.add env ">=" (binop (>=) boolean);
  Env.add env "define" define;
  Env.add env "if" if_;
  Env.add env "lambda" lambda;
  env

let read_file path =
  let chan = open_in path in
  let s = really_input_string chan (in_channel_length chan) in
  close_in chan;
  s

let rec eval env stream =
  match Jubalisp.Parser.parse_sexp stream with
    | None -> ()
    | Some value -> begin
      let value = Jubalisp.Preprocessors.sugar value in
      ignore (Jubalisp.Vm.eval env value);
      eval env stream
    end

let () =
  if Array.length Sys.argv = 2 then
    let sources = read_file Sys.argv.(1) in
    let stream = Stream.of_string sources in
    eval default_env stream
  else
    Printf.printf "%s jubafile" Sys.argv.(0)
