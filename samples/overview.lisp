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

; Yes, even macros...
(define iffalse (if false))
(iffalse (print "ok") (print "ko"))