#lang eopl



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


(define especificacion-gramatical
  '((programa (expresion) un-programa)
    (expresion (numero) num-lit)
    (expresion ("\'" texto "\'") texto-lit)
    (expresion (identificador) var-exp)
    (expresion (primitiva "[" (separated-list expresion ",") "]") primapp-exp)
    (primitiva ("+") suma)
    (primitiva ("-") resta)
    (primitiva ("/") division)
    (primitiva ("*") multiplicacion)
    (primitiva ("concat") concat)
    (primitiva ("length") length)
    (primitiva ("add1") add1)
    (primitiva ("sub1") sub1)
    ))

(sllgen:make-define-datatypes especificacion-lexica especificacion-gramatical)
;; veiw datatypes genrate literal text
(define view-datatype (sllgen:list-define-datatypes especificacion-lexica especificacion-gramatical))

(define scanner (sllgen:make-string-scanner especificacion-lexica especificacion-gramatical))
(define parser (sllgen:make-string-parser especificacion-lexica especificacion-gramatical))

;; EVALUATIONS

;El Interpretador (FrontEnd + Evaluación + señal para lectura )

(define prompt
  (sllgen:make-rep-loop  "@Miguel > "
    (lambda (pgm) (eval-program pgm)) 
    (sllgen:make-stream-parser 
      especificacion-lexica especificacion-gramatical)))

 

(define eval-program
  (lambda (exe)
   (cases programa exe
     (un-programa (body) (eval-exp body (init-env))))))

(define eval-exp
  (lambda (exp env)
    (cases expresion exp
      (num-lit (numero) numero)
      (texto-lit (texto) texto)
      (var-exp (id) (apply-env env id)) ;; buscar el id en el ambiente
      (primapp-exp (rator rands) (let ((args (eval-rands rands env)))
                     (eval-primitive rator args))))))

(define eval-primitive
  (lambda (rator lista)
    (cases primitiva rator
      (suma () (suma-lista lista))
      (resta () (resta-lista lista))
      (multiplicacion () (multiplicacion-lista lista))
      (division () (division-lista lista))
      (concat ()  (concatenar lista))
      (length () 'length)
      (add1 () (+ (car lista) 1))
      (sub1 () (- (car lista) 1))
      )))

;; AUX FUNCTIONS

(define suma-lista
  (lambda (lista)
    (if (null? lista) 0
        (+ (car lista) (suma-lista (cdr lista))))))

(define resta-lista
  (lambda (lista)
    (if (null? (cdr lista)) (car lista)
        (- (car lista) (resta-lista (cdr lista))))))

(define multiplicacion-lista
  (lambda (lista)
      (if (null? lista) 1
        (* (car lista) (multiplicacion-lista (cdr lista))))))

(define division-lista
  (lambda (lista)
      (if (null? lista) 1
        (/ (car lista) (division-lista (cdr lista))))))

(define concatenar
  (lambda (lista)
      (if (null? lista) ""
        (string-append (car lista) (concatenar (cdr lista))))))


;; BUSCAR ITEM A ITEM EN EL AMBIENTE, retornando el valor

(define eval-rands
  (lambda (rands env)
    (map (lambda (x) (eval-rand x env)) rands)))

(define eval-rand
  (lambda (rand env)
    (eval-exp rand env)))

;*******************************************************************************************
;AUX ENVS DATA TYPES

;; Env de pruebas

(define init-env (lambda () (extend-env '(@x @y @z) '(1 2 3) (empty-env))))

;definición del tipo de dato ambiente
(define-datatype environment environment?
  (empty-env-record)
  (extended-env-record (syms (list-of symbol?))
                       (vals (list-of scheme-value?))
                       (env environment?)))

(define scheme-value? (lambda (v) #t)) ;; CUALQUIER COSA ES VALIDA
;función que crea un ambiente vacío
(define empty-env  
  (lambda ()
    (empty-env-record)))


;extend-env: <list-of symbols> <list-of numbers> enviroment -> enviroment
;función que crea un ambiente extendido
(define extend-env
  (lambda (syms vals env)
    (extended-env-record syms vals env))) 

;función que busca un símbolo en un ambiente
(define apply-env
  (lambda (env sym)
    (cases environment env
      (empty-env-record ()
                        (eopl:error 'apply-env "No binding for ~s" sym))
      (extended-env-record (syms vals env)
                           (let ((pos (list-find-position sym syms)))
                             (if (number? pos)
                                 (list-ref vals pos)
                                 (apply-env env sym)))))))

;****************************************************************************************

(define list-find-position
  (lambda (sym los)
    (list-index (lambda (sym1) (eqv? sym1 sym)) los)))

(define list-index
  (lambda (pred ls)
    (cond
      ((null? ls) #f)
      ((pred (car ls)) 0)
      (else (let ((list-index-r (list-index pred (cdr ls))))
              (if (number? list-index-r)
                (+ list-index-r 1)
                #f))))))
