public class YellowTile extends Tile {
  
  public YellowTile() {
     colorOfTile = 50;
     index = 2;
     img = Images.yellowTile;
  }
  
  public Tile getInstance() { return new YellowTile();}
}
