public class RedTile extends Tile {
  
  public RedTile() {
     colorOfTile = 5;
     index = 0;
     img = Images.redTile;
  }
  
  public Tile getInstance() { return new RedTile();}
}
