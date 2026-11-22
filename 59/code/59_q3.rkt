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

; -------------------------------------------------------------------------
; Preorder Traversal Helper (Accumulator-based to avoid append)
;
; Recursive reading:
; To collect preorder traversal with an accumulator `acc`:
; - Empty tree '() returns `acc`.
; - For a node: recursively collect the right subtree onto `acc`,
;   then recursively collect the left subtree onto that,
;   and finally cons the node's value in front.
; -------------------------------------------------------------------------

; preorder-helper : tree list -> list
(define (preorder-helper tree acc)
  (if (null? tree)
      acc
      (cons (tree-val tree)
            (preorder-helper (tree-left tree)
                             (preorder-helper (tree-right tree) acc)))))

; preorder : tree -> list
(define (preorder tree)
  (preorder-helper tree '()))

; -------------------------------------------------------------------------
; Postorder Traversal Helper (Accumulator-based to avoid append)
;
; Recursive reading:
; To collect postorder traversal with an accumulator `acc`:
; - Empty tree '() returns `acc`.
; - For a node: cons the node's value onto `acc`,
;   recursively collect the right subtree onto that,
;   then recursively collect the left subtree onto that result.
; -------------------------------------------------------------------------

; postorder-helper : tree list -> list
(define (postorder-helper tree acc)
  (if (null? tree)
      acc
      (postorder-helper (tree-left tree)
                        (postorder-helper (tree-right tree)
                                          (cons (tree-val tree) acc)))))

; postorder : tree -> list
(define (postorder tree)
  (postorder-helper tree '()))

; -------------------------------------------------------------------------
; S1.b — print-all-traversals
;
; Prints three lines using `display`:
;   Line 1: inorder list (left, node, right)
;   Line 2: preorder list (node, left, right)
;   Line 3: postorder list (left, right, node)
; Each line ends with a newline.
; -------------------------------------------------------------------------

; print-all-traversals : tree -> void
(define (print-all-traversals tree)
  (display (inorder tree))
  (newline)
  (display (preorder tree))
  (newline)
  (display (postorder tree))
  (newline))

; -------------------------------------------------------------------------
; Tree Height and Leaf Count Helpers
;
; Conventions:
; - The height of '() is 0.
; - The height of a node is 1 + max(height(left), height(right)).
;   A single node has height 1.
; - A leaf is a node whose left and right subtrees are both '().
; - The empty tree '() has 0 leaves.
; -------------------------------------------------------------------------

; tree-height : tree -> number
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (tree-left tree))
                (tree-height (tree-right tree))))))

; leaf? : node -> boolean
(define (leaf? tree)
  (and (null? (tree-left tree))
       (null? (tree-right tree))))

; tree-leaf-count : tree -> number
(define (tree-leaf-count tree)
  (cond
    ((null? tree) 0)
    ((leaf? tree) 1)
    (else (+ (tree-leaf-count (tree-left tree))
             (tree-leaf-count (tree-right tree))))))

; -------------------------------------------------------------------------
; S1.c — print-height-and-leaves
;
; Prints one line: the list (height leaf-count) using `display`,
; followed by a newline.
; -------------------------------------------------------------------------

; print-height-and-leaves : tree -> void
(define (print-height-and-leaves tree)
  (display (list (tree-height tree) (tree-leaf-count tree)))
  (newline))
