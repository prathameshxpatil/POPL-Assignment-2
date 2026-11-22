# P1 Report — Department Assignment Puzzle

## P1.b: Value of N

With all eight original clues active (`[1,2,3,4,5,6,7,8]`):

**N = 3**

## What This Tells Us

The puzzle as originally stated is **under-constrained** — the eight clues do not uniquely determine the assignment. There are three distinct valid solutions:

| Solution | Alex | Ben | Carla | Dana |
|----------|------|-----|-------|------|
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

### Observations

- **Ben's assignment is fully determined** by clues 1–8: he is always in development, with javascript, working on web. The ambiguity lies in the assignments of Alex, Carla, and Dana.
- Solutions 1 and 3 have identical sets of (dept, lang, project) triples — only the people assigned to them differ. This means the clues constrain the *attribute combinations* well but leave some *person-to-combination* mappings ambiguous.
- Solution 2 has a different distribution entirely: the testing department gets the AI project, while in solutions 1 and 3, testing gets embedded.

## P1.c: The Repair Clue

**Clue 9:** *"The friend in the testing department prefers the AI project."*

This clue:
- Is true in solution 2 (Carla: testing + AI)
- Is false in solutions 1 and 3 (testing + embedded in both)
- Does not mention any friend by name — it refers only to attribute values

With clue 9 added, `count_solutions([1,2,3,4,5,6,7,8,9], N)` gives **N = 1**, making the puzzle uniquely solvable.
