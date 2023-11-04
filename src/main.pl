:-consult('board.pl').
:-consult('menu.pl').
:-consult('board-logic.pl').
:-consult('visual.pl').

%Main predicate
play :-
    start_menu.

start_Menu:-
    printMainMenu,
    initialstate(Board),
    game(InitialBoard,FinalBoard).

% Entry point for the game
game(InitialBoard, FinalBoard) :-
    play_game(InitialBoard, 1, FinalBoard).


play_game(Board, Color, FinalBoard) :-
    write('Player '), write(Color), write('\'s turn:\n'),
    move(Board, Color, I-J, I1-J1, TempBoard),
    switch_color(Color, NextColor),
    (is_game_over(I1-J1) -> FinalBoard = TempBoard ; play_game(TempBoard, NextColor, FinalBoard)).
    


printMainMenu:-
    nl,
    format('\e[1;34m\e[5mWelcome to \e[1mDIFFERO\e[0m\e[1;34m!\e[0m\n', []).
    nl,
    write("--------------------"),
    nl,
    write('1.Player vs Player'),
    write('2. Player vs Computer').
    write("--------------------"),
    nl.


printComputerDifficulty:-
    write("--------------------"),
    nl,
    write('1.Random Move'),
    write('2. AI Computated Move').
    write("--------------------"),
    nl.
