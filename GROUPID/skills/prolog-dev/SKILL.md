---
name: prolog-dev
description: Skill file for SWI-Prolog development in CS F301 Assignment 2
---

# Prolog Development Skill

## Language & Version
- **Language:** Prolog (ISO + SWI extensions)
- **Implementation:** SWI-Prolog 9.x
- **Run command:** `swipl -q -f <file>.pl -g main -t halt` (for main), or `swipl -q -f <file>.pl -g "<goal>" -t halt` (for individual predicates)

## Coding Conventions

### Naming
- Predicate names use `snake_case` (e.g., `count_solutions/2`).
- Variables start with uppercase (`X`, `Solution`, `Active`).
- Atoms use lowercase or single-quoted when they contain special characters (e.g., `'Alex'`, `'c++'`, `'AI'`).

### Comments
- Each predicate begins with a comment: `% predicate_name/arity — one-line description`.
- Complex logic gets inline comments explaining the declarative reading.
- Clue predicates include the English sentence of the clue as a comment.

### Structure
- One predicate definition per logical block, separated by blank lines.
- Helper predicates are defined before the predicates that use them.
- Each clue is its own `clue(N, Solution)` clause — never merge multiple clues.

### Declarative Reading
- Every predicate should have a clear declarative reading: "clue(1, S) holds when in solution S, the AI-project friend is not in research and is not Dana."
- Prefer logical constraints over imperative generate-and-test where possible.

## How to Run & Test
```bash
# Run main predicate
swipl -q -f GROUPID_q1.pl -g main -t halt

# Test a specific predicate
swipl -q -f GROUPID_q1.pl -g "clue(1, Solution)" -t halt

# Run test file
swipl -q -f test_q1.pl -g run_tests -t halt
```

## Restrictions (MUST follow)
- **NO** `assert`, `retract`, or global variables (`b_setval`, `nb_setval`).
- **NO** `halt/0` in source files.
- **NO** initialization directives (`:- initialization(...)`, `:- main`).
- **Allowed libraries:** `lists`, `apply`, `yall`, `aggregate`.
- Files contain **only definitions** — no top-level calls.
- Do not print anything other than what is specified in the task.

## Self-Review Checklist
Before finalizing any Prolog code, verify:
1. [ ] No initialization directives in the file
2. [ ] No calls to `halt/0`
3. [ ] No use of `assert/retract/b_setval/nb_setval`
4. [ ] All atoms match the exact specification (quoted where needed)
5. [ ] Output format matches the spec exactly (spacing, brackets, commas)
6. [ ] Predicate terminates — no infinite loops
7. [ ] `findall/3` or `aggregate_all/3` used correctly for counting
8. [ ] File loads without errors: `swipl -q -f file.pl -g true -t halt`
9. [ ] Each clue is a separate `clue/2` clause
10. [ ] No duplicate solutions from non-deterministic predicates

## Known AI Failure Modes for Prolog
1. **Atom quoting errors:** AI often forgets to quote atoms like `'Alex'`, `'c++'`, `'AI'`. Always single-quote atoms with uppercase or special chars.
2. **Permutation explosions:** AI may generate-and-test all permutations instead of using constraint propagation. Use `member/2` to select from domains and let unification prune.
3. **Output format mismatches:** AI adds extra spaces, brackets, or newlines. Match the spec character-by-character.
4. **Forgetting `halt/0` restriction:** AI often adds `:- main.` or calls `halt`. Never do this.
5. **Wrong arity:** AI sometimes defines `clue/1` instead of `clue/2`.
6. **Non-determinism leaks:** AI forgets cuts or uses predicates that leave choice points, causing duplicate solutions.
7. **String vs atom confusion:** In SWI-Prolog, `"hello"` is a string (list of codes), not an atom. Use atoms or explicitly handle strings where required (P2).
8. **Division safety:** AI ignores the "divisor not zero, result is integer" check for `/`.
