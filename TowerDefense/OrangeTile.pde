public class OrangeTile extends Tile {
  
  public OrangeTile() {
     colorOfTile = 25;
     index = 1;
     img = Images.orangeTile;
  }
  
  public Tile getInstance() { return new OrangeTile();}
}
