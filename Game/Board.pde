import java.util.HashSet;
import java.util.Queue;
import java.util.ArrayDeque;
import java.util.Collections;
public class Board {
  Block curBlock;
  Block nextBlockIcon;
  int topLeftX = 0;
  int topLeftY = 0;
  int startGravityRate = 30; // for start new game with same settings
  int originalGravityRate = 30; // For soft drop use
  int gravityRate = 30; // one down move every 30 frames
  int gravityTickCounter = 0;
  int startDeltaG = 600; // for start new game with same settings
  int deltaG = 600; // change gravity every x ticks, if -1, never
  int deltaGTickCounter = 0;
  int deltaDeltaG = 40;
  int gravityLimit = 1; // do not decrease gravity below this limit
  int DASTickCounter = 0;
  int DASKeyPressed = 0;
  boolean DASKeyRepeated = false; // has the das key pressed entered the "key repeat" stage
  float levelScoreMultiplier = 1;
  final int[] scoresByLineCount = new int[]{100, 300, 600, 800};
  int score = 0;
  static final int scorePerHardDropLine = 2;
  boolean stopped = false;
  static final int gameplayXOffset = 40;
  static final int gameplayYOffset = 40;
  static final int statZoneWidth = 240;
  int fixBlockDelay = 30; // .5s delay for you to move the block after it hits
  int fixBlockTickCounter = -1; // -1: block fix timer not running
  int boardWidth = 10;
  int boardHeight = 20;
  int[] controls = new int[CONTROLS_COUNT];
  boolean heldBlockEnabled = true;
  boolean heldBlockUsed = false; // true if hold block has been used alr and can't be used again until the cur block is locked in place
  Block heldBlock = null;
  Tile[][] tiles;
  Queue<Integer> upcomingBlocks = new ArrayDeque<Integer>();
  Screen parent;
  boolean isSoftDropping = false;
  int highScore = 0;
  public Board(Screen parent, int topLeftX, int topLeftY) {
    this.parent = parent;
    this.topLeftX = topLeftX;
    this.topLeftY = topLeftY;
    generateNewBlock();
    tiles = new Tile[boardHeight + 5][boardWidth]; // 0th row is bottom etc. 5 hidden rows to allow for drop
    // default controls, A for left, D for right, Q for CCW, E for CW, Z for hard drop, X for soft drop, C for hold
    // default for 2nd player: left arrow for left, right arrow for right, ctrl for CCW, up for CW, space for hard drop, down for soft drop, shift for hold
    controls = new int[] {(int)'A', (int)'D', (int)'Q', (int)'E', (int)'Z', (int)'X', (int)'C'};
    String tempHighScore = parent.parent.loadConfig(HIGHSCORE_DATA_CONFIG);
    highScore = (tempHighScore == null ? 0 : Integer.parseInt(tempHighScore));
  }
  void render() {
    if(stopped){
      return;
    }
    // for now temp, just draw the block
    DASProcess();
    stroke(100);
    fill(#404040);
    rect(topLeftX, topLeftY, gameplayXOffset * 2 + boardWidth * TILE_SIZE + statZoneWidth, gameplayYOffset * 2 + boardHeight * TILE_SIZE);
    fill(0);
    for (int x = topLeftX+gameplayXOffset;x<topLeftX+gameplayXOffset+boardWidth * TILE_SIZE;x+=TILE_SIZE){
      for (int y = topLeftY+gameplayYOffset;y<topLeftY+gameplayYOffset+boardHeight * TILE_SIZE;y+=TILE_SIZE){
        fill(0);
        stroke(100);
        rect(x, y, TILE_SIZE, TILE_SIZE);
      }   
    }
    //rect(topLeftX + gameplayXOffset, topLeftY + gameplayYOffset, boardWidth * TILE_SIZE, boardHeight * TILE_SIZE);
    noStroke();
    fill(255);
    textSize(24);
    textAlign(LEFT, TOP);
    text("Next Block:", topLeftX + gameplayXOffset * 2 + boardWidth * TILE_SIZE, topLeftY + gameplayYOffset);
    text("Score: " + score, topLeftX + gameplayXOffset * 2 + boardWidth * TILE_SIZE, topLeftY + gameplayYOffset + (heldBlockEnabled ? 240 : 120));
    text("High Score: " + highScore, topLeftX + gameplayXOffset * 2 + boardWidth * TILE_SIZE, topLeftY + gameplayYOffset + (heldBlockEnabled ? 300 : 180));
    if(heldBlockEnabled){
      text("Held Block:", topLeftX + gameplayXOffset * 2 + boardWidth * TILE_SIZE, topLeftY + gameplayYOffset + 120);
      if(heldBlock != null){
        heldBlock.render();
      }
    }
    nextBlockIcon.render();
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
    // process change in gravity
    if(deltaG > 0 && originalGravityRate > gravityLimit){
      deltaGTickCounter++;
      if(deltaGTickCounter >= deltaG){
        deltaGTickCounter = 0;
        deltaG += deltaDeltaG;
        originalGravityRate--;
        if(!isSoftDropping){
          gravityRate--;
        }
      }
    }
    // process gravity
    gravityTickCounter++;
    if(gravityTickCounter >= gravityRate){
      gravityTickCounter = 0;
      boolean gravitySuccessful = curBlock.doGravity();
      if(gravitySuccessful && isSoftDropping){
        score += 1;
      }
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
  void endGame(){
    parent.stopAllBoards();
    boolean newHighScore = score > highScore;
    if(newHighScore){
      highScore = score;
      parent.parent.setConfig(HIGHSCORE_DATA_CONFIG, Integer.toString(highScore));
    }
    parent.parent.changeScreen(SCREENTYPE_END, (new Object[]{score, newHighScore, parent}));
  }
  void fixBlockInPlace(){ // "deletes" this block and locks the tiles on the board after a delay
    if(curBlock.doGravity()){ // sanity check
      fixBlockTickCounter = 0;
      return;
    }
    if(heldBlockUsed){
      heldBlockUsed = false;
    }
    HashSet<Integer> rowsToCheck = new HashSet<Integer>();
    boolean inGameplayBounds = false;
    for(Tile t : curBlock.tiles){
      if(t.getBoardYPos() < boardHeight){
        inGameplayBounds = true;
      }
      rowsToCheck.add(t.getBoardYPos());
    }
    if(!inGameplayBounds){ // if block is entirely out of bounds
      endGame();
      return;
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
    score += levelScoreMultiplier * scoresByLineCount[rowsToClear.size() - 1];
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
  void generateNewBlock(){ // generates new block
    if(upcomingBlocks.size() <= 1){ // make new blocks first
      ArrayList<Integer> toAdd = new ArrayList<Integer>(Block.BLOCK_TYPE_COUNT);
      for(int i = 0; i < Block.BLOCK_TYPE_COUNT; i++){
        toAdd.add(i);
      }
      Collections.shuffle(toAdd);
      for(int blockType : toAdd){
        upcomingBlocks.add(blockType);
      }
    }
    curBlock = new Block(this,upcomingBlocks.remove());
    nextBlockIcon = new Block(this, upcomingBlocks.peek(), topLeftX + gameplayXOffset * 2 + (boardWidth + 1) * TILE_SIZE, topLeftY + gameplayYOffset + TILE_SIZE + 40);
    //System.out.println(nextBlockIcon.rawXPos);
    //System.out.println(topLeftX);
  }
  void tryHoldBlock(){
    if(!heldBlockEnabled || heldBlockUsed){ // can't hold block
      return;
    }
    heldBlockUsed = true;
    Block temp = heldBlock;
    heldBlock = curBlock;
    curBlock = temp;
    heldBlock.boardDoesRendering = false;
    for (int i = 0; i < heldBlock.locs[heldBlock.curr][heldBlock.rot].length; i++) {
      //System.out.println("Updating tile " + i + " to (" + (boardXPos + locs[i][0]) + ", " + (boardYPos + locs[i][1]) + ")");
      Tile t = heldBlock.tiles[i];
      if(tiles[t.boardYPos][t.boardXPos] == t){
        tiles[t.boardYPos][t.boardXPos] = null;
      }
      t.onBoard = false;
    }
    heldBlock.rot = 0;
    heldBlock.boardXPos = BLOCK_START_X_POS;
    heldBlock.boardYPos = BLOCK_START_Y_POS;
    heldBlock.rawXPos = topLeftX + gameplayXOffset * 2 + (boardWidth + 1) * TILE_SIZE;
    heldBlock.rawYPos = topLeftY + gameplayYOffset + TILE_SIZE + 160;
    if(curBlock == null){
      generateNewBlock();
    } else {
      curBlock.boardDoesRendering = true;
      for(Tile t : curBlock.tiles){
        t.onBoard = true;
      }
      curBlock.updateTilePos();
    }
  }
  void DASKeyPress(int DASKey){
    if(DASKey != DASKeyPressed){ // ignore OS autorepeating
      DASKeyRepeated = false;
      if(DASMoveBlock(DASKey)){
        DASKeyPressed = DASKey;
      } else {
        DASKey = DAS_NO_KEY_PRESSED; // if failed to move, ignore
      }
    }
  }
  void DASKeyRelease(int DASKey){
    if(DASKeyPressed == DASKey){
      DASKeyPressed = DAS_NO_KEY_PRESSED;
      DASTickCounter = 0;
      DASKeyRepeated = false;
    }
  }
  void DASProcess(){
    if(DASKeyPressed == DAS_NO_KEY_PRESSED){ // sanity check for key releasing
      DASTickCounter = 0;
      DASKeyRepeated = false;
      return;
    }
    DASTickCounter++;
    if(DASKeyRepeated){
      if(DASTickCounter >= DAS_KEY_REPEAT_FREQUENCY){
        DASTickCounter = 0;
        if(!DASMoveBlock(DASKeyPressed)){
          DASKeyPressed = DAS_NO_KEY_PRESSED; // if failed to move, ignore
        }
      }
    } else { // need DAS_KEY_REPEAT_DELAY until autorepeat kicks in
      if(DASTickCounter >= DAS_KEY_REPEAT_DELAY){
        DASKeyRepeated = true;
        DASTickCounter = 0;
        if(!DASMoveBlock(DASKeyPressed)){
          DASKeyPressed = DAS_NO_KEY_PRESSED; // if failed to move, ignore
        }
      }
    }
  }
  // Tries to move corresponding block and returns if move was successful
  boolean DASMoveBlock(int DASKey){
    if(curBlock == null){ // sanity check
      return false;
    }
    switch(DASKey){
      case DAS_MOVE_LEFT:
        return curBlock.tryMoveLeft();
      case DAS_MOVE_RIGHT:
        return curBlock.tryMoveRight();
    }
    return false;
  }
  void onKeyPressed(int keyCode){
    // temp controls:
    /* REMOVED
    if(keyCode == UP){
      originalGravityRate /= 2;
      if(originalGravityRate < 1){
        originalGravityRate = 1;
      }
      return;
    }
    if(keyCode == DOWN){
      originalGravityRate *= 2;
      return;
    }
    */
    if(keyCode == controls[MOVE_LEFT]){
      DASKeyPress(DAS_MOVE_LEFT);
      //curBlock.tryMoveLeft();
      return;
    }
    if(keyCode == controls[MOVE_RIGHT]){
      DASKeyPress(DAS_MOVE_RIGHT);
      //curBlock.tryMoveRight();
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
    if(keyCode == controls[SOFT_DROP]){
      if(!isSoftDropping){
        isSoftDropping = true;
        gravityRate = originalGravityRate / 10;
      }
    }
    if(keyCode == controls[HARD_DROP]){
      score += scorePerHardDropLine * curBlock.hardDrop();
      return;
    }
    if(keyCode == controls[HOLD_PIECE]){
      tryHoldBlock();
      return;
    }
    if(keyCode == ESC){
      parent.stopAllBoards();
      parent.parent.changeScreen(SCREENTYPE_PAUSE, new Object[]{parent}); // pass screen itself as argument
    }
  }
  void onKeyReleased(int keyCode){
    if(keyCode == controls[MOVE_LEFT]){
      DASKeyRelease(DAS_MOVE_LEFT);
      return;
    }
    if(keyCode == controls[MOVE_RIGHT]){
      DASKeyRelease(DAS_MOVE_RIGHT);
      return;
    }
    if(keyCode == controls[SOFT_DROP]){
      if(isSoftDropping){
        isSoftDropping = false;
        gravityRate = originalGravityRate;
      }
      return;
    }
  }
}
