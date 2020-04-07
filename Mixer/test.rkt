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

(parser "x32 [1 0 2 3]")
(parser "x16 [1 0 2 3]")
(parser "x8  [1 0 2 3]")

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
(parser "([1] join [2,6])")
(parser "([1,2] push [3,4])")
(parser "++32 (x32[1 2 3])")
(parser "--16 (x16[1 2 3])")
(parser "(x32[1 2 3] +32 x32[1 2 3])")
(parser "(x32[1 2 3] *32 x32[1 2 3])")



;; ++ COMPLEX 

(parser "export func $factorial ($x) => {
           if ($x == 0){1} else {( $x * import $factorial (--($x)) )}}")

(parser "export func $fibonacci ($x) => {
           if (($x == 0) || ($x == 1)){1} else {
                              ( import $fibonacci (--($x)) + import $fibonacci (($x - 2)) )}}")

(parser "private def (static $s, init static $x = 3, const $y = 5){(($s+1) * $y)}")

(parser "private def (static $XXX, init static $YYYY = 3, const $ZZZZZ = 5)
           { private def (static $AAA, init static $BBBB = 3, const $CCCC = 5){(($s+1) * $y)}}")

(parser "private def (init static $x = func ($x) => {++($x)})
{import $x (5)}")

(parser "import func ($y) => {++($y)} (5)")


;; VALIDACION 2
;; BASIC
(parser "import export func $factorial ($x) => {
           if ($x == 0){1} else {( $x * import $factorial (--($x)) )}} (3)")

;;ADVANCED
(parser "private def (init static $VarX = 3,
                      const $Fact = export func $factorial ($x) => {
                          if ($x == 0){ 1 } else { ( $x * import $factorial (--($x)) )}})
                     {import $Fact ($VarX)}")
