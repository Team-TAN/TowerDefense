public abstract class Tile {
  
  public int index; // would be static if processing would allow it
  protected Tile backgroundTile = null;
  protected int colorOfTile = 0;
  public int cost = 1;
  public PVector pos;
  
  public void update() {
    
  }
  
  public void display() {
    colorMode(HSB);
    fill(colorOfTile, 255, 255);
    rect(pos.x, pos.y, tileWidth, tileHeight);
    colorMode(RGB);
  }
  
  public abstract Tile getInstance();
  
  public void setBackgroundTile(int index) {
    backgroundTile = tiles.get(index).getInstance();
    backgroundTile.pos = pos;
  }
}
