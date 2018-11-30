public class LightningTower extends TowerTile {
  
  public LightningTower() {
    super(new UpgradeData[] { new UpgradeData(25, 50, 150, .25f, 0), new UpgradeData(50, 60, 200, .20f, 200), new UpgradeData(75, 75, 225, .15f, 300), new UpgradeData(100, 90, 250, .1f, 400) }, 1000, 400, 9);
    cost = 1000;
    fanCost = 500;
    index = 9;
    health = upgrades[0].health;
  }
  
  public LightningTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    super.display(Images.lightningTower);
  }
  
  @Override
  public Tile getInstance(Tile background) {
    return new LightningTower(background); 
  }
}
