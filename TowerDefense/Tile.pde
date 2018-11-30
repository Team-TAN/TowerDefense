public abstract class Tile {
  
  public int index; // would be static if processing would allow it
  protected Tile backgroundTile = null;
  protected int colorOfTile = 0;
  public int cost = 1;
  public int fanCost;
  public PVector pos;
  public PImage img;
  
  public void update(GameSceneMultiplayer scene, boolean player1) {
  }
  
  public void display() {
    image(img, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  public Tile getInstance() { return null;}
  public Tile getInstance(Tile background) { return null;}
  
  public void setBackgroundTile(int index) {
    backgroundTile = tiles.get(index).getInstance();
    backgroundTile.pos = pos;
  }
}
