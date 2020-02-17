#lang racket
;; Bintree ::= () | (Int Bintree Bintree)

;; Diseñar una interfaz para un tipo de datos recursivo
;;   1. Incluya un constructor para cada tipo de datos en el tipo de datos.
;;   2. Incluya un predicado para cada tipo de datos en el tipo de datos.
;;   3. Incluya un extractor por cada dato pasado a un constructor del tipo de datos.


;; CONSTRUCTOR

;; empty-bintree : () => bintree 
(define empty-bintree (lambda () '()))

;; bintree : int x bintree x bintree => bintree 
(define bintree (lambda (int left right) (list int left right)))

;; PREDICADOS

;; empty-bintree?:: bintree => bool
(define empty-bintree? (lambda (param) (null? param)))

;; bintree?: bintree => bool
(define bintree? (lambda (param)
                   [cond
                    ((empty-bintree?  param) #t)
                    ((number? (car param)) (and (bintree? (cadr param)) (bintree? (caddr param))))
                    (else  #f)]))

;; Extractores
(define current-element (lambda (arbol) (car arbol)))

(define move-to-left-son (lambda (arbol) (cadr arbol)))

(define move-to-right-son (lambda (arbol) (caddr arbol)))

(define number-to-bintree (lambda (numero) (list numero '() '())))

(define at-leaf? (lambda (arbol)
                   (and (number? (car arbol)) (null? (cadr arbol)) (null? (caddr arbol)))))

(define bintree-with-at-least-one-child? (lambda (arbol)
                   (and (number? (car arbol)) (null? (cadr arbol)) (null? (caddr arbol)))))

; Ejemplos
(define arbolito (bintree 1 '() '()))
(define arbol (bintree 3 (bintree 1 (bintree 5 '() '()) '()) (bintree 2 '() '())))
(define arbol2 (bintree 3 (bintree 5 '() '()) '()))
(define no-arbol (bintree 'a (bintree 1 (bintree 5 'b '()) '()) (bintree 2 '() '())))

