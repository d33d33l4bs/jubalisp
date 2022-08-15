open Jubalisp.Sexp
open Jubalisp.Parser


let%test _ = (is_char 'c') 'c'
let%test _ = not ((is_char 'c') 'e')

let%test _ = is_digit '0'
let%test _ = is_digit '5'
let%test _ = is_digit '9'
let%test _ = not (is_digit 'a')

let%test _ = is_space ' '
let%test _ = is_space '\n'
let%test _ = is_space '\r'
let%test _ = is_space '\t'
let%test _ = not (is_space 'a')

let%test _ = is_alpha 'a'
let%test _ = is_alpha 'z'
let%test _ = is_alpha 'A'
let%test _ = is_alpha 'Z'
let%test _ = not (is_alpha '1')


let%test _ = is_alphanum 'a'
let%test _ = is_alphanum 'z'
let%test _ = is_alphanum 'A'
let%test _ = is_alphanum 'Z'
let%test _ = is_alphanum '0'
let%test _ = is_alphanum '9'
let%test _ = not (is_alpha '#')

let%test _ =
  let stream = Stream.of_string "a" in
  parse_char 'a' stream = Some "a"
let%test _ =
  let stream = Stream.of_string "a" in
  parse_char 'b' stream = None
let%test _ =
  let stream = Stream.of_string "" in
  parse_char 'b' stream = None

let%test _ =
  let stream = Stream.of_string "hello world" in
  parse_chars "hello" stream = Some "hello"
let%test _ =
  let stream = Stream.of_string "world" in
  parse_chars "hello" stream = None
let%test _ =
  let stream = Stream.of_string "" in
  parse_chars "hello" stream = None

let%test _ =
  let stream = Stream.of_string "a" in
  parse_pred ((=) 'a') stream = Some "a"
let%test _ =
  let stream = Stream.of_string "a" in
  parse_pred ((=) 'b') stream = None
let%test _ =
  let stream = Stream.of_string "" in
  parse_pred ((=) 'a') stream = None

let%test _ =
  let stream = Stream.of_string "a" in
  let parsers = [parse_pred ((=) 'a'); parse_pred ((=) 'b')] in
  one_of parsers stream = Some "a"
let%test _ =
  let stream = Stream.of_string "b" in
  let parsers = [parse_pred ((=) 'a'); parse_pred ((=) 'b')] in
  one_of parsers stream = Some "b"
let%test _ =
  let stream = Stream.of_string "c" in
  let parsers = [parse_pred ((=) 'a'); parse_pred ((=) 'b')] in
  one_of parsers stream = None
let%test _ =
  let stream = Stream.of_string "" in
  let parsers = [parse_pred ((=) 'a'); parse_pred ((=) 'b')] in
  one_of parsers stream = None
let%test _ =
  let stream = Stream.of_string "a" in
  let parsers = [] in
  one_of parsers stream = None

let%test _ =
  let stream = Stream.of_string "(aaa)" in
  parse_open_par stream = Some "("
let%test _ =
  let stream = Stream.of_string "a" in
  parse_open_par stream = None

let%test _ =
  let stream = Stream.of_string ") aaa" in
  parse_close_par stream = Some ")"
let%test _ =
  let stream = Stream.of_string "a" in
  parse_close_par stream = None

let%test _ =
  let stream = Stream.of_string "1" in
  parse_digit stream = Some "1"
let%test _ =
  let stream = Stream.of_string "a" in
  parse_digit stream = None


let%test _ =
  let stream = Stream.of_string "a" in
  parse_alpha stream = Some "a"
let%test _ =
  let stream = Stream.of_string "1" in
  parse_alpha stream = None

let%test _ =
  let stream = Stream.of_string "a" in
  parse_alphanum stream = Some "a"
let%test _ =
  let stream = Stream.of_string "1" in
  parse_alphanum stream = Some "1"
let%test _ =
  let stream = Stream.of_string "#" in
  parse_alphanum stream = None

let%test _ =
  let stream = Stream.of_string " " in
  parse_space stream = Some " "
let%test _ =
  let stream = Stream.of_string "\n" in
  parse_space stream = Some "\n"
let%test _ =
  let stream = Stream.of_string "\t" in
  parse_space stream = Some "\t"
let%test _ =
  let stream = Stream.of_string "\r" in
  parse_space stream = Some "\r"
let%test _ =
  let stream = Stream.of_string "a" in
  parse_space stream = None

let%test _ =
  let stream = Stream.of_string "aaa123(d" in
  parse_while parse_alphanum fold_str None stream = Some "aaa123"
let%test _ =
  let stream = Stream.of_string "#aaa123(d" in
  parse_while parse_alphanum fold_str None stream = None
let%test _ =
  let stream = Stream.of_string "" in
  parse_while parse_alphanum fold_str None stream = None
let%test _ =
  let stream = Stream.of_string "123" in
  parse_while parse_alphanum fold_list (Some []) stream = Some ["3"; "2"; "1"]
let%test _ =
  let stream = Stream.of_string "#123" in
  parse_while parse_alphanum fold_list (Some []) stream = Some []
let%test _ =
  let stream = Stream.of_string "#123" in
  parse_while parse_alphanum fold_list None stream = None

let%test _ =
  let stream = Stream.of_string "  \r\n\t  \ta" in
  (stream |> discard_spaces |> Stream.next) = 'a'


let%test _ = boolean true = Boolean true
let%test _ = boolean false = Boolean false

let%test _ = integer 12345 = Integer 12345
let%test _ = integer 0 = Integer 0

let%test _ = string "abc" = String "abc"
let%test _ = string "" = String ""

let%test _ = id "add" = Id "add"

let%test _ = sexp [Id "a"] = Sexp [Id "a"]

let %test _ =
  let stream = Stream.of_string "true" in
  parse_boolean stream = Some (Boolean true)
let %test _ =
  let stream = Stream.of_string "false" in
  parse_boolean stream = Some (Boolean false)
let %test _ =
  let stream = Stream.of_string "trou" in
  parse_boolean stream = None
let %test _ =
  let stream = Stream.of_string "" in
  parse_boolean stream = None

let %test _ =
  let stream = Stream.of_string "123" in
  parse_integer stream = Some (Integer 123)
let %test _ =
  let stream = Stream.of_string "0" in
  parse_integer stream = Some (Integer 0)
let %test _ =
  let stream = Stream.of_string "a" in
  parse_integer stream = None
let %test _ =
  let stream = Stream.of_string "" in
  parse_integer stream = None

let %test _ =
  let stream = Stream.of_string "\"hello\"" in
  parse_string stream = Some (String "hello")
let %test _ =
  let stream = Stream.of_string "\"\"" in
  parse_string stream = Some (String "")
let %test _ =
  let stream = Stream.of_string "\"hello" in
  parse_string stream = None
let %test _ =
  let stream = Stream.of_string "hello\"" in
  parse_string stream = None
let %test _ =
  let stream = Stream.of_string "" in
  parse_string stream = None

let %test _ =
  let stream = Stream.of_string "add" in
  parse_id stream = Some (Id "add")
let %test _ =
  let stream = Stream.of_string "1add" in
  parse_id stream = None
let %test _ =
  let stream = Stream.of_string "" in
  parse_id stream = None


let %test _ =
  let stream = Stream.of_string "123" in
  parse_exp stream = Some (Integer 123)
let %test _ =
  let stream = Stream.of_string "\"hello\"" in
  parse_exp stream = Some (String "hello")
let %test _ =
  let stream = Stream.of_string "add" in
  parse_exp stream = Some (Id "add")
let %test _ =
  let stream = Stream.of_string "   " in
  parse_exp stream = None
let %test _ =
  let stream = Stream.of_string "" in
  parse_exp stream = None

let %test _ =
  let stream = Stream.of_string "(hello)" in
  parse_sexp stream = Some (Sexp [Id "hello"])
let %test _ =
  let stream = Stream.of_string "(print \"hello\" 123)" in
  parse_sexp stream = Some (Sexp [Id "print"; String "hello"; Integer 123])
let %test _ =
  let source = "(print (inc (x) (add x 1)))" in
  let stream = Stream.of_string source in
  parse_sexp stream = Some
    (Sexp [Id "print";
      Sexp [Id "inc";
        Sexp [Id "x"];
        Sexp [Id "add"; Id "x"; Integer 1]]])
let %test _ =
  let stream = Stream.of_string "(print" in
  parse_sexp stream = None
let %test _ =
  let stream = Stream.of_string "" in
  parse_sexp stream = None
let %test _ =
  let stream = Stream.of_string "()" in
  parse_sexp stream = Some (Sexp [])
let %test _ =
  let stream = Stream.of_string "(123)" in
  parse_sexp stream = Some (Sexp [Integer 123])