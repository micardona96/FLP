#lang eopl

;; Ambientes Listas

;; empty-env
(define empty-env (lambda () (list 'empty-env)))

;; extend-env
(define extend-env
  (lambda (var val env)
    (list 'extend-env var val env)))

;; apply-env => WITHOUT EXTEND-ENV*
(define apply-env
  (lambda (env search-var)
    (cond [(eqv? (car env) 'empty-env)(error-var search-var)]
          [(eqv? (car env) 'extend-env)
             (if (eqv? search-var (cadr env))(caddr env)
                 (apply-env (cadddr env) search-var))]
          [else (error-env env)])))

;; extend-env*
(define extend-env*
  (lambda (vars vals env)
     (list 'extend-env* vars vals env)))

;; check-env
(define check-env
  (lambda (env level) (check-aux env level (count-env env))))

;; funciones auxliares
;; count-env
(define count-env
  (lambda (env)
     (cond
        [(eqv? (car env) 'empty-env) 0]
        [else (+ 1 (count-env (cadddr env)))])))

;; check-aux
(define check-aux
  (lambda (env level count)
    (cond
      [(= level count) (join env)]
      [(< level count) (check-aux (cadddr env) level (- count 1))]
      [else (error-check)])))

;; crea las parejas segun el tipo ambiente.
(define join
  (lambda (env)
    (cond [(eqv? (car env) 'empty-env) '()]
          [(eqv? (car env) 'extend-env) (list (list (cadr env) (caddr env)))]
          [(eqv? (car env) 'extend-env*) (join-aux (cadr env) (caddr env))])))

;; une las cabezas de las listas formando parejas
(define join-aux
  (lambda (lista1 lista2)
  (if (null? lista1) '() (cons (list (car lista1) (car lista2)) (join-aux (cdr lista1) (cdr lista2))))))


;; msg error's
(define error-var (lambda (var) (eopl:error 'apply-env "No binding for ~s" var)))
(define error-env (lambda (var) (eopl:error 'apply-env "Expecting an environment, given ~s" var)))
(define error-check (lambda () (eopl:error 'check-env "Not possible to search depth on environment" )))


;; test
(define a '(1 2))
(define x (extend-env 'y 8 (extend-env* '(x z w) '(1 4 5) (extend-env 'a 7 (empty-env)))))
(define e (extend-env* '(a b c) '(1 2 3) (empty-env)))
