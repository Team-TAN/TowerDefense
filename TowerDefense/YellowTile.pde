public class YellowTile extends Tile {
  
  public YellowTile() {
     colorOfTile = 50;
     index = 2;
  }
  
  public Tile getInstance() { return new YellowTile();}
}
