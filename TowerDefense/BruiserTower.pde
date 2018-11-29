public class BruiserTower extends TowerTile {
  
  public BruiserTower() {
    super(new UpgradeData[] { new UpgradeData(25, 25, 150, .25f, 0), new UpgradeData(50, 40, 200, .20f, 150), new UpgradeData(75, 50, 225, .15f, 250), new UpgradeData(100, 65, 250, .1f, 400) }, 1000, 200, 7);
  }
  
  public BruiserTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    super.display(Images.bruiserTower);
  }
  
  @Override
  public Tile getInstance(Tile background) {
    return new BruiserTower(background); 
  }
}
