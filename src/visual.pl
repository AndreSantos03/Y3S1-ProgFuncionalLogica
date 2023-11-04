print_row(Row):-
    count_occurrences(3, Row, Count3),
    AmmountSpacesFirst is 2 * Count3,
    AmmountSpacesSecond is Count3,
    print_spaces(AmmountSpacesFirst),
    print_middle_row(Row),
    nl,
    print_spaces(AmmountSpacesSecond),
    length(Row,AmmountConnectors),
    print_connectors(AmmountConnectors),
    nl.

print_connectors(0).
print_connectors(AmmountConnectors):-
    write('/\ '),
    New is AmmountConnectors - 1.
    print_connectors(AmmountConnector).
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

    print_board(Rest).

print_initial_state :-
    initialstate(Board),
    print_board(Board).



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
