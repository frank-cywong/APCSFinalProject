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
      case SCREENTYPE_END: // arg format: [score, isThisANewHighScore, previous game screen if exists (if null, just use default settings)]
        timer = 3600;
        noStroke();
        fill(0x88000000);
        rect(0, 0, width, height);
        if(args == null){
          this.args = (Object[])(new Object[] {0, false, null});
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
      case SCREENTYPE_NEWGAME: // no arguments, but args used to store args for game as a temp storage ([gravity (in 1 tile / x frames), playercount, fix block delay])
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height); //  // entirely fill screen
        this.args = new Object[]{30, 1, 30};
        break;
      case SCREENTYPE_MAINMENU: // no arguments at all
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height); //  // entirely fill screen
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
        rect(width / 2 - 150, height / 2 - 190, 300, 380);
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(48);
        text("Game Over!", width / 2, height / 2 - 140);
        textSize(32);
        text(scoreText, width / 2, height / 2 - 70);
        fill(#CC4449);
        rect(width / 2 - 130, height / 2 - 20, 260, 80);
        fill(255);
        textSize(24);
        text("Start New Game\n(with same settings)", width / 2, height / 2 + 16);
        fill(#CC4449);
        rect(width / 2 - 130, height / 2 + 80, 260, 80);
        fill(255);
        text("Return to Main Menu", width / 2, height / 2 + 116);
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
      case SCREENTYPE_NEWGAME:
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height);
        textAlign(LEFT, CENTER);
        fill(255);
        textSize(24);
        text("Player Count:", 30, 40);
        text("Gravity (1 tile / x frames):", 30, 80);
        text("Additional Fix Block Delay (frames):", 30, 120); // block fix delay above gravity rate
        textAlign(CENTER, CENTER);
        fill(#CC4449);
        rect(width - 60, 30, 30, 30);
        rect(width - 60, 70, 30, 30);
        rect(width - 60, 110, 30, 30);
        rect(width - 150, 30, 30, 30);
        rect(width - 150, 70, 30, 30);
        rect(width - 150, 110, 30, 30);
        fill(255);
        text(">", width - 45, 40);
        text(">", width - 45, 80);
        text(">", width - 45, 120);
        text("<", width - 135, 40);
        text("<", width - 135, 80);
        text("<", width - 135, 120);
        text(args[1].toString(), width - 90, 40);
        text(args[0].toString(), width - 90, 80);
        text(args[2].toString(), width - 90, 120);
        textAlign(CENTER, CENTER);
        fill(#CC4449);
        rect(30, height - 85, width - 60, 70);
        textSize(48);
        fill(255);
        text("Start New Game", width / 2, height - 55);
        break;
      case SCREENTYPE_MAINMENU:
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(128);
        text("TETRIS", width / 2, height / 4);
        fill(#CC4449);
        rect(width * 0.1, height * 0.5, width * 0.8, height * 0.25 - 30);
        rect(width * 0.1, height * 0.75, width * 0.8, height * 0.25 - 30);
        fill(255);
        textSize(48);
        text("Start New Game", width / 2, height * 0.625 - 20);
        text("Settings", width / 2, height * 0.875 - 20);
        break;
      case SCREENTYPE_SETTINGS:
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height);
        fill(255);
        fill(#CC4449);
        rect(width * 0.1, height * 0.2, width * 0.8, 50);
        rect(width * 0.1, height * 0.5, width * 0.8, 50);
        fill(255);
        textSize(48);
        text("SinglePlayer", width * 0.35, height * 0.25 - 20);
        text("MultiPlayer", width * 0.35, height * 0.55 - 20);
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
    switch(screentype){
      case SCREENTYPE_PAUSE:
        if(keyCode == ESC){ // continue game
          ((Screen)args[0]).startAllBoards();
          parent.changeScreen((Screen)args[0]);
          return;
        }
        break;
      case SCREENTYPE_NEWGAME:
        if(keyCode == ESC){ // return to main menu
          parent.changeScreen(SCREENTYPE_MAINMENU);
          return;
        }
        break;
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
  boolean isInRange(int x, double a, double b){
    return(a <= x && x <= b);
  }
  void onMousePressed(int mouseX, int mouseY){
    switch(screentype){
      case SCREENTYPE_END:
        if(isInRange(mouseX, width / 2 - 130, width / 2 + 130) && isInRange(mouseY, height / 2 - 20, height / 2 + 60)){ // start new game button
          parent.changeScreen(SCREENTYPE_GAME);
          if(args[2] != null){ // then assume args 2 is a valid screen
            Screen copySettingsFrom = (Screen)(args[2]);
            parent.curScreen.setBoardGravity(copySettingsFrom.boards[0].originalGravityRate);
            parent.curScreen.setBoardBlockFixDelay(copySettingsFrom.boards[0].fixBlockDelay);
            // TODO: MAKE PLAYER COUNT ALSO BE COPIED
          }
          return;
        }
        if(isInRange(mouseX, width / 2 - 130, width / 2 + 130) && isInRange(mouseY, height / 2 + 80, height / 2 + 160)){ // return to main menu button
          parent.changeScreen(SCREENTYPE_MAINMENU);
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
      case SCREENTYPE_NEWGAME:
        if(isInRange(mouseX, 30, width - 30) && isInRange(mouseY, height - 85, height - 15)){ // start game button
          if((int)args[1]==1)parent.changeScreen(SCREENTYPE_GAME);
          //if((int)args[1]==2)parent.changeScreen(SCREENTYPE_MULTIGAME); This is annoying, will do later
          parent.curScreen.setBoardGravity((int)args[0]);
          parent.curScreen.setBoardBlockFixDelay((int)args[2]);
          // TODO: PLAYER COUNT CHANGE PUT HERE
        }
        if(isInRange(mouseX, width - 150, width - 120) && isInRange(mouseY, 30, 60)){ // decrease player count
          int curPlayerCount = (int)args[1];
          curPlayerCount--;
          if(curPlayerCount < MIN_PLAYER_COUNT){
            curPlayerCount = MIN_PLAYER_COUNT;
          }
          args[1] = (Object)curPlayerCount;
        }
        if(isInRange(mouseX, width - 60, width - 30) && isInRange(mouseY, 30, 60)){ // increase player count
          int curPlayerCount = (int)args[1];
          curPlayerCount++;
          if(curPlayerCount > MAX_PLAYER_COUNT){
            curPlayerCount = MAX_PLAYER_COUNT;
          }
          args[1] = (Object)curPlayerCount;
        }
        if(isInRange(mouseX, width - 150, width - 120) && isInRange(mouseY, 70, 100)){ // decrease gravity
          int curGrav = (int)args[0];
          curGrav -= 5;
          if(curGrav < MIN_GRAVITY_FRAMES){
            curGrav = MIN_GRAVITY_FRAMES;
          }
          args[0] = (Object)curGrav;
        }
        if(isInRange(mouseX, width - 60, width - 30) && isInRange(mouseY, 70, 100)){ // increase gravity
          int curGrav = (int)args[0];
          curGrav += 5;
          if(curGrav > MAX_GRAVITY_FRAMES){
            curGrav = MAX_GRAVITY_FRAMES;
          }
          curGrav -= (curGrav % 5); // make sure is mult of 5
          args[0] = (Object)curGrav;
        }
        if(isInRange(mouseX, width - 150, width - 120) && isInRange(mouseY, 110, 140)){ // decrease fix block delay
          int curFixDelay = (int)args[2];
          curFixDelay -= 5;
          if(curFixDelay < MIN_FIX_BLOCK_DELAY){
            curFixDelay = MIN_FIX_BLOCK_DELAY;
          }
          args[2] = (Object)curFixDelay;
        }
        if(isInRange(mouseX, width - 60, width - 30) && isInRange(mouseY, 110, 140)){ // increase fix block delay
          int curFixDelay = (int)args[2];
          curFixDelay += 5;
          if(curFixDelay > MAX_FIX_BLOCK_DELAY){
            curFixDelay = MAX_FIX_BLOCK_DELAY;
          }
          args[2] = (Object)curFixDelay;
        }
        break;
      case SCREENTYPE_MAINMENU:
        if(isInRange(mouseX, width * 0.1, width * 0.9) && isInRange(mouseY, height * 0.5, height * 0.75 - 30)){ // start new game
          parent.changeScreen(SCREENTYPE_NEWGAME);
          delay(1000);
        }
        if(isInRange(mouseX, width * 0.1, width * 0.9) && isInRange(mouseY, height * 0.75, height - 30)){ // settings menu
          parent.changeScreen(SCREENTYPE_SETTINGS);
          delay(1000);

        }
      case SCREENTYPE_SETTINGS:
        if(isInRange(mouseX, width * 0.1, width * 0.9) && isInRange(mouseY, height * 0.2, height * 0.2 + 30)){ // start new game
          parent.changeScreen(SCREENTYPE_GAME);

        }
        if(isInRange(mouseX, width * 0.1, width * 0.9) && isInRange(mouseY, height * 0.5, height *0.5 + 30)){ // settings menu
          parent.changeScreen(SCREENTYPE_MULTIGAME);
        }
        
        
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
  void setBoardGravity(int g){
    for(Board b : boards){
      b.originalGravityRate = g;
      b.levelScoreMultiplier = (float)LEVEL_SCORE_MULTIPLIER_CONSTANT / (float)g;
      if(!b.isSoftDropping){
        b.gravityRate = g;
      }
    }
  }
  void setBoardBlockFixDelay(int delay){
    for(Board b : boards){
      b.fixBlockDelay = delay;
    }
  }
}
