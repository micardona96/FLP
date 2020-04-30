#lang eopl

#|
    Created by Miguel Cardona on 04/04/20.
    Copyright © 2020 Miguel Cardona 1628209. All rights reserved.
|#

;; LEXICAS
(define lexica
  '((espacio (whitespace) skip)
    (comentario ("//" (arbno ( not #\newline ))) skip)
    (texto (letter (arbno (or letter digit))) string)
    (identificador ("$" letter (arbno (or letter digit))) symbol) ;; PHP
    (identificador ("&" letter (arbno (or letter digit))) symbol) ;; C
    (numero (digit (arbno digit)) number)
    (numero (digit (arbno digit) "." digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)) number)
    (numero ("-" digit (arbno digit) "." digit (arbno digit)) number)))

;*******************************************************************************************
;; GRAMATICA
(define gramatical
  '(
;*******************************************************************************************
;; PROGRAMA
    (programa (expresion) un-programa)
;*******************************************************************************************
;; EXPRESIONES
    (expresion (numero) numero-exp)
    (expresion ("true") true-exp)
    (expresion ("false") false-exp)
    (expresion ("\'" texto "\'") texto-exp) ;; PHP
    (expresion (identificador) id-exp)      ;; PHP
    (expresion ("if" expresion "{" expresion "}" "else" "{" expresion "}" ) condicional-exp) ;; JAVASCRIPT
    
    (expresion ("private" "def" "("(separated-list expresion ",")")" "{" expresion "}") definicion-exp) ;; PHYTON
    
    (expresion ("x32" "[" (arbno numero) "]") base-32-exp)
    (expresion ("x16" "[" (arbno numero) "]") base-16-exp)
    (expresion ("x8"  "[" (arbno numero) "]") base-8-exp) 
    (expresion ("["(separated-list expresion ",") "]") lista-exp) ;; arrays in JAVASCRIPT

    (expresion ("("expresion primitiva-binaria expresion ")") op-binaria-exp) ;; JAVASCRIPT
    (expresion (primitiva-unaria "(" expresion ")") op-unaria-exp) ;; C++

    (expresion ("func" "("(separated-list identificador ",") ")" "=>" "{" expresion "}") funcion-exp) ;; SWIFT 
    (expresion ("import" expresion "(" (separated-list expresion ",") ")") ejecutar-function-exp) ;; JAVASCRIPT
    
    (expresion ("export" "func" (arbno identificador "(" (separated-list identificador ",") ")"
                                       "=>" "{"expresion"}") "(" expresion ")") funcion-rec-exp) ;; JAVASCRIPT + SWIFT
        

;*******************************************************************************************
;;  DEFINICIONES EN AMBITOS PRIVADOS
    (expresion ("const" identificador "=" expresion )constante-exp) ;; C
    
    (expresion ("static" identificador) crear-var-exp) ;; JAVA
    (expresion ("init" "static" identificador  "=" expresion) asignar-var-exp) ;; JAVA
    
;*******************************************************************************************   
;; PRIMITIVAS POR BASES
    (primitiva-unaria  ("++32") sumar-uno-32) ;; C++
    (primitiva-unaria  ("--32") restar-uno-32) ;; C++
    (primitiva-unaria  ("cast x32") to-decimal-32) ;; C++
    (primitiva-binaria ("+32") sumar-32) ;; C++
    (primitiva-binaria ("-32") restar-32) ;; C++
    (primitiva-binaria ("*32") multiplicar-32) ;; C++
    ;; X16
    (primitiva-unaria  ("++16") sumar-uno-16) ;; C++
    (primitiva-unaria  ("--16") restar-uno-16) ;; C++
    (primitiva-unaria  ("cast x16") to-decimal-16) ;; C++
    (primitiva-binaria ("+16") sumar-16) ;; C++
    (primitiva-binaria ("-16") restar-16) ;; C++
    (primitiva-binaria ("*16") multiplicar-16) ;; C++
    ;; X8
    (primitiva-unaria  ("++8") sumar-uno-8) ;; C++
    (primitiva-unaria  ("--8") restar-uno-8) ;; C++
    (primitiva-unaria  ("cast x8") to-decimal-8) ;; C++    
    (primitiva-binaria ("+8") sumar-8) ;; C++
    (primitiva-binaria ("-8") restar-8) ;; C++
    (primitiva-binaria ("*8") multiplicar-8) ;; C++
    
;*******************************************************************************************
;; PRIMITIVAS UNARIAS   
    (primitiva-unaria ("!") negacion) ;; JAVASCRIPT
    (primitiva-unaria ("++") sumar-uno) ;; C++
    (primitiva-unaria ("--") restar-uno) ;; C++
    (primitiva-unaria ("strlen") longitud) ;; PHP
    (primitiva-unaria ("isNull") es-vacia?) ;; JAVASCRIPT
    (primitiva-unaria ("isList") es-lista?) ;; JAVASCRIPT
    (primitiva-unaria ("pop") primer-item) ;; JAVASCRIPT
    (primitiva-unaria ("next") resto-items) ;; STRUCT IN C,

;*******************************************************************************************
;; PRIMITIVAS BINARIAS
    (primitiva-binaria (">") mayor) ;; JAVASCRIPT
    (primitiva-binaria (">=") mayor-o-igual) ;; JAVASCRIPT
    (primitiva-binaria ("<") menor) ;; JAVASCRIPT
    (primitiva-binaria ("<=") menor-o-igual) ;; JAVASCRIPT
    (primitiva-binaria ("==") igual) ;; JAVASCRIPT
    (primitiva-binaria ("&&") and-operator) ;; JAVASCRIPT
    (primitiva-binaria ("||") or-operator) ;; JAVASCRIPT
    (primitiva-binaria ("!=") diferente) ;; JAVASCRIPT
    (primitiva-binaria ("+") sumar) ;; C++
    (primitiva-binaria ("-") restar) ;; C++
    (primitiva-binaria ("*") multiplicar) ;; C++
    (primitiva-binaria ("/") dividir) ;; C++
    (primitiva-binaria ("mod") modulo) ;; Visual Basic
    (primitiva-binaria ("concat") concatenar) ;; C#
    (primitiva-binaria ("join") join-lista) ;; JAVASCRIPT, eqv a cons en racket
    (primitiva-binaria ("push") push-lista) ;; JAVASCRIPT, eqv a eppend en racket
    
   ))

;*******************************************************************************************
;; EVAL-PROGRAM
(define eval-program
  (lambda (pgm)
   (cases programa pgm
     (un-programa (exp) (eval-expresion exp env0)))))

;*******************************************************************************************
;; EVAL-EXPORESION
(define eval-expresion
  (lambda (exp env)
   (cases expresion exp
     (numero-exp (num) num)
     (true-exp () #t)
     (false-exp () #f)
     (texto-exp (txt) txt)
     (id-exp (id) (apply-env env id))
     (condicional-exp (condition true-exp false-exp)
                      (if (eval-expresion condition env)
                          (eval-expresion true-exp env)
                          (eval-expresion false-exp env)))
     
     (definicion-exp (exps body)
     (let ((ids (map-extract-ids (eval-rands exps env)))
           (vals (map-extract-val (eval-rands exps env))))
      (eval-expresion body (extended-env ids vals env))))
     
;*******************************************************************************************
;; EXP PRIVATE
;; CONSTANTE BASICA EN UN AMBITO 
    (constante-exp (id val)
               (let ((arg (eval-rand val env)))
                 (extended-env (list id) (list arg) env)))

;; Funcionamiento parcial, constantes en su ambito 
     (crear-var-exp (id)(extended-env (list id) (list "indefinido") env))
                 
     (asignar-var-exp (id val)
               (let ((arg (eval-rand val env)))
                 (extended-env (list id) (list arg) env)))

     
;*******************************************************************************************

     (base-32-exp (list-nums) list-nums)
     (base-16-exp (list-nums) list-nums)
     (base-8-exp (list-nums) list-nums)
     (lista-exp (list-exps) (extract-list-map list-exps env))

     (op-binaria-exp (exp1 operator exp2)(eval-pri-bin operator
                                                       (eval-expresion exp1 env)
                                                       (eval-expresion exp2 env)))
     (op-unaria-exp (operator exp)(eval-pri-un operator
                                                       (eval-expresion exp env)))

     (funcion-exp (ids body)
                (closure ids body env))

     (ejecutar-function-exp (rator rands)
               (let ((proc (eval-expresion rator env))
                     (args (eval-rands rands env)))
                (if (closure-type? proc)
                    (apply-procedure proc args)
                    (eopl:error 'eval-expression "Error, no es un procedimiento" proc))))

     (funcion-rec-exp (names idss bodies letrec-body)
                  (eval-expresion letrec-body
                                   (extended-env-rec names idss bodies env)))
     
     (else #f))))


;*******************************************************************************************
;; EVAL PRIMITVE BINARY
(define eval-pri-bin
  (lambda (operator val1 val2)
    (cases primitiva-binaria operator
       ;;BASICAS
      (mayor          () (> val1 val2))
      (mayor-o-igual  () (>= val1 val2))
      (menor          () (< val1 val2))
      (menor-o-igual  () (<= val1 val2))
      (igual          () (equal? val1 val2))
      (and-operator   () (and val1 val2))
      (or-operator    () (or val1 val2))
      (diferente      () (not (equal? val1 val2)))
      (sumar          () (+ val1 val2))
      (restar         () (- val1 val2))
      (multiplicar    () (* val1 val2))
      (dividir        () (/ val1 val2))
      (modulo         () (remainder val1 val2))
      ;; STRING
      (concatenar     () (string-append val1 val2))
      ;; LISTAS
      (join-lista     () (cons val1 val2))
      (push-lista     () (append val1 val2))
      ;;X32
      (sumar-32       () (suma-bignum val1 val2 32))
      (restar-32      () (resta-bignum val1 val2 32))
      (multiplicar-32 () (multiplicacion-bignum val1 val2 32))
       ;;X16
      (sumar-16       () (suma-bignum val1 val2 16))
      (restar-16      () (resta-bignum val1 val2 16))
      (multiplicar-16 () (multiplicacion-bignum val1 val2 16))
      ;;X8
      (sumar-8        () (suma-bignum val1 val2 8))
      (restar-8       () (resta-bignum val1 val2 8))
      (multiplicar-8  () (multiplicacion-bignum val1 val2 8)))))


;*******************************************************************************************
;; EVAL PRIMITVE BINARY
(define eval-pri-un
  (lambda (operator val)
    (cases primitiva-unaria operator
      ;;BASICAS
      (negacion      () (not val))
      (sumar-uno     () (+ val 1))
      (restar-uno    () (- val 1))
      ;;STRING
      (longitud      () (string-length val))
      ;;LISTAS
      (es-vacia?     () (null? val))
      (es-lista?     () (list? val))
      (primer-item   () (car val))
      (resto-items   () (cdr val))
      ;;X32
      (sumar-uno-32  () (successor val 32))
      (restar-uno-32 () (predecessor val 32))
      (to-decimal-32 () (to-decimal val 32))
       ;;X16
      (sumar-uno-16  () (successor val 16))
      (restar-uno-16 () (predecessor val 16))
      (to-decimal-16 () (to-decimal val 16))
      ;;X8
      (sumar-uno-8   () (successor val 8))
      (restar-uno-8  () (predecessor val 8))
      (to-decimal-8  () (to-decimal val 8)))))  
      
;*******************************************************************************************
;; EXTRACTORES LIST
(define extract-list-map
  (lambda (list-without-eval env)
    (map (lambda (exp) (eval-expresion exp env)) list-without-eval)))

(define eval-rands
  (lambda (rands env)
    (map (lambda (x) (eval-rand x env)) rands)))

(define eval-rand
  (lambda (rand env)
    (eval-expresion rand env)))

;*******************************************************************************************
;; EXTRACT
(define map-extract-ids
  (lambda (ext-envs)
    (map (lambda (x) (extract-id x)) ext-envs)))

(define extract-id
  (lambda (ext-env)
    (cases env ext-env
    (extend-env (syms vec ammbiente) (car syms))
    (else 'error ))))

(define map-extract-val
  (lambda (ext-envs)
    (map (lambda (x) (extract-val x)) ext-envs)))

(define extract-val
  (lambda (ext-env)
    (cases env ext-env
    (extend-env (syms vec ammbiente) (vector-ref vec 0))
    (else 'error ))))

;*******************************************************************************************
;; BIGNUM
(define zero-bignum
  (lambda () '()))

(define is-zero-bignum?
  (lambda (n) (null? n)))

(define successor
  (lambda (n base)
    (cond
      [(null? n ) '(1)]
      [(= (car n) (- base 1)) (cons 0 (successor (cdr n) base))]
      [else (cons (+ (car n ) 1) (cdr n))])))

(define predecessor
  (lambda (n base)
    (cond
      [(equal? n '(1)) '()]
      [(= (car n) 0) (cons (- base 1) (predecessor (cdr n) base))]
      [else (cons (- (car n ) 1) (cdr n))])))
                      
(define suma-bignum
  (lambda (x y base)
    (if (is-zero-bignum? x) y
        (successor (suma-bignum (predecessor x base) y base ) base))))

(define resta-bignum
  (lambda (x y base)
    (if (is-zero-bignum? y) x
        (predecessor (resta-bignum  x (predecessor y base ) base) base))))

(define multiplicacion-bignum
  (lambda (x y base)
    (if (is-zero-bignum? x)(zero-bignum)
        (suma-bignum (multiplicacion-bignum (predecessor x base) y base) y base))))

;*******************************************************************************************
;; Funciona auxiliar para calcular en decimal un numero en otra base
(define to-decimal
  (lambda (n base)
    (to-decimal-aux n base 0)))

(define to-decimal-aux
  (lambda (n base index)
    (cond
      [(null? n )0]
      [else (+ (*(expt base index) (car n)) (to-decimal-aux (cdr n) base (+ index 1)))])))

;*******************************************************************************************
;; REFERENCIAS
(define-datatype reference reference?
  (una-referencia (index integer?)
                  (un-vector vector?)))

(define set-ref
  (lambda(ref val)
    (cases reference ref
      (una-referencia (index un-vector) (vector-set! un-vector index val)))))

(define val-ref
  (lambda(ref)
    (cases reference ref
      (una-referencia (index un-vector) (vector-ref un-vector index)))))


;*******************************************************************************************
;; AMBIENTES
(define scheme-value? (lambda (v) #t))

(define-datatype env env?
  (empty-env)
  (extend-env (syms (list-of symbol?))(vec vector?)(env env?)))

(define extended-env
  (lambda (syms vals env)
    (extend-env syms (list->vector vals) env)))

(define extended-env-rec
  (lambda (proc-names idss bodies old-env)
    (let ((len (length proc-names)))
      (let ((vec (make-vector len)))
        (let ((env (extend-env proc-names vec old-env)))
          (for-each
            (lambda (pos ids body)
              (vector-set! vec pos (closure ids body env)))
            (list-to-end len) idss bodies)
          env)))))
  
(define env0 (empty-env))



;*******************************************************************************************
;; CLOSURES
(define-datatype closure-type closure-type?
  (closure
   (ids (list-of symbol?))
   (exp expresion?)
   (env env?)))

(define apply-procedure
  (lambda (proc args)
    (cases closure-type proc
      (closure (ids exp env) (eval-expresion exp (extended-env ids args env))))))

(define apply-env
  (lambda (env sym)
    (val-ref (apply-env-aux env sym))))

(define apply-env-aux
  (lambda (ambiente id)
    (cases env ambiente
      (empty-env ()(eopl:error 'apply-env-aux "Error, el id no existe ~s" id))
      (extend-env (syms vals ambiente-old)
                           (let ((index (list-find-position id syms)))
                             (if (number? index)
                                 (una-referencia index vals)
                                 (apply-env-aux ambiente-old id)))))))

;*******************************************************************************************
;; FUNC AUX IN ENV
(define list-find-position
  (lambda (id lista)
    (list-index (lambda (x) (eqv? x id)) lista)))

(define list-index
  (lambda (func ls)
    (cond
      ((null? ls) #f)
      ((func (car ls)) 0)
      (else (let ((list-index-r (list-index func (cdr ls))))
              (if (number? list-index-r)
                (+ list-index-r 1)
                #f))))))

(define list-to-end
  (lambda (end)
    (let loop ((next 0))
      (if (>= next end) '()
        (cons next (loop (+ 1 next)))))))

;*******************************************************************************************
;; TARGETS
(define-datatype target target?
  (direct-target (expval  is-value-exp?))
  (indirect-target (ref  ref-direct-is-target?)))

(define is-value-exp? (lambda (x) (or
                                   (number? x)
                                   (closure-type? x)
                                   (string? x)
                                   (list? x))))
(define ref-direct-is-target?
  (lambda (x)
    (and (reference? x)
         (cases reference x
           (una-referencia (index vector)(cases target
                                           (vector-ref vector index)
                                           (direct-target (v) #t)
                                           (indirect-target (v) #f)))))))

;*******************************************************************************************
;; AUTOCREATE DATATYPES
(sllgen:make-define-datatypes lexica gramatical)
(define scanner (sllgen:make-string-scanner lexica gramatical))
(define parser (sllgen:make-string-parser lexica gramatical))
(define view-datatype (sllgen:list-define-datatypes lexica gramatical))

;*******************************************************************************************
;; PROMPT
(define mixer.exe
  (sllgen:make-rep-loop  "@Mixer -> "
    (lambda (programa) (eval-program programa)) 
    (sllgen:make-stream-parser lexica gramatical)))


;*******************************************************************************************
;; AUTONRUN
;(mixer.exe)


#|

Test

export func $f ($x) => {if ($x == 0){1} else { ($x* import $f (--($x)))}} (import $f (10))
export func $f ($x) => {if ($x == 0){1} else { ($x* import $f (--($x)))}} (import $f (10))

import func ($y) => {++($y)} (5)

private def (const $x = func ($x) => {++($x)}, const $z = 5){import $x (5)}
private def (init static $x = func ($x) => {++($x)}, const $z = 5){import $x (5)}

private def (const $b = 3, init static $a = 1,
             const $sumar = func ($x, $y) => {($y+$x)} ) {import $sumar ($a,$b)}

private def (const $b = 10, init static $a = 1) {
( export func $f ($x) => {if ($x == 0){1} else { ($x* import $f (--($x)))}} (import $f ($b))+ $a )}

private def (const $b = 10, const $a = 1) {
( export func $f ($x) => {if ($x == 0){1} else { ($x* import $f (--($x)))}} (import $f ($b))+ $a )}
|#






