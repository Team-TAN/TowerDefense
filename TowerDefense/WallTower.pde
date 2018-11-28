public class WallTower extends Tile {
  
  public int upgradeIndex = 0;
  public int health;
  public UpgradeData[] upgrades = { new UpgradeData(75, 0), new UpgradeData(100, 50), new UpgradeData(125, 75), new UpgradeData(150, 100) };
  
  
  public WallTower() {
    cost = 1200;
    fanCost = 50;
    index = 10;
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
  
    public boolean upgrade() {
     if(upgradeIndex + 1 < upgrades.length) { 
       upgradeIndex++;
       return true;
     }
     
     return false;
  }
  
  public int getUpgradeFanCost(int index) {
    if(upgradeIndex + index < upgrades.length)
      return upgrades[upgradeIndex + index].fanCost;
    
    return -1;
  }
}
