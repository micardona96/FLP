#lang eopl

(define especificacion-lexica
  '((espacio (whitespace) skip)
    (identificador (letter (arbno (or letter digit))) symbol)
    (numero (digit (arbno digit)) number)
    (numero (digit (arbno digit) "." digit (arbno digit)) number)
    ))

(define especificacion-gramatical
  '((programa (expresion) un-program)
    (expresion (numero) num-lit)
    (expresion ("(" expresion operacion expresion ")") exp-lit)
    (expresion (identificador) variable)
    (expresion ("var" "(" identificador "="  expresion ")" "in" expresion) declaracion) ;; ambiguous??
    (operacion ("+") suma)
    (operacion ("-") resta)
    (operacion ("*") multiplicacion)
    (operacion ("/") division)))

(sllgen:make-define-datatypes especificacion-lexica especificacion-gramatical)
;(sllgen:list-define-datatypes especificacion-lexica especificacion-gramatical) muestra los datatypes

(define scanner (sllgen:make-string-scanner especificacion-lexica especificacion-gramatical))
(define parser (sllgen:make-string-parser especificacion-lexica especificacion-gramatical))

(define unparser
  (lambda (prog)
    (cases programa prog
      (un-program (expresion) (unparse-expresion expresion)))))

(define unparse-expresion
  (lambda (exp)
    (cases expresion exp
      (num-lit (n) n)
      (exp-lit (exp1 op exp2) (list (unparse-expresion exp1) (unparse-operacion op) ( unparse-expresion exp2)))
      (variable (id) id)
      (declaracion (ids exps cuerpo) (list 'var (ids) (unparse-expresion exps) (unparse-expresion cuerpo))) ;; fixed?
      )))

(define unparse-operacion
  (lambda (primitiva)
    (cases operacion primitiva
      (suma () '+)
      (resta () '-)
      (multiplicacion () '*)
      (division () '/))))



