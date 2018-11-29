public class RedTile extends Tile {
  
  public RedTile() {
     colorOfTile = 5;
     index = 0;
  }
     
  public void display() {
    image(Images.redTile, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  public Tile getInstance() { return new RedTile();}
}
