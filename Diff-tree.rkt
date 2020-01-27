#lang racket

;; Grammar
;; Diff-tree ::= (one) | (diff Diff-tree Diff-tree)


;; Tip Pro
;; Designing an interface for a recursive data type
;; 1. Include one constructor for each kind of data in the data type.
;; 2. Include one predicate for each kind of data in the data type.
;; 3. Include one extractor for each piece of data passed to a constructor of the data type.

;; Constructor
(define one (lambda () '(one)))
(define diff (lambda (n1 n2) (list 'diff n1 n2)))

;; Observers: predicate
(define one? (lambda (diff-tree) (eqv? (car diff-tree) 'one)))
(define diff? (lambda (diff-tree) (eqv? (car diff-tree) 'diff)))

;; Observers: extractor
(define diff->n1 (lambda (diff-tree) (cadr diff-tree)))
(define diff->n2 (lambda (diff-tree) (caddr diff-tree)))



;; función auxiliar que tomara un dato de tipo diff-tree y calculara su valor,
;; permite conocer y trabajar de forma facil con los valores reales (numeros) del arbol.
(define diff->number (lambda (diff-tree)
                       (if (one? diff-tree) 1
                           (- (diff->number (diff->n1 diff-tree))
                              (diff->number (diff->n2 diff-tree))))))


;; Constructor
(define zero (lambda () (diff '(one) '(one))))

;; Observers: predicate
(define is-zero? (lambda (diff-tree) (= 0 (diff->number diff-tree))))

;; Definición de la función successor, suma 1 a un valor n, con la representacion de 1 - ( cero - n) = 1 + n.
(define successor (lambda (diff-tree) (diff (one) (diff (zero) diff-tree))))

;; Definición de la función predecessor, resta 1 a un valor n, con la representacion de (n - 1).
(define predecessor (lambda (diff-tree) (diff diff-tree (one))))

;; Definición de la función Suma, diff-tree + diff-tree.
;; se suman dos numeros con base a la representacion n1 - (zero - n2) = n1 + n2.
(define diff-tree-plus (lambda (n1 n2) (diff n1 (diff (zero) n2))))

;pruebas de variables sencillas.
(define cero  (lambda () (diff (one) (one))))
(define menos  (lambda () (diff (diff (one) (one)) (one))))
(define uno  (lambda () (one)))
(define dos  (lambda () (diff-tree-plus (uno) (uno))))
(define cinco (lambda () (diff->number  (successor (successor (diff-tree-plus (dos) (uno)))))))
