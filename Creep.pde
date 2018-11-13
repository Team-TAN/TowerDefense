public class Creep {
  
  public PVector targetPos;
  public PVector pos;
  public boolean isDead = false;
  
  public float health;
  public boolean isPowered;
  
  public float timeToLeave = 0;
  
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
    println("in update");
    int size = (isPowered ? 25 : 15);
    ellipse(pos.x, pos.y, size, size);    
  }
  
  public void timeUpdate() {
    if(timeToLeave >= 0) {
      timeToLeave -= Time.deltaTime;
    } else {
      pos.x += 20 * Time.deltaTime;
    }
  }
}
