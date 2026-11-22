#lang racket/base

; =========================================================================
; CS F301 — Assignment 2, S2: Conditional List Inserter
; Group 59
;
; Allowed built-ins only:
;   define, lambda, let, let*, letrec, named let, if, cond, and, or, not,
;   begin, quote ('), cons, car, cdr, list, cadr, caddr, etc. (up to 4 levels),
;   null?, pair?, eq?, assq, assoc, +, -, *, <, >, <=, >=, =, max,
;   display, newline, read.
;
; Strictly forbidden:
;   set! or mutation, built-in length, append, map, reverse, filter,
;   member, memq, loops (do, for), require, provide.
; No top-level function calls or prints on load; grader adds calls.
; =========================================================================

; -------------------------------------------------------------------------
; S2.b — Helpers: my-length and my-map
; -------------------------------------------------------------------------

; my-length : list -> integer
; Calculates the length of a list using tail recursion with an accumulator.
; Operates in O(N) time and O(1) stack space to support lists of 10,000+ elements.
(define (my-length lst)
  (let loop ([l lst] [len 0])
    (if (null? l)
        len
        (loop (cdr l) (+ len 1)))))

; my-map : (any -> any) list -> list
; Maps function f over elements of list lst using tail recursion.
; An accumulator gathers mapped elements in reverse order and is then reversed
; using a tail-recursive helper to maintain O(1) stack frames.
(define (my-map f lst)
  (let loop ([l lst] [acc '()])
    (if (null? l)
        (let rev ([rem acc] [res '()])
          (if (null? rem)
              res
              (rev (cdr rem) (cons (car rem) res))))
        (loop (cdr l) (cons (f (car l)) acc)))))

; -------------------------------------------------------------------------
; S2.c — Higher-order make-inserter and insert-if-short
; -------------------------------------------------------------------------

; make-inserter : any (integer -> boolean) -> (list -> list)
; Higher-order function that takes atom x and predicate len-ok?.
; Returns a procedure of one argument (lst) that inserts atom x at the front
; of every list (including '() and nested sublists) whose original length
; satisfies (len-ok? len). Non-list atoms remain untouched.
(define (make-inserter x len-ok?)
  (letrec ([inserter
            (lambda (lst)
              (if (not (or (pair? lst) (null? lst)))
                  lst
                  (let* ([insert? (len-ok? (my-length lst))]
                         [transformed (my-map (lambda (elem)
                                                (if (or (pair? elem) (null? elem))
                                                    (inserter elem)
                                                    elem))
                                              lst)])
                    (if insert?
                        (cons x transformed)
                        transformed))))])
    inserter))

; insert-if-short : any list integer -> list
; Inserts atom x at the front of every list whose original length is less
; than n, at every level of nesting.
; Defined strictly using make-inserter.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))
