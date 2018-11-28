public class GlacierTower extends Tile {
  
  public int upgradeIndex = 0;
  public int health;
  public UpgradeData[] upgrades = { new UpgradeData(50, 50, 150, .75f, 0), new UpgradeData(75, 60, 200, .65f, 200), new UpgradeData(100, 75, 250, .55f, 300), new UpgradeData(100, 85, 275, .45f, 500) };
  private float timeLeftToShoot = 0;
  
  private Creep target;
  private ArrayList<Creep> inRange = new ArrayList<Creep>();
  
  public GlacierTower() {
    cost = 1000;
    fanCost = 350;
    index = 8;
    health = upgrades[0].health;
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
    return new GlacierTower(background); 
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
