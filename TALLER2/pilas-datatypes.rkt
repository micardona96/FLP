#lang eopl

;; Miguel Ángel Cardona Chamorro
;; 1628209

;; Define Grammar
;; Stack ::= (empty-stack)
;;       ::= (push symbol Stack)

;; (empty-stack)                 => (empty-stack)
;; (push A |[v1 v2 v3])          => [A v1 v2 v3]
;; (pop [A v1 v2...])            => [v1 v2]

;; (top [A v2 v3...])            => A

;; (empty-stack? Element)        => #t if Element is a Stack
;;                               => #f otherwise

;; CONSTRUCTORES Y PREDICADOS.

;; Crea automaticamente la implemtacion del tipo de dato stack, vacio y con elementos,
(define-datatype stack stack?
  (empty-stack)
  (push (element symbol?)
              (pila stack?)))
   
;; EXTRACTORES
;; empty-stack? : Stack => bool
;; verfica si una elemento es de tipo stack
(define empty-stack?
  (lambda (element)
    (cases stack element
      (empty-stack () #t)
      (push (e s) #f))))

;; pop : Stack => Stack
;; Retira el elemento superior de la stack
(define pop
  (lambda (pila)
    (cases stack pila
      (empty-stack () (eopl:error 'pop "you can not remove an item from empty-stack"))
      (push (element rest) rest))))

;; top : Stack => Stack
;; Devuelve el elemento superior de la pila. (sin retirarlo) si es el caso de la pila vacia
;; devuelve nulo, pero podria ser cualquier otro valor arbitrario o un error.
(define top
  (lambda (pila)
    (cases stack pila
      (empty-stack () 'null)
      (push (element rest) element))))


;; Pruebas basicas

(define pilita (push 'a (push 'b (push 'c (empty-stack)))))
(define vacio (empty-stack))

(top vacio)
(top pilita)

(empty-stack?  vacio)
(empty-stack?  pilita)

;;(pop vacio) NICE! 
(pop pilita)




