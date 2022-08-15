# Jubalisp

## Introduction

Jubalisp is an unpretentious toy programming language based on the lisp syntax.
I'm working on this project because I want to find by myself how to implement some features like:
* only unary functions
  * all functions can have only one parameter
  * if you need more, just return a new function with one parameter
* closures
* lazy evaluation
* syntactic sugar
* ...

## Build and try

### Dependencies

Please install `ocaml` and its build system `dune`.

### Try it!

Be sure to be in the Jubalisp repository and run this command:

```bash
dune exec jubalisp samples/overview.lisp
```

## Quick overview

Here is an excerpt of a Jubalisp program:
```lisp
; Print some messages on stdout.
(print "Hello world! I'm Juba and I'm never late.")
(print "My tutor is a heartless despot.")

; Print 3 on stdout.
(print (+ 1 2))

; Another way to write the above expression.
(print ((+ 1) 2))

; Print lower on stout (1 is lower than 2, isn't it?).
(if
  (< 1 2) ; condition
  (print "lower") ; then branch
  (print "greater")) ; else branch

; Define a new function that decrements a value.
(define dec (lambda x (- x 1)))

; Use this new function, print 4 on stdout.
(print (dec 5))

; Define the factorial.
(define jubafact
    (lambda n
        (if
            (<= n 1)
            n
            (* n (jubafact (dec n))))))

; Print 120 on stdout.
(print (jubafact 5))

; Make a function that generates incrementers.
(define make-inc (lambda x (+ x)))

; Use make-inc to make a simple increment function.
(define inc-by-one (make-inc 1))

; Print 6 on stdout.
(print (inc-by-one 5))

; Use make-inc to make a simple increment by two function.
(define inc-by-two (make-inc 2))

; Print 7 on stdout.
(print (inc-by-two 5))

; Yes, even macros... Print ko on stdout.
(define iffalse (if false))
(iffalse (print "ok") (print "ko"))
```

## All functions have only one argument

All function in Jubalisp take only one argument (no need more).
So why `(+ 1 2)` from the previous section takes two args?
In fact, it's not the case.
A syntactic sugar preprocessor converts this expression into `((+ 1) 2)`.
To be more precise, the `+` function takes one argument (`1` in this example) and returns a function (a closure) that also takes one argument (`2` in the example).
This last function computes the addition of `1` and `2`.
If you know another language like Python, here is how this little expression could be implemented:

```python
def add(x):
    def add2(y):
        return x + y
    return add2

add(1)(2)
```

## Macro are like functions, but lazy

The difference between a function and a macro lies in lazy evaluation.
For example, when you write `(+ (- 1 2) 3)`, all the arguments (`(- 1 2)` and `3`) are evaluated before calling `+`.

However, that's not the case with `if` because it's a macro.
It would not be very useful if all of these arguments were evaluated like previously explained.
If that was the case, `(if true (print "true") (print "false"))` would print `true` and `false` on stdout because both branches would be evaluated.
So, in fact, `if` choose which of its arguments it will eval.
In this example, it will eval the condition (the first argument, that is `true`) and choose to eval the second argument `(print "true")`.
If the condition wasn't `true`, it would have chosen the third argument.

Here is the short list of already implemented macros:
* `if`
* `lambda`

For the moment, there is no features to directly make macro in a Jubalisp program.
They will come soon.

## Builtins are special

Some macros and functions cannot be implemented into in full Jubalisp (for example: the addition, `if` and `lambda` macros, etc.).
All these ones are builtins.
They act like regular functions or macros but are implemented in the Jubalisp interpreter (in OCaml).

## How does it work?

Jubalisp is an interpreted programming language.
A Jubalisp program goes through a pipeline like this one:
```
Jubalisp source code
         |
         V
       Parser
         |
         V
        sexp
         |
         V
    Preprocessors
         |
         V
        sexp
         |
         V
        Eval
         |
         V
        sexp
```

**Parser**

The parse takes in input a source code written in Jubalisp.
Its goal is to convert this string into a valid AST (a s-expression, abbreviated `sexp`).
Currently, the parser is build thanks to home made parser combinators.
The implementation is not really beautiful and must be improved.

**Preprocessors**

The `sexp` produced by the parser goes into several preprocessors (only one for the moment). 
These ones can change the structure of the `sexp`.
For example, the syntactic sugar preprocessor converts an expression like `(+ 1 2)` into `((+ 1) 2)` (only one argument function, do you remember?).

**Eval**

This step evaluates the `sexp`.
That's where the Jubalisp program is executed.

## Todo

* Make the code cleaner.
* Better error handling with more informative messages.
* In a general way, make this language more useful.
* Syntactic sugar for functions with no parameter (unit).
* Add data structures (list, array, hashmap and others).
* Parser refactoring.
* Better code organisation.
* Implement macros in Jubalisp.
* Add better tests and refactore the existing ones (I have to learn more about `ppx_expect`, `ppx_assert`, etc.)
* Allow Jubalisp to be used like a lib where the user can customize preprocessors, etc.
* A compilator based on LLVM.
* A transpiler to JS and Python.
* Tail call optimisation.
* A lot of things...

## FAQ

### What's the purpose of this language?
Just a fun side project to implement some interesting features.

### (Why (using (lisp (syntax)))?
I'm not very interested by the parsing step.
So I choose the cleanest and easiest existing syntax: parenthesis (parenthesis all around the world!).