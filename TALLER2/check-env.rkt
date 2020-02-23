#lang eopl

;; Miguel Ángel Cardona Chamorro
;; 1628209

;; Ambientes Listas
;; TOMADO DE EJERCICIOS ANTERIORES Y EL LIBRO

;; empty-env: () => env
;; crea un ambiente vacio
(define empty-env (lambda () (list 'empty-env)))

;; extend-env: var x val x env => env 
;; crea ambientes extendidos basicos
(define extend-env
  (lambda (var val env)
    (list 'extend-env var val env)))

;; apply-env : env x var => valor
;; devuelve el valor de una variable
(define apply-env
  (lambda (env search-var)
    (cond [(eqv? (car env) 'empty-env)(error-var search-var)]
          [(eqv? (car env) 'extend-env)
             (if (eqv? search-var (cadr env))(caddr env)
                 (apply-env (cadddr env) search-var))]
          [else (error-env env)])))

;; extend-env* : vars x vasl x env => env 
;; crea ambientes con listas de variables y lista de valores
(define extend-env*
  (lambda (vars vals env)
     (list 'extend-env* vars vals env)))

;; check-env
;; check-env: env x nivel => lista de parejas
;; busca en un ambiente por nivel y retorna una lista de parejas que estan en dicho nivel
(define check-env
  (lambda (env level) (check-aux env level (count-env env))))


;; funciones auxliares

;; count-env : env => number
;; cuenta la cantidad de sub ambientes (niveles) que tiene un ambiente
(define count-env
  (lambda (env)
     (cond
        [(eqv? (car env) 'empty-env) 0]
        [else (+ 1 (count-env (cadddr env)))])))

;; check-aux: env x nivel x contador => pareja
;; busca el nivel que solicita, usando un contador auxiliar que se decramenta hasta llegar
;; al caso que el buscado se igual al nivel auxiliar
(define check-aux
  (lambda (env level count)
    (cond
      [(= level count) (join env)]
      [(< level count) (check-aux (cadddr env) level (- count 1))]
      [else (error-check)])))


;; join: env => lista de parejas
;; crea las listas de parejas segun el tipo ambiente.
(define join
  (lambda (env)
    (cond [(eqv? (car env) 'empty-env) '()]
          [(eqv? (car env) 'extend-env) (list (list (cadr env) (caddr env)))]
          [(eqv? (car env) 'extend-env*) (join-aux (cadr env) (caddr env))])))


;; join-aux : lista x lista => lista
;; une las cabezas de las listas formando una lista de parejas en caso exted*
(define join-aux
  (lambda (lista1 lista2)
  (if (null? lista1) '() (cons (list (car lista1) (car lista2)) (join-aux (cdr lista1) (cdr lista2))))))


;; msg error's
(define error-var (lambda (var) (eopl:error 'apply-env "No binding for ~s" var)))
(define error-env (lambda (var) (eopl:error 'apply-env "Expecting an environment, given ~s" var)))
(define error-check (lambda () (eopl:error 'check-env "Not possible to search depth on environment" )))


;; test ambientes
(define e (extend-env 'y 8 (extend-env* '(x z w) '(1 4 5) (extend-env 'a 7 (empty-env)))))
(define x (extend-env* '(a b c) '(1 2 3) (empty-env)))


;;test
(check-env e 0)
(check-env e 1)
(check-env e 2)
(check-env e 3)
;;(check-env e 4) NICE ERROR CONTROL => OK!
