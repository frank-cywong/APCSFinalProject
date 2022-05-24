public class Block {
  int boardXPos = 7;
  int boardYPos = 18;
  Board parent;
  boolean boardDoesRendering = true;
  int[][][] locs = {{{-1, 0}, {0, 0}, {1, 0}, {2, 0}}, // I piece -1 0, 0 0, 1 0, 2 0
                   {{-1, 1}, {-1, 0}, {0, 0}, {1, 0}},  // J piece -1 1, -1 0, 0 0, 1 0
                   {{-1, 0}, {0, 0}, {1, 0}, {1, 1}},  // L piece -1 0, 0 0, 1 0, 1 1
                   {{0, 0}, {1, 0}, {0, 1}, {1, 1}},  // O piece 0 0, 1 0, 0 1, 1 1
                   {{-1, 0}, {0, 0}, {0, 1}, {1, 1}},  // S piece -1 0, 0 0, 0 1, 1 1
                   {{-1, 0}, {0, 0}, {0, 1}, {1, 0}},  // T piece -1 0, 0 0, 0 1, 1 0
                   {{-1, 1}, {0, 1}, {0, 0}, {1, 0}}}; //  Z piece -1 1, 0 1, 0 0, 1 0
  int curr = 3;
  Tile[] tiles;
  public Block(Board parent) {
    this.parent = parent;
    tiles = new Tile[locs[curr].length];
    for (int i = 0; i < locs[curr].length; i++) {
      tiles[i] = new Tile(parent, this);
    }
  }
  void updateTilePos() {
    for (int i = 0; i < locs[curr].length; i++) {
      //System.out.println("Updating tile " + i + " to (" + (boardXPos + locs[i][0]) + ", " + (boardYPos + locs[i][1]) + ")");
      tiles[i].updateBoardPos(boardXPos + locs[curr][i][0], boardYPos + locs[curr][i][1]);
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
  void hardDrop(){
    while(doGravity());
  }
}
