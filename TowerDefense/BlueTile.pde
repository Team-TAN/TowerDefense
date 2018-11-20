public class BlueTile extends Tile {
  
  public BlueTile() {
     colorOfTile = 150;
     index = 3;
  }
  
  public void update() {
    
  }
  
  public Tile getInstance() {
    return new BlueTile(); 
  }
}
