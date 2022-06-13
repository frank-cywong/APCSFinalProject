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
    System.out.println("test1");
    if(!immediate){ // evil tetris can only handle immediate next block
      return null;
    }
    System.out.println("test2");
    ArrayList<Integer> returnObj = new ArrayList<Integer>();
    Board testBoard = new Board(parent.parent, 0, 0, null, true);
    for(int i = 0; i < Block.BLOCK_TYPE_COUNT; i++){ // for every block type, find worst case, excluding twists for now
      for(int j = 0; j < parent.boardWidth; j++){
        testBoard.tiles = copyTiles(curState);
        testBoard.curBlock = new Block(testBoard, i);
        testBoard.curBlock.boardXPos = j;
      }
    }
    return returnObj;
  }
  public String returnDisplayName(){
    return "Evil Tetris";
  }
}
