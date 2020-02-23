#lang eopl

;; Miguel Ángel Cardona Chamorro
;; 1628209

;; Bintree ::= () | (Int Bintree Bintree)

;; Diseñar una interfaz para un tipo de datos recursivo
;;   1. Incluya un constructor para cada tipo de datos en el tipo de datos.
;;   2. Incluya un predicado para cada tipo de datos en el tipo de datos.
;;   3. Incluya un extractor por cada dato pasado a un constructor del tipo de datos.


;; CONSTRUCTOR

;; empty-bintree : () => bintree
;; crea elementos de tipo bintree empty
(define empty-bintree (lambda () '()))

;; bintree: int x bintree x bintree => bintree
;; crea elementos de tipo bintree
(define bintree (lambda (int left right) (list int left right)))


;; PREDICADOS

;; empty-bintree?:: bintree => bool

(define empty-bintree? (lambda (param) (null? param)))

;; bintree?: bintree => bool
;; retorna si un elemento es de tipo empty-bintree
(define bintree? (lambda (param)
                   [cond
                    ((empty-bintree?  param) #t)
                    ((number? (car param)) (and (bintree? (cadr param)) (bintree? (caddr param))))
                    (else  #f)]))

;; Extractores

;; current-element : bintree => number
;; retorna el valor del la raiz de un arbol
(define current-element
  (lambda (arbol) (car arbol)))

;; move-to-left-son : bintree => number
;; retorna el sub arbol izquierdo
(define move-to-left-son
  (lambda (arbol) (cadr arbol)))

;; move-to-right-son : bintree => number
;; retorna el sub arbol derecho
(define move-to-right-son
  (lambda (arbol) (caddr arbol)))

;; number-to-bintree : number => bintree
;; que recibe un numero y lo transforma a un
;; ́arbol binario en la gramatica utilizada, sin hijos inicialmente.
(define number-to-bintree
  (lambda (numero) (list numero '() '())))

;; at-leaf? : bintree => bool
;; pregunta si la posicion actual es un arbol hoja
(define at-leaf?
  (lambda (arbol)
    (and (empty-bintree? (cadr arbol)) (empty-bintree? (caddr arbol)))))

;; bintree-with-at-least-one-child?: bintree => bool
;; si en donde se encuentra actualmente
;; es un  ́arbol con al menos un hijo
(define bintree-with-at-least-one-child?
  (lambda (arbol)
    (or (not (empty-bintree? (cadr arbol))) (not (empty-bintree? (caddr arbol))))))


;; Funciones

;; insert-to-left: number x bintree => bintree
;; inserta dicho n ́umero, convertido en  ́arbol binario, a la
;; izquierda del  ́arbol 
(define insert-to-left
  (lambda (numero arbol)
    (list (car arbol) (number-to-bintree numero) (caddr arbol))))

;; insert-to-right number x bintree => bintree
;; inserta dicho numero, convertido en  ́arbol binario, a la
;; derecha del arbol 
(define insert-to-right
  (lambda (numero arbol)
    (list (car arbol)  (cadr arbol) (number-to-bintree numero))))



;; EPIC HARD
;; bintree-order-validation: bintree => bool
;; valida su propiedad de orden con validaciones anidadas con el uso del AND
;; se recorre todo el arbol validando la propuidad de orde, si todas son verdad retornara verdadero.
(define bintree-order-validation
  (lambda (arbol)
    (and
     (aux (current-element arbol) (move-to-left-son arbol) >)
     (aux (current-element arbol) (move-to-right-son arbol) <)
     (if (empty-bintree? (move-to-left-son arbol)) #t (bintree-order-validation (move-to-left-son arbol)))
     (if (empty-bintree? (move-to-right-son arbol)) #t (bintree-order-validation (move-to-right-son arbol))))))

;; aux: bintree => bool
;; compara sin arbol esta ordenado, con el caso base que un arbol vacio esta trivialmente ordenado.
;; y el caso general que nodo es menor o mayor, que sus hijos izquierdo y derecho respectivamente.
(define aux
  (lambda (cabeza comparar op)
    [if (empty-bintree? comparar) #t
        (op cabeza (current-element comparar))]))


;; SAVE STATES

;; insert-element-into-bintree: bintree x n => bintree
;; navega en el arbol buscando un numero, si lo encuentra retorna el arbol,
;; sino lo agrega en la posicion correcta.
(define insert-element-into-bintree
  (lambda (arbol n)
    (cond
      [(empty-bintree? arbol)  (number-to-bintree n)]
      [(= (current-element arbol) n) arbol]
      [(> (current-element arbol) n)
       (bintree
        (current-element arbol)
        (insert-element-into-bintree (move-to-left-son arbol) n)
        (move-to-right-son arbol))]
      [else
       (bintree
        (current-element arbol)
        (move-to-left-son arbol)
        (insert-element-into-bintree (move-to-right-son arbol) n))])))
      
     
; Ejemplos
(define arbolito (bintree 1 '() '()))
(define arbolito2 '(8 (3 (1 () ()) (6 (4 () ()) (7 () ()))) (10 () (14 (13 () ()) ()))))
(define arbol (bintree 3 (bintree 1 (bintree 5 '() '()) '()) (bintree 2 '() '())))
(define arbol2 (bintree 3 (bintree 1 '() '()) '()))
(define arbol3 (bintree 3 '() (bintree 5 '() '()) ))
(define no-arbol (bintree 'a (bintree 1 (bintree 5 'b '()) '()) (bintree 2 '() '())))

(insert-element-into-bintree arbolito2 2)
(bintree-order-validation arbolito2)
(bintree-order-validation arbol)
