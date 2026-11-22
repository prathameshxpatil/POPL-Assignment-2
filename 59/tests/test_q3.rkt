#lang racket/base

; =========================================================================
; Test Suite for S1: Binary Tree Traversals (59_q3.rkt)
; Group 59
;
; Run with:
;   racket 59/tests/test_q3.rkt
; or from within 59/tests/:
;   racket test_q3.rkt
; =========================================================================

(require racket/file)

;; -------------------------------------------------------------------------
;; Load definitions from 59_q3.rkt
;; -------------------------------------------------------------------------

(define code-path
  (cond
    ((file-exists? "59/code/59_q3.rkt") "59/code/59_q3.rkt")
    ((file-exists? "../code/59_q3.rkt") "../code/59_q3.rkt")
    ((file-exists? "code/59_q3.rkt") "code/59_q3.rkt")
    (else "59_q3.rkt")))

(define ns (make-base-namespace))

;; Read all definitions, stripping #lang line
(define file-lines (file->lines code-path))
(define code-str
  (apply string-append
         (map (lambda (line)
                (if (and (>= (string-length line) 5)
                         (string=? (substring line 0 5) "#lang"))
                    "\n"
                    (string-append line "\n")))
              file-lines)))

(parameterize ([current-namespace ns])
  (eval (read (open-input-string (string-append "(begin " code-str ")")))))

;; Helper to run an expression and capture its stdout string
(define (run-and-capture expr)
  (let ([out (open-output-string)])
    (parameterize ([current-output-port out]
                   [current-namespace ns])
      (eval expr))
    (get-output-string out)))

;; -------------------------------------------------------------------------
;; Test Trees
;; -------------------------------------------------------------------------

;; t1 from spec:
;;        4
;;      /   \
;;     2     6
;;    / \   / \
;;   1   3 5   7
(define t1 '(4 (2 (1 () ()) (3 () ()))
               (6 (5 () ()) (7 () ()))))

;; t2 from spec: right-skewed
;;   1 -> 2 -> 3
(define t2 '(1 () (2 () (3 () ()))))

;; t3 from spec: symbols
;;     a
;;    / \
;;   b   c
(define t3 '(a (b () ()) (c () ())))

;; Empty tree
(define t-empty '())

;; Single node tree
(define t-single '(42 () ()))

;; Left-skewed tree
;;   3 -> 2 -> 1
(define t-left '(3 (2 (1 () ()) ()) ()))

;; -------------------------------------------------------------------------
;; Assert Helper
;; -------------------------------------------------------------------------

(define (assert-equal test-name actual expected)
  (if (string=? actual expected)
      (begin
        (display "PASS: ")
        (display test-name)
        (newline))
      (begin
        (display "FAIL: ")
        (display test-name)
        (display " — expected: ")
        (display (format "~s" expected))
        (display ", got: ")
        (display (format "~s" actual))
        (newline))))

;; -------------------------------------------------------------------------
;; Test Suite Execution
;; -------------------------------------------------------------------------

(define (run-all-tests)
  (display "=== S1 Scheme Binary Tree Traversals Test Suite ===")
  (newline)

  ;; S1.a tests: print-inorder
  (assert-equal "print-inorder on t1"
                (run-and-capture `(print-inorder ',t1))
                "(1 2 3 4 5 6 7)\n")

  (assert-equal "print-inorder on t2"
                (run-and-capture `(print-inorder ',t2))
                "(1 2 3)\n")

  (assert-equal "print-inorder on t3"
                (run-and-capture `(print-inorder ',t3))
                "(b a c)\n")

  (assert-equal "print-inorder on empty tree"
                (run-and-capture `(print-inorder ',t-empty))
                "()\n")

  (assert-equal "print-inorder on single node"
                (run-and-capture `(print-inorder ',t-single))
                "(42)\n")

  (assert-equal "print-inorder on left-skewed tree"
                (run-and-capture `(print-inorder ',t-left))
                "(1 2 3)\n")

  ;; S1.b tests: print-all-traversals
  (assert-equal "print-all-traversals on t1"
                (run-and-capture `(print-all-traversals ',t1))
                "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")

  (assert-equal "print-all-traversals on t2"
                (run-and-capture `(print-all-traversals ',t2))
                "(1 2 3)\n(1 2 3)\n(3 2 1)\n")

  (assert-equal "print-all-traversals on t3"
                (run-and-capture `(print-all-traversals ',t3))
                "(b a c)\n(a b c)\n(b c a)\n")

  (assert-equal "print-all-traversals on empty tree"
                (run-and-capture `(print-all-traversals ',t-empty))
                "()\n()\n()\n")

  (assert-equal "print-all-traversals on single node"
                (run-and-capture `(print-all-traversals ',t-single))
                "(42)\n(42)\n(42)\n")

  (assert-equal "print-all-traversals on left-skewed tree"
                (run-and-capture `(print-all-traversals ',t-left))
                "(1 2 3)\n(3 2 1)\n(1 2 3)\n")

  ;; S1.c tests: print-height-and-leaves
  (assert-equal "print-height-and-leaves on t1"
                (run-and-capture `(print-height-and-leaves ',t1))
                "(3 4)\n")

  (assert-equal "print-height-and-leaves on t2"
                (run-and-capture `(print-height-and-leaves ',t2))
                "(3 1)\n")

  (assert-equal "print-height-and-leaves on t3"
                (run-and-capture `(print-height-and-leaves ',t3))
                "(2 2)\n")

  (assert-equal "print-height-and-leaves on empty tree"
                (run-and-capture `(print-height-and-leaves ',t-empty))
                "(0 0)\n")

  (assert-equal "print-height-and-leaves on single node"
                (run-and-capture `(print-height-and-leaves ',t-single))
                "(1 1)\n")

  (assert-equal "print-height-and-leaves on left-skewed tree"
                (run-and-capture `(print-height-and-leaves ',t-left))
                "(3 1)\n")

  (display "=== All S1 tests complete ===")
  (newline))

(run-all-tests)
