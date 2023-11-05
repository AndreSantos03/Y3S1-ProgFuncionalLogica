:-consult('board.pl').
:-consult('menu.pl').
:-consult('board-logic.pl').
:-consult('visual.pl').
:-consult('computer.pl').

%Main predicate
play :-
    game(FinalBoard).

% Entry point for the game
game(FinalBoard) :-
    initialstate(InitialBoard),
    start_menu(TypePlayer1,TypePlayer2),
    play_game(InitialBoard, 1, FinalBoard,TypePlayer1,TypePlayer2).

    play_game(Board, Color,FinalBoard,TypePlayer1,TypePlayer2) :-
        print_board(Board),
        get_color(Color,ColorName),
        format('It''s the ~w''s pieces turn to move!',ColorName),nl,
        format('Color=~d,typeplayer2:~d',[Color,TypePlayer2]),nl,
        (has_available_moves(Board, Color, AvailableMoves) ->
            move_handler(Board,Color,TempBoard,TypePlayer1,TypePlayer2,I1-J1),
            switch_color(Color, NextColor),
            (reach_goal(TempBoard, Color) -> game_over(TempBoard, Winner) ; play_game(TempBoard, NextColor,FinalBoard,TypePlayer1,TypePlayer2))
        ;
            game_over(Board, Winner)
        ).
    


move_handler(Board, 1, FinalBoard, 1, TypePlayer2, I1-J1) :-
    get_available_moves(Board, Color, AvailableMoves),
    print_available_moves(AvailableMoves),
    move(Board,1, FinalBoard).

move_handler(Board, 2, FinalBoard, TypePlayer1, 1, I1-J1) :-
    get_available_moves(Board, Color, AvailableMoves),
    print_available_moves(AvailableMoves),
    move(Board,2, FinalBoard).


move_handler(Board, 1, FinalBoard, 2, TypePlayer2, I1-J1) :-
    get_available_moves(Board, Color, AvailableMoves),
    randomMove(AvailableMoves, [Start-End]),
    move_board(Board, Color, Start, End, FinalBoard),
    [I1, J1] = Start,
    format('The computer has played the piece in position ~s to ~s!', [Start-End]),
    nl.

move_handler(Board, 2, FinalBoard, TypePlayer1, 2, I1-J1) :-
    get_available_moves(Board, Color, AvailableMoves),
    randomMove(AvailableMoves, [Start-End]),
    move_board(Board, Color, Start, End, FinalBoard),
    [I1, J1] = Start,
    format('The computer has played the piece in position ~s to ~s!', [Start-End]),
    nl.
  


%debugging purposes
% Enable tracing
start_tracing :-
    trace.

% Disable tracing
stop_tracing :-
    notrace.