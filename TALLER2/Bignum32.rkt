#lang racket


;; Miguel Ángel Cardona Chamorro
;; 1628209


;REPRESENTACIÓN NÚMEROS BIGNUM WITH N => 32
;Representación: Definición de funciones para representación de datos para numeros grandes Bigits con N = 32

; zero: () => lista vacia
; Definicion de zero en la interfaz, una lista vacia
(define zero (lambda () '()))

; is-zero? lista => bool
; Definicion del predicado is-zero, retorna un bool segun sea un zero en Bignum
(define is-zero? (lambda (n) (null? n)))


; successor: lista => lista
; Definicion de la funcion successor, suma 1 en la representacion Bignum, si llegara a ser el caso que el numero a sumar
; sea (N-1), se agrega la siguiente cifra a la derecha.
(define successor (
                   lambda (n)
                    (cond
                      [(null? n ) '(1)]
                      [(= (car n) (- 32 1)) (cons 0 (successor (cdr n)))]
                      [else (cons (+ (car n ) 1) (cdr n))])))

; predecessor: lista => lista
; Definicion de la funcion predecessor, resta 1 en la representacion Bignum, si llegara a ser el caso que el numero a restar
; sea 0, se quita una cifra.
(define predecessor (
                   lambda (n)
                    (cond
                      [(equal? n '(1)) '()]
                      [(= (car n) 0) (cons (- 32 1) (predecessor (cdr n)))]
                      [else (cons (- (car n ) 1) (cdr n))])))
                      
;CÓDIGO CLIENTE: Operaciones sobre datos ya definida anteriormente en clase
(define suma
  (lambda (x y)
    (if (is-zero? x)
        y
        (successor (suma (predecessor x) y)))))

(define resta
  (lambda (x y)
    (if (is-zero? y)
        x
        (predecessor (resta  x (predecessor y))))))

(define multiplicacion
  (lambda (x y)
    (if (is-zero? x)
        (zero)
        (suma (multiplicacion (predecessor x) y) y))
    ))
    
(define potencia
  (lambda (x y)
    (if (is-zero? y)
        (successor y)
        (multiplicacion (potencia x (predecessor y)) x))))

(define factorial
  (lambda (n)
    (if (is-zero? n)
        (successor n)
        (multiplicacion n (factorial (predecessor n))))))

;Invocación de funciones utilizando representación Números con bigNum, N => 32
(suma '() '(1))
(suma '(0 1) '(1))
(resta '(1) '(1))
(resta '(0 1) '(1))
(multiplicacion '(1) '(0 1))
(multiplicacion  '(2) '(1 1))
(potencia '(3) '(2))
(potencia '(4) '(4))
(factorial '(2))
(factorial '(3))
