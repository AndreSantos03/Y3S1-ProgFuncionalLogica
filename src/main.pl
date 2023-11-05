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
    game(Board,FinalBoard).

% Entry point for the game
game(InitialBoard, FinalBoard) :-
    play_game(InitialBoard, 1, FinalBoard).


play_game(Board, Color) :-
    print_board(Board),
    write('Player '), write(Color), write('\'s turn:\n'),
    (has_available_moves(Board, Color, AvailableMoves) ->
        get_available_moves(Board, Color, AvailableMoves),
        print_available_moves(AvailableMoves),
        move(Board, Color, TempBoard),
        switch_color(Color, NextColor),
        (reach_goal(TempBoard, Color) -> game_over(TempBoard, Winner) ; play_game(TempBoard, NextColor))
    ;
        game_over(Board, Winner)
    ).

    
