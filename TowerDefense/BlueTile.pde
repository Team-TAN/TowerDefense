public class BlueTile extends Tile {
  
  public BlueTile() {
     colorOfTile = 150;
     index = 3;
  }
  
  @Override
  public Tile getInstance() {
    return new BlueTile(); 
  }
}
