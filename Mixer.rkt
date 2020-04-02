#lang eopl

#| DEV: MIGUEL ÁNGEL CARDONA CHAMORRO
   CODE: 1628209


   GRAMATICA

<expresion> := <numero>
               number (numero)

            := true | false

            := "\'" <texto> "\'"
               texto (texto)

            := <identificador>
               id (identificador)

            := if (<expresion>) {<expresion>} else {<expresion>}
               condicional (test-exp true-exp false-exp)

            := const <identificador> = <expresion>
               constante (id exp)

            := static <identificador>
               var-asig-unica (id)

            := @ <identificador> => <expresion>
               set-asig-unica (id)

            := const <identificador> = <expresion>
               constante (id exp )

            := x32 [ <numero>(+) ]
               base-32 (numeros)

            := x16 [ <numero>(+) ]
               base-16 (numeros)

            := x8 [ <numero>(+) ]
               base-8 (numeros)

            := ! <expresion>
               negacion (exp)

            := Logic ( <expresion> <primitive-bool> <expresion> )
               binary-bool (exp prim-bool exp)

            := Calculate ( <expresion> <primitive-decimal> <expresion> )
               binary-bool (exp prim-bool exp)

            := Solve ( <expresion> <primitive-x-base> <expresion> )
               binary-bool (exp prim-bool exp)

            := Eval <identificador>  (<expresion>(*))
               eval-expresion (id exps)

            := <primitive-string> (<expresion>(+))
               string-exp (prim-string exps)

            := <primitive-list> (<expresion>^(*))
               list-exp (prim-list exps)

            := <primitive-x-base> <expresion>
               unario-x-base (prim-x-base exp)

            := <primitive-decimal> <expresion>
               unario-decimal (prim-decimal exp)

            := (<identificador> (,)(*)) => {<expresion>}
               procedimiento (ids exp)

            := func <identificador> (<identificador> (,)(*)) => {<expresion>}
               procedimiento-recursivo (id ids exp)


<primitive-bool> :=  > | >= | <= | < | == | && || !=

<primitive-decimal> :=  + | - | * | / | ++ | -- | mod

<primitive-x-base> :=  + | - | * | ++ | -- 

<primitive-string> :=  strlen | concat

<primitive-list> := isNull | join | isList | new List | pop | next | push

|#


;*******************************************************************************************
;; LEXICAS
(define lexica
  '((espacio (whitespace) skip)
    (comentario ("//" (arbno ( not #\newline ))) skip)
    (texto (letter (arbno (or letter digit))) string)
    (identificador ("$" letter (arbno (or letter digit))) symbol) ;; PHP
    (numero (digit (arbno digit)) number)
    (numero (digit (arbno digit) "." digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)) number)
    (numero ("-" digit (arbno digit) "." digit (arbno digit)) number)))

;*******************************************************************************************
;; GRAMATICA
(define gramatical
  '(
    ;; PROGRAMA
    (main (expresion) run-main)

    ;; EXPRESIONES
    (expresion (numero) numero-exp)
    (expresion ("true") true-exp)
    (expresion ("false") false-exp)
    (expresion ("\'" texto "\'") texto-exp) ;; PHP
    (expresion (identificador) id-exp)      ;; PHP
    (expresion ("if" expresion expresion "else"  expresion ) condicional-exp) ;; JAVASCRIPT
    (expresion ("const" identificador "=" expresion )constante-exp) ;; C
    
    (expresion ("static" identificador) crear-var-exp) ;; JAVA
    (expresion ("init" "static" identificador  "=" expresion) iniciar-var-exp) ;; JAVA
    (expresion ("@" "static" identificador "=" expresion) asignar-var-exp) ;; JAVA
    
    (expresion ("x32" "[" numero (arbno numero) "]") base-32-exp);; Guía del proyecto
    (expresion ("x16" "[" numero (arbno numero) "]") base-16-exp);; Guía del proyecto
    (expresion ("x8"  "[" numero (arbno numero) "]") base-8-exp);; Guía del proyecto
       
    (expresion ("("expresion primitive-binary expresion ")")op-binaria-exp)
    (expresion (primitive-unaria expresion) op-unaria-exp)

    (expresion ("func" "("(separated-list identificador ",") ")" "=>" "{" expresion "}") funcion-exp) ;; SWIFT 
    (expresion ("import" expresion "(" (arbno expresion) ")") ejectuar-function-exp) ;; JAVASCRIPT
    (expresion ("export" "func" identificador "("(separated-list identificador ",") ")"
                          "=>" "{" expresion "}")funcion-rec-exp) ;; JAVASCRIPT SWIFT
   

    ;; PRIMITIVAS UNARIAS
    (primitive-unaria ("!") negacion) ;; JAVASCRIPT
    (primitive-unaria ("++") sumar-uno) ;; C++
    (primitive-unaria ("--") restar-uno) ;; C++
    
    (primitive-unaria ("strlen") longitud) ;; PHP
    (primitive-unaria ("concat") concatenar) ;; C#
    
    (primitive-unaria ("isNull") es-vacia?) ;; JAVASCRIPT
    (primitive-unaria ("isList") es-lista?) ;; JAVASCRIPT
    (primitive-unaria ("new List()") nueva-lista) ;; JAVASCRIPT, crea una lista vacia
    (primitive-unaria ("pop") primer-item) ;; JAVASCRIPT, retorna el primer elemento
    (primitive-unaria ("next") resto-items) ;; Estructuras en C, retorna el rest

    
    ;; PRIMITIVAS BINARIAS
    (primitive-binary (">") mayor) ;; JAVASCRIPT
    (primitive-binary (">=") mayor-o-igual) ;; JAVASCRIPT
    (primitive-binary ("<=") menor-o-igual) ;; JAVASCRIPT
    (primitive-binary ("<") menor) ;; JAVASCRIPT
    (primitive-binary ("==") igual) ;; JAVASCRIPT
    (primitive-binary ("&&") and) ;; JAVASCRIPT
    (primitive-binary ("||") or) ;; JAVASCRIPT
    (primitive-binary ("!=") diferente) ;; JAVASCRIPT
   
    (primitive-binary ("+") add-decimal) ;; C++
    (primitive-binary ("-") sub-decimal) ;; C++
    (primitive-binary ("*") mult-decimal) ;; C++
    (primitive-binary ("/") div-decimal) ;; C++
    (primitive-binary ("mod") mod-decimal) ;; Visual Basic

    (primitive-binary ("join") join-list) ;; JAVASCRIPT
    (primitive-binary ("push") push-elmt) ;; JAVASCRIPT, append de dos listas
    
    
   ))

;*******************************************************************************************
;; AUTOCREATE DATATYPES

(sllgen:make-define-datatypes lexica gramatical)
(define scanner (sllgen:make-string-scanner lexica gramatical))
(define parser (sllgen:make-string-parser lexica gramatical))

;*******************************************************************************************
;; EVAL-PROGRAM
(define eval-program
  (lambda (token)
   (cases main token
     (run-main (main) main))))


;*******************************************************************************************
;;PROMPT
(define Mixer.exe
  (sllgen:make-rep-loop  "@Mixer -> "
    (lambda (main) (eval-program main)) 
    (sllgen:make-stream-parser lexica gramatical)))
