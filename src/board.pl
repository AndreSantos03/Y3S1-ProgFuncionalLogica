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

intermediatestate([ % Board
    [3,3,3,3,0,0,0,0,0],
    [3,3,3,0,2,2,2,0,0],
    [3,3,2,1,0,1,0,0,0],
    [3,0,2,0,1,2,2,0,0],
    [0,0,1,2,2,0,0,2,0],
    [0,1,1,2,1,1,1,0,3],
    [0,0,1,1,2,1,0,3,3],
    [0,1,2,0,0,0,3,3,3],
    [0,0,0,0,0,3,3,3,3]
]).

print_row(Row):-
    count_occurrences(3, Row, Count3),
    AmountSpaces is 2 * Count3,
    print_spaces(AmountSpaces),
    print_middle_row(Row).

count_occurrences(Item, List, Count) :-
    include(==(Item), List, Filtered),
    length(Filtered, Count).

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

count_in_row(Color, Index, Count) :-
    initialstate(Board),
    nth0(Index, Board, Row),
    count_pieces(Color, Row, Count).

list_bl(I-J, List) :-
    initialstate(Board),
    list_bl(Board, I-J, [], List).

% Base case: When J is less than or equal to 0, return the list
list_bl(_, _-_, Acc, Acc).

% Recursive case
list_bl(Board, I-J, Acc, List) :-
    J > 0,
    nth0(I, Board, Row), % Get the row at position I
    nth0(J, Row, Value), % Get the value at position J

    % Calculate new positions I1 and J1 for the next iteration
    I1 is I + 1,
    J1 is J - 1,

    % Add the current Value to the accumulator
    append(Acc, [Value], NewAcc),

    % Recursive call with updated positions and the updated accumulator
    list_bl(Board, I1-J1, NewAcc, List).

% Define your initialstate predicate

count_ul_br(Color,Index,Count) :-
    initialstate(Board),
    maplist(nth0(Index), Board, NthElements),
    count_pieces(Color, NthElements, Count).

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

steps_in_diag(Color,Index, Count) :-
    Color = 1,
    count_in_diag(1,Index,Count1),
    count_in_diag(2,Index,Count2),
    format('count1(white) = ~w    count2 (blacks)= ~w',[Count1,Count2]),

    Count is Count1 - Count2.


steps_in_diag(Color,Index, Count) :-
    Color = 2,
    count_in_diag(1,Index,Count1),
    count_in_diag(2,Index,Count2),
    Count is Count2 - Count1.

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


valid_move(Color,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_row(Color,Ui,Count), 
    Vi is Ui, 
    Vj is Uj + Count,
    is_valid_position(Vi-Vj). %right

valid_move(Color,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_row(Color,Ui,Count), 
    Vi is Ui, 
    Vj is Uj - Count,
    is_valid_position(Vi-Vj). %right

%white_piece

/* valid_move(1,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(1,Uj,Count), 
    Vi is Ui - Count, 
    Vj is Uj + Count,
    is_valid_position(Vi-Vj). %up_right

valid_move(1,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(1,Uj,Count), 
    Vi is Ui - Count, 
    Vj is Uj - Count,
    is_valid_position(Vi-Vj). %up_left */

valid_move(1,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(1,Uj,Count),
    Vi is Ui - Count, 
    Vj is Uj + Count,
    is_valid_position(Vi-Vj). %up_right

valid_move(1,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(1,Uj,Count), 
    write(Count),
    Vi is Ui - Count, 
    Vj is Uj,

    is_valid_position(Vi-Vj). %up_left

%black_piece

valid_move(2,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(2,Uj,Count), 
    Vi is Ui + Count, 
    Vj is Uj - Count,
    is_valid_position(Vi-Vj). %below_right

valid_move(2,Ui-Uj, Vi-Vj) :-
    is_valid_position(Ui-Uj),
    steps_in_diag(2,Uj,Count), 
    Vi is Ui + Count, 
    Vj is Uj,
    is_valid_position(Vi-Vj). %below_right

% Custom predicate to read a line and parse coordinates in "I-J" format
read_coordinates(I-J) :-
    write('I = '),
    read(I), % Read the first number into I
    write('J = '),
    read(J),
    !. % Read the second number into J

get_base_coordinates(Color, I-J) :-
    write('Enter the coordinates (I-J) from where you want to move your piece: '),
    read_coordinates(I-J),
    get_value(I-J,Color),
    is_valid_position(I-J).

get_target_coordinates(I-J) :-
    write('Enter the coordinates (I-J) to where you want to move your piece: '),
    read_coordinates(I-J),
    is_empty(I-J),
    is_valid_position(I-J).

move_choice(Color, I-J, I1-J1) :-
    get_base_coordinates(Color, I-J),
    get_target_coordinates(I1-J1).
    %valid_move(Color,I-J,I1-J1).

move_board(Board, Color, I-J, I1-J1, FinalBoard) :-
    update_board(Board, I, J, 0, TempBoard),
    update_board(TempBoard, I1, J1, Color, FinalBoard).

move(Board,Color,  I-J, I1-J1, FinalBoard) :-
    move_choice(Color, I-J, I1-J1),
    move_board(Board,Color,I-J, I1-J1, FinalBoard).

get_value(I-J, Value) :-
    initialstate(Board), % Load the board
    nth0(I, Board, Row), % Get the row at position I
    nth0(J, Row, Value). % Get the value at position J
    
update_board(Board, I, J, NewValue, NewBoard) :-
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

/*
is_game_over(I-J) :-
    (I = 0; I = 8).

play_game(Board, Color, FinalBoard) :-
    write('Player '), write(Color), write('\'s turn:\n'),
    move(Board, Color, I-J, I1-J1, TempBoard),
    switch_color(Color, NextColor),
    (is_game_over(I1-J1) -> FinalBoard = TempBoard ; play_game(TempBoard, NextColor, FinalBoard)).

% Custom predicate to switch the turn between players
switch_color(1, 2).
switch_color(2, 1).

% Entry point for the game
game(InitialBoard, FinalBoard) :-
    play_game(InitialBoard, 1, FinalBoard).
*/





