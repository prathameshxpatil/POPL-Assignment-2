% Run from the repository root:
% swipl -q -s 59/code/59_q2.pl -s 59/tests/test_q2.pl -g p2_tests -t halt

:- module(p2_test_suite, []).

% p2_expected/2 — Specify complete results independently of the implementation.
p2_expected([4,2,5,3], ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
                        "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).
p2_expected([2,4,8], ["2*4=8"]).
p2_expected([2,3,4], []).
p2_expected([], []).
p2_expected([5], []).
p2_expected([0,0], ["0=0"]).

% p2_case/2 — Enumerate named checks so a failed check cannot skip later cases.
p2_case(all_equations(Numbers), (
    findall(Es, all_equations(Numbers, Es), Results),
    Results = [Actual],
    Actual == Expected,
    maplist(string, Actual),
    sort(Actual, Actual)
)) :-
    p2_expected(Numbers, Expected).
p2_case(count_equations(Numbers), (
    findall(N, count_equations(Numbers, N), Counts),
    Counts == [ExpectedCount]
)) :-
    p2_expected(Numbers, Expected),
    length(Expected, ExpectedCount).
p2_case(generate_equation(Numbers), (
    findall(E, generate_equation(Numbers, E), Results),
    ( Expected == []
    -> Results == []
    ;  Results = [Only], string(Only), memberchk(Only, Expected)
    )
)) :-
    p2_expected(Numbers, Expected).
p2_case(ordered_splits, (
    findall(L-R, ordered_split([4,2,5,3], L, R), Splits),
    msort(Splits, Sorted),
    Sorted == [[4]-[2,5,3], [4,2]-[5,3], [4,2,5]-[3]]
)).
p2_case(expression_trees, (
    findall(Tree, expression_tree([2,3], Tree), Trees),
    findall(node(Op,num(2),num(3)), member(Op, ['+', '-', '*', '/']), Expected),
    msort(Trees, Sorted), msort(Expected, Sorted)
)).
p2_case(evaluate(Tree), (
    findall(V, evaluate_expression(Tree, V), Values),
    Values == Expected
)) :-
    member(Tree-Expected, [
        node('/',num(8),num(4))-[2],
        node('/',num(5),num(2))-[],
        node('/',num(4),num(0))-[],
        node('*',node('/',num(5),num(2)),num(2))-[],
        node('-',num(3),num(5))-[-2],
        node('*',node('-',num(3),num(5)),num(4))-[-8]
    ]).
p2_case(render(Tree), (
    findall(Text, render_expression(Tree, Text), [Actual]),
    string(Actual), Actual == Expected
)) :-
    member(Tree-Expected, [
        node('*',node('+',num(4),num(2)),num(3))-"(4+2)*3",
        node('+',num(1),node('+',num(2),num(3)))-"1+(2+3)",
        node('+',node('+',num(1),num(2)),num(3))-"1+2+3",
        node('/',num(8),node('*',num(4),num(2)))-"8/(4*2)",
        node('+',num(1),node('*',num(2),num(3)))-"1+2*3"
    ]).

% p2_failure/1 — Report a failed check or exception and yield its name.
p2_failure(Name) :-
    p2_case(Name, Goal),
    \+ catch(Goal, Error, (print_message(error, Error), fail)),
    format(user_error, 'FAILED ~q~n', [Name]).

% p2_tests/0 — Run every check and succeed only when the failure list is empty.
user:p2_tests :-
    findall(Name, p2_test_suite:p2_failure(Name), []).
