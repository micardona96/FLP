#lang eopl
;; Define Grammar
;; Stack ::= (empty-stack)
;;       ::= (push-stack symbol Stack)

;; (empty-stack)                 => '(empty-stack)
;; (push-stack A [v1 v2 v3])     => [A v1 v2 v3]
;; (pop-stack [A v1 v2])         => [v1 v2]

;; (top-stack [A v1 v2])         => A

;; (empty-stack? Element)        => #t if Element is a Stack
;;                               => #f otherwise


;; CONSTRUCTOR
;; empty-stack : () => Stack 
(define empty-stack (lambda () (list 'empty-stack)))

;; push-stack : Sym x Stack => Stack
(define push-stack (lambda (sym Stack) (list 'push-stack sym Stack)))

;; pop-stack : Stack => Stack
(define pop-stack (lambda (Stack)
                    (if (empty-stack? Stack)
                        (eopl:error 'pop "you can not remove an item from empty-stack")
                        (caddr Stack))))

;; OBSERVADOR - PREDICADO
;; empty-stack?: Stack => bool
(define empty-stack? (lambda (Stack) (eqv? (car Stack) 'empty-stack)))

;; OBSERVADOR - EXTRACTOR
;; top-stack : Stack => Stack
(define top-stack (lambda (Stack)
                    (if (empty-stack? Stack) 'null (cadr Stack))))

;; Ejemplos de prueba
(define vacio (empty-stack))
(define test (push-stack 'a (push-stack 'b vacio)))
(define long (push-stack 'a (push-stack 'b (push-stack 'b (push-stack 'c (push-stack 'd vacio))))))
