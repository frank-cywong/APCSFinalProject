public class Screen {
  boolean hasBoards = true;
  String screentype;
  Board[] boards;
  public Screen(String screentype) {
    this.screentype = screentype;
    boards = new Board[1];
    boards[0] = new Board();
  }
  void onDraw() {
    if (hasBoards) {
      for (Board b : boards) {
        b.render();
      }
    }
  }
  void onKeyPressed(int keyCode){
    if (hasBoards){
      for (Board b : boards){
        b.onKeyPressed(keyCode);
      }
    }
  }
}
