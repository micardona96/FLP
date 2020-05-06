#  🚀  Lenguaje Mixer
![Size](https://img.shields.io/github/size/micardona96/EOPL/Mixer/mixer.rkt)
![LICENSE](https://img.shields.io/github/license/micardona96/eopl)
![commits](https://img.shields.io/github/commit-activity/m/micardona96/EOPL)
![last-commit](https://img.shields.io/github/last-commit/micardona96/eopl)
![languages](https://img.shields.io/github/languages/top/micardona96/eopl)


Mixer es un lenguaje de programación (no tipado) con ciertas caracterısticas de lenguajes de programacion declarativos e imperativos. Se propone para este proyecto que usted implemente un lenguaje de programacion interpretado para lo cual usted es libre de proponer una sintaxis inspirandose en mınimo 3 lenguajes de programacion existentes (e.g., C, C++, Java, Python, R, Scala, Octave, etc). La semantica del lenguaje estara determinada por las especificaciones en este proyecto.


- [Mixer](#%EF%B8%8F-lenguaje-mixer)
- [Mixer +](#%EF%B8%8F-lenguaje-mixer-1)
- [Apéndice A](#%EF%B8%8F-essentials-of-programming-languages)
- [UniTest](/UniTest)

#### 🛰️ Valores

* **Valores denotados:**
enteros, flotantes, numeros
en base 32, hexadecimales, octales, cadenas de caracteres, booleanos (true, false), procedimientos, listas.

* **Valores expresados:**
enteros, flotantes, numeros en base 32, hexadecimales, octales, cadenas de caracteres, booleanos (true, false), procedimientos, listas.

#### 🎯 Aclaracion
Los numeros en una base distinta de 10, deberian representarse ası: [x32 0 23 12], [x16 4 1 0 7 14], [x8 2 1 4 0 7], teniendo en cuenta que el primer elemento de la lista indica la base del numero y el resto de la lista puede utilizar la representacion BIGNUM.

#### 💡 Sugerencia
trabaje los valores enteros, flotantes
desde la especificacion lexica. Implemente los n´umeros
en base 32, hexadecimales, octales, cadenas de caracteres, booleanos (true, false) y procedimientos desde la
especificacion gramatical.

## ✏️ Lenguaje Mixer

Caracterısticas del Lenguaje, el lenguaje debe permitir utilizar:

* **Identificadores:** Son secuencias de caracteres alfanumericos que comienzan con una letra o un simbolo especıfico dependiendo de las caracterısticas
que desee implementar en su lenguaje

* **Definiciones:** Este lenguaje permitira crear distintas definiciones:

  + **Constantes:** introduce una coleccion de
identificadores no actualizables y sus valores
iniciales. Una constante es de asignacion unica y debe ser declarada con un valor inicial,
por ejemplo: Constante y = 9;. Para este
caso y no podra ser modificada durante la
ejecucion de un programa.

  + **Variables de asignacion unica:** introduce una coleccion de identificadores actualizables una unica vez. Una variable de asignacion unica puede ser declarada ası: Val z
= 9, x = VALORMIXER;. Para este caso, z no
podr´a ser modificada durante la ejecuci´on de
un programa puesto que ya ha sido asignada. Sin embargo, x podra ser asignada una
unica vez a algun valor del lenguaje MIXER.
Por ejemplo: x ->29;. En caso que se utilice
la variable x sin estar ligada, el interpretador
debera lanzar un error.

* **Condicionales:** Son estructuras para controlar el
flujo de un programa

* **Expresiones:** las estructuras sintacticas son una
expresi´on. Algunas expresiones producen un valor,
otras producen un efecto (ejemplo, las expresiones
relacionadas con asignaci´on)

* **Primitivas booleanas:** <, >, <=, >=, ==, ! =
, ==, and, or, not. Estas primitivas son binarias
(exceptuando el not, que es unaria) y permiten
evaluar expresiones para generar un valor booleano
Primitivas aritmeticas para enteros:
+, −, ∗, %, /, add1, sub1

* **Primitivas aritmeticas para otras bases** +, −, ∗, add1, sub1

* **Primitivas sobre cadenas:** longitud, concatenar

* **Primitivas sobre listas:** se deben crear primitivas que simulen el comportamiento de: empty?,
empty, cons, list?, car, cdr, append

* **Definicion/invocacion de procedimientos:** el
lenguaje debe permitir la creacion/invocacion de
procedimientos que retornan un valor al ser invocados. El paso de parametros sera por valor y por
referencia, el lenguaje debera permitir identificar
de alguna manera la forma como se enviaran los
argumentos.

* **Definicion/invocacion de procedimientos recursivos:** el lenguaje debe permitir la creacion/invocacion de procedimientos que pueden invocarse recursivamente. . El paso de parametros
sera por valor y por referencia, el lenguaje debera
permitir identificar de alguna manera la forma como se enviaran los argumentos.

---
## 🖊️ Lenguaje Mixer+

* **Variables de multiple asignacion (mutables):** introduce una coleccion de variables actualizables y sus valores iniciales. El lenguaje debera
distinguir entre constantes, variables mutables y
variables asignacion unica. Una variable mutable
puede ser modificada cuantas veces se desee. Una
variable mutable puede ser declarada ası: Var a
= 5, b = MEZCLAVAL;. En ambos casos, ambas
variables podran ser modificadas durante la ejecucion de un programa. Por ejemplo: a ->9; o
b->true;

* **Secuenciacion**
el lenguaje debera permitir expresiones para la creacion de bloques de instrucciones

* **Iteracion**
el lenguaje debe permitir la deficion de
una estrutura de repeticion tipo for. Por ejemplo:
for x = a1 to a2 do a3 end. Se sugiere agregar
funcionalidad al lenguaje para que permita “imprimir” resultados por salida estandar tipo print.

* **Primitivas sobre vectores:** 
se debe extender
el lenguaje y agregar manejo de vectores. Se deben crear primitivas que simulen el comportamiento de: vector?, make-vector, vector-ref,
vector-set!.

* **Tipos de datos:**
el lenguaje debe permitir manejo de tipos de datos. El lenguaje debe incluir
solemanete chequeo de tipos (no es necesario implementar inferencia de tipos). Se deben definir
reglas para todas las primitivas, condicionales, invocaci´on de procedimientos, iteracion y manejo de
los distintos tipos de variables.

---
## 🖍️ ESSENTIALS OF PROGRAMMING LANGUAGES
Developed by [Miguel Cardona](mailto:cardona.miguel@correounivalle.edu.co),
This repository contains the codes related to different activities. for the development of a programming language using Scheme with the use of the SLLGEN library.

* [Interfaces](TALLER2)
* [Interpretador Basico](TALLER3)

## License
* Proyecto final escrito por: [Robinson Duque](mailto:robinson.duque@correounivalle.edu.co) , Ph.D <br>
* [MIT](LICENSE) Copyright (c) 2020 micardona96
