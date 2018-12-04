public class TowerTile extends Tile {
  
  public int upgradeIndex;
  public int health;
  public UpgradeData[] upgrades;
  private float timeLeftToShoot;
  
  private Creep target;
  private ArrayList<Creep> inRange = new ArrayList<Creep>();
  private float showProjectile = 0;
  
  public TowerTile(UpgradeData[] upgrades, int cost, int fanCost, int index, PImage img) {
    upgradeIndex = 0;
    this.upgrades = upgrades;
    this.img = img;
    health = this.upgrades[0].health;
    timeLeftToShoot = 0;
    
    this.cost = cost;
    this.fanCost = fanCost;
    this.index = index;
  }
  
  @Override
  public void display() {
    backgroundTile.display();
    image(img, pos.x, pos.y, tileWidth, tileHeight);
  }
  
  public void displayRadius() {
    fill(255, 255, 255, 50);
    noStroke();
    ellipse(pos.x + tileWidth / 2, pos.y + tileHeight / 2, getRange(0) * 2, getRange(0) * 2);
  }
  
  @Override
  public void update(Player enemy) {
    inRange.clear();
    ArrayList<Creep> creeps = enemy.creeps;
    
    for(int i = 0; i < creeps.size(); ++i) {
      Creep c = creeps.get(i);
      if(PVector.sub(new PVector(pos.x + tileWidth / 2, pos.y + tileHeight / 2), c.pos).mag() <= getRange(0)) inRange.add(c);
    }
    
    if(!inRange.isEmpty()) {
      target = inRange.get(0);
    
      timeLeftToShoot -= Time.deltaTime;
      if(timeLeftToShoot <= 0) {
        target.health -= getDamage(0);
        showProjectile = .05f;
        showProjectile();
        timeLeftToShoot = getFireSpeed(0);
      } else if(showProjectile > 0) {
        showProjectile -= Time.deltaTime;
        showProjectile();
      }
    }
  }
  
  public void showProjectile() {
    float px = pos.x + tileWidth / 2;
    float py = pos.y + tileHeight / 2;
    pushMatrix();
    translate(px, py);
    rotate(atan2(target.pos.y - py, target.pos.x - px));  
    image(Images.towerAttack, 0, -7.5, PVector.sub(new PVector(px, py), target.pos).mag(), 15);
    //rect(0, -7.5, PVector.sub(new PVector(px, py), target.pos).mag(), 15);
    popMatrix();
  }
  
  public int getDamage(int index) {
    return upgrades[upgradeIndex + index].damage;
  }
  
  public float getFireSpeed(int index) {
    return upgrades[upgradeIndex + index].fireSpeed;
  }
  
  public int getRange(int index) {
    return upgrades[upgradeIndex + index].range;
  }
  
  public int getUpgradeFanCost(int index) {
    if(upgradeIndex + index < upgrades.length)
      return upgrades[upgradeIndex + index].fanCost;
    
    return -1;
  }
  
  public boolean upgrade() {
     if(upgradeIndex + 1 < upgrades.length) { 
       upgradeIndex++;
       return true;
     }
     
     return false;
  }
  
  public void upgradeHealth() {
     health = upgrades[upgradeIndex].health;
  }
}
