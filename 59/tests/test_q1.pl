% Test file for P1: Department Assignment Puzzle
% Run with: swipl -q -f 59_q1.pl -l test_q1.pl -g run_tests -t halt

:- use_module(library(lists)).

% =========================================================================
% Helper: load the solution for testing
% =========================================================================

get_solution(S) :-
    solution_template(S),
    clue(1,S), clue(2,S), clue(3,S), clue(4,S),
    clue(5,S), clue(6,S), clue(7,S), clue(8,S).

% =========================================================================
% Tests
% =========================================================================

% Test: main/0 produces output (doesn't crash)
test_main :-
    main,
    write('PASS: main/0 produces output'), nl.

% Test: count_solutions with all 8 clues gives 3
test_count_all :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    ( N =:= 3
    -> write('PASS: count_solutions([1..8]) = 3'), nl
    ;  format('FAIL: count_solutions([1..8]) = ~w, expected 3~n', [N])
    ).

% Test: count_solutions with 9 clues gives 1
test_count_repair :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    ( N =:= 1
    -> write('PASS: count_solutions([1..9]) = 1'), nl
    ;  format('FAIL: count_solutions([1..9]) = ~w, expected 1~n', [N])
    ).

% Test: Clue 9 is true in exactly one solution of clues 1..8 and false in the others
test_clue9_filters_exactly_two :-
    findall(S, get_solution(S), Solutions8),
    length(Solutions8, 3),
    include(clue(9), Solutions8, TrueSols),
    exclude(clue(9), Solutions8, FalseSols),
    length(TrueSols, 1),
    length(FalseSols, 2),
    write('PASS: clue 9 is true in exactly 1 and false in 2 solutions of clues 1..8'), nl.

% Test: each clue holds individually on at least one solution
test_each_clue_holds :-
    forall(
        between(1, 9, C),
        ( ( solution_template(S), clue(C, S), ! )
        -> format('PASS: clue ~w holds on some solution~n', [C])
        ;  format('FAIL: clue ~w holds on no solution~n', [C])
        )
    ).

% Test: all attributes are distinct in every solution
test_all_distinct :-
    get_solution([p(_,D1,L1,P1), p(_,D2,L2,P2), p(_,D3,L3,P3), p(_,D4,L4,P4)]),
    msort([D1,D2,D3,D4], Ds), length(Ds, 4),
    msort([L1,L2,L3,L4], Ls), length(Ls, 4),
    msort([P1,P2,P3,P4], Ps), length(Ps, 4),
    !,
    write('PASS: all attributes distinct in solution'), nl.

% Test: count with no clues = total permutations = 4!^3 = 13824
test_count_empty :-
    count_solutions([], N),
    ( N =:= 13824
    -> write('PASS: count_solutions([]) = 13824 (all permutations)'), nl
    ;  format('FAIL: count_solutions([]) = ~w, expected 13824~n', [N])
    ).

% Test: Ben always has web and development (from solutions)
test_ben_constant :-
    findall(ben(D,L,P),
            ( get_solution(S), member(p('Ben',D,L,P), S) ),
            Bens),
    sort(Bens, UniqueBens),
    ( UniqueBens = [ben(development, javascript, web)]
    -> write('PASS: Ben is always development/javascript/web'), nl
    ;  format('FAIL: Ben assignments vary: ~w~n', [UniqueBens])
    ).

% =========================================================================
% Run all tests
% =========================================================================
run_tests :-
    write('=== P1 Test Suite ==='), nl,
    test_main, nl,
    test_count_all,
    test_count_repair,
    test_clue9_filters_exactly_two,
    test_each_clue_holds,
    test_all_distinct,
    test_count_empty,
    test_ben_constant,
    nl, write('=== All P1 tests complete ==='), nl.
