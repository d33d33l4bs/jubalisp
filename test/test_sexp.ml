open Jubalisp.Parser
open Jubalisp.Sexp


let%test _ =
  let source = "(print (inc (x) (add x 1)))" in
  let stream = Stream.of_string source in
  let sexp = Option.get (parse_sexp stream) in
  to_string sexp = source