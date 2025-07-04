
//-------------------Colours---------------------
final color BLACK = #00291a;
final color GREY = #989898;
final color TEALGREEN = #e6f0ea;
final color TEALGREEN2 = #e8f3f1;

//-------------------------------------------------------------

Shape currentShape;
Shape nextShape;

color gridSpotColour[][];
boolean occupiedGridSpot[][];
PowerUp powerUpGridSpot[][]; // the spot where the powerup landed
int dropTimer;
int points;
int easyBarUsage = 0; // morph into bar shape power up useage


void setup() {
  size(1280, 720);
  gridSpotColour = new color[boardWidth][boardHeight];
  for (int x = 0; x < 10; x++) {
    for (int y = 0; y < 20; y++) {
      gridSpotColour[x][y] = BLACK; // default colour for all cells in the gameboard grid
    }
  }

  occupiedGridSpot = new boolean[boardWidth][boardHeight];
  currentShape = new Shape(5, 0, occupiedGridSpot);
  nextShape = new Shape(5, 0, occupiedGridSpot);
  points = 0;
  powerUpGridSpot = new PowerUp[boardWidth][boardHeight];
}
void draw() {
  background(TEALGREEN);

  for (int x = 0; x < boardWidth; x++) {
    for (int y = 0; y < boardHeight; y++) {
      stroke(TEALGREEN2);
      fill(gridSpotColour[x][y]);
      rect(x* 36, y * 36, 36, 36, 10);
      textSize(12);
      text(y, 390, y*36 + 20);
      if (powerUpGridSpot[x][y] != null) {
        powerUpGridSpot[x][y].display();
      }
    }
  }

  //game board outline
  stroke(TEALGREEN);

  fill(255, 0);
  rect(0, 0, 360, 720);

  //----------------shape code------------
  dropTimer++;
  if (dropTimer > 30) {
    dropTimer = 0;
    currentShape.moveDown();
  }
  currentShape.display();
  currentShape.landingZone();
  if (currentShape.landed) {
    recordShapeLanded(currentShape);
    clearFullRows();
    currentShape = nextShape;
    nextShape = new Shape(5, 0, occupiedGridSpot);
  }
  //----------------------------------
  UI();



  if (checkGameOver()) {
    fill(GREY);
    rect(30, height/2 - 160, 310, 80, 10);
    fill(255);
    textSize(50);
    text("GAME OVER", 40, height/2 - 100);
  }


  //-------------DebugCode--------------
  //debug();
}

void keyPressed() {
  if (key == 'a') {
    currentShape.moveLeft();
  }
  if (key == 'd') {
    currentShape.moveRight();
  }
  if (key == 's') {
    currentShape.moveDown();
  }
  if (key == 'e') {
    currentShape.rotateClockwise();
  }
  if (key == 'q') {
    currentShape.rotateCounterClockwise();
  }
  if (keyCode == 32) {
    currentShape.dropShape();
  }
  if (key == 'r') {
    swapShape();
  }

  if (keyCode == 10) { //enter key
    setup();
  }

  if (key == 'f' && easyBarUsage > 0) {
    easyBarUsage -= 1;
    for (int i = 0; i < 4; i++) {
      currentShape.blocks[i][0] = BARSHAPE[i][0] + 5;
      currentShape.blocks[i][1] = BARSHAPE[i][1];
    }
  }
}

void recordShapeLanded(Shape s) {
  for (int i = 0; i < 4; i++) {
    int currentBlockX = s.blocks[i][0];
    int currentBlockY = s.blocks[i][1];
    gridSpotColour[currentBlockX][currentBlockY] = s.colour;
    occupiedGridSpot[currentBlockX][currentBlockY] = true;
  }
  if (s.powerup != null) {
    powerUpGridSpot[s.powerup.x][s.powerup.y] = s.powerup;
  }
}


boolean checkFullRow(int row) {
  int fullSpots = 0;
  for (int x = 0; x < boardWidth; x++) {
    if (occupiedGridSpot[x][row]) {
      fullSpots++;
    }
    if (fullSpots == 10) {

      return true;
    }
  }
  return false;
}

void clearFullRows() {
  int startingRowCleared = 0;
  int numRowsCleared = 0; //keeps track how many times the rows will have to drop down based off total rows cleared 
  for (int y = boardHeight-1; y > 1; y--) {
    if (checkFullRow(y)) {
      numRowsCleared++;
      points += 10;
      clearRow(y);
      if (y > startingRowCleared) {
        startingRowCleared = y;
      }
      //println("startingRow" + startingRowCleared);
      //dropBlocksDown(y);
    }
  }
  //checks to see if any power ups should be activated 
  for (int i = 0; i < numRowsCleared; i++) {
    println(startingRowCleared-i);
    gainPowerUp(startingRowCleared-i);
  }

  debugRowDropping(startingRowCleared);

  for (int i = 0; i < numRowsCleared; i++) {
    dropBlocksDown(startingRowCleared);
    dropPowerUpsDown(startingRowCleared);
  }
}

void clearRow(int row) {
  for (int x = 0; x < boardWidth; x++) {
    occupiedGridSpot[x][row] = false;
    gridSpotColour[x][row] = color(#00291a);
  }
}

void dropBlocksDown(int rowNum) {
  for (int x = 0; x < boardWidth; x++) {
    for (int y = rowNum; y > 1; y-=1) {
      occupiedGridSpot[x][y] = occupiedGridSpot[x][y-1];
      gridSpotColour[x][y] = gridSpotColour[x][y-1];
    }
  }
}



boolean checkGameOver() {
  for (int i = 0; i < boardWidth; i++) {
    if (occupiedGridSpot[i][0]) {
      return true;
    }
  }
  return false;
}


void previewNextShape() {
  //println(mouseX, mouseY);
  stroke(BLACK);
  fill(BLACK, 20);
  rect(500, 20, 175, 175, 5);
  fill(nextShape.colour);
  for (int i  = 0; i < nextShape.blocks.length; i++) {

    if (nextShape.shape == SQ) {
      rect(nextShape.blocks[i][0] * 36 + 405, nextShape.blocks[i][1] * 36 + 70, 36, 36, 10);
    } else if (nextShape.shape == L || nextShape.shape == J) {
      rect(nextShape.blocks[i][0] * 36 + 390, nextShape.blocks[i][1] * 36 + 50, 36, 36, 10);
    } else if (nextShape.shape == BAR) {
      rect(nextShape.blocks[i][0] * 36 + 390, nextShape.blocks[i][1] * 36 + 33, 36, 36, 10);
    } else {
      rect(nextShape.blocks[i][0] * 36 + 390, nextShape.blocks[i][1] * 36 + 75, 36, 36, 10);
    }
  }
}

void UI() {
  previewNextShape();

  fill(0);
  textSize(30);
  text("Points: " + points, 700, 100);
  fill(0);
  textSize(30);
  text("easy BAR: " + easyBarUsage, 700, 150);
}



//----------------------------------Power Ups--------------------
void swapShape() {
  boolean canSwap = true;
  int [][]nextShapeForm = shapes[nextShape.shape];
  int temp = currentShape.shape;
  int currentShapeCenterBlock[] = {currentShape.blocks[1][0], currentShape.blocks[1][1]};
  for (int i = 0; i < 4; i++) {
    if (nextShapeForm[i][0] + currentShapeCenterBlock[0] < 0 || nextShapeForm[i][0] + currentShapeCenterBlock[0] > 9 || 
      nextShapeForm[i][1] + currentShapeCenterBlock[1] > 19 || 
      occupiedGridSpot[nextShapeForm[i][0] + currentShapeCenterBlock[0]][nextShapeForm[i][1] + currentShapeCenterBlock[1]]) {
      canSwap = false;
    }
  }

  if (!canSwap) return; //exit the function if can't swap early 

  for (int i = 0; i < 4; i++) {
    currentShape.blocks[i][0] = shapes[nextShape.shape][i][0] + currentShapeCenterBlock[0];
    currentShape.blocks[i][1] = shapes[nextShape.shape][i][1] + currentShapeCenterBlock[1];

    nextShape.blocks[i][0] = shapes[temp][i][0] + 5;
    nextShape.blocks[i][1] = shapes[temp][i][1] + 0;
  }
  currentShape.shape = nextShape.shape;
  nextShape.shape = temp;
}

/*
checks to see if there are any powerups to gain when clearing a line 
 */
void gainPowerUp(int rowNumber) {
  for (int x = 0; x < boardWidth; x++) {
    if (powerUpGridSpot[x][rowNumber] != null) {
      println("filled");
      PowerUp powerUp = powerUpGridSpot[x][rowNumber];
      if (powerUp.type == CLEARBOARD){
        points += 50;
      }
      powerUpGridSpot[x][rowNumber].activate();
      powerUpGridSpot[x][rowNumber] = null;
    }
  }
  currentShape.occupiedBoardSpots = occupiedGridSpot;
}

/*
 has the power ups drop down and fall when a the line below them is cleared
 */
void dropPowerUpsDown(int startingRow) {
  for (int x = 0; x < boardWidth; x++) {
    for (int y = startingRow; y > 1; y--) {
      if (powerUpGridSpot[x][y-1] != null) {
        powerUpGridSpot[x][y-1].y +=1;
      }
      powerUpGridSpot[x][y] = powerUpGridSpot[x][y-1];
    }
  }
}
