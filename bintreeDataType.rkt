#lang eopl
;; Bintree ::= () | (Int Bintree Bintree)

;; Diseñar una interfaz para un tipo de datos recursivo
;;   1. Incluya un constructor para cada tipo de datos en el tipo de datos.
;;   2. Incluya un predicado para cada tipo de datos en el tipo de datos.
;;   3. Incluya un extractor por cada dato pasado a un constructor del tipo de datos.


;; CONSTRUCTOR

(define-datatype bintree bintree?
  (empty-bintree)
  (bintree-exp
   (numero number?)
   (left bintree?)
   (right bintree?)))

;; EXTRACTORES

(define empty-bintree?
  (lambda (param)
     (cases bintree param
      (empty-bintree () #t)
      (bintree-exp (n l r) #f))))

(define current-element
  (lambda (arbol)
    (cases bintree arbol
      (empty-bintree () '())
      (bintree-exp (n l r) n))))

(define move-to-left-son
  (lambda (arbol)
    (cases bintree arbol
      (empty-bintree () (eopl:error 'move "you can not move to left an item from empty-bintree"))
      (bintree-exp (n l r) l))))

(define move-to-right-son
 (lambda (arbol)
    (cases bintree arbol
      (empty-bintree () (eopl:error 'move "you can not move to right an item from empty-bintree"))
      (bintree-exp (n l r) r))))

(define number-to-bintree
  (lambda (numero)
    (bintree-exp numero (empty-bintree) (empty-bintree))))

(define at-leaf?
  (lambda (arbol)
     (cases bintree arbol
      (empty-bintree () (eopl:error 'move "you can not say at-leaf? an item from empty-bintree")) ;; valid true?
      (bintree-exp (n l r)
                   (and
                    (empty-bintree? l)
                    (empty-bintree? r))))))

(define bintree-with-at-least-one-child?
 (lambda (arbol)
     (cases bintree arbol
      (empty-bintree () (eopl:error 'move "you can not say at-leaf? an item from empty-bintree"))
      (bintree-exp (n l r)
                   (or (not (empty-bintree? l))
                       (not (empty-bintree? r)))))))


;; FUNCIONES


(define insert-to-left
  (lambda (numero arbol)
     (cases bintree arbol
      (empty-bintree () (eopl:error 'move "you can not insert to left an item from empty-bintree"))
      (bintree-exp (n l r)
                   (bintree-exp n (number-to-bintree n) r)
                   ))))

(define insert-to-right
  (lambda (numero arbol)
     (cases bintree arbol
      (empty-bintree () (eopl:error 'move "you can not insert to right an item from empty-bintree"))
      (bintree-exp (n l r)
                   (bintree-exp n l (number-to-bintree n))
                   ))))


;; EPIC HARD

(define bintree-order-validation
  (lambda (arbol)
    (and
     (aux (current-element arbol) (move-to-left-son arbol) >)
     (aux (current-element arbol) (move-to-right-son arbol) <)
     (if ( empty-bintree? (move-to-left-son arbol)) #t (bintree-order-validation (move-to-left-son arbol)))
     (if ( empty-bintree? (move-to-right-son arbol)) #t (bintree-order-validation (move-to-right-son arbol))))))

(define aux
  (lambda (cabeza comparar op)
    [if (empty-bintree? comparar) #t
        (op cabeza (current-element comparar))]))



;; SAVE STATES
(define insert-element-into-bintree
  (lambda (arbol n)
    (cond
      [(empty-bintree? arbol)  (number-to-bintree n)]
      [(= (current-element arbol) n) arbol]
      [(> (current-element arbol) n)
       (bintree-exp
        (current-element arbol)
        (insert-element-into-bintree (move-to-left-son arbol) n)
        (move-to-right-son arbol))]
      [else
       (bintree-exp
        (current-element arbol)
        (move-to-left-son arbol)
        (insert-element-into-bintree (move-to-right-son arbol) n))])))


;;PARSER
(define parser
   (lambda (param)
     (cond
       [(null? param) (empty-bintree)]
       [(list? param) (bintree-exp (car param) (parser (cadr param)) (parser (caddr param)))]
       [else (eopl:error 'parser "Invalid concret sintax ~s" param)]
       )))


;; UNPARSER
(define unparser
    (lambda (param)
     (cases bintree param
      (empty-bintree () '())
      (bintree-exp (n l r)
                   (list n (unparser l) (unparser r))))))



; Ejemplos
(define arbolito (bintree-exp 1 (empty-bintree) (empty-bintree)))
(define arbolito2 (bintree-exp 10 (bintree-exp 1 (empty-bintree) (empty-bintree)) (empty-bintree)))
(define arbolito3 (bintree-exp 1  (empty-bintree) (bintree-exp 10 (empty-bintree) (empty-bintree))))
(define arbolito4 (bintree-exp 5
                               (bintree-exp 1 (empty-bintree) (empty-bintree))
                               (bintree-exp 10 (empty-bintree) (empty-bintree))))

(define arbol (parser '(8 (3 (1 () ()) (6 (4 () ()) (7 () ()))) (10 () (14 (13 () ()) ())))))
