public class GlacierTower extends TowerTile {
  
  public GlacierTower() {
    super(new UpgradeData[] { new UpgradeData(50, 50, 150, .75f, 0), new UpgradeData(75, 60, 200, .65f, 200), new UpgradeData(100, 75, 250, .55f, 300), new UpgradeData(100, 85, 275, .45f, 500) }, 1000, 350, 8);
  }
  
  public GlacierTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    backgroundTile.display();
    image(Images.glacierTower, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  @Override
  public Tile getInstance(Tile background) {
    return new GlacierTower(background); 
  }
}
