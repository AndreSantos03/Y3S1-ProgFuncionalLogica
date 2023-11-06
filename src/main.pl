:-consult('board.pl').
:-consult('menu.pl').
:-consult('board-logic.pl').
:-consult('visual.pl').
:-consult('computer.pl').

% Main predicate to start the game
play :- game(FinalBoard).

% Entry point for the game
game(FinalBoard) :-
    initialstate(InitialBoard),
    start_menu(TypePlayer1, TypePlayer2), % Get player types from the menu
    play_game(InitialBoard, 1, FinalBoard, TypePlayer1, TypePlayer2).

% Main game loop
play_game(Board, Color, FinalBoard, TypePlayer1, TypePlayer2) :-
    display_board(Board), % Display the current game board
    get_color(Color, ColorName),
    format('It''s the ~w''s pieces turn to move!', ColorName), nl,
    (
        has_available_moves(Board, Color, AvailableMoves) ->
        move_handler(Board, Color, TempBoard, TypePlayer1, TypePlayer2, I1-J1), % Allow the player to make a move
        switch_color(Color, NextColor),
        (
            reach_goal(TempBoard, Color) -> game_over(TempBoard, Winner) ; % Check for a winner
            play_game(TempBoard, NextColor, FinalBoard, TypePlayer1, TypePlayer2)
        )
        ;
        game_over(Board, Winner) % Handle game over if no available moves for the current player
    ).

% Handle the move for different player types
move_handler(Board, 1, FinalBoard, 1, TypePlayer2, I1-J1) :-
    get_available_moves(Board, 1, AvailableMoves),
    print_available_moves(AvailableMoves),
    move(Board, 1, FinalBoard).

move_handler(Board, 2, FinalBoard, TypePlayer1, 1, I1-J1) :-
    get_available_moves(Board, 2, AvailableMoves),
    print_available_moves(AvailableMoves),
    move(Board, 2, FinalBoard).

move_handler(Board, 1, FinalBoard, 2, TypePlayer2, I1-J1) :-
    get_available_moves(Board, 1, AvailableMoves),
    print_available_moves(AvailableMoves),
    randomMove(AvailableMoves, [Start, End]), % Random move for the computer
    move_board(Board, 1, Start, End, FinalBoard),
    nl,
    write('-------------------'), nl,
    format('The computer has played the piece in position ~w to ~w!', [Start, End]), nl,
    write('-------------------'),
    nl.

move_handler(Board, 2, FinalBoard, TypePlayer1, 2, I1-J1) :-
    get_available_moves(Board, 2, AvailableMoves),
    print_available_moves(AvailableMoves),
    randomMove(AvailableMoves, [Start, End]), % Random move for the computer
    move_board(Board, 2, Start, End, FinalBoard),
    nl,
    write('-------------------'), nl,
    format('The computer has played the piece in position ~w to ~w!', [Start, End]),
    write('-------------------'),
    nl.

move_handler(Board, 1, FinalBoard, 3, TypePlayer2, I1-J1) :-
    get_available_moves(Board, 1, AvailableMoves),
    print_available_moves(AvailableMoves),
    bestComputerMove(1, AvailableMoves, [Start, End]), % Computer plays the best move
    move_board(Board, 1, Start, End, FinalBoard),
    nl,
    write('-------------------'), nl,
    format('The computer has played the piece in position ~w to ~w!', [Start, End]), nl,
    write('-------------------'),
    nl.

move_handler(Board, 2, FinalBoard, TypePlayer1, 3, I1-J1) :-
    get_available_moves(Board, 2, AvailableMoves),
    print_available_moves(AvailableMoves),
    bestComputerMove(2, AvailableMoves, [Start, End]), % Computer plays the best move
    move_board(Board, 2, Start, End, FinalBoard),
    nl,
    write('-------------------'), nl,
    format('The computer has played the piece in position ~w to ~w!', [Start, End]), nl,
    write('-------------------'),
    nl.

% For debugging purposes
% Enable tracing
start_tracing :- trace.

% Disable tracing
stop_tracing :- notrace.