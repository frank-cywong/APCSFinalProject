public class Block {
  int boardXPos = 4;
  int boardYPos = 20;
  Board parent;
  boolean boardDoesRendering = true;
  int rawXPos = 0; // used only if boardDoesRendering is false, represents top left corner of "center"
  int rawYPos = 0;
  static final int I_PIECE = 0;
  static final int J_PIECE = 1;
  static final int L_PIECE = 2;
  static final int O_PIECE = 3;
  static final int S_PIECE = 4;
  static final int T_PIECE = 5;
  static final int Z_PIECE = 6;
  static final int BLOCK_TYPE_COUNT = 7;
  int[][][][] locs = {{{{-1, 0}, {0, 0}, {1, 0}, {2, 0}}, // I piece -1 0, 0 0, 1 0, 2 0
                   {{1, 1}, {1, 0}, {1, -1}, {1, -2}},
                   {{-1, -1}, {0, -1}, {1, -1}, {2, -1}},
                   {{0, 1}, {0, 0}, {0, -1}, {0, -2}}},
                   {{{-1, 1}, {-1, 0}, {0, 0}, {1, 0}},  // J piece -1 1, -1 0, 0 0, 1 0
                   {{1, 1}, {0, 1}, {0, 0}, {0, -1}},
                   {{-1, 0}, {0, 0}, {1, 0}, {1, -1}},
                   {{0, 1}, {0, 0}, {0, -1}, {-1, -1}}},
                   {{{-1, 0}, {0, 0}, {1, 0}, {1, 1}},  // L piece -1 0, 0 0, 1 0, 1 1
                   {{0, 1}, {0, 0}, {0, -1}, {1, -1}},
                   {{-1, -1}, {-1, 0}, {0, 0}, {1, 0}},
                   {{-1, 1}, {0, 1}, {0, 0}, {0, -1}}},
                   {{{0, 0}, {1, 0}, {0, 1}, {1, 1}},  // O piece 0 0, 1 0, 0 1, 1 1
                   {{0, 0}, {1, 0}, {0, 1}, {1, 1}},
                   {{0, 0}, {1, 0}, {0, 1}, {1, 1}},
                   {{0, 0}, {1, 0}, {0, 1}, {1, 1}}},
                   {{{-1, 0}, {0, 0}, {0, 1}, {1, 1}},  // S piece -1 0, 0 0, 0 1, 1 1
                   {{0, 1}, {0, 0}, {1, 0}, {1, -1}},
                   {{-1, -1}, {0, -1}, {0, 0}, {1, 0}},
                   {{-1, 1}, {-1, 0}, {0, 0}, {0, -1}}},
                   {{{-1, 0}, {0, 0}, {0, 1}, {1, 0}},  // T piece -1 0, 0 0, 0 1, 1 0
                   {{0, 1}, {0, 0}, {0, -1}, {1, 0}},
                   {{-1, 0}, {0, 0}, {1, 0}, {0, -1}},
                   {{0, 1}, {0, 0}, {0, -1}, {-1, 0}}},
                   {{{-1, 1}, {0, 1}, {0, 0}, {1, 0}}, //  Z piece -1 1, 0 1, 0 0, 1 0
                   {{1, 1}, {1, 0}, {0, 0}, {0, -1}},
                   {{-1, 0}, {0, 0}, {0, -1}, {1, -1}},
                   {{0, 1}, {0, 0}, {-1, 0}, {-1, -1}}}};
  int [] colors = {#00FFFF, #0000FF, #FFAA00, #FFFF00, #00FF00, #800080, #FF0000};
  int curr;
  int rot = 0;
  Tile[] tiles;
  public Block(Board parent, int type) {
    this.parent = parent;
    curr = type;
    tiles = new Tile[locs[curr][rot].length];
    for (int i = 0; i < locs[curr][rot].length; i++) {
      tiles[i] = new Tile(parent, this, colors[curr]);
    }
  }
  public Block(Board parent, int type, int rawX, int rawY){
    this(parent, type);
    for(Tile t : tiles){
      t.onBoard = false;
    }
    boardDoesRendering = false;
    rawXPos = rawX;
    rawYPos = rawY;
    boardXPos = -10;
    boardYPos = -10;
  }
  void updateTilePos() {
    if(!boardDoesRendering){ // tiles shouldnt be rendered by board
      return;
    }
    for (int i = 0; i < locs[curr][rot].length; i++) {
      //System.out.println("Updating tile " + i + " to (" + (boardXPos + locs[i][0]) + ", " + (boardYPos + locs[i][1]) + ")");
      tiles[i].updateBoardPos(boardXPos + locs[curr][rot][i][0], boardYPos + locs[curr][rot][i][1]);
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
    for(int i = 0; i < tiles.length; i++){
      tiles[i].render(rawXPos + TILE_SIZE * locs[curr][rot][i][0], rawYPos - TILE_SIZE * locs[curr][rot][i][1]);
    }
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
  int hardDrop(){
    int rows = 0;
    while(doGravity()){rows++;};
    return rows;
  }
  // returns p3 = p1 - p2, where all points are 2d arrays
  int[] coordSubtract(int[] a, int[] b){
    int[] o = new int[2];
    o[0] = a[0] - b[0];
    o[1] = a[1] - b[1];
    return o;
  }
  void rotateBlock(boolean clockwise){
    int newRot = (clockwise ? (rot + 1) % 4 : (rot + 3) % 4); // +3 same as -1 but no negatives
    for(int i = 0; i < tiles.length; i++){
      if(!tiles[i].canMoveTo(coordSubtract(locs[curr][newRot][i],locs[curr][rot][i]))){
        return;
      }
    }
    rot = newRot;
    updateTilePos();
  }
}
