public class Board {
  Block curBlock;
  int topLeftX = 0;
  int topLeftY = 0;
  final int gravityRate = 30; // one down move every 30 frames
  int gravityTickCounter = 0;
  static final int gameplayXOffset = 40;
  static final int gameplayYOffset = 40;
  static final int statZoneWidth = 160;
  int boardWidth = 10;
  int boardHeight = 20;
  Tile[][] tiles;
  public Board() {
    curBlock = new Block(this);
    tiles = new Tile[boardHeight + 5][boardWidth]; // 0th row is bottom etc. 5 hidden rows to allow for drop
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
      curBlock.doGravity();
    }
  }
  int[] boardCoordsToCoords(int col, int row) {
    return(new int[] {col * TILE_SIZE + topLeftX + gameplayXOffset, (boardHeight - row - 1) * TILE_SIZE + topLeftY + gameplayYOffset});
  }
}
