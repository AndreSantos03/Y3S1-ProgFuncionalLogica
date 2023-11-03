:-use_module(library(lists)).


/**                   
 * i = 0   A           o---o---o---o---o
 *                    / \ / \ / \ / \ / \ 
 * i = 1   B         o---o---o---o---o---o
 *                  / \ / \ / \ / \ / \ / \ 
 * i = 2   C       o---o---o---o---o---o---o
 *                / \ / \ / \ / \ / \ / \ / \
 * i = 3   D     o---o---o---o---o---o---o---o
 *              / \ / \ / \ / \ / \ / \ / \ / \
 * i = 4   E   o---o---o---o---o---o---o---o---o
 *              \ / \ / \ / \ / \ / \ / \ / \ / \
 * i = 5   F     o---o---o---o---o---o---o---o   \
 *                \ / \ / \ / \ / \ / \ / \ / \   \
 * i = 6   G       o---o---o---o---o---o---o   \   \
 *                  \ / \ / \ / \ / \ / \ / \   \   \ 
 * i = 7   H         o---o---o---o---o---o   \   \   \
 *                    \ / \ / \ / \ / \ / \   \   \   \
 * i = 8   I          o---o---o---o---o   \   \   \   \
 *                      \   \   \   \   \   \   \   \   \
 *                       1   2   3   4   5   6   7   8   9
 * 
 *                      j=0 j=1 j=2 j=3 j=4 j=5 j=6 j=7 j=8
 * 
 * 
 * | i \ j | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 
 * |-------|---|---|---|---|---|---|---|---|---|   
 * |     0 |   |   |   |   |   |XXX|XXX|XXX|XXX|   
 * |     1 |   |   |   |   |   |   |XXX|XXX|XXX|   
 * |     2 |   |   |   |   |   |   |   |XXX|XXX|   
 * |     3 |   |   |   |   |   |   |   |   |XXX|   
 * |     4 |   |   |   |   |   |   |   |   |   |   
 * |     5 |XXX|   |   |   |   |   |   |   |   |   
 * |     6 |XXX|XXX|   |   |   |   |   |   |   |   
 * |     7 |XXX|XXX|XXX|   |   |   |   |   |   |   
 * |     8 |XXX|XXX|XXX|XXX|   |   |   |   |   |   
 * 
 *  
**/

%0 stands for empty space
%1 stands for white piece
%2 stands for black piece
%3 stands for unused space, mostly for spacing
initialstate([ % Board
    [3,3,3,3,0,0,0,0,0],
    [3,3,3,0,2,2,2,2,0],
    [3,3,0,2,0,2,0,2,0],
    [3,0,2,2,2,2,2,2,0],
    [0,0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,0,3],
    [0,1,0,1,0,1,0,3,3],
    [0,1,1,1,1,0,3,3,3],
    [0,0,0,0,0,3,3,3,3]
]).


is_valid_position(I-J) :- between(0, 4, I), R is I+4-2*I, between(R, 8, J).
is_valid_position(I-J) :- between(5, 8, I), L is 12-I, between(0, L, J).


between(L, R, I) :- ground(I), !, L =< I, I =< R.
between(L, L, I) :- I is L, !.
between(L, R, I) :- L < R, I is L.
between(L, R, I) :- L < R, L1 is L+1, between(L1, R, I).


print_row(Row):-
    count_occurrences(3, Row, Count3),
    AmountSpaces is 2 * Count3,
    print_spaces(AmountSpaces),
    print_middle_row(Row).

count_occurrences(Item, List, Count) :-
    include(==(Item), List, Filtered),
    length(Filtered, Count).

%to get the other color
other_color(1,2).
other_color(2,1).

print_spaces(0).

print_spaces(N) :- 
    N > 0, 
    N1 is N - 1, 
    put_char(' '), 
    print_spaces(N1).

print_middle_row([]).

%For the cases where it's the last element (or followed by a 3) and we don't want the --- after it
print_middle_row([0]):-
    put_char(o).
print_middle_row([1]):-
    put_char('W').
print_middle_row([2]):-
    put_char('B').
print_middle_row([0,3 | _]):-
    put_char(o).
print_middle_row([1,3 | _]):-
    put_char('W').
print_middle_row([2,3 | _]):-
    put_char('B').

%When its in the middle
print_middle_row([0|Rest]):-
    put_char('o'),
    write('---'),
    print_middle_row(Rest).
print_middle_row([1|Rest]):-
    put_char('W'),
    write('---'),
    print_middle_row(Rest).
print_middle_row([2|Rest]):-
    put_char('B'),
    write('---'),
    print_middle_row(Rest).

print_middle_row([3|Rest]):-
    print_middle_row(Rest).

print_board([]).

print_board([Row|Rest]) :-
    print_row(Row),
    put_char('\n'),
    print_board(Rest).

print_initial_state :-
    initialstate(Board),
    print_board(Board).

/* count_in_diag(Color,Index,Count) :-
    initialstate(Board),
    maplist(nth0(Index), Board, NthElements),
    count_pieces(Color, NthElements, Count). */

/* % Define a predicate to count occurrences of a value in a list
count_pieces(_, [], 0).
count_pieces(Value, [Value | Rest], Count) :-
    count_pieces(Value, Rest, SubCount),
    Count is SubCount + 1.
count_pieces(Value, [_ | Rest], Count) :-
    count_pieces(Value, Rest, Count).

 */

%possible fix for the poor counting
count_pieces(_,[],0).
count_pieces(Value, [Value | Rest], Count) :-
    count_pieces(Value, Rest, SubCount),
    Count is SubCount + 1.
count_pieces(Value, [First | Rest], Count) :-
    First =\= Value,
    count_pieces(Value, Rest, Count).


count_in_row(Color, Index, Count) :-
    initialstate(Board),
    nth0(Index, Board, Row),
    count_pieces(Color, Row, Count).


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
steps_in_diag_left(Color,I-J,Steps):-
    initialstate(Board),
    pieces_diagonal_left(8-J,List,Board),
    count_pieces(Color,List,SameColor),
    other_color(Color,OpColor),
    count_pieces(OpColor,List,OtherColor),
    Steps is SameColor - OtherColor.

%The Other Diagonal
steps_in_diag_right(Color,I-J,Steps):-
    initialstate(Board),
    get_bottom_left(I-J,NewI-NewJ),
    pieces_diagonal_right(NewI-NewJ,List,Board),
    count_pieces(Color,List,SameColor),
    other_color(Color,OpColor),
    count_pieces(OpColor,List,OtherColor),
    Steps is SameColor - OtherColor.
    
%ROWS

valid_move(Color,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_row(Color,Ui,Count), 
    Vi is Ui, 
    Vj is Uj  +Count,
    is_valid_position(Vi-Vj). %right

valid_move(Color,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_row(Color,Ui,Count), 
    Vi is Ui, 
    Vj is Uj - Count,
    is_valid_position(Vi-Vj). %right

%DIAGONALS

%White pieces
valid_move(1,Ui-Uj,Vi-Vj):-
    is_valid_position(Ui-Uj),
    steps_in_diag_left(1,Ui-Uj,Steps),
    Vi is Ui - Steps,
    Vj is Uj.

valid_move(1,Ui-Uj,Vi-Vj):-
    is_valid_position(Ui-Uj),
    steps_in_diag_right(1,Ui-Uj,Steps),
    Vi is Ui - Steps,
    Vj is Uj + Steps.

%Black Pieces
valid_move(2,Ui-Uj,Vi-Vj):-
    is_valid_position(Ui-Uj),
    steps_in_diag_left(1,Ui-Uj,Steps),
    Vi is Ui - Steps,
    Vj is Uj.

valid_move(2,Ui-Uj,Vi-Vj):-
    is_valid_position(Ui-Uj),
    steps_in_diag_right(1,Ui-Uj,Steps),
    Vi is Ui - Steps,
    Vj is Uj + Steps.


get_bottom_left(8-J, 8-J).
get_bottom_left(I-0, I-0).

get_bottom_left(I-J, N-M) :-
    I > 0,
    J > 0,
    N1 is I + 1,
    M1 is J - 1,
    get_bottom_left(N1-M1, N-M).

/* %gets both diagonals to count the pieces in either
pieces_diagonal(I-J,List1,List2,Board):-
    pieces_diagonal_left(8-J,List1,Board),
    get_bottom_left(I-J,NewI-NewJ),
    pieces_diagonal_right(NewI-NewJ,List2,Board). */

% Base case to stop the recursion when I or J are out of bounds
pieces_diagonal_left(I-_, [], _) :- I < 0.

pieces_diagonal_left(I-J, List, Board) :-
    I >= 0,
    nth0(I, Board, ListAux),  
    nth0(J, ListAux, Element),
    append([Element], NewList, List),  
    New_i is I - 1,
    New_j is J,
    pieces_diagonal_left(New_i-New_j, NewList, Board).  



% Base case to stop the recursion when I or J are out of bounds
pieces_diagonal_right(I-_, [], _) :- I < 0.
pieces_diagonal_right(_-J, [], _) :- J > 8.

pieces_diagonal_right(I-J, List, Board) :-
    I >= 0,
    J =< 8,
    nth0(I, Board, ListAux),  
    nth0(J, ListAux, Element),
    append([Element], NewList, List),  
    New_i is I - 1,
    New_j is J + 1,    
    pieces_diagonal_right(New_i-New_j, NewList, Board).

read_number(Number) :-
read_number(0, Number).

% Base case: when Line Feed (ASCII 10) is encountered, stop and return the accumulated number
read_number(Number, Number) :- peek_code(10), !.

% Read digits and update the accumulated number
read_number(CurrentNumber, Number) :-
    peek_code(Code),
    Code >= 48, Code =< 57, % Check if the code is a digit (ASCII 48-57)
    DigitValue is Code - 48, % Convert ASCII code to digit value
    NewNumber is CurrentNumber * 10 + DigitValue,
    get_code(_), % Consume the character
    read_number(NewNumber, Number).

% Skip non-digit characters
read_number(CurrentNumber, Number) :-
    get_code(_),
    read_number(CurrentNumber, Number).

get_base_coordinates(Color, I-J) :-
    write('Enter the coordinates (I-J) from where you want to move your piece: '), nl,
    read_number(Number),
    integer(Number),
    Number >= 0,
    parse_coordinates(Number, I, J),
    is_valid_position(I-J),
    get_value(I-J, Color).

get_target_coordinates(I-J) :-
    write('Enter the coordinates (I-J) to where you want to move your piece: '),
    read_number(Number),
    integer(Number),
    Number >= 0,
    parse_coordinates(Number, I, J),
    is_valid_position(I-J),
    is_empty(I-J).

move_choice(Color, I-J, I1-J1) :-
    get_base_coordinates(Color, I-J),
    get_target_coordinates(I1-J1).
    %valid_move(Color,I-J,I1-J1).

/*move(Board, Color, I,J, I1,J1, FinalBoard) :-
   initialstate(Board),
   update_board(Board, I, J, 0, TempBoard),
   update_board(TempBoard, I1, J1, Color, FinalBoard).
*/

parse_coordinates(Number, I, J) :-
    I is Number // 10,
    J is Number mod 10.

is_empty(I-J) :-
    get_value(I-J, 0).

get_value(I-J, Value) :-
    initialstate(Board), % Load the board
    nth0(I, Board, Row), % Get the row at position I
    nth0(J, Row, Value). % Get the value at position J
    
update_board(Board, I, J, NewValue, NewBoard) :-
    initialstate(Board),
    update_cell(Board, I, J, NewValue, UpdatedBoard),
    NewBoard = UpdatedBoard.

update_cell([Row | Rest], 0, J, NewValue, [UpdatedRow | Rest]) :-
    update_row(Row, J, NewValue, UpdatedRow).

update_cell([Row | Rest], I, J, NewValue, [Row | UpdatedRest]) :-
    I > 0,
    I1 is I - 1,
    update_cell(Rest, I1, J, NewValue, UpdatedRest).

update_row([_ | Rest], 0, NewValue, [NewValue | Rest]).

update_row([Value | Rest], J, NewValue, [Value | UpdatedRest]) :-
    J > 0,
    J1 is J - 1,
    update_row(Rest, J1, NewValue, UpdatedRest).






