#lang eopl

(define-datatype prefix-exp prefix-exp?
  (const-exp (num integer?))
  (diff-exp
    (operand1 prefix-exp?)
    (operand2 prefix-exp?)))

(define parse-prefix-exp
  (lambda (lista)
    (cond
      [(integer? (car lista)) (cons (const-exp (car lista)) (cdr lista))]
      [(equal? (car lista) '-) (diff (cdr lista))]
      [else (error-parse-exp lista)])))

(define diff
  (lambda (lista)
    (let*
     [(minuendo (parse-prefix-exp lista))
      (sustraendo (parse-prefix-exp (cdr minuendo)))]
     (cons (diff-exp (car minuendo) (car sustraendo))
            (cdr sustraendo)))))

(define parse-prefix-list
  (lambda (datum)
  (if (list? datum)
      (car (parse-prefix-exp datum))
      (error-parse-list datum))))


;; msg error's
(define error-parse-list (lambda (var) (eopl:error 'prefix-list "Invalid concrete syntax for list, Give: ~s" var)))
(define error-parse-exp (lambda (var) (eopl:error 'prefix-exp "Invalid concrete syntax in exp, Give: ~s" var)))
