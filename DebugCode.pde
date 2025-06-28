int startingRowToDrop;

void debug() {
  fill(255, 0, 0);
  circle(420, startingRowToDrop * 36 + 20, 25);
  //nextShape.display();
  debugPowerUpsOnBoard();
}

void debugRowDropping(int startRow) {
  startingRowToDrop = startRow;
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
