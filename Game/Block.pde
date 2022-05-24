public class Block {
  int boardXPos = 8;
  int boardYPos = 18;
  Board parent;
  boolean boardDoesRendering = true;
  int[][] locs = {{-1, 1}, {-1, 0}, {0, 0}, {1, 0}}; // L piece -1 1, -1 0, 0 0, 1 0
  Tile[] tiles;
  public Block(Board parent) {
    this.parent = parent;
    tiles = new Tile[locs.length];
    for (int i = 0; i < locs.length; i++) {
      tiles[i] = new Tile(parent, this);
    }
  }
  void updateTilePos() {
    for (int i = 0; i < locs.length; i++) {
      //System.out.println("Updating tile " + i + " to (" + (boardXPos + locs[i][0]) + ", " + (boardYPos + locs[i][1]) + ")");
      tiles[i].updateBoardPos(boardXPos + locs[i][0], boardYPos + locs[i][1]);
    }
  }
  boolean doGravity(){
    for(Tile t : tiles){
      if(!t.canMoveTo(0, -1)){
        parent.startFixingBlockInPlace();
        return false;
      }
    }
    boardYPos--;
    updateTilePos();
    return true;
  }
  void render() {
    updateTilePos();
    if (boardDoesRendering) {
      return;
    }
    // todo for future for we have blocks off the main playing field
  }
  void tryMoveLeft(){
    for(Tile t : tiles){
      if(!t.canMoveTo(-1,0)){
        return;
      }
    }
    boardXPos--;
    updateTilePos();
  }
  void tryMoveRight(){
    for(Tile t : tiles){
      if(!t.canMoveTo(1,0)){
        return;
      }
    }
    boardXPos++;
    updateTilePos();
  }
}
