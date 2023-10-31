:-use_module(library(lists)).


/**                   
 * i = 8   I           o---o---o---o---o
 *                    / \ / \ / \ / \ / \ 
 * i = 7   H         o---o---o---o---o---o
 *                  / \ / \ / \ / \ / \ / \ 
 * i = 6   G       o---o---o---o---o---o---o
 *                / \ / \ / \ / \ / \ / \ / \
 * i = 5   F     o---o---o---o---o---o---o---o
 *              / \ / \ / \ / \ / \ / \ / \ / \
 * i = 4   E   o---o---o---o---o---o---o---o---o
 *              \ / \ / \ / \ / \ / \ / \ / \ / \
 * i = 3   D     o---o---o---o---o---o---o---o   \
 *                \ / \ / \ / \ / \ / \ / \ / \   \
 * i = 2   C       o---o---o---o---o---o---o   \   \
 *                  \ / \ / \ / \ / \ / \ / \   \   \ 
 * i = 1   B         o---o---o---o---o---o   \   \   \
 *                    \ / \ / \ / \ / \ / \   \   \   \
 * i = 0   A           o---o---o---o---o   \   \   \   \
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



board_is_valid_position(I-J) :- between(0, 4, I), R is I+4, between(0, R, J).
board_is_valid_position(I-J) :- between(5, 8, I), L is I-4, between(L, 8, J).

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

isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui, Vj is Uj+1, board_is_valid_position(Vi-Vj). %right
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui, Vj is Uj-1, board_is_valid_position(Vi-Vj). %left

%white_piece
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui+1, Vj is Uj+1, board_is_valid_position(Vi-Vj). %up_right
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui+1, Vj is Uj, board_is_valid_position(Vi-Vj). %up_left

%black_piece
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui-1, Vj is Uj, board_is_valid_position(Vi-Vj). %below_right
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui-1, Vj is Uj-1, board_is_valid_position(Vi-Vj). %below_left


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

%When it's in the middle
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
