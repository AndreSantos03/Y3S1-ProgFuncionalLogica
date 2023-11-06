% Define the valid positions on the board
is_valid_position(I-J) :- between(0, 4, I), R is I + 4 - 2 * I, between(R, 8, J).
is_valid_position(I-J) :- between(5, 8, I), L is 12 - I, between(0, L, J).

% Define the 'between' predicate for use in is_valid_position
between(L, R, I) :- ground(I), !, L =< I, I =< R.
between(L, L, I) :- I is L, !.
between(L, R, I) :- L < R, I is L.
between(L, R, I) :- L < R, L1 is L + 1, between(L1, R, I).

% Count the occurrences of an item in a list
count_occurrences(Item, List, Count) :-
    include(==(Item), List, Filtered),
    length(Filtered, Count).

% Determine the other color
other_color(1, 2).
other_color(2, 1).

% Count the number of pieces of a given value in a list
% Possible fix for the poor counting
count_pieces(_, [], 0).
count_pieces(Value, [Value | Rest], Count) :-
    count_pieces(Value, Rest, SubCount),
    Count is SubCount + 1.
count_pieces(Value, [First | Rest], Count) :-
    First =\= Value,
    count_pieces(Value, Rest, Count).

% Count the number of pieces of a given color in a row
count_in_row(Color, Index, Count, Board) :-
    get_row(Index, Row, Board),
    count_pieces(Color, Row, Count).

% Calculate the number of steps in a row for a given color
steps_in_row(Color, Index, Count, Board) :-
    Color = 1,
    count_in_row(1, Index, Count1, Board),
    count_in_row(2, Index, Count2, Board),
    Count is Count1 - Count2.

steps_in_row(Color, Index, Count, Board) :-
    Color = 2,
    count_in_row(1, Index, Count1, Board),
    count_in_row(2, Index, Count2, Board),
    Count is Count2 - Count1.

% Calculate the number of steps in the left diagonal for a given color
steps_in_diag_left(Color, _-J, Steps, Board) :-
    pieces_diagonal_left(8-J, List, Board),
    count_pieces(Color, List, SameColor),
    other_color(Color, OpColor),
    count_pieces(OpColor, List, OtherColor),
    Steps is SameColor - OtherColor.

% Calculate the number of steps in the right diagonal for a given color
steps_in_diag_right(Color, I-J, Steps, Board) :-
    get_bottom_left(I-J, NewI-NewJ),
    pieces_diagonal_right(NewI-NewJ, List, Board),
    count_pieces(Color, List, SameColor),
    other_color(Color, OpColor),
    count_pieces(OpColor, List, OtherColor),
    Steps is SameColor - OtherColor.

% Get the bottom-left corner of a diagonal
get_bottom_left(8-J, 8-J).
get_bottom_left(I-0, I-0).
get_bottom_left(I-J, N-M) :-
    I > 0,
    J > 0,
    N1 is I + 1,
    M1 is J - 1,
    get_bottom_left(N1-M1, N-M).

% Base case to stop the recursion when I or J are out of bounds for the left diagonal
pieces_diagonal_left(I-_, [], _) :- I < 0.
pieces_diagonal_left(I-J, List, Board) :-
    I >= 0,
    get_value(I-J, Element, Board),
    append([Element], NewList, List),
    New_i is I - 1,
    New_j is J,
    pieces_diagonal_left(New_i-New_j, NewList, Board).

% Base case to stop the recursion when I or J are out of bounds for the right diagonal
pieces_diagonal_right(I-_, [], _) :- I < 0.
pieces_diagonal_right(_-J, [], _) :- J > 8.
pieces_diagonal_right(I-J, List, Board) :-
    I >= 0,
    J =< 8,
    get_value(I-J, Element, Board),
    append([Element], NewList, List),
    New_i is I - 1,
    New_j is J + 1,
    pieces_diagonal_right(New_i-New_j, NewList, Board).

% Get available moves for a player
get_available_moves(Board, Color, AvailableMoves) :-
    findall([I-J, I1-J1], (
        between(0, 8, I),
        between(0, 8, J),
         get_value(I-J, Color, Board), 
         find_valid_moves(Board, Color, I-J, I1-J1)),
          AvailableMoves).
        
% Find valid moves for a piece at position I-J
find_valid_moves(Board, Color, I-J, I1-J1) :-
    valid_move(Color, I-J, I1-J1, Board),
    is_empty(I1-J1, Board),
    is_valid_position(I1-J1).


