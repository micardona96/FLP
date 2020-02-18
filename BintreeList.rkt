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
;; addd validation to is-bintree? ???????

(define current-element
  (lambda (arbol) (car arbol)))

(define move-to-left-son
  (lambda (arbol) (cadr arbol)))

(define move-to-right-son
  (lambda (arbol) (caddr arbol)))

(define number-to-bintree
  (lambda (numero) (list numero '() '())))

(define at-leaf?
  (lambda (arbol)
    (and (empty-bintree? (cadr arbol)) (empty-bintree? (caddr arbol)))))

(define bintree-with-at-least-one-child?
  (lambda (arbol)
    (or (not (empty-bintree? (cadr arbol))) (not (empty-bintree? (caddr arbol))))))


;; Funciones

(define insert-to-left
  (lambda (numero arbol)
    (list (car arbol) (number-to-bintree numero) (caddr arbol))))

(define insert-to-right
  (lambda (numero arbol)
    (list (car arbol)  (cadr arbol) (number-to-bintree numero))))

;;; no se como funciona realmene

(define bintree-order-validation
  (lambda (arbol)
    (and
     (aux (current-element arbol) (move-to-left-son arbol) >)
     (aux (current-element arbol) (move-to-right-son arbol) <)
     (if (null? (move-to-left-son arbol)) #t (bintree-order-validation (move-to-left-son arbol)))
     (if (null? (move-to-right-son arbol)) #t (bintree-order-validation (move-to-right-son arbol)))
     )))

(define aux
  (lambda (cabeza comparar op)
    [if (null? comparar) #t
        (op cabeza (car comparar))]))

; Ejemplos
(define arbolito (bintree 1 '() '()))
(define arbolito2 '(8 (3 (1 () ()) (6 (4 () ()) (7 () ()))) (10 () (14 (13 () ()) ()))))
(define arbolito3 '(8 (3 (1 () ()) (6 (4 () ()) (7 () ()))) (10 () (14 (20 () ()) ()))))
(define arbol (bintree 3 (bintree 1 (bintree 5 '() '()) '()) (bintree 2 '() '())))
(define arbol2 (bintree 3 (bintree 5 '() '()) '()))
(define arbol3 (bintree 3 '() (bintree 5 '() '()) ))
(define no-arbol (bintree 'a (bintree 1 (bintree 5 'b '()) '()) (bintree 2 '() '())))

