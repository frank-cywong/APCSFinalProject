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

static final int BLOCK_START_X_POS = 4;
static final int BLOCK_START_Y_POS = 20;

Screen curScreen;
void setup(){
  changeScreen(SCREENTYPE_GAME);
  size(640, 720);
}
void draw(){
  curScreen.onDraw();
}
void keyPressed(){
  //System.out.println(keyCode);
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
}
void changeScreen(String screenType, Object[] args){
  curScreen = new Screen(screenType, this, args);
}
