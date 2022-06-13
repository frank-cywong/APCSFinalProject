public interface Mod {
  public ArrayList<Integer> generateNewBlock(Tile[][] curState, boolean immediate);
  public String returnDisplayName();
}
