public class WallTower extends TowerTile { 
  
  public WallTower() {
    super(new UpgradeData[] { new UpgradeData(75, 0), new UpgradeData(100, 50), new UpgradeData(125, 75), new UpgradeData(150, 100) }, 1200, 50, 10);
  }
  
  public WallTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    super.display(Images.wall);
  }
  
  @Override
  public void update(GameSceneMultiplayer scene, boolean player1) {}
  
  @Override
  public Tile getInstance(Tile background) {
    return new WallTower(background); 
  }
}
