public class Tile {
  int c = #0000FF;
  Board parent;
  boolean onBoard = true;
  private int boardXPos;
  private int boardYPos;
  public Tile(Board parent) {
    this.parent = parent;
  }
  void render(int xcor, int ycor) {
    noStroke();
    fill(c);
    rect(xcor, ycor, TILE_SIZE, TILE_SIZE);
  }
  public void updateBoardPos(int newBoardXPos, int newBoardYPos){
    if(!onBoard){
      return; // do nothing
    }
    if(newBoardXPos == boardXPos && newBoardYPos == boardYPos){
      return; // no change
    }
    parent.tiles[boardYPos][boardXPos] = null;
    boardXPos = newBoardXPos;
    boardYPos = newBoardYPos;
    parent.tiles[boardYPos][boardXPos] = this;
  }
}
