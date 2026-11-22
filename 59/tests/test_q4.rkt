#lang racket/base

; =========================================================================
; Test Suite for S2: Conditional List Inserter (59_q4.rkt)
; Group 59
;
; Run with:
;   racket 59/tests/test_q4.rkt
; or from within 59/tests/:
;   racket test_q4.rkt
; =========================================================================

(require racket/file)

;; -------------------------------------------------------------------------
;; Load definitions from 59_q4.rkt
;; -------------------------------------------------------------------------

(define code-path
  (cond
    ((file-exists? "59/code/59_q4.rkt") "59/code/59_q4.rkt")
    ((file-exists? "../code/59_q4.rkt") "../code/59_q4.rkt")
    ((file-exists? "code/59_q4.rkt") "code/59_q4.rkt")
    (else "59_q4.rkt")))

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

;; Helper to run print-insert-result with specified stdin string and capture stdout
(define (run-with-input-capture input-str)
  (let ([in (open-input-string input-str)]
        [out (open-output-string)])
    (parameterize ([current-input-port in]
                   [current-output-port out]
                   [current-namespace ns])
      (eval '(print-insert-result)))
    (get-output-string out)))

;; -------------------------------------------------------------------------
;; Assert Helper
;; -------------------------------------------------------------------------

(define (assert-equal test-name actual expected)
  (if (equal? actual expected)
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
;; Test Helpers: Large List & Deep Nesting Generators
;; -------------------------------------------------------------------------

;; Generates a list of n integers: (0 1 2 ... n-1)
(define (make-range-list n)
  (let loop ([i (- n 1)] [acc '()])
    (if (< i 0)
        acc
        (loop (- i 1) (cons i acc)))))

;; Generates a nested list of specified depth:
;; depth 1: (())
;; depth 2: ((()))
;; depth d: (((... ()...)))
(define (make-nested-list depth)
  (let loop ([d depth] [acc '()])
    (if (= d 0)
        acc
        (loop (- d 1) (list acc)))))

;; -------------------------------------------------------------------------
;; Test Suite Execution
;; -------------------------------------------------------------------------

(define (run-all-tests)
  (display "=== S2 Scheme Conditional List Inserter Test Suite ===")
  (newline)

  ;; -----------------------------------------------------------------------
  ;; S2.b tests: my-length and my-map
  ;; -----------------------------------------------------------------------
  (assert-equal "my-length on empty list"
                (parameterize ([current-namespace ns]) (eval '(my-length '())))
                0)

  (assert-equal "my-length on standard list"
                (parameterize ([current-namespace ns]) (eval '(my-length '(1 2 3 4 5))))
                5)

  (assert-equal "my-length on 10,000 elements"
                (let ([ten-k (make-range-list 10000)])
                  (parameterize ([current-namespace ns])
                    (eval `(my-length ',ten-k))))
                10000)

  (assert-equal "my-map on empty list"
                (parameterize ([current-namespace ns]) (eval '(my-map (lambda (x) (+ x 1)) '())))
                '())

  (assert-equal "my-map on standard list"
                (parameterize ([current-namespace ns]) (eval '(my-map (lambda (x) (* x 2)) '(1 2 3))))
                '(2 4 6))

  (assert-equal "my-map on 10,000 elements"
                (let* ([ten-k (make-range-list 10000)]
                       [res (parameterize ([current-namespace ns])
                              (eval `(my-map (lambda (x) (+ x 1)) ',ten-k)))])
                  (let check ([l res] [expected 1])
                    (cond
                      ((null? l) (if (= expected 10001) 10000 #f))
                      ((= (car l) expected) (check (cdr l) (+ expected 1)))
                      (else #f))))
                10000)

  ;; -----------------------------------------------------------------------
  ;; S2.c tests: make-inserter and insert-if-short
  ;; -----------------------------------------------------------------------

  ;; Spec Example 1
  (assert-equal "insert-if-short: spec example 1"
                (parameterize ([current-namespace ns])
                  (eval '(insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3)))
                '((42 1 2) (3 4 5) (42 6) (42)))

  ;; Spec Example 2
  (assert-equal "insert-if-short: spec example 2 (empty list, 0 < 3)"
                (parameterize ([current-namespace ns])
                  (eval '(insert-if-short 7 '() 3)))
                '(7))

  ;; Spec Example 3
  (assert-equal "insert-if-short: spec example 3 (empty list, 0 < 0 false)"
                (parameterize ([current-namespace ns])
                  (eval '(insert-if-short 7 '() 0)))
                '())

  ;; Top-level insertion test
  (assert-equal "insert-if-short: top-level satisfies condition"
                (parameterize ([current-namespace ns])
                  (eval '(insert-if-short 99 '(1 2) 5)))
                '(99 1 2))

  (assert-equal "insert-if-short: top-level does not satisfy condition"
                (parameterize ([current-namespace ns])
                  (eval '(insert-if-short 99 '(1 2) 2)))
                '(1 2))

  ;; Multi-level nested lists with symbols
  (assert-equal "insert-if-short: multi-level nested with symbols"
                (parameterize ([current-namespace ns])
                  (eval '(insert-if-short 'x '((a b) (c (d))) 2)))
                '((a b) (c (x d))))

  ;; make-inserter with custom predicate
  (assert-equal "make-inserter with (= len 2)"
                (parameterize ([current-namespace ns])
                  (eval '((make-inserter 'Z (lambda (len) (= len 2)))
                          '((1 2) (1 2 3) (2 1) ()))))
                '((Z 1 2) (1 2 3) (Z 2 1) ()))

  ;; Nesting Depth 100 test
  (let* ([d100 (make-nested-list 100)]
         [res (parameterize ([current-namespace ns])
                (eval `(insert-if-short 'w ',d100 2)))])
    (assert-equal "insert-if-short: handles nesting depth 100 without stack overflow"
                  (car res)
                  'w))

  ;; 10,000 Elements Test (flat list)
  (let* ([ten-k (make-range-list 10000)]
         [res-no-ins (parameterize ([current-namespace ns])
                       (eval `(insert-if-short 999 ',ten-k 5)))])
    (assert-equal "insert-if-short: 10k elements (no insert, length unchanged)"
                  (parameterize ([current-namespace ns]) (eval `(my-length ',res-no-ins)))
                  10000))

  (let* ([ten-k (make-range-list 10000)]
         [res-ins (parameterize ([current-namespace ns])
                    (eval `(insert-if-short 999 ',ten-k 10001)))])
    (assert-equal "insert-if-short: 10k elements (insert at front, head is 999)"
                  (car res-ins)
                  999)
    (assert-equal "insert-if-short: 10k elements (new length is 10001)"
                  (parameterize ([current-namespace ns]) (eval `(my-length ',res-ins)))
                  10001))

  ;; -----------------------------------------------------------------------
  ;; S2.a tests: print-insert-result (stdin / stdout)
  ;; -----------------------------------------------------------------------

  (assert-equal "print-insert-result: spec example 1"
                (run-with-input-capture "42 ((1 2) (3 4 5) (6) ()) 3\n")
                "((42 1 2) (3 4 5) (42 6) (42))\n")

  (assert-equal "print-insert-result: spec example 2"
                (run-with-input-capture "7 () 3\n")
                "(7)\n")

  (assert-equal "print-insert-result: spec example 3"
                (run-with-input-capture "7 () 0\n")
                "()\n")

  (display "=== All S2 tests complete ===")
  (newline))

(run-all-tests)
