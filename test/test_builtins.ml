open Jubalisp.Sexp
open Jubalisp.Builtins
module Env = Jubalisp.Env
module Vm = Jubalisp.Vm

let env = 
  let env = Env.make None in
  Env.add env "print" print;
  Env.add env "define" define;
  Env.add env "+" (binop (+) integer);
  Env.add env "=" (binop (=) boolean);
  env

let%test _ =
  let source = Sexp [Id "print"; String "hello"] in
  let result = Vm.eval env source in
  result = String "hello"

let%expect_test _ =
  let source = Sexp [Id "print"; String "hello"] in
  ignore (Vm.eval env source);
  [%expect {| hello |}]

let%test _ =
  let source = Sexp [Sexp [Id "define"; Id "x"]; Integer 1] in
  let result = Vm.eval env source in
  result = Integer 1

let%test _ =
  let source = Sexp [Sexp [Id "define"; Id "x"]; Integer 2] in
  ignore (Vm.eval env source);
  Env.get env "x" = Integer 2

let%test _ =
  let source = Sexp [Sexp [Id "+"; Integer 1]; Integer 2] in
  let result = Vm.eval env source in
  result = Integer 3

let%test _ =
  let source = Sexp [Sexp [Id "="; Integer 1]; Integer 2] in
  let result = Vm.eval env source in
  result = Boolean false