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
