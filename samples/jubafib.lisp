(define jubafib
    (lambda n
        (if
            (<= n 1)
            n
            (+
                (jubafib (- n 1))
                (jubafib (- n 2))))))

(print (jubafib 20))