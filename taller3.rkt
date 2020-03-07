#lang eopl
;*******************************************************************************************
;; LEXICAS
(define especificacion-lexica
  '((espacio (whitespace) skip)
    (comentario ("//" (arbno ( not #\newline ))) skip)
    (texto (letter (arbno (or letter digit))) string)
    (identificador ("@" letter (arbno (or letter digit))) symbol)
    (numero (digit (arbno digit)) number)
    (numero (digit (arbno digit) "." digit (arbno digit)) number)
    (numero ("-" digit (arbno digit)) number)
    (numero ("-" digit (arbno digit) "." digit (arbno digit)) number)
    ))
;*******************************************************************************************
;; GRAMATICA
(define especificacion-gramatical
  '(
    ;; PROGRAMA
    (programa (expresion) un-programa)
    ;; EXPRESIÓN
    (expresion (numero) numero-lit)
    (expresion ("\"" texto "\"") texto-lit)
    (expresion (identificador) var-exp)
    (expresion ( "(" expresion primitiva-binaria expresion ")" ) primapp-bin-exp)
    (expresion (primitiva-unaria "(" expresion ")") primapp-un-exp)
    (expresion ("Si" expresion "entonces" expresion "sino" expresion "finSI" )  condicional-exp)
    (expresion ("declarar" "(" (separated-list identificador "=" expresion ";") ")" "{" expresion "}")
               variableLocal-exp)
    (expresion ("procedimiento" "("
               (separated-list identificador  ",") ")" "haga" expresion "finProc") procedimiento-ex)
    
    (expresion ("procedimiento-rec"
                "(" (arbno identificador "(" (separated-list identificador ",") ")" "haga" expresion ) ")"
                "con"  expresion)
                procedimiento-rec)
    
    (expresion ("evaluar" expresion "(" (separated-list expresion  ",") ")" "finEval") app-exp)
    
    
    ;; BINARIA
    (primitiva-binaria ("+") primitiva-suma)
    (primitiva-binaria ("~") primitiva-resta)
    (primitiva-binaria ("/") primitiva-div)
    (primitiva-binaria ("*") primitiva-multi)
    (primitiva-binaria ("concat") primitiva-concat)
    ;; UNARIA
    (primitiva-unaria ("longitud") primitiva-longitud)
    (primitiva-unaria ("add1") primitiva-add1)
    (primitiva-unaria ("sub1") primitiva-sub1)))

;*******************************************************************************************
;; AUTOCREATE DATATYPES

(sllgen:make-define-datatypes especificacion-lexica especificacion-gramatical)
;; veiw datatypes genrate literal text
;; (define view-datatype (sllgen:list-define-datatypes especificacion-lexica especificacion-gramatical))
(define scanner (sllgen:make-string-scanner especificacion-lexica especificacion-gramatical))
(define parser (sllgen:make-string-parser especificacion-lexica especificacion-gramatical))

;*******************************************************************************************
;; AMBIENTESS

;definición del tipo de dato ambiente
(define-datatype env env?
  (empty-env)
  (extended-env (syms (list-of symbol?))
                (vals (list-of scheme-value?))
                (env env?))
 (extended-env-rec
  (proc-names (list-of symbol?))
  (syms (list-of (list-of symbol?)))
  (vals (list-of scheme-value?))
  (env env?)))

;función que crea un ambiente vacío
(define env0 (lambda () (empty-env)))

;; Ambiente incial
(define init-env (lambda() (extended-env '(@a @b @c @d @e) '(1 2 3 "hola" "FLP") (env0))))

;; Analiza si un parametro v es un valor valido de scheme => boolean
(define scheme-value? (lambda (v) #t))

;función que busca un símbolo en un ambiente
(define buscar-variable
  (lambda (id ambiente)
    (cases env ambiente
      (empty-env ()(eopl:error 'buscar-variable "Error, la variable no existe ~s" id))
      (extended-env (syms vals ambiente-old)
                           (let ((index (list-find-position id syms)))
                             (if (number? index)
                                 (list-ref vals index)
                                 (buscar-variable id ambiente-old))))
      (extended-env-rec (proc-names symss vals ambiente-old)
                           (let ((index (list-find-position id proc-names)))
                             (if (number? index)
                                 (cerradura (list-ref symss index)
                                            (list-ref vals index)
                                            ambiente)
                                 (buscar-variable id ambiente-old))))
      )))


;; busca un elemento en una lista, item a item
(define list-find-position
  (lambda (id lista)
    (list-index (lambda (x) (eqv? x id)) lista)))

;; analiar si un elemento es igual al id que se busca, item a item por la lista
(define list-index
  (lambda (func ls)
    (cond
      ((null? ls) #f)
      ((func (car ls)) 0)
      (else (let ((list-index-r (list-index func (cdr ls))))
              (if (number? list-index-r)
                (+ list-index-r 1)
                #f))))))

;*******************************************************************************************
;; EVALUADORES

;; TRUE AND FALSE
(define valor-verdad?
  (lambda (value)
    (if (zero? value) #f #t)))

;; PROGRAMA
(define eval-program
  (lambda (exe)
   (cases programa exe
     (un-programa (body) (eval-exp body (init-env))))))

(define eval-exp
  (lambda (exp env)
   (cases expresion exp
     (numero-lit (num) num)
     (texto-lit (txt) txt)
     (var-exp (id) (buscar-variable id env))
     (primapp-bin-exp (exp1 op exp2) (eval-pri-bin (eval-exp exp1 env) op (eval-exp exp2 env)))
     (primapp-un-exp (op exp) (eval-pri-un op (eval-exp exp env)))
     (condicional-exp (exp exp-true exp-false)
                      (if (valor-verdad? (eval-exp exp env))
                          (eval-exp exp-true env)
                          (eval-exp exp-false env)))
     (variableLocal-exp (ids exps cuerpo)
                        (let ((valores (eval-rands exps env)))
                          (eval-exp cuerpo (extended-env ids valores env))))
    (procedimiento-ex (ids cuerpo) (cerradura ids cuerpo env))
    (procedimiento-rec (names idss cuerpo cuerpo-rec)
                       (eval-exp cuerpo-rec (extended-env-rec names idss cuerpo env)))
    (app-exp (operador operando)
             (let
                 ((proc (eval-exp operador env))
                  (args (eval-rands operando env)))
               (if (procVal? proc)
                   (apply-procedure proc args)
                   (eopl:error 'eval-exp "error al evaluar el operador (rator) ~s" proc))))
    ;;(else 'else)
     )))


(define eval-pri-bin
  (lambda (val1 op val2)
    (cases primitiva-binaria op
      (primitiva-suma () (+ val1 val2))
      (primitiva-resta () (- val1 val2))
      (primitiva-div () (/ val1 val2))
      (primitiva-multi () (* val1 val2))
      (primitiva-concat () (string-append val1 val2))
      )))

(define eval-pri-un
  (lambda (op val)
    (cases primitiva-unaria op
      (primitiva-longitud () (string-length val))
      (primitiva-add1 () (+ 1 val))
      (primitiva-sub1 () (- val 1)))))


; funciones auxiliares para aplicar eval-expression a cada elemento de una 
; lista de operandos (expresiones)
(define eval-rands
  (lambda (rands env)
    (map (lambda (x) (eval-rand x env)) rands)))

(define eval-rand
  (lambda (rand env)
    (eval-exp rand env)))


;; SHELL PROMPT  @user ->
(define Dr-Shell
  (sllgen:make-rep-loop  "@user ->"
    (lambda (pgm) (eval-program pgm)) 
    (sllgen:make-stream-parser 
      especificacion-lexica especificacion-gramatical)))


;; CLOSURE

(define-datatype procVal procVal?
  (cerradura
   (ids (list-of symbol?))
   (exp expresion?)
   (env env?)))

(define apply-procedure
  (lambda (proc args)
    (cases procVal proc
      (cerradura (ids exp env) (eval-exp exp (extended-env ids args env))))))



#|

AREA
(eval-program (parser "evaluar
                       procedimiento (@radio)
                           haga (3.141516 * (@radio * @radio)) finProc
                       (4) finEval"))

FACTORIAL
(eval-program (parser "procedimiento-rec
    (@factorial (@x) haga
           Si @x
                 entonces (evaluar @factorial ((@x ~ 1)) finEval * @x)
                 sino 1 finSI)
              con evaluar  @factorial (3) finEval"))

MULTIPLICAR
(eval-program (parser "procedimiento-rec
      (@multiplicar (@a, @b) haga
          Si @b
                entonces (evaluar @multiplicar (@a ,sub1(@b)) finEval + @a)
                sino 0 finSI)
             con evaluar @multiplicar (3,4) finEval"))

PROGRAMA QUE HACE SUMAS RESTAS Y MULTIPLICACIONES
(eval-program (parser "procedimiento-rec
      (
       @sumar (@a, @b) haga
          Si @b
                entonces evaluar @sumar (add1(@a),sub1(@b)) finEval
                sino @a finSI
       @restar (@a, @b) haga
          Si @b
                entonces evaluar @restar (sub1(@a),sub1(@b)) finEval
                sino @a finSI
       @multi (@a, @b) haga
          Si @b
                entonces evaluar @sumar
                        (evaluar @multi (@a ,sub1(@b)) finEval  , @a) finEval
                sino 0 finSI)
       con evaluar @multi (3,4) finEval"))

|#



