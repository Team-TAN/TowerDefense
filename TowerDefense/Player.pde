public class Player {
  
  private final int MAX_HEALTH = 100;
  
  public ArrayList<Creep> creeps = new ArrayList<Creep>();
  
  public int health;
  public int fans;
  public int minionCount;
  
  public int selectedTileX;
  public int selectedTileY;
  
  public Player() {
    health = MAX_HEALTH;
    fans = 200;
  }
  
  public float healthPercent() {
    return health / MAX_HEALTH;  
  }
  
}
