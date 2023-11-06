:- use_module(library(random)).
:- use_module(library(samsort)).

randomMove(AvailableMoves, [Start,End]) :-
    length(AvailableMoves, NumMoves),
    random(0, NumMoves, RandomIndex),
    nth0(RandomIndex, AvailableMoves, [Start,End]).

bestComputerMove(1,AvailableMoves, [Start,End]):-
    samsort(compareWhite, AvailableMoves, SortedList),
    nth0(0, SortedList, [Start,End]).

compareWhite([Ran, I1-J1], [Ran2, I2-J2]) :-
    getWhiteValue(I1-J1, Value1),
    getWhiteValue(I2-J2, Value2),
    Value1 >= Value2.


bestComputerMove(2,AvailableMoves, [Start,End]):-
    samsort(compareBlack, AvailableMoves, SortedList),
    nth0(0, SortedList, [Start,End]).

compareBlack([Ran, I1-J1], [Ran2, I2-J2]) :-
    getBlackValue(I1-J1, Value1),
    getBlackValue(I2-J2, Value2),
    Value1 >= Value2.

