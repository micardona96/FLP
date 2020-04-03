#lang eopl

;; Created by Miguel Cardona on 02/04/2020.
;; Copyright © 2020 Miguel Cardona. All rights reserved.

#|

### Programa

< programa >
                :=  < expresion > 
                un-programa (exp)

< expresion >
                :=  < numero >
                número-exp (num)

                := true  
                true-exp

                := false 
                false-exp

                :=  \'  < texto >  \' 
                texto-exp (txt)

                :=  < identificador >  
                id-exp ( id)

                :=  if  < expresion >  {  < expresion >  } else {  < expresion >  }  
                condicional-exp (cond  true-exp  false-exp)

                :=  const  < identificador >  =  < expresion > 
                constante-exp (id  exp)

                :=  static  < identificador > 
                crear-var-exp (id)

                :=  init static  < identificador >  =  < expresion > 
                asignar-var-exp (id  exp)

                :=  x32  [  < numero * >  ]  
                base-32-exp (nums)

                :=  x16  [  < numero * >  ]  
                base-16-exp (nums)

                :=  x8  [  < numero * >  ]  
                base-8-exp (nums)

                :=  new list  
                nueva-lista-exp

                :=  list  =  [  < expresion > , *  ] 
                iniciar-lista-exp (exps)

                :=  (< expresion >  < primitiva-binaria >  < expresion > )  
                op-binaria-exp (rand primitive-bin rator)

                :=  < primitiva-unaria >  (< expresion > )  
                op-unaria-exp (primitive-un exp)

                :=  func (< identificador > , * ) = {  < expresion >  }  
                función-exp (ids  exp)

                :=  import (< expresion >  (< expresion > * )  
                ejecutar-function-exp (ids  exp)

                :=  export func  < identificador >  (< identificador > , * ) ={  < expresion >  }  
                función-rec-exp (id  ids  exp)


< primitiva-unaria >
    :=  !   [ negación ]
    :=  ++  [ sumar-uno ]
    :=  --  [ restar-uno ]
    :=  strlen  [ longitud ]
    :=  isNull  [ es-vacía? ]
    :=  isList  [ es-lista? ]
    :=  pop  [ primer-ítem ]
    :=  next [ resto-items ]


< primitiva-binaria >
    :=  >  [ mayor ]
    :=  >= [ mayor-o-igual]
    :=  <  [ menor ]
    :=  <= [ menor-o-igual ]
    :=  == [ igual ]
    :=  && [ and ]
    :=  || [ or ]
    :=  != [ diferente ]
    :=  +  [ sumar ]
    :=  -  [ restar ]
    :=  *  [ multiplicar ]
    :=  /  [ dividir ]
    :=  mod [ módulo ]
    :=  concat [ concatenar ]
    :=  join [  join-lista ]
    :=  push [ push-lista ]

|#

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
    (programa (expresion) un-programa)

    ;; EXPRESIONES
    (expresion (numero) numero-exp)
    (expresion ("true") true-exp)
    (expresion ("false") false-exp)
    (expresion ("\'" texto "\'") texto-exp) ;; PHP
    (expresion (identificador) id-exp)      ;; PHP
    
    (expresion ("if" expresion "{" expresion "}" "else" "{" expresion "}" ) condicional-exp) ;; JAVASCRIPT
    (expresion ("const" identificador "=" expresion )constante-exp) ;; C
    
    (expresion ("static" identificador) crear-var-exp) ;; JAVA
    (expresion ("init" "static" identificador  "=" expresion) asignar-var-exp) ;; JAVA
    
    (expresion ("x32" "[" (arbno numero) "]") base-32-exp)
    (expresion ("x16" "[" (arbno numero) "]") base-16-exp)
    (expresion ("x8"  "[" (arbno numero) "]") base-8-exp) 

    (expresion ("new" "list") nueva-lista-exp) ;; JAVASCRIPT
    (expresion ("list" "="  "["(separated-list expresion ",") "]") iniciar-lista-exp) ;; JAVASCRIPT
    
    (expresion ("("expresion primitiva-binaria expresion ")") op-binaria-exp) ;; JAVASCRIPT
    (expresion (primitiva-unaria "(" expresion ")") op-unaria-exp) ;; C++

    (expresion ("func" "("(separated-list identificador ",") ")" "=>" "{" expresion "}") funcion-exp) ;; SWIFT 
    (expresion ("import" expresion "(" (arbno expresion) ")") ejecutar-function-exp) ;; JAVASCRIPT
    (expresion ("export" "func" identificador "("(separated-list identificador ",") ")"
                          "=>" "{" expresion "}")funcion-rec-exp) ;; JAVASCRIPT + SWIFT
   

    ;; PRIMITIVAS UNARIAS
    (primitiva-unaria ("!") negacion) ;; JAVASCRIPT
    (primitiva-unaria ("++") sumar-uno) ;; C++
    (primitiva-unaria ("--") restar-uno) ;; C++
    
    (primitiva-unaria ("strlen") longitud) ;; PHP
    
    (primitiva-unaria ("isNull") es-vacia?) ;; JAVASCRIPT
    (primitiva-unaria ("isList") es-lista?) ;; JAVASCRIPT
    (primitiva-unaria ("pop") primer-item) ;; JAVASCRIPT
    (primitiva-unaria ("next") resto-items) ;; STRUCT IN C,
    
    ;; PRIMITIVAS BINARIAS
    (primitiva-binaria (">") mayor) ;; JAVASCRIPT
    (primitiva-binaria (">=") mayor-o-igual) ;; JAVASCRIPT
    (primitiva-binaria ("<") menor) ;; JAVASCRIPT
    (primitiva-binaria ("<=") menor-o-igual) ;; JAVASCRIPT
    (primitiva-binaria ("==") igual) ;; JAVASCRIPT
    (primitiva-binaria ("&&") and) ;; JAVASCRIPT
    (primitiva-binaria ("||") or) ;; JAVASCRIPT
    (primitiva-binaria ("!=") diferente) ;; JAVASCRIPT
   
    (primitiva-binaria ("+") sumar) ;; C++
    (primitiva-binaria ("-") restar) ;; C++
    (primitiva-binaria ("*") multiplicar) ;; C++
    (primitiva-binaria ("/") dividir) ;; C++
    (primitiva-binaria ("mod") modulo) ;; Visual Basic

    (primitiva-binaria ("concat") concatenar) ;; C#
    
    (primitiva-binaria ("join") join-lista) ;; JAVASCRIPT, eqv a cons en racket
    (primitiva-binaria ("push") push-lista) ;; JAVASCRIPT
    
   ))

;*******************************************************************************************
;; AUTOCREATE DATATYPES

(sllgen:make-define-datatypes lexica gramatical)
(define scanner (sllgen:make-string-scanner lexica gramatical))
(define parser (sllgen:make-string-parser lexica gramatical))

;*******************************************************************************************
;; PROMPT
(define Mixer.exe
  (sllgen:make-rep-loop  "@Mixer -> "
    (lambda (programa) (eval-program programa)) 
    (sllgen:make-stream-parser lexica gramatical)))

;*******************************************************************************************
;; EVAL-PROGRAM
(define eval-program
  (lambda (pgm)
   (cases programa pgm
     (un-programa (exp) exp))))

;*******************************************************************************************
;; TEST DEFITIONS TO SYNTAX TREE

(parser "1")
(parser "1.1")
(parser "-1")
(parser "-1.1")
(parser "//comentario
          'message'
         //comentario")

(parser "true")
(parser "false")

(parser "'mensaje'")
(parser "$var")

(parser "if ((1+2)>4) { true } else { false }")

(parser "const $var = 5")

(parser "static $var")
(parser "init static $var = (1 + 3)")

(parser "x32 [1 0 2 3]")
(parser "x16 [1 0 2 3]")
(parser "x8  [1 0 2 3]")

(parser "new list")
(parser "list = [1,0,2,3]")

(parser "!(false)")
(parser "++($var)")
(parser "--($var)")
(parser "strlen($var)")
(parser "isNull($var)")
(parser "isList($var)")
(parser "pop($var)")
(parser "next($var)")

(parser "(1 + 2)")
(parser "(1 - 2)")
(parser "(5 * 2)")
(parser "(1 / 2)")
(parser "(1 mod 2)")

(parser "(5 > 2)")
(parser "(1 < 2)")
(parser "(1 >= 2)")
(parser "(1 <= 2)")
(parser "(1 == 2)")

(parser "(true != false)")
(parser "(true || false)")
(parser "(true && true)")

(parser "('hola' concat 'adios')")
(parser "(list = [1] join list = [2])")
(parser "(list = [1,2] push list = [3,4])")
