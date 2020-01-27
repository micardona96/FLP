#lang racket

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

;pruebas de variables sencilla.
(define valor (diff (one) (diff (one) (one))))
(define basico (one))
