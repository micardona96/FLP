
### Programa

> :=  `< expresion >` <br> un-programa (  _**exp**_ )

---
### Expresión

> :=  `< numero >`  <br> número-exp (  _**num**_ )

> :=  **'**  `< texto >`  **'** <br> texto-exp (  _**txt**_  )

> :=  `< identificador >`  [id-exp (  _**id**_ )

> :=  **if**  `< expresion >`  **{**  `< expresion >`  **} else {**  `< expresion >`  **}**  <br> condicional-exp (  _**cond**_  _**true-exp**_  _**false-exp**_ )

> :=  **const**  `< identificador >`  **=**  `< expresion >` <br> constante-exp (  _**id**_  _**exp**_ )

> :=  **static**  `< identificador >` <br> crear-var-exp (  _**id**)

> :=  **init static**  `< identificador >`  **=**  `< expresion >` <br> asignar-var-exp (  _**id**_  _**exp**_ )

> :=  **x32**  **[**  `< numero * >`  **]**  <br> base-32-exp (  _**nums**_ )

> :=  **x16**  **[**  `< numero * >`  **]**  <br> base-16-exp (  _**nums**_ )

> :=  **x8**  **[**  `< numero * >`  **]**  <br> base-8-exp (  _**nums**_ )

> :=  **new list**  <br> nueva-lista-exp]

> :=  **list**  **=**  **[**  `< expresion , * >`  **]** <br> iniciar-lista-exp (  _**exps**_ )

> :=  **(**  `< expresion >`  `< primitiva-binaria >`  `< expresion >`  **)**  <br> op-binaria-exp (  _**rand primitive-bin rator**_ )

> :=  `< primitiva-unaria >`  **(**  `< expresion >`  **)**  <br> op-unaria-exp (  _**primitive-un exp**_ )

> :=  **func (**  `< identificador , * >`  **) => {**  `< expresion >`  **}**  <br> función-exp (  _**ids**_  **exp** )

> :=  **import (**  `< expresion >`  **(**  `< expresion * >`  **)**  <br> ejecutar-function-exp (  _**ids**_  **exp** )

> :=  **export func**  `< identificador >`  **(**  `< identificador , * >`  **) => {**  `< expresion >`  **}**  <br> función-rec-exp (  **id**  _**ids**_  **exp** )


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

:=  * [ multiplicar ]

:=  **/**  [ dividir ]

:=  **mod**  [ módulo ]

:=  **concat**  [ concatenar ]

:=  **join**  [  join-lista ]

:=  **push**  [ push-lista ]




