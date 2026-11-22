% CS F301 — Assignment 2, Problem 1
% Department Assignment Puzzle, Reloaded
%
% A solution is a list of four terms:
%   [p('Alex', Dept, Lang, Proj), p('Ben', Dept, Lang, Proj),
%    p('Carla', Dept, Lang, Proj), p('Dana', Dept, Lang, Proj)]
%
% Each attribute domain has exactly four values, used exactly once.

:- use_module(library(lists)).
:- use_module(library(aggregate)).

% dept/1 — the four department values
dept(research).
dept(development).
dept(design).
dept(testing).

% lang/1 — the four favorite-language values
lang(python).
lang(java).
lang('c++').
lang(javascript).

% project/1 — the four project-preference values
project('AI').
project(web).
project(embedded).
project(data).

% solution_template/1 — a fully filled-in solution where every attribute
% domain is a permutation of its four values.
solution_template(Solution) :-
    Solution = [p('Alex', D1, L1, Pr1),
                p('Ben',  D2, L2, Pr2),
                p('Carla',D3, L3, Pr3),
                p('Dana', D4, L4, Pr4)],
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],       [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],              [Pr1, Pr2, Pr3, Pr4]).

% =========================================================================
% clue/2 — each clue as its own clause
% clue(N, Solution) succeeds when clue number N holds in Solution.
% =========================================================================

% CLUE 1: The friend who prefers the AI project does not work in research
%          and is not Dana.
clue(1, Solution) :-
    member(p(Name, Dept, _Lang, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.

% CLUE 2: Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _Proj), Solution),
    Dept \= development,
    Lang \= 'c++'.

% CLUE 3: The friend working in the testing department likes Python.
clue(3, Solution) :-
    member(p(_Name, testing, python, _Proj), Solution).

% CLUE 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    member(p('Ben', Dept, _Lang, web), Solution),
    Dept \= testing.


% CLUE 5: The friend whose favorite language is Java works in the design
%          department.
clue(5, Solution) :-
    member(p(_Name, design, java, _Proj), Solution).

% CLUE 6: Carla's project preference is not embedded, and her department
%          is not development.
clue(6, Solution) :-
    member(p('Carla', Dept, _Lang, Proj), Solution),
    Proj \= embedded,
    Dept \= development.

% CLUE 7: Dana's favorite language is not Java, and she works in research
%          or testing.
clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _Proj), Solution),
    Lang \= java,
    (Dept = research ; Dept = testing).

% CLUE 8: The friend who prefers data projects works in research and does
%          not use JavaScript.
clue(8, Solution) :-
    member(p(_Name, research, Lang, data), Solution),
    Lang \= javascript.

% =========================================================================
% solve/1 — find a solution satisfying all clues 1-8
% =========================================================================

% solve/1 — Solution satisfies all eight clues.
solve(Solution) :-
    solution_template(Solution),
    clue(1, Solution),
    clue(2, Solution),
    clue(3, Solution),
    clue(4, Solution),
    clue(5, Solution),
    clue(6, Solution),
    clue(7, Solution),
    clue(8, Solution).

% =========================================================================
% main/0 — print one solution in the required format
% =========================================================================

% print_person/1 — prints one person in the format: Name = [Dept, Lang, Proj]
print_person(p(Name, Dept, Lang, Proj)) :-
    format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Proj]).

% main/0 — find one solution and print all four people.
main :-
    solve(Solution),
    !,
    maplist(print_person, Solution).

% =========================================================================
% P1.b — count_solutions/2
% =========================================================================

% apply_clues/2 — apply only the clues whose numbers are in Active.
apply_clues([], _Solution).
apply_clues([N|Rest], Solution) :-
    clue(N, Solution),
    apply_clues(Rest, Solution).

% count_solutions/2 — N is the number of solutions satisfying exactly
% the clues listed in Active.
count_solutions(Active, N) :-
    findall(Solution,
            ( solution_template(Solution),
              apply_clues(Active, Solution) ),
            Solutions),
    length(Solutions, N).
