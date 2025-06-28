int CLEARBOARD = 0;
int EASYSHAPE = 1;

/*
conencts with a shape and will be placed in one of it's block
*/
class PowerUp {
  int type;
  int x, y;
  int offset;
  PowerUpAbility ability;
  color c;
  PowerUp(int x, int y, int offset) {
    randomize();
    this.x = x;
    this.y = y;
    this.offset = offset;
  }

  void randomize() {
    type = int(random(2));
    if (type == 0) {
      ability = new ClearBoardAbility();
      c = color(0, 0, 0);
    } else {
      ability = new BarShapeAbility();
      c = color(255);
    }
  }

  void activate() {
    ability.useAbility();
  }
  
  void display(){
    fill(c);
    circle(x * offset + 18, y * offset + 18, 20);
  }
}

public interface PowerUpAbility {
  public void useAbility();
}

/*
clears the entire board when a shape lands and clears the line this power up is trapped in
 */
class ClearBoardAbility implements PowerUpAbility {
  public void useAbility() {
    //occupiedGridSpot = new boolean[boardWidth][boardHeight];
    for (int x = 0; x < boardWidth; x++) {
      for (int y = 0; y < boardHeight; y++) {
        gridSpotColour[x][y] = BLACK; // default colour for all cells in the gameboard grid
        occupiedGridSpot[x][y] =  false;
      }
    }
    println("clearing board");
  }
}


class BarShapeAbility implements PowerUpAbility {
  public void useAbility() {
    //implement code to increase a var for power up usage
    println("Got 1 use of morphing to BarShape");
    easyBarUsage += 1;
  }
}
