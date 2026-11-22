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

% evaluate_expression/2 — Evaluate an integer expression tree with exact division at every node.
evaluate_expression(num(N), N) :-
    integer(N).
evaluate_expression(node(Op, Left, Right), Value) :-
    evaluate_expression(Left, A),
    evaluate_expression(Right, B),
    (   Op = '+', Value is A + B
    ;   Op = '-', Value is A - B
    ;   Op = '*', Value is A * B
    ;   Op = '/',
        B =\= 0,
        0 =:= A mod B,
        Value is A // B
    ).

% tree_precedence/2 — Classify a tree by its root operator or numeric leaf.
tree_precedence(num(_), 3).
tree_precedence(node('+', _, _), 1).
tree_precedence(node('-', _, _), 1).
tree_precedence(node('*', _, _), 2).
tree_precedence(node('/', _, _), 2).

% render_in_context/4 — Render a tree with the parentheses required by its parent.
render_in_context(num(N), _, _, Text) :-
    number_string(N, Text).
render_in_context(node(Op, Left, Right), ParentPrecedence, Side, Text) :-
    tree_precedence(node(Op, Left, Right), Precedence),
    render_in_context(Left, Precedence, left, LeftText),
    render_in_context(Right, Precedence, right, RightText),
    atomics_to_string([LeftText, Op, RightText], Body),
    (   ( Precedence < ParentPrecedence
        ; Side == right, Precedence =:= ParentPrecedence
        )
    ->  atomics_to_string(['(', Body, ')'], Text)
    ;   Text = Body
    ).

% render_expression/2 — Render a complete expression tree as a canonical string.
render_expression(Tree, Text) :-
    render_in_context(Tree, 0, root, Text).

% candidate_equation/2 — Generate equations whose ordered sides have the same integer value.
candidate_equation(Numbers, Equation) :-
    ordered_split(Numbers, LeftNumbers, RightNumbers),
    expression_tree(LeftNumbers, LeftTree),
    evaluate_expression(LeftTree, Value),
    expression_tree(RightNumbers, RightTree),
    evaluate_expression(RightTree, Value),
    render_expression(LeftTree, LeftText),
    render_expression(RightTree, RightText),
    atomics_to_string([LeftText, RightText], '=', Equation).
