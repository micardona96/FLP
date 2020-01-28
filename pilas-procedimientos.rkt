#lang racket
;; Define Grammar
;; Stack ::= (empty-stack)
;;       ::= (push-stack symbol Stack)

;; (empty-stack)                 => '(empty-stack)
;; (push-stack A |[v1 v2 v3]|)   => |[A v1 v2 v3]|
;; (pop-stack |[A v1 v2...]|)    => |[v1 v2]|

;; (top-stack |[A v2 v3...]|)    => A
;; (empty-stack? Element)        => #t if Element is a Stack
;;                               => #f otherwise



;; No entinedo xD
