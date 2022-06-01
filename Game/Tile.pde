public class Tile {
  int c = #0000FF;
  Board parent;
  Block parentBlock = null; // no collision between tiles in the same block
  boolean onBoard = true;
  private int boardXPos;
  private int boardYPos;
  PImage displayImage;
  public Tile(Board parent) {
    this.parent = parent;
  }
  public Tile(Board parent, Block parentBlock, int c){
    this.parent = parent;
    this.parentBlock = parentBlock;
    this.c = c;
    updateTexture();
  }
  public void render(int xcor, int ycor) {
    //stroke(100);
    //fill(c);
    //rect(xcor, ycor, TILE_SIZE, TILE_SIZE);
    image(displayImage, xcor, ycor, TILE_SIZE, TILE_SIZE);
  }
  int scaleColor(int c, byte scalar){
    double scalar_d = (double)((int)scalar & 0xFF) / 0xFF;
    int output = 0;
    output += (int)((c & 0xFF) * scalar_d);
    output += ((int)(((c >> 8) & 0xFF) * scalar_d)) << 8;
    output += ((int)(((c >> 16) & 0xFF) * scalar_d)) << 16;
    return output;
  }
  void updateTexture(){
    updateTexture(parent.parent.parent.tileTexture);
  }
  void updateTexture(byte[] texture){
    displayImage = createImage(TILE_SIZE, TILE_SIZE, RGB);
    displayImage.loadPixels();
    for(int i = 0; i < 1024; i++){
      displayImage.pixels[i] = scaleColor(c, texture[i]);
    }
    displayImage.updatePixels();
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
