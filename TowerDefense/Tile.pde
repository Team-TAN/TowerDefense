public class Tile {
  
  protected int colorOfTile = 0;
  public int cost = 0;
  
  public Tile() {
  }
  
  public void update() {
    
  }
  
  public void display(PVector pos) {
    colorMode(HSB);
    fill(colorOfTile, 255, 255);
    rect(pos.x, pos.y, tileWidth, tileHeight);
    colorMode(RGB);
  }
}
