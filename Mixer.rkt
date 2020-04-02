#lang eopl

#| DEV: MIGUEL ÁNGEL CARDONA CHAMORRO
   CODE: 1628209


   GRAMATICA

<expresion> := <numero>
               number (numero)

            := true | false

            := "\'" <texto> "\'"
               string (texto)

            := <identificador>
               id (identificador)

            := if (<expresion>) {<expresion>} else {<expresion>}
               condicional (test-exp true-exp false-exp)

            := const <identificador> = <expresion>
               constante (id exp)

            := static <identificador>
               var-asig-unica (id)

            := * <identificador> => <expresion>
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
    (expresion (numero) number)
    (expresion ("true") true)
    (expresion ("false") false)
    (expresion ("\'" texto "\'") string) ;; PHP
    (expresion (identificador) id)      ;; PHP
    (expresion ("if" "(" expresion ")" "{" expresion "}" "else" "{" expresion "}") condicional) ;; JAVASCRIPT
    (expresion ("const" identificador "=" expresion )constante) ;; C
    (expresion ("static" identificador) var-asig-unica) ;; C
    (expresion ("*" identificador "=>" expresion) set-asig-unica) ;; C
    (expresion ("x32" "[" numero (arbno numero) "]") base-32);; Guía del proyecto
    (expresion ("x16" "[" numero (arbno numero) "]") base-16);; Guía del proyecto
    (expresion ("x8"  "[" numero (arbno numero) "]") base-8);; Guía del proyecto
    (expresion ("!" expresion) negacion);; JAVASCRIPT UNARIA
   
    (expresion ("Logic" "(" expresion primitive-bool expresion ")") binary-bool)
    (expresion ("Calculate"  "(" expresion primitive-decimal expresion ")") binary-decimal)
    (expresion ("Solve" "(" expresion primitive-x-base expresion ")") binary-x-base)
    (expresion ("Eval" identificador "(" (arbno expresion) ")") eval-expresion)
    (expresion (primitive-string  "(" expresion (arbno expresion) ")") string-exp)
    (expresion (primitive-list "(" (arbno expresion) ")") list-exp)
    (expresion (primitive-x-base (expresion)) unario-x-base)
    (expresion (primitive-decimal (expresion)) unario-decimal)
    
    (expresion ("("(separated-list identificador ",") ")" "=>" "{" expresion "}") procedimiento) ;; JAVASCRIPT
    (expresion ("func" identificador "("(separated-list identificador ",") ")" "=>" "{" expresion "}")
               procedimiento-recursivo) ;; SWIFT
   
    ;; PRIMITIVAS BOOLEANAS
    (primitive-bool (">") mayor) ;; JAVASCRIPT
    (primitive-bool (">=") mayor-o-igual) ;; JAVASCRIPT
    (primitive-bool ("<=") menor-o-igual) ;; JAVASCRIPT
    (primitive-bool ("<") menor) ;; JAVASCRIPT
    (primitive-bool ("==") igual) ;; JAVASCRIPT
    (primitive-bool ("&&") and) ;; JAVASCRIPT
    (primitive-bool ("||") or) ;; JAVASCRIPT
    (primitive-bool ("!=") diferente) ;; JAVASCRIPT
   
     ;; PRIMITIVAS BASE 10
    (primitive-decimal ("+") add-decimal) ;; C++
    (primitive-decimal ("-") sub-decimal) ;; C++
    (primitive-decimal ("*") mult-decimal) ;; C++
    (primitive-decimal ("/") div-decimal) ;; C++
    (primitive-decimal ("++") plus-1-decimal) ;; C++
    (primitive-decimal ("--") minus-1-decimal) ;; C++
    (primitive-decimal ("mod") mod-decimal) ;; Visual Basic

     ;; PRIMITIVAS OTRAS BASES
    (primitive-x-base ("+") add-x-base) ;; C++
    (primitive-x-base ("-") sub-x-base) ;; C++
    (primitive-x-base ("*") mult-x-base) ;; C++
    (primitive-x-base ("++") plus-1-x-base) ;; C++
    (primitive-x-base ("--") minus-1-x-base) ;; C++

     ;; PRIMITIVAS STRINGS
     (primitive-string ("strlen") longitud) ;; PHP
     (primitive-string ("concat") concatenar) ;; C#

      ;; PRIMITIVAS LISTAS
     (primitive-list ("isNull") es-vacia?) ;; JAVASCRIPT
     (primitive-list ("join") join-list) ;; JAVASCRIPT 
     (primitive-list ("isList") es-lista?) ;; JAVASCRIPT
     (primitive-list ("new List") new-list) ;; JAVASCRIPT, crea una lista vacia
     (primitive-list ("pop") primer-elmt) ;; JAVASCRIPT, retorna el primer elemento
     (primitive-list ("next") next-elmt) ;; Estructuras en C, retorna el resto
     (primitive-list ("push") push-elmt) ;; JAVASCRIPT, append de dos listas
    
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
(define RUN
  (sllgen:make-rep-loop  "Mixer-> "
    (lambda (main) (eval-program main)) 
    (sllgen:make-stream-parser lexica gramatical)))
