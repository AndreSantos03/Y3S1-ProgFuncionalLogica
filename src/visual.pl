% Predicate to print a certain number of spaces.
print_spaces(0).
print_spaces(N) :- 
    N > 0, 
    N1 is N - 1, 
    put_char(' '), 
    print_spaces(N1).

% Display the game board, calling print_row for each row in the board.
display_board(Board) :-
    display_board(Board, 0).

% Base case for displaying the board.
display_board([], _).

% Display the game board by rows and elements.
display_board([Row], I) :-
    print_row_last(Row, I).

% Recursive case for displaying the board row by row.
display_board([Row|Rest], I) :-
    length(Rest, SizeRest),
    NewI is I + 1,
    print_row(Row, I),
    display_board(Rest, NewI).

% Print a row with proper formatting, including spaces and connectors.
print_row(Row, I) :-
    count_occurrences(3, Row, Count3),
    AmmountSpaces1 is 2 * Count3,
    AmmountSpaces2 is AmmountSpaces1 - 1,
    format('i = ~w', I),
    put_code(9), % Insert a tab character
    print_spaces(AmmountSpaces1),
    print_middle_row(Row),
    length(Row, SizeRow),
    AmmountConnectors is SizeRow - Count3,
    nth0(0, Row, First), % Get the first character, if it's not a 3, then we invert the connectors.
    nl,
    put_code(9),
    print_connectors(First, AmmountConnectors, AmmountSpaces2),
    nl.

% Print the last row of the board, including connectors if needed.
print_row_last(Row, I) :-
    count_occurrences(3, Row, Count3),
    length(Row, SizeRow),
    AmmountJs is SizeRow - Count3,
    AmmountSpaces1 is 2 * Count3,
    format('i = ~w', I),
    put_code(9), % Insert a tab character
    print_spaces(AmmountSpaces1),
    print_middle_row(Row),
    nl,
    put_code(9),
    AmmountSpaces2 is AmmountSpaces1 - 1,
    print_spaces(AmmountSpaces2),
    print_js(AmmountJs, 0),
    nl.

% Print the middle of a row with elements.
print_middle_row([]).

% For the cases where it's the last element (or followed by a 3) and we don't want the --- after it.
print_middle_row([0]) :- put_char(o).
print_middle_row([1]) :- put_char('W').
print_middle_row([2]) :- put_char('B').
print_middle_row([0, 3 | _]) :- put_char(o).
print_middle_row([1, 3 | _]) :- put_char('W').
print_middle_row([2, 3 | _]) :- put_char('B').

% When it's in the middle of a row, print o or W or B with --- separators.
print_middle_row([0 | Rest]) :-
    put_char('o'),
    write('---'),
    print_middle_row(Rest).
print_middle_row([1 | Rest]) :-
    put_char('W'),
    write('---'),
    print_middle_row(Rest).
print_middle_row([2 | Rest]) :-
    put_char('B'),
    write('---'),
    print_middle_row(Rest).

% When it's a connector element (3), continue to the next element.
print_middle_row([3 | Rest]) :-
    print_middle_row(Rest).

% Print the connectors (/ \) between rows.
print_connectors(3, AmmountConnectors, AmmountSpaces) :-
    print_spaces(AmmountSpaces),
    AmmountConnectors > 0,
    write('/ \\ '),
    New is AmmountConnectors - 1,
    print_connectors_inner(New, 3, 0).

% For the last row, print the connectors (/ \) without the trailing ---.
print_connectors(_, AmmountConnectors, AmmountSpaces) :-
    AmSpaces is AmmountSpaces + 1,
    print_spaces(AmSpaces),
    AmmountConnectors > 0,
    write(' \\ / '),
    New is AmmountConnectors - 2,
    CounterJ is AmmountConnectors - 1,
    print_connectors_inner(New, 0, CounterJ).

% Print the inner part of connectors between rows.
print_connectors_inner(0, 0, J) :-
    format('j=~d', J).

print_connectors_inner(0, _, _).
print_connectors_inner(AmmountConnectors, First, J) :-
    AmmountConnectors > 0,
    (First = 3 -> write('/ \\ '); write('\\ / ')),
    New is AmmountConnectors - 1,
    print_connectors_inner(New, First, J).

% Print J values for the last row.
print_js(0, _).

print_js(AmmountJs, Counter) :-
    AmmountJs > 0,
    format('j=~d|', Counter),
    NewJs is AmmountJs - 1,
    NewCounter is Counter + 1,
    print_js(NewJs, NewCounter).

% Print available moves based on the AvailableMoves list.
print_available_moves(AvailableMoves) :-
    nl,
    write('Here are the following available moves:'),
    nl,
    print_available_moves_inner(AvailableMoves).

% Recursive predicate to print the available moves.
print_available_moves_inner([]).
print_available_moves_inner([[StartPos, TargetPos] | Rest]) :-
    put_code(9), % Insert a tab character
    format("-Move from ~w to ~w", [StartPos, TargetPos]),
    nl,
    print_available_moves_inner(Rest).