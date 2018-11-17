public class Tile {
  
  public Tile backgroundTile = null;
  protected int colorOfTile = 0;
  public int cost = 1;
  
  public void update() {
    
  }
  
  public void display(PVector pos) {
    colorMode(HSB);
    fill(colorOfTile, 255, 255);
    rect(pos.x, pos.y, tileWidth, tileHeight);
    colorMode(RGB);
  }
}
