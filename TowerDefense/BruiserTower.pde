public class BruiserTower extends Tile {
  
  public int upgradeIndex = 0;
  public int health;
  public UpgradeData[] upgrades = { new UpgradeData(25, 25, 150, .25f, 0), new UpgradeData(50, 40, 200, .20f, 150), new UpgradeData(75, 50, 225, .15f, 250), new UpgradeData(100, 65, 250, .1f, 400) };
  private float timeLeftToShoot = 0;
  
  private Creep target;
  private ArrayList<Creep> inRange = new ArrayList<Creep>();
  
  public BruiserTower() {
    cost = 1000;
    fanCost = 200;
    index = 7;
    health = upgrades[0].health;
  }
  
  public BruiserTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    backgroundTile.display();
    image(Images.bruiserTower, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  @Override
  public void update(GameSceneMultiplayer scene, boolean player1) {
    inRange.clear();
    ArrayList<Creep> creeps = (player1 ? scene.player2.creeps : scene.player1.creeps);
    
    for(int i = 0; i < creeps.size(); ++i) {
      Creep c = creeps.get(i);
      if(PVector.sub(new PVector(pos.x + tileWidth / 2, pos.y + tileHeight / 2), c.pos).mag() <= upgrades[upgradeIndex].range) inRange.add(c);
    }
    
    if(!inRange.isEmpty()) {
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
  }
  
  @Override
  public Tile getInstance(Tile background) {
    return new BruiserTower(background); 
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
