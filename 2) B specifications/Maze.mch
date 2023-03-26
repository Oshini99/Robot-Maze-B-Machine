/* Maze
* Author: Oshini Ilukkumbura
* Creation date: 1/5/2023
*/
MACHINE
    Maze
    // Define the machine for Maze
    
SETS
    NOTIFICATIONS = {CANNOT_MOVE_OUT_OF_MAZE_BOUNDARY,CANNOT_MOVE_WALL_DETECTED,TELEPORTED_SUCCESSFULLY,CANNOT_IMMEDIATE_TELEPORT_TO_EXIT,MOVED_NORTH, MOVED_SOUTH, MOVED_EAST, MOVED_WEST,REACHED_EXIT};
    RESPONSES = {Yes , No }
    
CONSTANTS
    height ,             // Height of the maze
    width ,              // Width of the maze
    maze_x_position ,    // X axis positions of the maze
    maze_y_position ,    // y axis positions of the maze 
    wall ,               // Positions of wall inside the maze
    exit_position        // Position of maze's exit point
    
PROPERTIES
    height = 5 & width = 7 & maze_x_position = 1..width & maze_y_position = 1..height & exit_position = (1|-> 5) & 
    wall : maze_x_position <-> maze_y_position &
    wall = {(1 |-> 3), (2 |-> 1), (2 |-> 3), (2 |-> 5), (3 |-> 3), (4 |-> 2), (4 |-> 3), (4 |-> 4),(6 |-> 1), (6 |-> 2), (6 |-> 4), (7 |-> 4)}
    
END
