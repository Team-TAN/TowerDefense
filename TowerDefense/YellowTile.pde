public class YellowTile extends Tile {
  
  public YellowTile() {
     colorOfTile = 50;
     index = 2;
  }
  
  public void display() {
    image(Images.yellowTile, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  public Tile getInstance() { return new YellowTile();}
}
