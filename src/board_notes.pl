/**                   
 * i = 8   I           o---o---o---o---o
 *                    / \ / \ / \ / \ / \ 
 * i = 7   H         o---o---o---o---o---o
 *                  / \ / \ / \ / \ / \ / \ 
 * i = 6   G       o---o---o---o---o---o---o
 *                / \ / \ / \ / \ / \ / \ / \
 * i = 5   F     o---o---o---o---o---o---o---o
 *              / \ / \ / \ / \ / \ / \ / \ / \
 * i = 4   E   o---o---o---o---o---o---o---o---o
 *              \ / \ / \ / \ / \ / \ / \ / \ / \
 * i = 3   D     o---o---o---o---o---o---o---o   \
 *                \ / \ / \ / \ / \ / \ / \ / \   \
 * i = 2   C       o---o---o---o---o---o---o   \   \
 *                  \ / \ / \ / \ / \ / \ / \   \   \ 
 * i = 1   B         o---o---o---o---o---o   \   \   \
 *                    \ / \ / \ / \ / \ / \   \   \   \
 * i = 0   A           o---o---o---o---o   \   \   \   \
 *                      \   \   \   \   \   \   \   \   \
 *                       1   2   3   4   5   6   7   8   9
 * 
 *                      j=0 j=1 j=2 j=3 j=4 j=5 j=6 j=7 j=8
 * 
 * 
 * | i \ j | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 
 * |-------|---|---|---|---|---|---|---|---|---|   
 * |     0 |   |   |   |   |   |XXX|XXX|XXX|XXX|   
 * |     1 |   |   |   |   |   |   |XXX|XXX|XXX|   
 * |     2 |   |   |   |   |   |   |   |XXX|XXX|   
 * |     3 |   |   |   |   |   |   |   |   |XXX|   
 * |     4 |   |   |   |   |   |   |   |   |   |   
 * |     5 |XXX|   |   |   |   |   |   |   |   |   
 * |     6 |XXX|XXX|   |   |   |   |   |   |   |   
 * |     7 |XXX|XXX|XXX|   |   |   |   |   |   |   
 * |     8 |XXX|XXX|XXX|XXX|   |   |   |   |   |   
 * 
 *  
**/

initialstate(
    [ % Board
        [  0,  0,  0,  0,  0,nan,nan,nan,nan],
        [  0,  1,  1,  1,  1,  0,nan,nan,nan],
        [  0,  1,  0,  1,  0,  1,  0,nan,nan],
        [  0,  1,  1,  1,  1,  1,  1,  0,nan],
        [  0,  0,  0,  0,  0,  0,  0,  0,  0],
        [nan,  0,  2,  2,  2,  2,  2,  2,  0],
        [nan,nan,  0,  2,  0,  2,  0,  2,  0],
        [nan,nan,nan,  0,  2,  2,  2,  2,  0],
        [nan,nan,nan,nan,  0,  0,  0,  0,  0]
    ],
)

[https://github.com/dmfrodrigues/feup-plog-tp1/blob/master/src/board.pl]

board_is_valid_position(I-J) :- between(0, 4, I), R is I+4, between(0, R, J).
board_is_valid_position(I-J) :- between(5, 8, I), L is I-4, between(L, 8, J).

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

isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui, Vj is Uj+1, board_is_valid_position(Vi-Vj). %right
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui, Vj is Uj-1, board_is_valid_position(Vi-Vj). %left

%white_piece

isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui+1, Vj is Uj+1, board_is_valid_position(Vi-Vj). %up_right
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui+1, Vj is Uj, board_is_valid_position(Vi-Vj). %up_left

%black_piece
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui-1, Vj is Uj, board_is_valid_position(Vi-Vj). %below_right
isAdj(Ui-Uj, Vi-Vj) :- board_is_valid_position(Ui-Uj), Vi is Ui-1, Vj is Uj-1, board_is_valid_position(Vi-Vj). %below_left

