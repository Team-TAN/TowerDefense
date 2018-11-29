public class OrangeTile extends Tile {
  
  public OrangeTile() {
     colorOfTile = 25;
     index = 1;
  }
  
  public void display() {
    image(Images.orangeTile, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  public Tile getInstance() { return new OrangeTile();}
}
