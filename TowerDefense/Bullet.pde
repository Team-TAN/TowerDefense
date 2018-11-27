public class Bullet {
  
  private PVector vel;
  private PVector pos;
  
  public Bullet(PVector p, PVector v) {
    pos = p.copy(); 
    vel = v;
  }
  
  
  public void display() {
    pos.add(PVector.mult(vel, Time.deltaTime));
    
    fill(0);
    ellipse(pos.x, pos.y, 10, 10);
  }
  
}
