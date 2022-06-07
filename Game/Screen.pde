public class Screen {
  boolean hasBoards = false;
  String screentype;
  Board[] boards;
  Game parent;
  Object[] args = null;
  int timer = 0;
  final int menuStartOffset = 160;
  final int menuSizeLength = 30;
  public Screen(String screentype, Game parent) {
    this(screentype, parent, null);
  }
  public Screen(String screentype, Game parent, Object[] args){
    this.screentype = screentype;
    this.parent = parent;
    this.args = args;
    boards = new Board[1];
    boards[0] = new Board(this, 0, 0);
    if(screentype == SCREENTYPE_GAME){
      hasBoards = true;
      boards = new Board[1];
      boards[0] = new Board(this, 0, 0);
      updateBoardControls();
    }
    if(screentype == SCREENTYPE_MULTIGAME){
      hasBoards = true;
      boards = new Board[2];
      boards[0] = new Board(this, 0, 0);
      boards[1] = new Board(this, Board.gameplayXOffset * 2 + boards[0].boardWidth * TILE_SIZE + Board.statZoneWidth, 0);
      updateBoardControls();
    }
    switch(screentype){
      case SCREENTYPE_END: // arg format: [score, isThisANewHighScore, previous game screen if exists (if null, just use default settings)] - but highscore checking done here
        timer = 3600;
        noStroke();
        fill(0x88000000);
        rect(0, 0, width, height);
        if(args == null){
          this.args = (Object[])(new Object[] {0, false, null});
        }
        this.args = args;
        if(this.args[2] != null){
          Screen temp = (Screen)this.args[2];
          int highScore = Integer.parseInt(parent.loadConfig(HIGHSCORE_DATA_CONFIG));
          int curMaxScore = 0;
          for(Board b : temp.boards){
            if(b.score > curMaxScore){
              curMaxScore = b.score;
            }
          }
          if(curMaxScore > highScore){
            this.args[1] = (Object)(true);
            parent.setConfig(HIGHSCORE_DATA_CONFIG, ""+curMaxScore);
          }
          this.args[0] = (Object)(curMaxScore);
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
      case SCREENTYPE_NEWGAME: // no arguments, but args used to store args for game as a temp storage ([gravity (in 1 tile / x frames), playercount, fix block delay, decrease gravity every n frames, amount to change delta G by every time its increased, minimum gravity, ghost block enabled, garbage enabled])
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height); //  // entirely fill screen
        this.args = new Object[]{30, 1, 30, 600, 40, 1, true, true};
        break;
      case SCREENTYPE_MAINMENU: // no arguments at all
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height); //  // entirely fill screen
        break;
      case SCREENTYPE_SETTINGS: // no arguments, but args used to store current selected player for config options & the keybinding being edited rn ([cur sel player, current editing]), player # is 0 indexed
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height);
        this.args = new Object[]{0, -1};
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
        text("Gravity (1 line / x frames):", 30, 80);
        text("Additional Fix Block Delay (frames):", 30, 120); // block fix delay above gravity rate
        text("Decrease Gravity (every x frames):", 30, 160);
        text("Slow Down Δg by (every Δg frames):", 30, 200);
        text("Don't Decrease Gravity Below:", 30, 240);
        text("Ghost Blocks:", 30, 280);
        text("[MULTIPLAYER] Garbage:", 30, 320);
        textAlign(CENTER, CENTER);
        fill(#CC4449);
        rect(width - 60, 30, 30, 30);
        rect(width - 60, 70, 30, 30);
        rect(width - 60, 110, 30, 30);
        rect(width - 60, 150, 30, 30);
        rect(width - 60, 190, 30, 30);
        rect(width - 60, 230, 30, 30);
        rect(width - 60, 270, 30, 30);
        rect(width - 60, 310, 30, 30);
        rect(width - 150, 30, 30, 30);
        rect(width - 150, 70, 30, 30);
        rect(width - 150, 110, 30, 30);
        rect(width - 150, 150, 30, 30);
        rect(width - 150, 190, 30, 30);
        rect(width - 150, 230, 30, 30);
        rect(width - 150, 270, 30, 30);
        rect(width - 150, 310, 30, 30);
        fill(255);
        text(">", width - 45, 40);
        text(">", width - 45, 80);
        text(">", width - 45, 120);
        text(">", width - 45, 160);
        text(">", width - 45, 200);
        text(">", width - 45, 240);
        text(">", width - 45, 280);
        text(">", width - 45, 320);
        text("<", width - 135, 40);
        text("<", width - 135, 80);
        text("<", width - 135, 120);
        text("<", width - 135, 160);
        text("<", width - 135, 200);
        text("<", width - 135, 240);
        text("<", width - 135, 280);
        text("<", width - 135, 320);
        text(args[1].toString(), width - 90, 40);
        text(args[0].toString(), width - 90, 80);
        text(args[2].toString(), width - 90, 120);
        text((int)args[3] == -1 ? "∞" : args[3].toString(), width - 90, 160); // -1 means infinity
        text(args[4].toString(), width - 90, 200);
        text(args[5].toString(), width - 90, 240);
        text((boolean)args[6] ? "On" : "Off", width - 90, 280);
        text((boolean)args[7] ? "On" : "Off", width - 90, 320);
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
        String curTextureString = parent.loadConfig(TEXTURE_PACK_CONFIG);
        // ignore file path
        int cutOffPoint = max(curTextureString.lastIndexOf("/"), curTextureString.lastIndexOf("\\"));
        if(cutOffPoint != -1){
          curTextureString = curTextureString.substring(cutOffPoint + 1);
        }
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height);
        fill(255);
        textSize(24);
        textAlign(LEFT, CENTER);
        text("Current Texture:\n" + curTextureString, 30, 58);
        Tile sampleTile = new Tile(null);
        sampleTile.onBoard = false;
        sampleTile.c = #0000FF;
        sampleTile.updateTexture(parent.tileTexture);
        sampleTile.render(width - 62, 30);
        sampleTile.render(width - 94, 30);
        sampleTile.render(width - 62, 62);
        sampleTile.render(width - 94, 62);
        fill(#CC4449);
        rect(width - 324, 30, 200, 64);
        fill(255);
        textAlign(CENTER, CENTER);
        text("Change Texture", width - 224, 58);
        textAlign(LEFT, CENTER);
        text("Edit Keybindings for Player", 30, 135);
        fill(#CC4449);
        rect(width - 60, 125, 30, 30);
        rect(width - 150, 125, 30, 30);
        textAlign(CENTER, CENTER);
        fill(255);
        text("<", width - 135, 135);
        text(">", width - 45, 135);
        text((Integer)(args[0]) + 1, width - 90, 135);
        textSize(24);
        for(int i = 0; i < CONTROLS_COUNT; i++){
          textAlign(LEFT, CENTER);
          textSize(24);
          text(CONTROLS_TO_NAME[i]+":", 30, menuStartOffset + menuSizeLength * i + 9);
          textAlign(RIGHT, CENTER);
          textSize((int)(args[1]) == i ? 18 : 24);
          text((int)(args[1]) == i ? "TYPE NEW KEYBIND" : controlToText(parent.loadConfig(CONTROLS_CONFIG_LABEL_MAPPING[i], (int)(args[0]))), width - 120, menuStartOffset + menuSizeLength * i + 9);
        }
        for(int i = 0; i < CONTROLS_COUNT; i++){
          fill(#CC4449);
          rect(width - 110, menuStartOffset + menuSizeLength * i, 80, 24);
          textAlign(CENTER, CENTER);
          fill(255);
          textSize(18);
          text((int)(args[1]) == i ? "CANCEL" : "EDIT", width - 70, menuStartOffset + menuSizeLength * i + 9);
        }
        break;
      case SCREENTYPE_MULTIGAME:
        noStroke();
        fill(0xFF606060);
        rect(0, 0, width, height);
        fill(255);
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
      case SCREENTYPE_SETTINGS:
        if(keyCode == ESC){ // return to main menu
          parent.changeScreen(SCREENTYPE_MAINMENU);
          return;
        }
        if((int)args[1] != -1){ // editing keybinds
          if(keyCode >= 'A' && keyCode <= 'Z'){
            parent.setConfig(CONTROLS_CONFIG_LABEL_MAPPING[(int)args[1]], ""+(char)(keyCode), (int)args[0]);
          } else {
            parent.setConfig(CONTROLS_CONFIG_LABEL_MAPPING[(int)args[1]], ""+keyCode, (int)args[0]);
          }
          args[1] = -1;
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
  void fileSelected(File selected){
    if(selected == null){
      return;
    }
    switch(screentype){
      case SCREENTYPE_SETTINGS:
        // this is a texture file then, step 1: validate input
        try{
          DataLoader dataLoader = new DataLoader();
          byte[] possibleTexture = dataLoader.loadTextureFromFile(ABSOLUTE_FILE_PATH_PREFIX + selected.getAbsolutePath());
          boolean entirelyBlank = true;
          for(int i = 0; i < 1024; i++){
            if(possibleTexture[i] != (byte)(0xFF)){
              entirelyBlank = false;
              continue;
            }
          }
          if(entirelyBlank){
            throw new IllegalArgumentException("Texture file entirely blank");
          }
          // texture file is now (likely) valid
          parent.setConfig(TEXTURE_PACK_CONFIG, ABSOLUTE_FILE_PATH_PREFIX + selected.getAbsolutePath());
        } catch (Exception e){ // invalid texture file
          // do nothing
        }
        break;
    }
  }
  // returns if x is in [a,b]
  boolean isInRange(int x, double a, double b){
    return(a <= x && x <= b);
  }
  String controlToText(String control){
    if(control.length() == 1 && Character.isLetter(control.charAt(0))){
      return control;
    }
    try{
      int configInt = Integer.parseInt(control);
      if(controlsMap.containsKey(configInt)){
        return(controlsMap.get(configInt));
      } else {
        return("KEY " + configInt);
      }
    } catch (NumberFormatException e){
      return "INVALID";
    }
  }
  void onMousePressed(int mouseX, int mouseY){
    switch(screentype){
      case SCREENTYPE_END:
        if(isInRange(mouseX, width / 2 - 130, width / 2 + 130) && isInRange(mouseY, height / 2 - 20, height / 2 + 60)){ // start new game button
          if(args[2] == null){
            parent.changeScreen(SCREENTYPE_GAME);
          } else { // then assume args 2 is a valid screen
            Screen copySettingsFrom = (Screen)(args[2]);
            if(copySettingsFrom.boards.length >= 2){
              parent.changeScreen(SCREENTYPE_MULTIGAME); 
            } else {
              parent.changeScreen(SCREENTYPE_GAME);
            }
            parent.curScreen.setBoardGravity(copySettingsFrom.boards[0].startGravityRate);
            parent.curScreen.setBoardBlockFixDelay(copySettingsFrom.boards[0].fixBlockDelay);
            parent.curScreen.setDeltaG(copySettingsFrom.boards[0].startDeltaG);
            parent.curScreen.setDeltaDeltaG(copySettingsFrom.boards[0].deltaDeltaG);
            parent.curScreen.setMinGrav(copySettingsFrom.boards[0].gravityLimit);
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
          if((int)args[1]==2)parent.changeScreen(SCREENTYPE_MULTIGAME); //This is annoying, will do later
          parent.curScreen.setBoardGravity((int)args[0]);
          parent.curScreen.setBoardBlockFixDelay((int)args[2]);
          parent.curScreen.setDeltaG((int)args[3]);
          parent.curScreen.setDeltaDeltaG((int)args[4]);
          parent.curScreen.setMinGrav((int)args[5]);
          parent.curScreen.setGhostBlocks((boolean)args[6]);
          parent.curScreen.setGarbage((boolean)args[7]);
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
          if(curGrav > 10){
            curGrav -= 5;
          } else {
            curGrav--;
          }
          if(curGrav < MIN_GRAVITY_FRAMES){
            curGrav = MIN_GRAVITY_FRAMES;
          }
          args[0] = (Object)curGrav;
        }
        if(isInRange(mouseX, width - 60, width - 30) && isInRange(mouseY, 70, 100)){ // increase gravity
          int curGrav = (int)args[0];
          if(curGrav >= 10){
            curGrav += 5;
          } else {
            curGrav++;
          }
          if(curGrav > MAX_GRAVITY_FRAMES){
            curGrav = MAX_GRAVITY_FRAMES;
          }
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
        if(isInRange(mouseX, width - 150, width - 120) && isInRange(mouseY, 150, 180)){ // decrease delta G
          int curDeltaG = (int)args[3];
          if(curDeltaG == -1){
            curDeltaG = MAX_DELTAG;
          } else {
            curDeltaG -= 100;
            if(curDeltaG < MIN_DELTAG){
              curDeltaG = MIN_DELTAG;
            }
          }
          args[3] = (Object)curDeltaG;
        }
        if(isInRange(mouseX, width - 60, width - 30) && isInRange(mouseY, 150, 180)){ // increase delta G
          int curDeltaG = (int)args[3];
          if(curDeltaG != -1){
            curDeltaG += 100;
            if(curDeltaG > MAX_DELTAG){
              curDeltaG = -1;
            }
            args[3] = (Object)curDeltaG;
          }
        }
        if(isInRange(mouseX, width - 150, width - 120) && isInRange(mouseY, 190, 220)){ // decrease ΔΔG
          int curDeltaDeltaG = (int)args[4];
          curDeltaDeltaG -= 5;
          if(curDeltaDeltaG < MIN_DELTADELTAG){
            curDeltaDeltaG = MIN_DELTADELTAG;
          }
          args[4] = (Object)curDeltaDeltaG;
        }
        if(isInRange(mouseX, width - 60, width - 30) && isInRange(mouseY, 190, 220)){ // increase ΔΔG
          int curDeltaDeltaG = (int)args[4];
          curDeltaDeltaG += 5;
          if(curDeltaDeltaG > MAX_DELTADELTAG){
            curDeltaDeltaG = MAX_DELTADELTAG;
          }
          args[4] = (Object)curDeltaDeltaG;
        }
        if(isInRange(mouseX, width - 150, width - 120) && isInRange(mouseY, 230, 260)){ // decrease min grav
          int curMinGrav = (int)args[5];
          curMinGrav--;
          if(curMinGrav < MIN_MINIMUMGRAVITY){
            curMinGrav = MIN_MINIMUMGRAVITY;
          }
          args[5] = (Object)curMinGrav;
        }
        if(isInRange(mouseX, width - 60, width - 30) && isInRange(mouseY, 230, 260)){ // increase min grav
          int curMinGrav = (int)args[5];
          curMinGrav++;
          if(curMinGrav > MAX_MINIMUMGRAVITY){
            curMinGrav = MAX_MINIMUMGRAVITY;
          }
          args[5] = (Object)curMinGrav;
        }
        if((isInRange(mouseX, width - 150, width - 120) || isInRange(mouseX, width - 60, width - 30)) && isInRange(mouseY, 310, 340)){ // toggle garbage
          boolean curGarbageEnabled = (boolean)args[7];
          curGarbageEnabled = !curGarbageEnabled;
          args[7] = (Object)curGarbageEnabled;
        }
        if((isInRange(mouseX, width - 150, width - 120) || isInRange(mouseX, width - 60, width - 30)) && isInRange(mouseY, 270, 300)){ // toggle ghost blocks
          boolean curGBEnabled = (boolean)args[6];
          curGBEnabled = !curGBEnabled;
          args[6] = (Object)curGBEnabled;
        }
        break;
      case SCREENTYPE_MAINMENU:
        if(isInRange(mouseX, width * 0.1, width * 0.9) && isInRange(mouseY, height * 0.5, height * 0.75 - 30)){ // start new game
          parent.changeScreen(SCREENTYPE_NEWGAME);
          //delay(1000);
        }
        if(isInRange(mouseX, width * 0.1, width * 0.9) && isInRange(mouseY, height * 0.75, height - 30)){ // settings menu
          parent.changeScreen(SCREENTYPE_SETTINGS);
          //delay(1000);
        }
      case SCREENTYPE_SETTINGS:
        if(isInRange(mouseX, width - 324, width - 124) && isInRange(mouseY, 30, 94)){ // change texture
          File f = new File(sketchPath("/textures"));
          selectInput("Select texture file", "fileSelected", f);
        }
        if(isInRange(mouseX, width - 150, width - 120) && isInRange(mouseY, 125, 155)){ // - player count
          int curPlayerCount = (int)(args[0]);
          curPlayerCount--;
          if(curPlayerCount < MIN_PLAYER_COUNT - 1){
            curPlayerCount = MIN_PLAYER_COUNT - 1;
          }
          args[0] = (Object)curPlayerCount;
        }
        if(isInRange(mouseX, width - 60, width - 30) && isInRange(mouseY, 125, 155)){ // + player count
          int curPlayerCount = (int)(args[0]);
          curPlayerCount++;
          if(curPlayerCount > MAX_PLAYER_COUNT - 1){
            curPlayerCount = MAX_PLAYER_COUNT - 1;
          }
          args[0] = (Object)curPlayerCount;
        }
        if(isInRange(mouseX, width - 110, width - 30)){ // select edit controls keybind
          int selected = -1;
          for(int i = 0; i < CONTROLS_COUNT; i++){
            if(isInRange(mouseY, menuStartOffset + menuSizeLength * i, menuStartOffset + menuSizeLength * i + 24)){
              selected = i;
              break;
            }
          }
          if(selected != -1){
            if(selected == (int)args[1]){
              args[1] = -1;
            } else {
              args[1] = selected;
            }
          }
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
        if(configOption.length() == 1 && Character.isLetter(configOption.charAt(0))){ // directly interpret it as a key
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
      b.startGravityRate = g;
      b.originalGravityRate = g;
      b.levelScoreMultiplier = min(LEVEL_SCORE_MAX_MULTIPLIER, (float)LEVEL_SCORE_MULTIPLIER_CONSTANT / (float)g);
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
  void setDeltaG(int deltaG){
    for(Board b : boards){
      b.startDeltaG = deltaG;
      b.deltaG = deltaG;
    }
  }
  void setDeltaDeltaG(int deltaDeltaG){
    for(Board b : boards){
      b.deltaDeltaG = deltaDeltaG;
    }
  }
  void setMinGrav(int minGrav){
    for(Board b : boards){
      b.gravityLimit = minGrav;
    }
  }
  void setGarbage(boolean garbageEnabled){
    for(Board b : boards){
      b.garbageEnabled = garbageEnabled;
    }
  }
  void setGhostBlocks(boolean GBEnabled){
    for(Board b : boards){
      b.ghostBlocksEnabled = GBEnabled;
      if(GBEnabled){
        b.curBlock.createGhostBlock();
      } else {
        b.curBlock.deleteGhostBlock(false);
      }
    }
  }
  void sendGarbage(int lines, Board avoid){
    for(Board b : boards){
      if(b != avoid){
        b.receiveGarbage(lines);
      }
    }
  }
}
