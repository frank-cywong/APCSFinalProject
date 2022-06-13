public class EvilTetris implements Mod {
  Board parent;
  public void onModMount(Board board){
    this.parent = board;
  }
  public Tile[][] copyTiles(Tile[][] tileArray){ // copies tilearray
    Tile[][] output = new Tile[tileArray.length][];
    for(int i = 0; i < tileArray.length; i++){
      output[i] = new Tile[tileArray[i].length];
      for(int j = 0; j < tileArray[i].length; j++){
        output[i][j] = tileArray[i][j];
      }
    }
    return output;
  }
  public ArrayList<Integer> generateNewBlock(Tile[][] curState, boolean immediate){
    //System.out.println("test1");
    if(!immediate){ // evil tetris can only handle immediate next block
      return null;
    }
    //System.out.println("test2");
    ArrayList<Integer> returnObj = new ArrayList<Integer>();
    Board testBoard = new Board(parent.parent, 0, 0, null, true);
    int worstBlock = -1;
    int bestWorstBlockHeight = 0;
    for(int i = 0; i < Block.BLOCK_TYPE_COUNT; i++){ // for every block type, find worst case, excluding twists for now
      int bestPossibleHeight = 40;
      for(int j = 0; j < parent.boardWidth; j++){ // for every x pos
        for(int k = 0; k < 4; k++){ // for every rotational state
          testBoard.tiles = copyTiles(curState);
          testBoard.curBlock = new Block(testBoard, i);
          testBoard.curBlock.boardXPos = j;
          testBoard.curBlock.rot = k;
          boolean invalidPlacement = false;
          for(int l = 0; l < testBoard.curBlock.tiles.length; l++){ // in bounds check
            int curTileXPos = testBoard.curBlock.boardXPos + testBoard.curBlock.locs[testBoard.curBlock.curr][testBoard.curBlock.rot][l][0];
            if(curTileXPos < 0 || curTileXPos >= parent.boardWidth){
              //System.out.println("Skipping invalid placement ("+i+", "+j+", "+k+")");
              invalidPlacement = true;
              break;
            }
          }
          if(invalidPlacement){
            continue;
          }
          testBoard.curBlock.updateTilePos();
          //System.out.println(Arrays.deepToString(testBoard.tiles));
          testBoard.curBlock.hardDrop();
          int curHeight = 0;
          for(int row = 0; row <= bestPossibleHeight; row++){
            boolean hasTileInRow = false;
            boolean hasSpaceInRow = false;
            for(int xPos = 0; xPos < parent.boardWidth; xPos++){
              if(testBoard.tiles[row][xPos] != null){
                hasTileInRow = true;
              } else {
                hasSpaceInRow = true;
              }
            }
            if(hasTileInRow && hasSpaceInRow){
              curHeight++;
            }
            if(!hasTileInRow){ // empty row, height is this - 1
              if(curHeight < bestPossibleHeight){
                bestPossibleHeight = curHeight;
              }
              break;
            }
          }
        }
      }
      //System.out.println("Computerd best possible height for block type " + i + " is: " + bestPossibleHeight);
      if(bestPossibleHeight > bestWorstBlockHeight){
        bestWorstBlockHeight = bestPossibleHeight;
        worstBlock = i;
        //System.out.println("Set worst block to: " + i);
      }
    }
    returnObj.add(worstBlock);
    return returnObj;
  }
  public String returnDisplayName(){
    return "Evil Tetris";
  }
}
