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

#### Initial State

#### Intermediate State

#### Final State

### Game State Visualization

#### Menu

#### Board

We added labels to the lines on the game board using 'i' and 'j' is a helpful and intuitive approach. This labeling system provides a clear, intuitive and user-friendly way to reference specific locations on the board.

The pieces and empty positions are represented in the following way:
  - White piece: W
  - Black piece: B
  - empty space: o

Here you can see the initial board:

For this we iterate through through the game state considering the different scenarios (Is the position in the middle? Is the last position of the row? (we don't want --- after it) Is the last row?)











  
