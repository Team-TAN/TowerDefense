class StandardTower extends Tile {
  
  public StandardTower() {
    cost = 1000;
  }
  
  public void display() {
    backgroundTile.display();
    //display image
    fill(0);
    rect(pos.x + 5, pos.y + 5, 20, 20);
  }
  
  public Tile getInstance() {
    return new StandardTower(); 
  }
}
