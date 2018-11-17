public class Creep {
  
  public PVector targetPos;
  public Queue<PVector> path;
  public PVector nextTile;
  public PVector pos;
  public PVector start;
  public boolean isDead = false;
  
  public float health;
  public boolean isPowered;
  
  public float timeToLeave = 0;
  private float speed = 50;
  
  int i = 0;
  
  public Creep(boolean isPowered) {
    this.isPowered = isPowered;
    if(isPowered) {
      health = 100;
    } else {
      health = 50;
    }
  }
  
  public void update() {
    fill(10);
    timeUpdate();
    int size = (isPowered ? 20 : 15);
    ellipse(pos.x, pos.y, size, size); 
    
    if(nextTile != null) {
      if(tileToPoint(nextTile).equals(pos)) {
        
        nextTile = path.poll();
      } else {
        PVector distance = PVector.sub(tileToPoint(nextTile), pos);
        PVector dir = distance.copy().normalize();
        PVector travel = new PVector(speed*Time.deltaTime * dir.x, speed*Time.deltaTime * dir.y);
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
      
    }
  }
  
  public void timeUpdate() {
    if(timeToLeave >= 0) {
      timeToLeave -= Time.deltaTime;
    }
  }
  
  public void findPath() {
    path = Pathfinder.findPath(start, targetPos);
    nextTile = path.poll();
    nextTile = path.poll();
  }
}
