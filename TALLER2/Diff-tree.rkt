#lang racket

;; Miguel Ángel Cardona Chamorro
;; 1628209


;; Grammar
;; Diff-tree ::= (one) | (diff Diff-tree Diff-tree)

;; Tip Pro
;; Designing an interface for a recursive data type
;; 1. Include one constructor for each kind of data in the data type.
;; 2. Include one predicate for each kind of data in the data type.
;; 3. Include one extractor for each piece of data passed to a constructor of the data type.

;; Constructor
; one: () => Diff-tree
; crea una interfaz con listas Diff-tree caso de ser uno
(define one (lambda () '(one)))

; diff: Diff-tree x Diff-tree => Diff-tree
; crea una interfaz con listas Diff-tree caso de ser una diferencia
(define diff (lambda (n1 n2) (list 'diff n1 n2)))

;; Observers: predicate

; one?: Diff-tree => bool
;; verificamos si algo es uno
(define one? (lambda (diff-tree) (eqv? (car diff-tree) 'one)))

; diff?: Diff-tree => bool
;; verificamos si algo es diferencia
(define diff? (lambda (diff-tree) (eqv? (car diff-tree) 'diff)))

;; Observers: extractor
; diff->n1: Diff-tree => Diff-tree
;; en el caso de ser difs extraaemos el operdor 1
(define diff->n1 (lambda (diff-tree) (cadr diff-tree)))

; diff->n2: Diff-tree => Diff-tree
;; en el caso de ser difs extraaemos el operdor 2
(define diff->n2 (lambda (diff-tree) (caddr diff-tree)))



;; función auxiliar que tomara un dato de tipo diff-tree y calculara su valor,
;; permite conocer y trabajar de forma facil con los valores reales (numeros) del arbol.
(define diff->number (lambda (diff-tree)
                       (if (one? diff-tree) 1
                           (- (diff->number (diff->n1 diff-tree))
                              (diff->number (diff->n2 diff-tree))))))


;; Constructor
;; zero: () => diff-tree
;; cre una representacion de cero en forma de diff-tree
(define zero (lambda () (diff '(one) '(one))))

;; Observers: predicate
;; is-zero?: diff-tree => bool
;; analizar si el diff es cero
(define is-zero? (lambda (diff-tree) (= 0 (diff->number diff-tree))))


;; successor: diff-tree => diff-tree
;; Definición de la función successor, suma 1 a un valor n, con la representacion de 1 - ( cero - n) = 1 + n.
(define successor (lambda (diff-tree) (diff (one) (diff (zero) diff-tree))))

;; predecessor: diff-tree => diff-tree
;; Definición de la función predecessor, resta 1 a un valor n, con la representacion de (n - 1).
(define predecessor (lambda (diff-tree) (diff diff-tree (one))))


;; diff-tree-plus: diff-tree x diff-tree => diff-tree
;; Definición de la función Suma, diff-tree + diff-tree.
;; se suman dos numeros con base a la representacion n1 - (zero - n2) = n1 + n2.
(define diff-tree-plus (lambda (n1 n2) (diff n1 (diff (zero) n2))))

;pruebas de variables sencillas.

;; listas
(define cero-lista  '(diff (one) (one)))
(define menos-uno-lista '(diff (diff (one) (one)) (one)))
(define uno-lista  (one))
(define dos-lista  (diff-tree-plus (one) (one)))

;; decimal
(define cinco-decimal (diff->number  (successor (successor (diff-tree-plus dos-lista uno-lista)))))
(define uno-decimal (diff->number '(diff (one) (diff (one) (one)))))
(define  menos-uno-decimal (diff->number menos-uno-lista))









