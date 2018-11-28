class StandardTower extends Tile {
  
  public int upgradeIndex = 0;
  public int health;
  public UpgradeData[] upgrades = { new UpgradeData(50, 25, 150, .5f, 0), new UpgradeData(75, 40, 200, .45f, 100), new UpgradeData(100, 50, 225, .35f, 200), new UpgradeData(125, 65, 250, .25f, 300) };
  private float timeLeftToShoot = 0;
  
  private Creep target;
  private ArrayList<Creep> inRange = new ArrayList<Creep>();
  
  public StandardTower() {
    cost = 1000;
    fanCost = 60;
    index = 6;
  }
  
  public StandardTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    backgroundTile.display();
    image(Images.standardTower, pos.x, pos.y, tileWidth, tileHeight);
    
    //fill(0, 0, 255, 40);
    //ellipse(pos.x + tileWidth / 2, pos.y + tileHeight / 2, range * 2, range * 2);
  }
  
  @Override
  public void update(GameSceneMultiplayer scene, boolean player1) {
    inRange.clear();
    ArrayList<Creep> creeps = (player1 ? scene.player2.creeps : scene.player1.creeps);
    
    for(int i = 0; i < creeps.size(); ++i) {
      Creep c = creeps.get(i);
      if(PVector.sub(new PVector(pos.x + tileWidth / 2, pos.y + tileHeight / 2), c.pos).mag() <= upgrades[upgradeIndex].range) inRange.add(c);
    }
    
    if(!inRange.isEmpty()){
      target = inRange.get(0);
    
      timeLeftToShoot -= Time.deltaTime;
      if(timeLeftToShoot <= 0) {
        target.health -= upgrades[upgradeIndex].damage;
        ellipse(pos.x, pos.y, 20, 20);
        //bullets.add(new Bullet(pos, PVector.sub(target.pos, pos)));
        println(target.pos);
        timeLeftToShoot = upgrades[upgradeIndex].fireSpeed;
      }
    }
    
    /*for(int i = bullets.size() - 1; i >= 0 ; --i) {
      Bullet b = bullets.get(i);
      b.display();
      if(b.pos.x < 0 || b.pos.x > 1000 || b.pos.y < 0 || b.pos.y > 900) bullets.remove(i);
    }*/
  }
  
  @Override
  public Tile getInstance(Tile background) {
    return new StandardTower(background); 
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
