
is_valid_position(I-J) :- between(0, 4, I), R is I+4-2*I, between(R, 8, J).
is_valid_position(I-J) :- between(5, 8, I), L is 12-I, between(0, L, J).

/**
 * between(+L, +R, ?I)
 * 
 * If I is binded, it checks if L =< I =< R.
 * If I is not binded, it is successively assigned
 * to the integers between L and R inclusive.
 */
 
between(L, R, I) :- ground(I), !, L =< I, I =< R.
between(L, L, I) :- I is L, !.
between(L, R, I) :- L < R, I is L.
between(L, R, I) :- L < R, L1 is L+1, between(L1, R, I).


count_occurrences(Item, List, Count) :-
    include(==(Item), List, Filtered),
    length(Filtered, Count).

%to get the other color
other_color(1,2).
other_color(2,1).



%possible fix for the poor counting
count_pieces(_,[],0).
count_pieces(Value, [Value | Rest], Count) :-
    count_pieces(Value, Rest, SubCount),
    Count is SubCount + 1.
count_pieces(Value, [First | Rest], Count) :-
    First =\= Value,
    count_pieces(Value, Rest, Count).


count_in_row(Color,Index,Count):-
    get_row(Index,Row),
    count_pieces(Color,Row,Count).

steps_in_row(Color,Index, Count) :-
    Color = 1,
    count_in_row(1,Index,Count1),
    count_in_row(2,Index,Count2),
    Count is Count1 - Count2.

steps_in_row(Color,Index, Count) :-
    Color = 2,
    count_in_row(1,Index,Count1),
    count_in_row(2,Index,Count2),
    Count is Count2 - Count1.


%The left diagonal is the diagonal that keeps the same I
steps_in_diag_left(Color,_-J,Steps):-
    pieces_diagonal_left(8-J,List),
    count_pieces(Color,List,SameColor),
    other_color(Color,OpColor),
    count_pieces(OpColor,List,OtherColor),
    Steps is SameColor - OtherColor.
    


%The Other Diagonal
steps_in_diag_right(Color,I-J,Steps):-
    get_bottom_left(I-J,NewI-NewJ),
    pieces_diagonal_right(NewI-NewJ,List),
    count_pieces(Color,List,SameColor),
    other_color(Color,OpColor),
    count_pieces(OpColor,List,OtherColor),
    Steps is SameColor - OtherColor.
    
%ROWS

valid_move(Color,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_row(Color,Ui,Count), 
    Count > 0,
    Vi is Ui, 
    Vj is Uj  +Count,
    is_valid_position(Vi-Vj). %right

valid_move(Color,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_row(Color,Ui,Count), 
    Count > 0,
    Vi is Ui, 
    Vj is Uj - Count,
    is_valid_position(Vi-Vj). %right

%DIAGONALS

%White pieces
valid_move(1,Ui-Uj,Vi-Vj):-
    is_valid_position(Ui-Uj),
    steps_in_diag_left(1,Ui-Uj,Steps),
    Steps > 0,
    Vi is Ui - Steps,
    Vj is Uj.

valid_move(1,Ui-Uj,Vi-Vj):-
    is_valid_position(Ui-Uj),
    steps_in_diag_right(1,Ui-Uj,Steps),
    Steps > 0,
    Vi is Ui - Steps,
    Vj is Uj + Steps.

%Black Pieces
valid_move(2,Ui-Uj,Vi-Vj):-
    is_valid_position(Ui-Uj),
    steps_in_diag_left(1,Ui-Uj,Steps),
    Steps > 0,
    Vi is Ui + Steps,
    Vj is Uj.

valid_move(2,Ui-Uj,Vi-Vj):-
    is_valid_position(Ui-Uj),
    steps_in_diag_right(1,Ui-Uj,Steps),
    Steps > 0,
    Vi is Ui + Steps,
    Vj is Uj - Steps.


get_bottom_left(8-J, 8-J).
get_bottom_left(I-0, I-0).

get_bottom_left(I-J, N-M) :-
    I > 0,
    J > 0,
    N1 is I + 1,
    M1 is J - 1,
    get_bottom_left(N1-M1, N-M).



% Base case to stop the recursion when I or J are out of bounds
pieces_diagonal_left(I-_, []) :- I < 0.

pieces_diagonal_left(I-J, List) :-
    I >= 0,
    get_value(I-J,Element),
    append([Element], NewList, List),  
    New_i is I - 1,
    New_j is J,
    pieces_diagonal_left(New_i-New_j, NewList).  



% Base case to stop the recursion when I or J are out of bounds
pieces_diagonal_right(I-_, []) :- I < 0.
pieces_diagonal_right(_-J, []) :- J > 8.

pieces_diagonal_right(I-J, List) :-
    I >= 0,
    J =< 8,
    get_value(I-J,Element),
    append([Element], NewList, List),  
    New_i is I - 1,
    New_j is J + 1,    
    pieces_diagonal_right(New_i-New_j, NewList).


get_available_moves(Board, Color, AvailableMoves) :-
    findall([I-J, I1-J1], (between(0, 8, I), between(0, 8, J), get_value(I-J, Color), find_valid_moves(Board, Color, I-J, I1-J1)), AvailableMoves).

find_valid_moves(Board, Color, I-J, I1-J1) :-
    valid_move(Color, I-J, I1-J1),
    is_empty(I1-J1),
    is_valid_position(I1-J1).