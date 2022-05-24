public class Tile {
  int c = #0000FF;
  Board parent;
  Block parentBlock = null; // no collision between tiles in the same block
  boolean onBoard = true;
  private int boardXPos;
  private int boardYPos;
  public Tile(Board parent) {
    this.parent = parent;
  }
  public Tile(Board parent, Block parentBlock, int c){
    this.parent = parent;
    this.parentBlock = parentBlock;
    this.c = c;
  }
  public void render(int xcor, int ycor) {
    noStroke();
    fill(c);
    rect(xcor, ycor, TILE_SIZE, TILE_SIZE);
  }
  public boolean canMoveTo(int[] a){
    return canMoveTo(a[0], a[1]);
  }
  public boolean canMoveTo(int dx, int dy){
    int nx = boardXPos + dx;
    int ny = boardYPos + dy;
    if(nx < 0 || ny < 0 || ny >= parent.tiles.length || nx >= parent.tiles[ny].length){
      return false;
    }
    Tile toTest = parent.tiles[boardYPos + dy][boardXPos + dx];
    return(toTest == null || toTest.parentBlock == this.parentBlock);
  }
  public void updateBoardPos(int newBoardXPos, int newBoardYPos){
    if(!onBoard){
      return; // do nothing
    }
    if(newBoardXPos == boardXPos && newBoardYPos == boardYPos){
      return; // no change
    }
    if(newBoardXPos < 0 || newBoardYPos < 0 || newBoardYPos >= parent.tiles.length || newBoardXPos >= parent.tiles[newBoardYPos].length){
      return; // out of bounds
    }
    if(parent.tiles[boardYPos][boardXPos] == this){
      parent.tiles[boardYPos][boardXPos] = null;
    }
    boardXPos = newBoardXPos;
    boardYPos = newBoardYPos;
    parent.tiles[boardYPos][boardXPos] = this;
  }
  public int getBoardXPos(){ // if boardXPos and boardYPos are modified erroneously its very bad, hence getter & setter methods
    return boardXPos;
  }
  public int getBoardYPos(){
    return boardYPos;
  }
}
