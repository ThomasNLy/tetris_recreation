//-----pseudo constant static variables from some static class to hold the info------------------ 

int LSHAPE[][] = {{0, 0}, {0, 1}, {0, 2}, {1, 2}};
int TSHAPE[][] = {{-1, 0}, {0, 0}, {1, 0}, {0, 1}};
int SQUARESHAPE[][] = {{-1, 0}, {0, 0}, {0, 1}, {-1, 1}};
int BARSHAPE[][] = {{0, 0}, {0, 1}, {0, 2}, {0, 3}};
int JSHAPE[][] = {{0, 0}, {0, 1}, {0, 2}, {-1, 2}};
int ZSHAPE[][] = {{-1, 0}, {0, 0}, {0, 1}, {1, 1}};
int SSHAPE[][] ={{1, 0}, {0, 0}, {0, 1}, {-1, 1}};

//constants to keep track of what shape was chosen
//numbers based off index in the array holding the shapes
final int L = 0;
final int T= 1;
final int SQ = 2;
final int BAR= 3;
final int J = 4;
final int Z = 5;
final int S = 6;

/*
multidimensional array to hold all the shapes' block arrangement
 first [] represents number of items in the array
 second [] represents number of blocks in the shapes array: 4
 third [] represents number of items that make up a block(x, y coordinates): 2
 e.x. int [][][] shapes = new int[7][4][2] 7 shapes, 4 blocks, 2 numbers for x,y coordinates
 */
int [][][] shapes = {LSHAPE, TSHAPE, SQUARESHAPE, BARSHAPE, JSHAPE, ZSHAPE, SSHAPE};
//the shapes use the second block as the center for it's positioning blocks[1] is the block
//used as it's center for reference on the screen

final color GREEN = color(28, 211, 188);
final color MAGENTA = color(208, 131, 239);
final color ORGANGE = color(181, 162, 37);
final color BLUE = color(120, 192, 255);
final color YELLOW = color(219, 216, 31);
color colourList[] = {GREEN, MAGENTA, ORGANGE, BLUE, YELLOW};

//------------------------------------------------------------

class Shape {
  /*
  used to keep track of the arrangement of the blocks
   the first [] referrs to which block:0-4, the second [] refers to the x or y coordinate:[0] == x, [1] == y
   */
  int blocks[][];
  color colour;
  boolean landed;
  boolean occupiedBoardSpots[][];
  int shape;
  int landedYCoordinate;
  PowerUp powerup;
  Shape(int x, int y, boolean [][]gridState) {

    blocks = new int[4][2];
    int randomShape = int(random(colourList.length));
    shape = randomShape;
    //randomShape=  2;
    for (int i = 0; i < 4; i++) {
      blocks[i][0] = shapes[randomShape][i][0] + x;
      blocks[i][1] = shapes[randomShape][i][1] + y;
    }
    int randomColour = int(random(colourList.length));
    colour = colourList[randomColour];



    occupiedBoardSpots = gridState;
    float powerUpChance = random(5);
    if (powerUpChance < 0.5) {
      powerup = new PowerUp(blocks[0][0], blocks[0][1], blockSize);
    } else {
      powerup = null;
    }
  }

  void display() {
    fill(colour);
    stroke(#e8f3f1);
    for (int coordinates[] : blocks) {
      //minus 1 to have it appear as if it is dropping from top out of view
      rect(coordinates[0] * 36, coordinates[1] * 36, 36, 36, 10);
    }
    if (powerup != null) {
      powerup.display();

      powerup.x = blocks[0][0];
      powerup.y = blocks[0][1];
    }
  }

  void moveDown() {


    boolean stopped = false;
    checkShapeLanded();
    if (landed == true) {
      stopped = true;
      int ycoords[] = {blocks[0][1], blocks[1][1], blocks[2][1], blocks[3][1]};
      landedYCoordinate = max(ycoords);
    }
    if (!stopped) {

      for (int i = 0; i < 4; i++) {
        blocks[i][1] += 1;
      }
    }
  }

  void moveLeft() {
    boolean stopped = false;
    for (int coordinates[] : blocks) {
      if (coordinates[0]-1 < 0 || occupiedBoardSpots[coordinates[0]-1][coordinates[1]]) {
        stopped = true;
      }
    }
    if (!stopped) {

      for (int i = 0; i < 4; i++) {
        blocks[i][0] -= 1;
      }
    }
  }
  void moveRight() {
    boolean stopped = false;
    for (int coordinates[] : blocks) {
      if (coordinates[0] + 1 > boardWidth-1 || occupiedBoardSpots[coordinates[0]+1][coordinates[1]]) {
        stopped = true;
      }
    }
    if (!stopped) {
      for (int i = 0; i < 4; i++) {
        blocks[i][0] += 1;
      }
    }
  }

  /*
  rotation formula 90 degrees clockwise is (x,y) -> (y, -x)
   counterclockwise 90 degrees is (x,y) -> (-y, x)
   when rotating around origin
   xrotated = x * cos(angle) - y * sin(angle)
   yrotated  = x * sin(angle) + y * cos(angle)
   cos(90) = 0, sin(90) = 1
   cos(-90) = 0, sin(-90) = -1
   90 represents positive rotation which is counterclockwise
   
   -90 represent negative rotation which is clockwise
   
   
   to rotate around a point other than origin, translate the points back to the origin before doing the rotation
   than translate it back to the rotation point
   xrotated = [x * cos(angle) - y * sin(angle)] - y coordinate away from origin
   xrotated += x coordinate away from origin -> this gets the newly rotated x coordinate at a point away from origin
   
   yrotated = [x * sin(angle) + y * cos(angle)] - x coordinate away from origin
   yrotated + y coordinate away from origin 0> get newly rotated y coordiante at point away from origin
   */

  /*
  since y coordinate is flipped rotating clockswise uses counterclock wise formula
   */
  void rotateClockwise() {
    int rotatedCoordinates[][] = new int[4][2];
    boolean canRotate = true;
    for (int i = 0; i  < 4; i++) {
      int rotationPointX = blocks[1][0];
      int rotationPointY = blocks[1][1];
      int rotatedX = -(blocks[i][1] - rotationPointY) + rotationPointX;
      int rotatedY = (blocks[i][0] - rotationPointX) + rotationPointY;
      rotatedCoordinates[i][0] = rotatedX;
      rotatedCoordinates[i][1] = rotatedY;
      if (rotatedX > boardWidth-1 || rotatedX < 0 || rotatedY > boardHeight-1 || rotatedY < 0 || this.occupiedBoardSpots[rotatedX][rotatedY]) {
        canRotate = false;
      }
    }
    if (canRotate) {
      for (int i = 0; i < 4; i++) {
        blocks[i][0] = rotatedCoordinates[i][0];
        blocks[i][1] = rotatedCoordinates[i][1];
      }
    }
  }
  /*
  since y coordinate is flipped rotating counter clockswise uses clockwise formula
   */
  void rotateCounterClockwise() {
    int rotatedCoordinates[][] = new int[4][2];
    boolean canRotate = true;
    for (int i = 0; i  < 4; i++) {
      int rotationPointX = blocks[1][0];
      int rotationPointY = blocks[1][1];
      int rotatedX = (blocks[i][1] - rotationPointY) + rotationPointX;
      int rotatedY = -(blocks[i][0] - rotationPointX) + rotationPointY;
      rotatedCoordinates[i][0] = rotatedX;
      rotatedCoordinates[i][1] = rotatedY;
      if (rotatedX > boardWidth-1 || rotatedX < 0 || rotatedY > boardHeight-1 || rotatedY < 0 || this.occupiedBoardSpots[rotatedX][rotatedY]) {
        canRotate = false;
      }
    }
    if (canRotate) {
      for (int i = 0; i < 4; i++) {
        blocks[i][0] = rotatedCoordinates[i][0];
        blocks[i][1] = rotatedCoordinates[i][1];
      }
    }
  }


  void checkShapeLanded() {
    for (int coordinates[] : blocks) {
      if (coordinates[1] + 1 > boardHeight-1 || occupiedBoardSpots[coordinates[0]][coordinates[1] + 1]) {
        landed = true;
      }
    }
  }

  void landingZone() {
    int landingZoneBlocks[][] = new int [4][2];
    for (int i = 0; i < 4; i++) {
      landingZoneBlocks[i][0] = blocks[i][0];
      landingZoneBlocks[i][1] = blocks[i][1];
    }

    boolean landingZoneFound = false;
    while (!landingZoneFound) {
      for (int i = 0; i < landingZoneBlocks.length; i++) {
        landingZoneBlocks[i][1] += 1;
      }
      for (int i = 0; i < landingZoneBlocks.length; i++) {
        if (landingZoneBlocks[i][1] >= 19 || occupiedBoardSpots[ landingZoneBlocks[i][0]][landingZoneBlocks[i][1] + 1]) {
          landingZoneFound = true;
          break;
        }
      }
      //if (landingZoneFound) {
      //  break;
      //}
    }
    for (int block[] : landingZoneBlocks) {
      fill(255, 100);
      rect(block[0] * 36, block[1] * 36, 36, 36);
    }
  }

  void dropShape() {
    while (true) {
      for (int block[] : blocks) {
        block[1] += 1;
      }

      checkShapeLanded();
      if (landed == true) {
        int ycoords[] = {blocks[0][1], blocks[1][1], blocks[2][1], blocks[3][1]};
        landedYCoordinate = max(ycoords);
        break;
      }
    }
  }
}
