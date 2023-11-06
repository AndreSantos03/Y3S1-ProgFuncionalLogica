# Differo

Group 

André (up) - 50%

Inês Ferreira de Almeida (up202004513) - 50%

## Description of the game

Differo is an abstract game for 2 players by Kashio Fujii. 

In this game, victory is achieved through strategic calculations of the power balance between your faction and the adversary's, as well as by reinforcing your own forces and impeding the opponent's progress towards the ultimate goal.
As you progressively advance your own game pieces, you may encounter challenges in impeding the opponent's advancing pieces. This gameplay offers the excitement of a thrilling abstract experience.
A player wins when one of their pieces reaches the goal.

### Board

- The board is hexagonal with 5 on a side.

### Pieces

- 13 white pieces
- 13 black pieces

### End conditions

- A player wins when one of their pieces reaches the goal.
- A player loses if they cannot move any of their pieces in their turn.

### Preparation

- Place pieces in predetermined positions (as shown below).
- The players choose their own color. The one who chooses White takes the first turn.

### Moving rules

The player can only move one of their pieces in their turn, acording to the follwing rules:
- The piece moves in a straight line and can jump over any number of pieces, whether they belong to the player or the opponent.
- The piece can move a number of steps equal to (number of player pieces) − (number of player opponent’s pieces) along the line. If this value is less than or equal to 0, the piece cannot move on the line.
- The player cannot move a piece off the board, into an already occupied space, or into the opponent's goal.

## Game Logic

### Internal State Representation

The board is internally represented as a list of lists. Because our game has the pieces in prediminated positions we create a initialstate list and work from there. 
Some positions are not valid (e.g. (1, 1)), which can be checked by calling board_is_valid_position(I-J). 

The pieces and empty positions are represented in the following way:
  - White piece: ``` 1 ```
  - Black piece: ``` 2 ```
  - empty space: ``` 0 ```

#### Initial State
```shell
initialstate([ % Board
    [3,3,3,3,0,0,0,0,0],
    [3,3,3,0,2,2,2,2,0],
    [3,3,0,2,0,2,0,2,0],
    [3,0,2,2,2,2,2,2,0],
    [0,0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,0,3],
    [0,1,0,1,0,1,0,3,3],
    [0,1,1,1,1,0,3,3,3],
    [0,0,0,0,0,3,3,3,3]
]).
```

#### Intermediate State

```shell
intermediatestate([ % Board
    [3,3,3,3,0,0,0,0,0],
    [3,3,3,0,2,2,2,0,0],
    [3,3,2,1,0,1,0,0,0],
    [3,0,2,0,1,2,2,0,0],
    [0,0,1,2,2,0,0,2,0],
    [0,1,1,2,1,1,1,0,3],
    [0,0,1,1,2,1,0,3,3],
    [0,1,2,0,0,0,3,3,3],
    [0,0,0,0,0,3,3,3,3]
]).
```

#### Final State

### Game State Visualization

#### Menu

#### Board

We added labels to the lines on the game board using 'i' and 'j' is a helpful and intuitive approach. This labeling system provides a clear, intuitive and user-friendly way to reference specific locations on the board.

The pieces and empty positions are represented in the following way:
  - White piece: ``` W ```
  - Black piece: ``` B ```
  - empty space: ``` o ```

Here you can see the initial board:

For this we iterate through the game state considering the different scenarios (Is the position in the middle? Is the last position of the row? (we don't want --- after it) Is the last row?)

#### User interation

Throughout the game, players will receive the necessary instructions to enhance the game's intuitiveness. 

We will inform the users about the winner when the game is over, 
```shell
write('Player '), write(Color), write('is the winner.\n').
```

whose turn it is, 

and display player's valid moves to make easy for them know all the options they have.

We also require users to specify which piece they want to move and where they want to place it. To facilitate this, we ask for base and then target coordinates in the format (I-J), and users provide both I and J separately

### Move Validation and Execution

#### Valid moves

We verify if the move given by the player is valid using the predicate ``` valid_move(Color,Ui-Uj,Vi-Vj) ```

The piece can move a number of steps equal to the difference between the count of the player's color pieces and the count of the opponent's color pieces along the line. This envolves count the ocorrence of the value of the player's color piece and the ocorrence of the value of the player's oponent's color piece in that line and calculating the subtraction.

Creating a list with elements of that line, we can use count_pieces(Color, Line, Count) to count the occurrence of that color's piece.

``` shell
count_pieces(_,[],0).
count_pieces(Value, [Value | Rest], Count) :-
    count_pieces(Value, Rest, SubCount),
    Count is SubCount + 1.
count_pieces(Value, [First | Rest], Count) :-
    First =\= Value,
    count_pieces(Value, Rest, Count).
```
#### Directions

Pieces can move along the lines in six directions, as shown below.

``` shell
    5   3
     \ /
1  ---o--- 2
     / \
    4   6
```
This prompts the need to have different methods for creating the list for the different directions. 
Example of the directions 5 and 6 below.

### Move Execution

After the move choice we call move_board that




 









  
