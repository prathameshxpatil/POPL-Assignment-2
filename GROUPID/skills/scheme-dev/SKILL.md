---
name: scheme-dev
description: Skill file for Racket/Scheme development in CS F301 Assignment 2
---

# Scheme Development Skill

## Language & Version
- **Language:** Scheme (via Racket)
- **Implementation:** Racket 8.x
- **Dialect:** `#lang racket/base`
- **Run command:** `racket <file>.rkt`

## Coding Conventions

### Naming
- Function names use `kebab-case` (e.g., `print-inorder`, `insert-if-short`).
- Helper functions are prefixed with `my-` when reimplementing standard functions (e.g., `my-length`, `my-map`, `my-reverse`).
- Predicates (boolean-returning) end with `?` (e.g., `null?`, `pair?`).

### Comments
- Each function begins with: `; function-name : description`
- Complex recursion gets inline comments explaining the step.

### Structure
- Files start with `#lang racket/base` — always the very first line.
- Helper functions are defined before the functions that use them.
- One function per logical block, separated by blank lines.
- Use `define` for top-level functions; `let`/`let*`/`letrec` for local bindings.

### Recursive/Functional Reading
- Every function should have a clear recursive reading: "To get the inorder traversal: recursively traverse left, then the node, then recursively traverse right."
- Prefer tail recursion with accumulators where natural.
- Pass all state through function arguments — no mutation.

## Allowed Built-ins (STRICT — nothing else!)
```
define, lambda, let, let*, letrec, named let
if, cond (with else), and, or, not, begin
quote ('), cons, car, cdr, list
cadr, cddr, caddr, cdddr, cadddr, cddddr (all car/cdr compositions up to 4 levels)
null?, pair?, eq?, assq, assoc
+, -, *, <, >, <=, >=, =
max
display, newline
read (S2 only)
```

## Forbidden (NEVER use)
- `set!` or any mutation
- `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`
- `list-ref`, `list-tail`
- `vectors`, `hash tables`, `strings`
- `do`, `for` or any loop construct
- `apply`, `eval`, `require`, `provide`
- Any function not in the allowed list above

If you need `length`, `map`, `append`, etc. — write your own (`my-length`, `my-map`, `my-append`).

## How to Run & Test
```bash
# Run a Scheme file
racket GROUPID_q3.rkt

# Test interactively
racket -i GROUPID_q3.rkt
# Then type: (print-inorder '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))

# For S2 (reads from stdin):
echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket GROUPID_q4.rkt
```

## Self-Review Checklist
Before finalizing any Scheme code, verify:
1. [ ] File starts with `#lang racket/base` on line 1
2. [ ] No top-level function calls — only `define` forms
3. [ ] No forbidden built-ins used (especially `length`, `append`, `map`, `set!`)
4. [ ] No printing when file is loaded — grader adds its own calls
5. [ ] Every function ends output with `(newline)` where specified
6. [ ] Uses `display` for output (not `print` or `write` — they add quotes)
7. [ ] Empty tree `'()` handled correctly as a base case
8. [ ] All state passed through arguments (no global mutation)
9. [ ] Tail recursion used where natural
10. [ ] Trees use the specified representation: `(value left right)` or `()`

## Known AI Failure Modes for Scheme
1. **Using forbidden functions:** AI reflexively uses `length`, `append`, `map`, `reverse`. Always write `my-` versions.
2. **Wrong output function:** AI uses `print` or `write` instead of `display`. `display` does not add quotes around symbols.
3. **Forgetting `#lang racket/base`:** AI sometimes uses `#lang racket` or omits the language line.
4. **Top-level calls:** AI adds test calls at the bottom of the file. Remove them — grader adds its own.
5. **Mutation:** AI uses `set!` or `define` inside functions to update variables. Use `let` or recursion instead.
6. **Wrong tree representation:** AI may assume `(left value right)` instead of `(value left right)`.
7. **Empty tree handling:** AI returns wrong values for `'()` — height should be 0, leaf count 0.
8. **Tail recursion mistakes:** AI may build stack-heavy recursion when an accumulator-based version is natural.
9. **Parenthesization of output:** `display` on a list prints `(1 2 3)` with parens — this is correct. Don't manually format.
10. **`read` behavior:** `read` reads one S-expression at a time. For S2, need three separate `read` calls.
