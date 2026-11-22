#lang racket/base

; =========================================================================
; CS F301 — Assignment 2, S1: Binary Tree Traversals
; Group 59
;
; Tree representation:
;   - Empty tree: '()
;   - Node:       (value left right) where left and right are trees.
;
; Allowed built-ins only:
;   define, lambda, let, let*, letrec, named let, if, cond, and, or, not,
;   begin, quote ('), cons, car, cdr, list, cadr, caddr, etc., null?, pair?,
;   eq?, assq, assoc, +, -, *, <, >, <=, >=, =, max, display, newline.
;
; No forbidden built-ins (no set!, length, append, reverse, map, filter).
; No top-level function calls — the grader adds calls itself.
; =========================================================================

; -------------------------------------------------------------------------
; Tree Accessor Helpers
; -------------------------------------------------------------------------

; tree-val : node -> value
(define (tree-val tree)
  (car tree))

; tree-left : node -> left-subtree
(define (tree-left tree)
  (cadr tree))

; tree-right : node -> right-subtree
(define (tree-right tree)
  (caddr tree))

; -------------------------------------------------------------------------
; Inorder Traversal Helper (Accumulator-based to avoid append)
;
; Recursive reading:
; To collect inorder traversal with an accumulator `acc`:
; - Empty tree '() returns `acc`.
; - For a node: recursively collect the right subtree onto `acc`,
;   cons the node's value in front, then recursively collect the left
;   subtree onto that result.
; -------------------------------------------------------------------------

; inorder-helper : tree list -> list
(define (inorder-helper tree acc)
  (if (null? tree)
      acc
      (inorder-helper (tree-left tree)
                      (cons (tree-val tree)
                            (inorder-helper (tree-right tree) acc)))))

; inorder : tree -> list
(define (inorder tree)
  (inorder-helper tree '()))

; -------------------------------------------------------------------------
; S1.a — print-inorder
;
; Prints the list of values of the tree in inorder (left subtree, node,
; right subtree) using `display`, followed by a newline.
; -------------------------------------------------------------------------

; print-inorder : tree -> void
(define (print-inorder tree)
  (display (inorder tree))
  (newline))
