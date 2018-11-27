public class GlacierTower extends Tile {
  
  private int damage = 50;
  private int health = 50;
  private int fanCost = 350;
  private int range = 150;
  private float timeBetweenShots = .75f;
  private float timeLeftToShoot = 0;
  
  private Creep target;
  private ArrayList<Creep> inRange = new ArrayList<Creep>();
  private ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  
  public GlacierTower() {
    cost = 1000;
  }
  
  public GlacierTower(Tile background) {
    this();
    backgroundTile = background.getInstance();
  }
  
  @Override
  public void display() {
    backgroundTile.display();
    image(Images.glacierTower, pos.x, pos.y, tileWidth, tileHeight);
    
    //fill(0, 0, 255, 40);
    //ellipse(pos.x + tileWidth / 2, pos.y + tileHeight / 2, range * 2, range * 2);
  }
  
  @Override
  public void update(GameSceneMultiplayer scene, boolean player1) {
    inRange.clear();
    ArrayList<Creep> creeps = (player1 ? scene.player2.creeps : scene.player1.creeps);
    
    for(int i = 0; i < creeps.size(); ++i) {
      Creep c = creeps.get(i);
      if(PVector.sub(new PVector(pos.x + tileWidth / 2, pos.y + tileHeight / 2), c.pos).mag() <= range) inRange.add(c);
    }
    
    if(!inRange.isEmpty()) {
      target = inRange.get(0);
    
      timeLeftToShoot -= Time.deltaTime;
      if(timeLeftToShoot <= 0) {
        target.health -= damage;
        ellipse(pos.x, pos.y, 20, 20);
        //bullets.add(new Bullet(pos, PVector.sub(target.pos, pos)));
        println(target.pos);
        timeLeftToShoot = timeBetweenShots;
      }
    }
  }
  
  @Override
  public Tile getInstance(Tile background) {
    return new GlacierTower(background); 
  }
}
