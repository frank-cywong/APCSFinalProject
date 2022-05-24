import java.util.HashSet;
public class Board {
  Block curBlock;
  int topLeftX = 0;
  int topLeftY = 0;
  int gravityRate = 30; // one down move every 30 frames
  int gravityTickCounter = 0;
  static final int gameplayXOffset = 40;
  static final int gameplayYOffset = 40;
  static final int statZoneWidth = 160;
  static final int fixBlockDelay = 30; // .5s delay for you to move the block after it hits
  int fixBlockTickCounter = -1; // -1: block fix timer not running
  int boardWidth = 10;
  int boardHeight = 20;
  int[] controls = new int[CONTROLS_COUNT];
  Tile[][] tiles;
  public Board() {
    generateNewBlock();
    tiles = new Tile[boardHeight + 5][boardWidth]; // 0th row is bottom etc. 5 hidden rows to allow for drop
    // default controls, A for left, D for right, Q for CCW, E for CW, Z for hard drop, X for soft drop, C for hold
    controls = new int[] {(int)'A', (int)'D', (int)'Q', (int)'E', (int)'Z', (int)'X', (int)'C'};
  }
  void render() {
    // for now temp, just draw the block
    noStroke();
    fill(#404040);
    rect(topLeftX, topLeftY, gameplayXOffset * 2 + boardWidth * TILE_SIZE + statZoneWidth, gameplayYOffset * 2 + boardHeight * TILE_SIZE);
    fill(0);
    rect(topLeftX + gameplayXOffset, topLeftY + gameplayYOffset, boardWidth * TILE_SIZE, boardHeight * TILE_SIZE);
    curBlock.render();
    for(int i = 0; i < boardWidth; i++){
      for(int j = 0; j < boardHeight; j++){
        if(tiles[j][i] == null){
          continue;
        }
        int[] coords = boardCoordsToCoords(i, j);
        tiles[j][i].render(coords[0], coords[1]);
      }
    }
    // process gravity
    gravityTickCounter++;
    if(gravityTickCounter >= gravityRate){
      gravityTickCounter = 0;
      boolean gravitySuccessful = curBlock.doGravity();
      if(gravitySuccessful && fixBlockTickCounter >= 0){ // reset lock delay if moved by gravity successfully, note to self, make infinity resetting (ie. reset by any move) a config option in the future (SEE: https://tetris.fandom.com/wiki/Infinity)
        fixBlockTickCounter = -1;
      }
    }
    // process block locking
    if(fixBlockTickCounter >= 0){
      fixBlockTickCounter++;
      if(fixBlockTickCounter >= fixBlockDelay){
        fixBlockInPlace();
      }
    }
  }
  int[] boardCoordsToCoords(int col, int row) {
    return(new int[] {col * TILE_SIZE + topLeftX + gameplayXOffset, (boardHeight - row - 1) * TILE_SIZE + topLeftY + gameplayYOffset});
  }
  void startFixingBlockInPlace(){
    if(fixBlockTickCounter == -1){
      fixBlockTickCounter = 0;
    }
  }
  void fixBlockInPlace(){ // "deletes" this block and locks the tiles on the board after a delay
    if(curBlock.doGravity()){ // sanity check
      fixBlockTickCounter = 0;
      return;
    }
    HashSet<Integer> rowsToCheck = new HashSet<Integer>();
    for(Tile t : curBlock.tiles){
      rowsToCheck.add(t.getBoardYPos());
    }
    int[] a = new int[rowsToCheck.size()];
    int index = 0;
    for(int row : rowsToCheck){
      a[index] = row;
      index++;
    }
    tryClearRows(a);
    fixBlockTickCounter = -1;
    for(Tile t : curBlock.tiles){
      t.parentBlock = null;
    }
    curBlock.tiles = null;
    curBlock = null;
    generateNewBlock();
  }
  void tryClearRows(int[] rows){
    //System.out.println(Arrays.toString(rows));
    rows = sort(rows);
    ArrayList<Integer> rowsToClear = new ArrayList<Integer>();
    for(int row : rows){
      boolean fullRow = true;
      for(int col = 0; col < boardWidth; col++){
        if(tiles[row][col] == null){
          fullRow = false;
          break;
        }
      }
      if(fullRow){
        rowsToClear.add(row);
      }
    }
    if(rowsToClear.size() == 0){
      return;
    }
    //System.out.println(rowsToClear);
    int[] rowsClearedBelow = new int[boardHeight + 5]; // ie. move this row down by x amount
    int moveDownBy = 0;
    int curRowCheck = 0;
    for(int i = 0; i < boardHeight + 5; i++){
     if(curRowCheck < rowsToClear.size() && rowsToClear.get(curRowCheck) == i){
       moveDownBy++;
       curRowCheck++;
       rowsClearedBelow[i] = -1; // ie. cleared
       continue;
     }
     rowsClearedBelow[i] = moveDownBy;
    }
    for(int row = 0; row < boardHeight + 5; row++){
      moveDownBy = rowsClearedBelow[row];
      if(moveDownBy == -1){
        for(int col = 0; col < boardWidth; col++){
          tiles[row][col] = null;
        }
        continue;
      }
      if(moveDownBy == 0){
        continue;
      }
      //System.out.println("For row: " + row + ", moveDownBy=" + moveDownBy);
      for(int col = 0; col < boardWidth; col++){
        tiles[row - moveDownBy][col] = tiles[row][col];
        if(tiles[row][col] != null){
          //System.out.println("SENDING TILE AT " + col + ", " + row + " DOWN BY " + moveDownBy);
          tiles[row][col].updateBoardPos(col, row - moveDownBy);
        }
        tiles[row][col] = null;
      }
    }
  }
  void generateNewBlock(){ // generates new block, currently just filler
    curBlock = new Block(this,Block.I_PIECE);
  }
  void onKeyPressed(int keyCode){
    // temp controls:
    if(keyCode == UP){
      gravityRate /= 2;
      if(gravityRate < 1){
        gravityRate = 1;
      }
      return;
    }
    if(keyCode == DOWN){
      gravityRate *= 2;
      return;
    }
    if(keyCode == controls[MOVE_LEFT]){
      curBlock.tryMoveLeft();
      return;
    }
    if(keyCode == controls[MOVE_RIGHT]){
      curBlock.tryMoveRight();
      return;
    }
    if(keyCode == controls[ROTATE_CCW]){
      curBlock.rotateBlock(false);
      return;
    }
    if(keyCode == controls[ROTATE_CW]){
      curBlock.rotateBlock(true);
      return;
    }
    if(keyCode == controls[HARD_DROP]){
      curBlock.hardDrop();
      return;
    }
  }
}
