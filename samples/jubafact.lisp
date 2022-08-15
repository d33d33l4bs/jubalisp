(define jubafact
    (lambda n
        (if
            (<= n 1)
            n
            (* n (jubafact (- n 1))))))

(print (jubafact 1))
(print (jubafact 2))
(print (jubafact 3))
(print (jubafact 4))
(print (jubafact 5))