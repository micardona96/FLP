#lang eopl
;; Define Grammar
;; Stack ::= (empty-stack)
;;       ::= (push-stack symbol Stack)

;; (empty-stack)                 => (empty-stack)
;; (push-stack A |[v1 v2 v3]|)   => |[A v1 v2 v3]|
;; (pop-stack |[A v1 v2...]|)    => |[v1 v2]|

;; (top-stack |[A v2 v3...]|)    => A
;; (empty-stack? Element)        => #t if Element is a Stack
;;                               => #f otherwise

;; CONSTRUCTORES Y PREDICADOS
(define-datatype stack stack?
  (empty-stack)
  (push-stack (element symbol?)
              (pila stack?)))
   
;; EXTRACTORES

(define empty-stack?
  (lambda (element)
    (cases stack element
      (empty-stack () #t)
      (push-stack (e s) #f))))

(define pop-stack
  (lambda (pila)
    (cases stack pila
      (empty-stack () (eopl:error 'pop "you can not remove an item from empty-stack"))
      (push-stack (element rest) rest))))

(define top-stack
  (lambda (pila)
    (cases stack pila
      (empty-stack () 'null)
      (push-stack (element rest) element))))


(define pilita (push-stack 'a (push-stack 'b (push-stack 'c (empty-stack)))))
(define vacio (empty-stack))
