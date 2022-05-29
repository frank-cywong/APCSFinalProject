public class Screen {
  boolean hasBoards = true;
  String screentype;
  Board[] boards;
  Game parent;
  Object[] args = null;
  int timer = 0;
  public Screen(String screentype, Game parent) {
    this(screentype, parent, null);
  }
  public Screen(String screentype, Game parent, Object[] args){
    this.screentype = screentype;
    this.parent = parent;
    this.args = args;
    hasBoards = (screentype == SCREENTYPE_GAME);
    boards = new Board[1];
    boards[0] = new Board(this);
    updateBoardControls();
    switch(screentype){
      case SCREENTYPE_END: // arg format: [score, isThisANewHighScore]
        timer = 3600;
        noStroke();
        fill(0x88000000);
        rect(0, 0, width, height);
        if(args == null){
          this.args = (Object[])(new Object[] {0, false});
        }
      break;
      case SCREENTYPE_PAUSE: // arg format: old screen
        noStroke();
        fill(0x88000000);
        rect(0, 0, width, height);
        if(args == null){
          throw new IllegalArgumentException("Pause screen must have old game screen passed into it as argument");
        }
      break;
    }
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
        String scoreText = "Score: " + args[0];
        if((Boolean)args[1]){
          if(timer > 0){
            timer--;
          }
          if(timer % 240 >= 120){ // every 2 seconds
            scoreText = "NEW HIGH SCORE!";
          }
        }
        noStroke();
        fill(0xFF606060);
        rect(width / 2 - 150, height / 2 - 150, 300, 300);
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(48);
        text("Game Over!", width / 2, height / 2 - 100);
        textSize(32);
        text(scoreText, width / 2, height / 2 - 30);
        fill(#CC4449);
        rect(width / 2 - 120, height / 2 + 20, 240, 100);
        fill(255);
        textSize(24);
        text("Start New Game", width / 2, height / 2 + 70);
        break;
      case SCREENTYPE_PAUSE:
        noStroke();
        fill(0xFF606060);
        rect(width / 2 - 150, height / 2 - 105, 300, 210);
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(40);
        text("Game Paused", width / 2, height / 2 - 70);
        fill(#CC4449);
        rect(width / 2 - 135, height / 2 - 20, 270, 50);
        rect(width / 2 - 135, height / 2 + 40, 270, 50);
        fill(255);
        textSize(24);
        text("Resume Game", width / 2, height / 2 + 2);
        text("Return to Main Menu", width / 2, height / 2 + 62);
        break;
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
  void onKeyReleased(int keyCode){
    if (hasBoards){
      for (Board b : boards){
        b.onKeyReleased(keyCode);
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
        break;
      case SCREENTYPE_PAUSE:
        if(isInRange(mouseX, width / 2 - 135, width / 2 + 135) && isInRange(mouseY, height / 2 - 20, height / 2 + 30)){ // resume game button
          ((Screen)args[0]).startAllBoards();
          parent.changeScreen((Screen)args[0]);
        }
        if(isInRange(mouseX, width / 2 - 135, width / 2 + 135) && isInRange(mouseY, height / 2 + 40, height / 2 + 90)){ // return to main menu button
          parent.changeScreen(SCREENTYPE_MAINMENU);
        }
        break;
    }
  }
  void updateBoardControls(){
    if(!hasBoards){
      return;
    }
    Board b;
    for(int i = 0; i < boards.length; i++){
      b = boards[i];
      for(int j = 0; j < CONTROLS_COUNT; j++){
        String configOption = parent.loadConfig(CONTROLS_CONFIG_LABEL_MAPPING[j], i);
        if(configOption == null){ // config option doesn't exist, so set it
          int curConfig = b.controls[j];
          parent.setConfig(CONTROLS_CONFIG_LABEL_MAPPING[j], Character.isLetter((char)curConfig) ? "" + (char)(curConfig) : "" + curConfig , i);
          continue;
        }
        int configInt;
        if(configOption.length() == 1){ // directly interpret it as a key
          configInt = configOption.charAt(0);
        } else {
          try {
            configInt = Integer.parseInt(configOption);
          } catch (NumberFormatException e){ // invalid config option, ignore it
            continue;
          }
        }
        b.controls[j] = configInt;
      }
    }
  }
  void stopAllBoards(){
    for(Board b : boards){
      b.stopped = true;
    }
  }
  void startAllBoards(){
    for(Board b : boards){
      b.stopped = false;
    }
  }
}
