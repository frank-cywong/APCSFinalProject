public class Block {
  int boardXPos = BLOCK_START_X_POS;
  int boardYPos = BLOCK_START_Y_POS;
  Board parent;
  Block ghostBlock;
  boolean canMove = true;
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
  String lastMove = "";
  static final String LAST_MOVE_GRAVITY = "LASTMOVEGRAVITY";
  static final String LAST_MOVE_LEFT = "LASTMOVELEFT";
  static final String LAST_MOVE_RIGHT = "LASTMOVERIGHT";
  static final String LAST_MOVE_ROTATE = "LASTMOVEROT"; // format LASTMOVEROT[rotIndex]KICK[wallkick]
  // Indexes: [i][X,Y]
  final int[][] T_PIECE_CORNER_LOCS = {{-1, 1}, {1, 1}, {1, -1}, {-1, -1}};
  // Indexes: [ROT][is i-th corner FRONT/BACK]
  /* - CORNER ORDER
  0x1
  xxx
  3x2
  */
  final boolean[][] T_PIECE_ROT_INFRONT = {{true, true, false, false}, {false, true, true, false}, {false, false, true, true}, {true, false, false, true}};
  // Indexes: [PIECE][ROT][TILE][X,Y]
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
  // Index: [PIECE] (I -> type 1, O -> type 2, else: type 0)
  int[] wallKickPieceTypes = {1, 0, 0, 2, 0, 0, 0};
  // Indexes: [PIECE_TYPE][ROT_TRANS][index][X,Y] - NOTE: index length may be 1 or 5, where ROT_TRANS is ORIG_STATE << 1 | (CLOCKWISE ? 0 : 1) (eg. 0 -> 1 would be ROT_STATE 0, 1 -> 0 would be ROT_STATE 3) 
  int [][][][] wallKickOffsets = {{{{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, 2}},  // Everything else - 0 -> 1
                  {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, // 0 -> 3
                  {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, // 1 -> 2
                  {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, // 1 -> 0
                  {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, // 2 -> 3
                  {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, // 2 -> 1
                  {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, // 3 -> 0
                  {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}}, // 3 -> 2
                  {{{0, 0}, {-2, 0}, {1, 0}, {-2, -1}, {1, 2}}, // I type - 0 -> 1
                  {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}}, // 0 -> 3
                  {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}}, // 1 -> 2
                  {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}}, // 1 -> 0
                  {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}}, // 2 -> 3
                  {{0, 0}, {1, 0}, {-2, 0}, {1, -2}, {-2, 1}}, // 2 -> 1
                  {{0, 0}, {1, 0}, {-2, 0}, {1, -2}, {-2, 1}}, // 3 -> 0
                  {{0, 0}, {-2, 0}, {1, 0}, {-2, -1}, {1, 2}}}, // 3 -> 2
                  {{{0, 0}}, {{0, 0}}, {{0, 0}}, {{0, 0}}, {{0, 0}}, {{0, 0}}, {{0, 0}}, {{0, 0}}}}; // O type, every rot trans is 0, 0 
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
  void updateTilePos(){
    updateTilePos(false);
  }
  void updateTilePos(boolean noOverRender) {
    if(!boardDoesRendering){ // tiles shouldnt be rendered by board
      return;
    }
    for (int i = 0; i < locs[curr][rot].length; i++) {
      //System.out.println("Updating tile " + i + " to (" + (boardXPos + locs[i][0]) + ", " + (boardYPos + locs[i][1]) + ")");
      tiles[i].updateBoardPos(boardXPos + locs[curr][rot][i][0], boardYPos + locs[curr][rot][i][1], noOverRender);
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
    lastMove = LAST_MOVE_GRAVITY;
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
  int checkTSpinStatus(){
    if(curr != T_PIECE){ // can't t-spin if its not a t piece
      return TSPIN_NONE;
    }
    //System.out.println("LASTMOVE: " + lastMove);
    if(!lastMove.substring(0, LAST_MOVE_ROTATE.length()).equals(LAST_MOVE_ROTATE)){ // last move must be a rotation
      return TSPIN_NONE;
    }
    int frontMinoCount = 0;
    int backMinoCount = 0;
    for(int i = 0; i < T_PIECE_CORNER_LOCS.length; i++){
      int checkX = boardXPos + T_PIECE_CORNER_LOCS[i][0];
      int checkY = boardYPos + T_PIECE_CORNER_LOCS[i][1];
      if(checkX >= 0 && checkY >= 0 && checkY < parent.tiles.length && checkX < parent.tiles[0].length){
        if(parent.tiles[checkY][checkX] != null){
          if(T_PIECE_ROT_INFRONT[rot][i]){
            frontMinoCount++;
          } else {
            backMinoCount++;
          }
        }
      } else { // if hit wall, must be back
        backMinoCount++;
      }
    }
    //System.out.println("FRONT COUNT: " + frontMinoCount);
    //System.out.println("BACK COUNT: " + backMinoCount);
    if(frontMinoCount == 2 && backMinoCount >= 1){
      return TSPIN_FULL;
    }
    if(frontMinoCount == 1 && backMinoCount == 2){
      if(lastMove.charAt(lastMove.length() - 1) == '4'){ // if last wallkick type
        return TSPIN_FULL;
      }
      return TSPIN_MINI;
    }
    return TSPIN_NONE;
  }
  void createGhostBlock(){
    ghostBlock = new Block(parent, curr);
    for(Tile t : ghostBlock.tiles){
      t.parentBlock = this; // to prevent collisions
      t.updateTexture(parent.parent.parent.ghostTexture);
    }
    ghostBlock.updateTilePos();
    updateGhostBlock();
  }
  void updateGhostBlock(){
    if(ghostBlock == null){
      return;
    }
    ghostBlock.boardXPos = boardXPos;
    ghostBlock.boardYPos = boardYPos;
    ghostBlock.rot = rot;
    ghostBlock.updateTilePos(true);
    int moveDown = -1;
    while(true){
      boolean failure = false;
      for(Tile t: ghostBlock.tiles){
        if(!t.canMoveTo(0, moveDown)){
          failure = true;
        }
      }
      if(failure){
        moveDown++;
        break;
      }
      moveDown--;
    }
    ghostBlock.boardYPos += moveDown;
    ghostBlock.updateTilePos();
  }
  void deleteGhostBlock(boolean replaceWithMain){
    if(ghostBlock == null){
      return;
    }
    for(int i = 0; i < ghostBlock.tiles.length; i++){
      Tile t = ghostBlock.tiles[i];
      if(parent.tiles[t.getBoardYPos()][t.getBoardXPos()] == t){
        parent.tiles[t.getBoardYPos()][t.getBoardXPos()] = (replaceWithMain ? tiles[i] : null);
      }
      ghostBlock.tiles[i] = null;
    }
    ghostBlock = null;
  }
  boolean tryMoveLeft(){
    if(!this.canMove) return false;
    for(Tile t : tiles){
      if(!t.canMoveTo(-1,0)){
        return false;
      }
    }
    Game.move.play();
    boardXPos--;
    updateGhostBlock();
    updateTilePos();
    lastMove = LAST_MOVE_LEFT;
    return true;
  }
  boolean tryMoveRight(){
    if(!this.canMove) return false;
    for(Tile t : tiles){
      if(!t.canMoveTo(1,0)){
        return false;
      }
    }
    Game.move.play();
    boardXPos++;
    updateGhostBlock();
    updateTilePos();
    lastMove = LAST_MOVE_RIGHT;
    return true;
  }
  int hardDrop(){
    int rows = 0;
    while(doGravity()){
      if(rows==0){
        Game.hardDrop.play();
      }
      rows++;
    }
    return rows;
  }
  // returns p3 = p1 + p2, where all points are 2d arrays
  int[] coordAdd(int[] a, int[] b){
    int[] o = new int[2];
    o[0] = a[0] + b[0];
    o[1] = a[1] + b[1];
    return o;
  }
  // returns p3 = p1 - p2, where all points are 2d arrays
  int[] coordSubtract(int[] a, int[] b){
    int[] o = new int[2];
    o[0] = a[0] - b[0];
    o[1] = a[1] - b[1];
    return o;
  }
  void rotateBlock(boolean clockwise){
    if(!this.canMove) return;
    int newRot = (clockwise ? (rot + 1) % 4 : (rot + 3) % 4); // +3 same as -1 but no negatives
    int rotIndex = (rot << 1) | (clockwise ? 0 : 1);
    int wallKickType = wallKickPieceTypes[curr];
    int workingWallKick = -1;
    for(int i = 0; i < wallKickOffsets[wallKickType][rotIndex].length; i++){
      boolean success = true;
      for(int j = 0; j < tiles.length; j++){
        if(!tiles[j].canMoveTo(coordAdd(coordSubtract(locs[curr][newRot][j],locs[curr][rot][j]), wallKickOffsets[wallKickType][rotIndex][i]))){
          success = false;
          break;
        }
      }
      if(success){
        workingWallKick = i;
        break;
      }
    }
    if(workingWallKick == -1){
      return;
    }
    rot = newRot;
    boardXPos += wallKickOffsets[wallKickType][rotIndex][workingWallKick][0];
    boardYPos += wallKickOffsets[wallKickType][rotIndex][workingWallKick][1];
    lastMove = LAST_MOVE_ROTATE+rotIndex+"W"+workingWallKick;
    updateGhostBlock();
    updateTilePos();
    Game.rotate.play();
  }
}
