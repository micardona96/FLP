#lang eopl
#|

    DEV: MIGUEL ÁNGEL CARDONA CHAMORRO
    CODE: 1628209


ANALIZAR LA GRAMATICA

<programa> :=  <expresion>
               un-programa (exp)

<expresion> := <numero>
               numero-lit (num)

            := "\""<texto> "\""
               texto-lit (txt)

            := <identificador>
               var-exp (id)

            := (expresion <primitiva-binaria> expresion)
               primapp-bin-exp (exp1 exp2)

            := <primitiva-unaria> (expresion)
               primapp-un-exp (exp)

            := Si <expresion> entonces <expresion>  sino <expresion> finSI
               condicional-exp (test-exp true-exp false-exp)

            := declarar (<identificador> = <expresion> (;)) { <expresion> }

               variableLocal-exp (ids exps cuerpo)


<primitiva-binaria> :=  + (primitiva-suma)
                    :=  ~ (primitiva-resta)
                    :=  / (primitiva-div)
                    :=  * (primitiva-multi)
                    :=  concat (primitiva-concat)

<primitiva-unaria>  :=  longitud (primitiva-longitud)
                    :=  add1 (primitiva-add1)
                    :=  sub1 (primitiva-sub1)


ANALISIS LEXICA

<numero>: Debe definirse para valores decimales y enteros (positivos y negativos)

<texto>: Debe definirse para cualquier texto escrito en racket

<identificador>: En este lenguaje todo identificador iniciará con el símbolo  @,
                 es decir las variables @x y @z son válidas

|#
