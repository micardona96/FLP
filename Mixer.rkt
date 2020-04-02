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
    (expresion (">" identificador ">" expresion) set-asig-unica) ;; C
    (expresion ("x32" "[" numero (arbno numero) "]") base-32);; Guía del proyecto
    (expresion ("x16" "[" numero (arbno numero) "]") base-16);; Guía del proyecto
    (expresion ("x8"  "[" numero (arbno numero) "]") base-8);; Guía del proyecto
    (expresion ("Logic" "(" expresion primitive-bool expresion ")") binary-bool)
    (expresion ("Calculate"  "(" expresion primitive-decimal expresion ")") binary-decimal)
    (expresion ("Solve" "(" expresion primitive-x-base expresion ")") binary-x-base)
    (expresion (primitive-unaria expresion) prim-unaria)
    (expresion ("Eval" identificador "(" (arbno expresion) ")") eval-expresion)
    (expresion (primitive-list "(" (arbno expresion) ")") list-exp)
    (expresion ("("(separated-list identificador ",") ")" "=>" "{" expresion "}") procedimiento) ;; JAVASCRIPT
    (expresion ("func" identificador "("(separated-list identificador ",") ")" "=>" "{" expresion "}")
               procedimiento-recursivo) ;; SWIFT


    ;; PRIMITIVAS UNARIAS
    (primitive-unaria ("!") negacion) ;; JAVASCRIPT
    (primitive-unaria ("++") plus-one) ;; C++
    (primitive-unaria ("--") minus-one) ;; C++
    (primitive-unaria ("strlen") longitud) ;; PHP
    (primitive-unaria ("concat") concatenar) ;; C#
    (primitive-unaria ("isNull") es-vacia?) ;; JAVASCRIPT
    (primitive-unaria ("isList") es-lista?) ;; JAVASCRIPT
    (primitive-unaria ("new List") new-list) ;; JAVASCRIPT, crea una lista vacia
    (primitive-unaria ("pop") primer-elmt) ;; JAVASCRIPT, retorna el primer elemento
    (primitive-unaria ("next") next-elmt) ;; Estructuras en C, retorna el resto
    
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
    (primitive-decimal ("mod") mod-decimal) ;; Visual Basic

     ;; PRIMITIVAS OTRAS BASES
    (primitive-x-base ("+") add-x-base) ;; C++
    (primitive-x-base ("-") sub-x-base) ;; C++
    (primitive-x-base ("*") mult-x-base) ;; C++

      ;; PRIMITIVAS LISTAS
     (primitive-list ("join") join-list) ;; JAVASCRIPT
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
