public abstract class Tile {
  
  public int index; // would be static if processing would allow it
  protected Tile backgroundTile = null;
  protected int colorOfTile = 0;
  public int cost = 1;
  public PVector pos;
  
  public void update(GameSceneMultiplayer scene, boolean player1) {
  }
  
  public void display() {
    colorMode(HSB);
    fill(colorOfTile, 255, 255);
    if(pos != null) rect(pos.x, pos.y, tileWidth, tileHeight);
    colorMode(RGB);
  }
  
  public Tile getInstance() { return null;}
  public Tile getInstance(Tile background) { return null;}
  
  public void setBackgroundTile(int index) {
    backgroundTile = tiles.get(index).getInstance();
    backgroundTile.pos = pos;
  }
}
