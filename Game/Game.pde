static final int TILE_SIZE = 32;

static final int MOVE_LEFT = 0;
static final int MOVE_RIGHT = 1;
static final int ROTATE_CCW = 2;
static final int ROTATE_CW = 3;
static final int HARD_DROP = 4;
static final int SOFT_DROP = 5;
static final int HOLD_PIECE = 6;

static final int CONTROLS_COUNT = 7;

static final String SCREENTYPE_GAME = "GAMESCREEN";
static final String SCREENTYPE_END = "ENDSCREEN";
static final String SCREENTYPE_PAUSE = "PAUSESCREEN";
static final String SCREENTYPE_MAINMENU = "MAINMENUSCREEN";
static final String SCREENTYPE_NEWGAME = "NEWGAMESCREEN";
static final String SCREENTYPE_MULTIGAME = "MULTIGAMESCREEN";
static final String SCREENTYPE_SETTINGS = "SETTINGSSCREEN"; // TODO

static final int BLOCK_START_X_POS = 4;
static final int BLOCK_START_Y_POS = 20;

static final String DATA_FILE = "data/PERSISTENT_DATA.dat";
static final String DEFAULT_DATA_FILE = "data/DEFAULT_CONFIG_DATA_DO_NOT_MODIFY.dat"; // if this file and data_file doesn't exist VERY BAD THINGS HAPPEN

static final String HIGHSCORE_DATA_CONFIG = "HIGH_SCORE";

static final String TEXTURE_PACK_CONFIG = "TEXTURE_FILE";

static final String[] CONTROLS_CONFIG_LABEL_MAPPING = {"KEYBIND_LEFT", "KEYBIND_RIGHT", "KEYBIND_ROTATE_CCW", "KEYBIND_ROTATE_CW", "KEYBIND_HARD_DROP", "KEYBIND_SOFT_DROP", "KEYBIND_HOLD_PIECE"};

static final String ABSOLUTE_FILE_PATH_PREFIX = "ABSOLUTEPATH://";

static final int MIN_PLAYER_COUNT = 1;
static final int MAX_PLAYER_COUNT = 2;
static final int MIN_GRAVITY_FRAMES = 1;
static final int MAX_GRAVITY_FRAMES = 120;
static final int MIN_FIX_BLOCK_DELAY = 0;
static final int MAX_FIX_BLOCK_DELAY = 60;

static final int LEVEL_SCORE_MULTIPLIER_CONSTANT = 30;
static final int LEVEL_SCORE_MAX_MULTIPLIER = 6;

static final int DAS_KEY_REPEAT_DELAY = 16; // frames
static final int DAS_KEY_REPEAT_FREQUENCY = 3; // frames
static final int DAS_NO_KEY_PRESSED = 0;
static final int DAS_MOVE_LEFT = 1;
static final int DAS_MOVE_RIGHT = 2;


Screen curScreen;
private HashMap<String, String> config; // use config getter / setter methods
DataLoader localDataLoader = new DataLoader();

byte[] tileTexture;

void setup(){
  config = localDataLoader.readConfigData();
  tileTexture = localDataLoader.loadTextureFromFile(config.get(TEXTURE_PACK_CONFIG));
  changeScreen(SCREENTYPE_MAINMENU);
  size(640, 720);
  surface.setResizable(true);
}
void draw(){
  curScreen.onDraw();
}
void keyPressed(){
  //System.out.println(keyCode);
  if(key == ESC && curScreen != null && !curScreen.screentype.equals(SCREENTYPE_MAINMENU)){ // Stop sketch from terminating when ESC is pressed unless sketch is on main menu
    key = 0;
  }
  curScreen.onKeyPressed(keyCode);
}
void keyReleased(){
  curScreen.onKeyReleased(keyCode);
}
void mousePressed(){
  curScreen.onMousePressed(mouseX, mouseY);
}
void changeScreen(String screenType){
  curScreen = new Screen(screenType, this);
  if(screenType.equals(SCREENTYPE_MULTIGAME)){
    surface.setSize(2*width,height);
  }
}
void changeScreen(String screenType, Object[] args){
  curScreen = new Screen(screenType, this, args);
  if(screenType.equals(SCREENTYPE_MULTIGAME)){
    surface.setSize(2*width,height);
  }
}
void changeScreen(Screen target){
  curScreen = target;
}
String loadConfig(String configOption){
  if(config == null){
    return null;
  }
  return config.get(configOption);
}
String loadConfig(String configOption, int board){
  return(loadConfig(configOption + "_$" + board));
}
// Returns if successful
boolean setConfig(String configOption, String value){
  if(config == null){
    config = new HashMap<String, String>();
  }
  config.put(configOption, value);
  if(configOption == TEXTURE_PACK_CONFIG){
    tileTexture = localDataLoader.loadTextureFromFile(value);
  }
  if(configOption.substring(0, 8).equals("KEYBIND_")){
    if(curScreen != null){
      curScreen.updateBoardControls();
    }
  }
  return(localDataLoader.writeConfigData(config));
}
boolean setConfig(String configOption, String value, int board){
  return(setConfig(configOption + "_$" + board, value));
}
