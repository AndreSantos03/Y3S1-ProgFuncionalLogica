:-use_module(library(lists)).
:-consult(board-logic.pl).


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
    get_value(Board,I-J,Color),
    is_valid_position(I-J).

get_target_coordinates(I-J) :-
    write('Enter the coordinates (I-J) to where you want to move your piece: '),
    read_coordinates(I-J),
    is_empty(Board,I-J),
    is_valid_position(I-J).

move_choice(Board,Color, I-J, I1-J1) :-
    get_base_coordinates(Color, I-J),
    get_target_coordinates(I1-J1).
    %valid_move(Color,I-J,I1-J1).

move_board(Board, Color, I-J, I1-J1, FinalBoard) :-
    update_board(Board, I, J, 0, TempBoard),
    update_board(TempBoard, I1, J1, Color, FinalBoard).

move(Board,Color,  I-J, I1-J1, FinalBoard) :-
    move_choice(Board,Color, I-J, I1-J1),
    move_board(Board,Color,I-J, I1-J1, FinalBoard).

is_empty(Board,I-J) :-
    get_value(Board,I-J,0).

get_value(Board,I-J, Value) :-
    % Load the board
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

is_game_over(I-J) :-
    (I = 0; I = 8).

play_game(Board, Color, FinalBoard) :-
    print_board(Board),
    write('Player '), write(Color), write('\'s turn:\n'),
    move(Board, Color, I-J, I1-J1, TempBoard),
    switch_color(Color, NextColor),
    (is_game_over(I1-J1) -> FinalBoard = TempBoard ; play_game(TempBoard, NextColor, FinalBoard)).

% Custom predicate to switch the turn between players
switch_color(1, 2).
switch_color(2, 1).

% Entry point for the game
game(InitialBoard, FinalBoard) :-
    initialstate(InitialBoard),
    play_game(InitialBoard, 1, FinalBoard).

*/






