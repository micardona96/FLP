#lang eopl

#|
    Created by Miguel Cardona on 04/04/20.
    Copyright © 2020 Miguel Cardona 1628209. All rights reserved.

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
                
                :=  x32  [  < numero * >  ]  
                base-32-exp (nums)

                :=  x16  [  < numero * >  ]  
                base-16-exp (nums)

                :=  x8  [  < numero * >  ]  
                base-8-exp (nums)

                := [  < expresion > , *  ] 
                lista-exp (exps)

                :=  (< expresion >  < primitiva-binaria >  < expresion > )  
                op-binaria-exp (rand primitive-bin rator)

                :=  < primitiva-unaria >  (< expresion > )  
                op-unaria-exp (primitive-un exp)

                :=  func ( < identificador > , * ) => {  < expresion >  }  
                función-exp (ids exp)

                :=  import < expresion >  (< expresion > * )  
                ejecutar-function-exp (operator operands)

                :=  export func  < identificador >  (< identificador > , * ) => {  < expresion >  }  (< expresion > )
                función-rec-exp (id  ids  exp)

                :=  private def ( < expresion , * > ) {  < expresion >  }
                definicion-exp (def-privadas body)

                :=  const  < identificador >  =  < expresion > 
                constante-exp (id  exp)

                :=  static  < identificador > 
                crear-var-exp (id)

                :=  init static  < identificador >  =  < expresion > 
                asignar-var-exp (id  exp)


< primitiva-unaria >

        base-32
                :=  ++32  [ sumar-uno-32 ]
                :=  --32  [ restar-uno-32 ]
        base-16
                :=  ++16  [ sumar-uno-16 ]
                :=  --16  [ restar-uno-16 ]

         base-8
                :=  ++8  [ sumar-uno-8 ]
                :=  --8  [ restar-uno-8 ]

       decimales
                :=  !   [ negación ]
                :=  ++  [ sumar-uno ]
                :=  --  [ restar-uno ]

        strings
                :=  strlen  [ longitud ]

         listas
                :=  isNull  [ es-vacía? ]
                :=  isList  [ es-lista? ]
                :=  pop  [ primer-ítem ]
                :=  next [ resto-items ]


< primitiva-binaria >

         base-32
                :=  +32  [ sumar-32 ]
                :=  -32  [ restar-32 ]
                :=  *32  [ multiplicar-32 ]

         base-16
                :=  +32  [ sumar-16 ]
                :=  -32  [ restar-16 ]
                :=  *32  [ multiplicar-16 ]

          base-8
                :=  +8  [ sumar-8 ]
                :=  -8  [ restar-8 ]
                :=  *8  [ multiplicar-8 ]

       decimales
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

         strings
                :=  concat [ concatenar ]

          listas
                :=  join [ join-lista ]
                :=  push [ push-lista ]

|#
