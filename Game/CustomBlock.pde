public class CustomBlock extends Block implements Mod {
  CustomBlock(Board parent, int type) {
    super(parent, type);
  }
  public ArrayList<Integer> generateNewBlock(Tile[][] curState, boolean immediate){ // default methods not supported by processing, just placeholder before this gets implemented
    return null;
  }
  public String returnDisplayName(){ // also placeholder before this gets implemented
    return null;
  }
}
