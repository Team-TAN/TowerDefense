public class Creep {
  
  public PVector targetPos;
  public Queue<PVector> path;
  public PVector nextTile;
  public PVector pos;
  public PVector start;
  public boolean isDead = false;
  
  public float health;
  public boolean isPowered;
  
  public float speedMult;
  public float spawnMult;
  
  public float timeToLeave = 0;
  private float speed = 50;
  private boolean isPlayer1;
  
  private float hoverCounter = 0f;
  private final float hoverHeight = 3f;
  private final float hoverSpeed = 6;
  
  int i = 0;
  
  public Creep(boolean isPowered, boolean isPlayer1, float healthMult) {
    this.isPowered = isPowered;
    this.isPlayer1 = isPlayer1;
    if(isPowered) {
      health = 125 * healthMult;
    } else {
      health = 75 * healthMult;
    }
  }
  
  public void update() {
    timeUpdate();
    hoverCounter += Time.deltaTime;
    PImage img;
    
    if(isPlayer1) {
      tint(100, 200, 255);
      if(isPowered) {
        img = Images.creepUpgraded1;
      } else {
        img = Images.creepNormal1;
      }
    } else {
      if(isPowered) {
        img = Images.creepUpgraded2;
      } else {
        img = Images.creepNormal2;
      }
    }
    
    if(isPowered)
      image(img, pos.x - tileWidth / 2, pos.y - tileHeight / 2 + sin(hoverCounter * hoverSpeed) * hoverHeight, tileWidth, tileHeight);
    else 
      image(img, pos.x - tileWidth / 2 + 2, 2 + pos.y - tileHeight / 2 + sin(hoverCounter * hoverSpeed) * hoverHeight, tileWidth - 4, tileHeight - 4);
    noTint();
    if(nextTile != null) {
      if(tileToPoint(nextTile).equals(pos)) {
        
        nextTile = path.poll();
      } else {
        PVector distance = PVector.sub(tileToPoint(nextTile), pos);
        PVector dir = distance.copy().normalize();
        PVector travel = new PVector(speed * speedMult * Time.deltaTime * dir.x, speed * speedMult * Time.deltaTime * dir.y);
        if(travel.mag() > distance.mag())
          pos = tileToPoint(nextTile.copy());
        else
          pos.add(travel);
      }
    }
    
    if(tileToPoint(targetPos).equals(pos)) {
      // deal damage to base
      isDead = true;
    } else {
      if(health < 0) isDead = true;
    }
  }
  
  public void timeUpdate() {
    if(timeToLeave >= 0) {
      timeToLeave -= Time.deltaTime * spawnMult;
    }
  }
  
  public void findPath() {
    path = Pathfinder.findPath(start, targetPos);
    nextTile = path.poll();
    nextTile = path.poll();
  }
}
