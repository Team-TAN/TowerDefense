public class SpawnTile extends Tile {
  
  public SpawnTile() {
     colorOfTile = 200;
     index = 5;
  }
  
    
  public void display() {
    image(Images.spawnTile, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  public Tile getInstance() {
    return new SpawnTile(); 
  }
}
