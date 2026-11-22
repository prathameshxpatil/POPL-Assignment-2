% ordered_split/3 — Split List into a nonempty prefix Left and a nonempty suffix Right.
ordered_split(List, Left, Right) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List).
