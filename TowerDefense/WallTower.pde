public class WallTower extends Tile {
  
  private int health = 100;
  private int fanCost = 50;
  
  public WallTower() {
    cost = 1200;
  }
  
  public WallTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    backgroundTile.display();
    image(Images.wall, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  @Override
  public Tile getInstance(Tile background) {
    return new WallTower(background); 
  }
}
