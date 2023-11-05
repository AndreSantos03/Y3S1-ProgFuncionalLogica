:- use_module(library(random)).

randomMove(AvailableMoves, [Start,End]) :-
    length(AvailableMoves, NumMoves),
    random(0, NumMoves, RandomIndex),
    nth0(RandomIndex, AvailableMoves, [Start,End]).