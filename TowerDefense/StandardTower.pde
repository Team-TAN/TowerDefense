class StandardTower extends TowerTile {
  
  public StandardTower() {
    super(new UpgradeData[] { new UpgradeData(50, 25, 150, .5f, 0), new UpgradeData(75, 40, 200, .45f, 80), new UpgradeData(100, 50, 225, .35f, 150), new UpgradeData(125, 65, 250, .25f, 300) }, 1000, 60, 6);
  }
  
  public StandardTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    super.display(Images.standardTower);
  }
  
  @Override
  public Tile getInstance(Tile background) {
    return new StandardTower(background); 
  }
}
