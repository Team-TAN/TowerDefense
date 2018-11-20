public class SpawnTile extends Tile {
  
  public SpawnTile() {
     colorOfTile = 200;
     index = 5;
  }
  
  public Tile getInstance() {
    return new SpawnTile(); 
  }
}
