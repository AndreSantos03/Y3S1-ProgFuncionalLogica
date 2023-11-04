:-consult('board.pl').
:-consult('menu.pl').
:-consult('board-logic.pl').
:-consult('visual.pl').

%Main predicate
play :-
    start_menu.

start_menu:-
    printMainMenu,
    initialstate(Board),
    game(InitialBoard,FinalBoard).

% Entry point for the game
game(InitialBoard, FinalBoard) :-
    play_game(InitialBoard, 1, FinalBoard).


play_game(Board, Color, FinalBoard) :-
    write('Player '), write(Color), write('\'s turn:\n'),
    move(Board, TempBoard),
    switch_color(Color, NextColor),
    (is_game_over(I1-J1) -> FinalBoard = TempBoard ; play_game(TempBoard, NextColor, FinalBoard)).
    
