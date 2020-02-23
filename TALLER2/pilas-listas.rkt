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

;; CONSTRUCTOR
;; empty-stack : () => Stack
;; crea elemento de tipo empty-stack
(define empty-stack (lambda () (list 'empty-stack)))

;; push : Sym x Stack => Stack
;; Insertar elemento en una pila.
(define push (lambda (sym Stack) (list 'push sym Stack)))

;; pop : Stack => Stack
;; Retira el elemento superior de la pila.
(define pop (lambda (Stack)
                    (if (empty-stack? Stack)
                        (eopl:error 'pop "you can not remove an item from empty-stack")
                        (caddr Stack))))

;; OBSERVADOR - PREDICADO
;; empty-stack?: Stack => bool
;;Predicado que se encarga de preguntar si la pila esta vacıa.
(define empty-stack? (lambda (Stack) (eqv? (car Stack) 'empty-stack)))

;; OBSERVADOR - EXTRACTOR
;; top : Stack => Stack
;; Devuelve el elemento superior de la pila. (sin retirarlo) si es el caso de  la pila vacia
;; devuelve nulo, pero podria ser cualquier otro valor arbitrario o un error.
(define top (lambda (Stack)
                    (if (empty-stack? Stack) 'null (cadr Stack))))

;; Ejemplos de prueba
(define vacio (empty-stack))
(define test (push 'a (push 'b vacio)))
(define long (push 'x (push 'y (push 'z (push 'a (push 'b vacio))))))

(top vacio)
(top test)
(top long)

(empty-stack?  vacio)
(empty-stack?  test)

;;(pop vacio) NICE! 
(pop test)
(pop long)

