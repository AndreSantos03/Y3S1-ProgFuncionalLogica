start_menu(TypePlayer1, TypePlayer2) :-
    nl,
    write('Welcome to DIFFERO!\n'),
    nl,
    choose_type_player(1, TypePlayer1), 
    choose_type_player(2, TypePlayer2).

% Predicates for choosing the type of player for a given number
% (1: Player, 2: Dumb Computer, 3: Smart Computer)

choose_type_player(NumberPlayer, TypePlayer) :-
    get_color(NumberPlayer, Color),
    nl,
    write('--------------------'), nl,
    format('Choose the type of player for the ~w pieces', [Color]), nl,
    write('1: Player.'), nl,
    write('2: Dumb Computer.'), nl,
    write('3: Smart Computer.'), nl, nl,
    repeat,
    write('Type your answer (1, 2, or 3): '),
    read(TypePlayer),
    (is_valid_choice(TypePlayer) -> !; 
        write('Invalid choice! Please enter 1, 2, or 3.'), nl,
        fail
    ).

% Predicate to validate if a choice is valid (1, 2, or 3)
is_valid_choice(1).
is_valid_choice(2).
is_valid_choice(3).

% Predicate to get the color based on the player number
get_color(1, 'white').
get_color(2, 'black').