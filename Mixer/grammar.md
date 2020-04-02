
### Programa

:=  `< expresion >`  \
un-programa (  _**exp**_  )
     

---
### Expresión

:=  `< numero >` \
número-exp (  _**num**_  )


:=  **'**  `< texto >`  **'** \
texto-exp (  _**txt**_  )


:=  `< identificador >`  [id-exp (  _**id**_  ) ]

:=  **if**  `< expresion >`  **{**  `< expresion >`  **} else {**  `< expresion >`  **}**  [ condicional-exp (  _**cond**_  _**true-exp**_  _**false-exp**_  ) ]

:=  **const**  `< identificador >`  **=**  `< expresion >`  [ constante-exp (  _**id**_  _**exp**_  ) ]

:=  **static**  `< identificador >`  [ crear-var-exp (  _**id**_) ]

:=  **init static**  `< identificador >`  **=**  `< expresion >`  [ asignar-var-exp (  _**id**_  _**exp**_  )]

:=  **x32**  **[**  `< numero * >`  **]**  [ base-32-exp (  _**nums**_  )]

:=  **x16**  **[**  `< numero * >`  **]**  [ base-16-exp (  _**nums**_  )]

:=  **x8**  **[**  `< numero * >`  **]**  [ base-8-exp (  _**nums**_  )]

:=  **new list**  [ nueva-lista-exp]

:=  **list**  **=**  **[**  `< expresion , * >`  **]**  [ iniciar-lista-exp (  _**exps**_  )]

:=  **(**  `< expresion >`  `< primitiva-binaria >`  `< expresion >`  **)**  [ op-binaria-exp (  _**rand primitive-bin rator**_  )]

:=  `< primitiva-unaria >`  **(**  `< expresion >`  **)**  [ op-unaria-exp (  _**primitive-un exp**_  )]

:=  **func (**  `< identificador , * >`  **) => {**  `< expresion >`  **}**  [ función-exp (  _**ids**_  **exp**  )]

:=  **import (**  `< expresion >`  **(**  `< expresion * >`  **)**  [ ejecutar-function-exp (  _**ids**_  **exp**  )]

:=  **export func**  `< identificador >`  **(**  `< identificador , * >`  **) => {**  `< expresion >`  **}**  [ función-rec-exp (  **id**  _**ids**_  **exp**  )]


---
### Primitiva-Unaria

:=  **!**  [ negación ]

:=  **++**  [ sumar-uno ]

:=  **--**  [ restar-uno ]

:=  **strlen**  [ longitud ]

:=  **isNull**  [ es-vacía? ]

:=  **isList**  [ es-lista? ]

:=  **pop**  [ primer-ítem ]

:=  **next**  [ resto-items ]

---
### Primitiva-Binaria

:=  **>**  [ mayor ]

:=  **>=**  [ mayor-o-igual]

:=  **<**  [ menor ]

:=  **<=**  [ menor-o-igual ]

:=  **==**  [ igual ]

:=  **&&**  [ and ]

:=  **||**  [ or ]

:=  **!=**  [ diferente ]

:=  **+**  [ sumar ]

:=  -  [ restar ]

:=  *  [ multiplicar ]

:=  **/**  [ dividir ]

:=  **mod**  [ módulo ]

:=  **concat**  [ concatenar ]

:=  **join**  [  join-lista ]

:=  **push**  [ push-lista ]














