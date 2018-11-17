class StandardTower extends Tile {
  
  public StandardTower() {
    cost = 1000;
  }
  
  public void display(PVector pos) {
    backgroundTile.display(pos);
    //display image
    fill(0);
    rect(pos.x + 5, pos.y + 5, 20, 20);
  }
}
