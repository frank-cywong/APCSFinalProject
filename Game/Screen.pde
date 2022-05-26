public class Screen {
  boolean hasBoards = true;
  String screentype;
  Board[] boards;
  Game parent;
  Object[] args = null;
  public Screen(String screentype, Game parent) {
    this.screentype = screentype;
    hasBoards = (screentype == SCREENTYPE_GAME);
    boards = new Board[1];
    boards[0] = new Board(this);
    this.parent = parent;
    switch(screentype){
      case SCREENTYPE_END: // arg format: [score]
        noStroke();
        fill(0x88000000);
        rect(0, 0, width, height);
        if(args == null){
          args = (Object[])(new Integer[] {0});
        }
    }
  }
  public Screen(String screentype, Game parent, Object[] args){
    this(screentype, parent);
    this.args = args;
  }
  void onDraw() {
    if (hasBoards) {
      for (Board b : boards) {
        b.render();
      }
      return;
    }
    switch(screentype){
      case SCREENTYPE_END:
        noStroke();
        fill(0xFF606060);
        rect(width / 2 - 150, height / 2 - 150, 300, 300);
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(48);
        text("Game Over!", width / 2, height / 2 - 100);
        textSize(32);
        text("Score: " + args[0], width / 2, height / 2 - 30);
        fill(#CC4449);
        rect(width / 2 - 120, height / 2 + 20, 240, 100);
        fill(255);
        textSize(24);
        text("Start New Game", width / 2, height / 2 + 70);
    }
  }
  void onKeyPressed(int keyCode){
    if (hasBoards){
      for (Board b : boards){
        b.onKeyPressed(keyCode);
      }
      return;
    }
  }
  // returns if x is in [a,b]
  boolean isInRange(int x, int a, int b){
    return(a <= x && x <= b);
  }
  void onMousePressed(int mouseX, int mouseY){
    switch(screentype){
      case SCREENTYPE_END:
        if(isInRange(mouseX, width / 2 - 120, width / 2 + 120) && isInRange(mouseY, height / 2 + 20, height / 2 + 120)){ // start new game button
          parent.changeScreen(SCREENTYPE_GAME);
        }
    }
  }
}
