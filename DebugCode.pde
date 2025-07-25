int startingRowToDrop;

void debug() {
  textAlign(LEFT);
  textFont(regularFont);
  fill(255, 0, 0);
  circle(420, startingRowToDrop * 36 + 20, 25);
  //nextShape.display();
  debugPowerUpsOnBoard();
  debugRowNumbers();
}

void debugRowDropping(int startRow) {
  startingRowToDrop = startRow;
}
void debugRowNumbers() {
  fill(0);
  for (int x = 0; x < boardWidth; x++) {
    for (int y = 0; y < boardHeight; y++) {
      textSize(12);
      text(y, 390, y*36 + 20);
    }
  }
}

void debugPowerUpsOnBoard() {
  for (int x = 0; x < boardWidth; x++) {
    for (int y = 0; y < boardHeight; y++) {
      if (powerUpGridSpot[x][y] != null) {
        powerUpGridSpot[x][y].display();
      } else {
        fill(255);
        textSize(12);
        text("no\npowerup", x*36, y*36 + 18);
      }
    }
  }
}

void showMouseCoordinates() {
  fill(255, 0, 0);
  textSize(15);
  text("x: " + mouseX + "\ny: " + mouseY, mouseX, mouseY);
}
