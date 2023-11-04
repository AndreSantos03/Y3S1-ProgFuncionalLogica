count_in_row(Color, Index, Count) :-
    initialstate(Board),
    nth0(Index, Board, Row),
    count_pieces(Color, Row, Count).

list_bl(I-J, List) :-
    initialstate(Board),
    list_bl(Board, I-J, [], List).

% Base case: When J is less than or equal to 0, return the list
list_bl(_, _-_, Acc, Acc).

% Recursive case
list_bl(Board, I-J, Acc, List) :-
    J > 0,
    nth0(I, Board, Row), % Get the row at position I
    nth0(J, Row, Value), % Get the value at position J

    % Calculate new positions I1 and J1 for the next iteration
    I1 is I + 1,
    J1 is J - 1,

    % Add the current Value to the accumulator
    append(Acc, [Value], NewAcc),

    % Recursive call with updated positions and the updated accumulator
    list_bl(Board, I1-J1, NewAcc, List).

% Define your initialstate predicate

count_ul_br(Color,Index,Count) :-
    initialstate(Board),
    maplist(nth0(Index), Board, NthElements),
    count_pieces(Color, NthElements, Count).

/* % Define a predicate to count occurrences of a value in a list
count_pieces(_, [], 0).
count_pieces(Value, [Value | Rest], Count) :-
    count_pieces(Value, Rest, SubCount),
    Count is SubCount + 1.
count_pieces(Value, [_ | Rest], Count) :-
    count_pieces(Value, Rest, Count).

 */

%possible fix for the poor counting
count_pieces(_,[],0).
count_pieces(Value, [Value | Rest], Count) :-
    count_pieces(Value, Rest, SubCount),
    Count is SubCount + 1.
count_pieces(Value, [First | Rest], Count) :-
    First =\= Value,
    count_pieces(Value, Rest, Count).

steps_in_row(Color,Index, Count) :-
    Color = 1,
    count_in_row(1,Index,Count1),
    count_in_row(2,Index,Count2),
    Count is Count1 - Count2.

steps_in_row(Color,Index, Count) :-
    Color = 2,
    count_in_row(1,Index,Count1),
    count_in_row(2,Index,Count2),
    Count is Count2 - Count1.

steps_in_diag(Color,Index, Count) :-
    Color = 1,
    count_in_diag(1,Index,Count1),
    count_in_diag(2,Index,Count2),
    format('count1(white) = ~w    count2 (blacks)= ~w',[Count1,Count2]),

    Count is Count1 - Count2.


steps_in_diag(Color,Index, Count) :-
    Color = 2,
    count_in_diag(1,Index,Count1),
    count_in_diag(2,Index,Count2),
    Count is Count2 - Count1.

is_valid_position(I-J) :- between(0, 4, I), R is I+4-2*I, between(R, 8, J).
is_valid_position(I-J) :- between(5, 8, I), L is 12-I, between(0, L, J).

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


valid_move(Color,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_row(Color,Ui,Count), 
    Vi is Ui, 
    Vj is Uj + Count,
    is_valid_position(Vi-Vj). %right

valid_move(Color,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_row(Color,Ui,Count), 
    Vi is Ui, 
    Vj is Uj - Count,
    is_valid_position(Vi-Vj). %right

%white_piece

/* valid_move(1,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(1,Uj,Count), 
    Vi is Ui - Count, 
    Vj is Uj + Count,
    is_valid_position(Vi-Vj). %up_right

valid_move(1,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(1,Uj,Count), 
    Vi is Ui - Count, 
    Vj is Uj - Count,
    is_valid_position(Vi-Vj). %up_left */

valid_move(1,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(1,Uj,Count),
    Vi is Ui - Count, 
    Vj is Uj + Count,
    is_valid_position(Vi-Vj). %up_right

valid_move(1,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(1,Uj,Count), 
    write(Count),
    Vi is Ui - Count, 
    Vj is Uj,

    is_valid_position(Vi-Vj). %up_left

%black_piece

valid_move(2,Ui-Uj, Vi-Vj) :- 
    is_valid_position(Ui-Uj),
    steps_in_diag(2,Uj,Count), 
    Vi is Ui + Count, 
    Vj is Uj - Count,
    is_valid_position(Vi-Vj). %below_right

valid_move(2,Ui-Uj, Vi-Vj) :-
    is_valid_position(Ui-Uj),
    steps_in_diag(2,Uj,Count), 
    Vi is Ui + Count, 
    Vj is Uj,
    is_valid_position(Vi-Vj). %below_right