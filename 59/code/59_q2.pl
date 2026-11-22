% ordered_split/3 — Split List into a nonempty prefix Left and a nonempty suffix Right.
ordered_split(List, Left, Right) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List).

% expression_tree/2 — Generate binary arithmetic trees with the numbers in input order.
expression_tree([N], num(N)) :-
    number(N).
expression_tree(Numbers, node(Op, Left, Right)) :-
    ordered_split(Numbers, Prefix, Suffix),
    expression_tree(Prefix, Left),
    expression_tree(Suffix, Right),
    member(Op, ['+', '-', '*', '/']).
