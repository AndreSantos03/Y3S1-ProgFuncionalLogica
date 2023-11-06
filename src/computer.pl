:- use_module(library(random)).
:- use_module(library(samsort)).

% Generate a random move from a list of AvailableMoves.
randomMove(AvailableMoves, [Start, End]) :-
    length(AvailableMoves, NumMoves),  % Calculate the number of available moves.
    random(0, NumMoves, RandomIndex),  % Generate a random index within the range of available moves.
    nth0(RandomIndex, AvailableMoves, [Start, End]).  % Get the move at the randomly chosen index.

% Determine the best computer move for White (Color 1) based on available moves.
bestComputerMove(1, AvailableMoves, [Start, End]) :-
    samsort(compareWhite, AvailableMoves, SortedList),  % Sort the available moves based on the compareWhite predicate.
    nth0(0, SortedList, [Start, End]).  % Choose the best move as the first move in the sorted list.

% Custom comparison predicate for sorting moves for White.
compareWhite([_, I1-J1], [_, I2-J2]) :-
    getWhiteValue(I1-J1, Value1),  % Calculate a value for the move at I1-J1 for White.
    getWhiteValue(I2-J2, Value2),  % Calculate a value for the move at I2-J2 for White.
    Value1 >= Value2.  % Compare the values to determine the order for sorting.

% Determine the best computer move for Black (Color 2) based on available moves.
bestComputerMove(2, AvailableMoves, [Start, End]) :-
    samsort(compareBlack, AvailableMoves, SortedList),  % Sort the available moves based on the compareBlack predicate.
    nth0(0, SortedList, [Start, End]).  % Choose the best move as the first move in the sorted list.

% Custom comparison predicate for sorting moves for Black.
compareBlack([_, I1-J1], [_, I2-J2]) :-
    getBlackValue(I1-J1, Value1),  % Calculate a value for the move at I1-J1 for Black.
    getBlackValue(I2-J2, Value2),  % Calculate a value for the move at I2-J2 for Black.
    Value1 >= Value2.  % Compare the values to determine the order for sorting.