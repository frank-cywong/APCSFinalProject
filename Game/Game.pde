static final int TILE_SIZE = 32;
Screen curScreen;
void setup(){
  curScreen = new Screen("GAMESCREEN");
  size(560, 720);
}
void draw(){
  curScreen.onDraw();
}
