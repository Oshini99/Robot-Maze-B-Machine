/* Robot
* Author: Oshini Ilukkumbura
* Creation date: 1/5/2023
*/

MACHINE
    Robot   // Define the machine for Robot
    
SEES
    Maze
    
VARIABLES
    // Declare the required variables for the robot machine
    robot_x_position,     // x axis position of the robot
    robot_y_position,     // y axis position of the robot
    robot_visited_path    // Path of squares that the robot has visited
    
INVARIANT
    robot_x_position : NATURAL1 & 
    robot_y_position : NATURAL1 & 
    robot_visited_path : seq(maze_x_position * maze_y_position)
    
INITIALISATION
    robot_x_position, robot_y_position,robot_visited_path := 1, 1,[]
    
DEFINITIONS
    // Functions that have used to create the animation
    ANIMATION_FUNCTION == ({row,col,img | col:1..7 & row:1..5 & img = 0});
    ANIMATION_FUNCTION1 == ({row,col,img | col:1..7 & row:1..5 & img = 1 & (col , 6 - row):wall});
    ANIMATION_FUNCTION2 == ({ row, col, img | col:1..7 & row:1..5 & img=2 & col=robot_x_position & row=(6-robot_y_position) });
    
    // Set paths of images for animations
    ANIMATION_IMG0 == "images/cell.gif";
    ANIMATION_IMG1 == "images/wall.gif";
    ANIMATION_IMG2 == "images/robot.gif";
    
OPERATIONS
    
    // Move the robot 1 square to North side by increasing the current y axis value by 1. (y+1)
    notification <-- moveNorth = 
    BEGIN
        // Check whether the position that the robot going to move is within the maze boundary
        IF
            (robot_y_position + 1 : maze_y_position)
        THEN
            // Check whether the position that the robot going to move is a position on the wall and prompt the error notification
            IF
                (robot_x_position |-> (robot_y_position + 1 ): wall)
            THEN
                notification := CANNOT_MOVE_WALL_DETECTED  
                
                // Check whether the position that the robot going to move is the exit position and prompt the error notification
            ELSIF
                ((robot_x_position |-> robot_y_position) = exit_position)
            THEN
                notification := REACHED_EXIT
                
            ELSE
                robot_visited_path, robot_y_position := robot_visited_path <- (robot_x_position, robot_y_position), robot_y_position + 1 || notification := MOVED_NORTH
            END
        ELSE
            notification := CANNOT_MOVE_OUT_OF_MAZE_BOUNDARY       
        END
    END;
    
    
    // Move the robot 1 square to South side by decreasing the current y axis value by 1. (y-1)
    notification <-- moveSouth =
    BEGIN
        // Check whether the position that the robot going to move is within the maze boundary
        IF
            (robot_y_position - 1 : maze_y_position)
        THEN
            // Check whether the position that the robot going to move is a position on the wall and prompt the error notification
            IF
                (robot_x_position |-> (robot_y_position - 1) : wall)
            THEN
                notification := CANNOT_MOVE_WALL_DETECTED
                
                // Check whether the position that the robot going to move is the exit position and prompt the error notification
            ELSIF
                ((robot_x_position |-> robot_y_position) = exit_position)
            THEN
                notification := REACHED_EXIT
                
            ELSE
                robot_visited_path, robot_y_position := robot_visited_path <- (robot_x_position, robot_y_position), robot_y_position - 1 ||
                notification := MOVED_SOUTH
                
            END
        ELSE
            notification := CANNOT_MOVE_OUT_OF_MAZE_BOUNDARY
        END
    END; 
    
    
    // Move the robot 1 square to East side by increasing the current x axis value by 1. (x+1)
    notification <-- moveEast =
    BEGIN
        // Check whether the position that the robot going to move is within the maze boundary
        IF
            (robot_x_position + 1 : maze_x_position)
        THEN
            // Check whether the position that the robot going to move is a position on the wall and prompt the error notification
            IF
                ((robot_x_position + 1) |-> robot_y_position : wall)
            THEN
                notification := CANNOT_MOVE_WALL_DETECTED
                
                // Check whether the position that the robot going to move is the exit position and prompt the error notification     
            ELSIF
                ((robot_x_position |-> robot_y_position) = exit_position)
            THEN
                notification := REACHED_EXIT
                
            ELSE
                robot_visited_path, robot_x_position := robot_visited_path <- (robot_x_position, robot_y_position), robot_x_position + 1 || notification := MOVED_EAST
                
            END
        ELSE
            notification := CANNOT_MOVE_OUT_OF_MAZE_BOUNDARY
        END
    END;
    
    
    
    // Move the robot 1 square to West side by decreasing the current x axis value by 1. (x-1)
    notification <-- moveWest =
    BEGIN
        // Check whether the position that the robot going to move is within the maze boundary
        IF
            (robot_x_position - 1 : maze_x_position)
        THEN
            // Check whether the position that the robot going to move is a position on the wall and prompt the error notification
            IF
                ((robot_x_position - 1) |-> robot_y_position : wall)
            THEN
                notification := CANNOT_MOVE_WALL_DETECTED
                
                
                // Check whether the position that the robot going to move is the exit position and prompt the error notification       
            ELSIF
                ((robot_x_position |-> robot_y_position) = exit_position)
            THEN
                notification := REACHED_EXIT
                
            ELSE
                robot_visited_path, robot_x_position := robot_visited_path <- (robot_x_position, robot_y_position), robot_x_position - 1 ||
                notification := MOVED_WEST
                
            END
        ELSE
            notification := CANNOT_MOVE_OUT_OF_MAZE_BOUNDARY
        END
    END;
    
    
    //Teleport Operations
    notification <-- teleport(x_position, y_position) = 
    
    PRE
        x_position : NATURAL1 &
        y_position : NATURAL1 &
        
        (x_position |-> y_position) /= (robot_x_position |-> robot_y_position)
    THEN
        
        // To prevent the immediate teleport to exit position
        IF
            ( (x_position |-> y_position ) = exit_position &
                size(robot_visited_path) = 0)
        THEN
            notification := CANNOT_IMMEDIATE_TELEPORT_TO_EXIT
        ELSE
            // Check whether the selected teleport position is on the wall or not
            IF
                (x_position |-> y_position /: wall)
            THEN
                // Check whether the selected teleport position is inside the maze boundary or not
                IF
                    (x_position : maze_x_position & y_position : maze_y_position)
                THEN
                    // Check whether the teleport position is the exit position or not
                    // If it is yes prompt an error notification and prevent further movements
                    IF
                        ((robot_x_position|-> robot_y_position)=exit_position)
                    THEN
                        notification := REACHED_EXIT
                    ELSE
                        
                        robot_x_position, robot_y_position, robot_visited_path := x_position, y_position, robot_visited_path <- (robot_x_position, robot_y_position) ||
                        notification := TELEPORTED_SUCCESSFULLY
                    END
                    
                ELSE
                    notification := CANNOT_MOVE_OUT_OF_MAZE_BOUNDARY
                END
                
            ELSE
                notification := CANNOT_MOVE_WALL_DETECTED
            END
        END
    END;
    
    
    
    
    // Operation to Get the current position of robot
    answer <-- getPosition =
    
    BEGIN
        answer := robot_x_position |-> robot_y_position
    END;
    
    
    // Operation to check whether the Robot reached to the exit point or not
    answer <-- foundExit =
    BEGIN
        
        //check whether the current position equals to the exit position (1,5) 
        IF
            ((robot_x_position |-> robot_y_position) = exit_position)
        THEN
            
            answer := Yes
        ELSE
            answer := No
        END
    END;
    
    
    //Keep track on the visited Squares in the maze
    answer <-- hasVisitedSquare(x_position, y_position) =
    PRE
        x_position : maze_x_position &
        y_position : maze_y_position
    THEN
        IF
            ((x_position |-> y_position) : ran(robot_visited_path))
        THEN
            
            answer := Yes
        ELSE
            answer := No
        END
    END;
    
    
    //Operation to get the sequence of squares that the robot has visited
    answer <-- robotsRoute =
    BEGIN
        answer := robot_visited_path 
    END;
    
    
    // Reset the robot to its original position which is the the entrance square (1,1)
    resetRobotPosition = 
    BEGIN
        robot_x_position, robot_y_position, robot_visited_path := 1, 1, []
    END
    
    
END
