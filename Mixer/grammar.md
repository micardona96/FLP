### Programa
:= `< expresion >`  [ un-programa ( ***exp*** ) ]


### Expresion
:= `< numero >`  [ número-exp ( ***num*** ) ]

:= **'** `< texto >` **'**  [ texto-exp ( ***txt*** ) ]

:= `< identificador >`  [id-exp ( ***id*** ) ]

:= **if** `< expresion >` **{** `< expresion >` **} else {** `< expresion >` **}** [ condicional-exp ( ***cond*** ***true-exp*** ***false-exp*** ) ]

:= **const** `< identificador >` **=**  `< expresion >`  [ constante-exp ( ***id*** ***exp*** ) ]

:= **static** `< identificador >` [ crear-var-exp ( ***id***) ]

:= **init static** `< identificador >` **=**  `< expresion >` [ asignar-var-exp ( ***id*** ***exp*** )]

:= **x32** **[** `< numero * >` **]**   [ base-32-exp ( ***nums*** )]

:= **x16** **[** `< numero * >` **]**   [ base-16-exp ( ***nums*** )]

:= **x8**   **[** `< numero * >` **]**   [ base-8-exp ( ***nums*** )]

:= **new list** [ nueva-lista-exp]

:= **list** **=** **[** `< expresion , * >` **]**   [ iniciar-lista-exp ( ***exps*** )]

:=  **(** `< expresion >`  `< primitiva-binaria >`   `< expresion >` **)**   [ op-binaria-exp ( ***rand primitive-bin rator*** )]

:=   `< primitiva-unaria >`   **(** `< expresion >` **)**   [ op-unaria-exp ( ***primitive-un exp*** )]

:= **func (**   `< identificador , * >` **) => {**  `< expresion >`  **}** [ función-exp ( ***ids*** **exp** )]

:= **import (**   `< expresion >` **(**  `< expresion * >`  **)** [ ejecutar-function-exp ( ***ids*** **exp** )]

:= **export func**   `< identificador >` **(** `< identificador , * >` **) => {**  `< expresion >`  **}** [ función-rec-exp ( **id** ***ids*** **exp** )]



















