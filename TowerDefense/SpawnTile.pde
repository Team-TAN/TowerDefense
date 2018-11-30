public class SpawnTile extends Tile {
  
  public SpawnTile() {
     colorOfTile = 200;
     index = 5;
     img = Images.spawnTile;
  }
  
  public Tile getInstance() {
    return new SpawnTile(); 
  }
}
