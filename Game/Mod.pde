public interface Mod {
  public void onModMount(Board board);
  public ArrayList<Integer> generateNewBlock(Tile[][] curState, boolean immediate);
  public String returnDisplayName();
}
