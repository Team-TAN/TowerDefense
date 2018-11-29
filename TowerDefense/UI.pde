class UI {

  private int sX = 0;
  private int sY = 55;
  private int w = 50;
  private int h = 50;

  private Player player;
  
  private TowerTile[] towers = {(TowerTile) tiles.get(6), (TowerTile) tiles.get(7), (TowerTile) tiles.get(8), (TowerTile) tiles.get(9), (TowerTile) tiles.get(10)};
  
  UI(int SX, Player PLAYER) {
    sX = SX;
    player = PLAYER;
  }

  void display() {
    pushStyle();
    textSize(10);
    
    fill(255);
    text("1", sX + tileWidth / 2 - 2, sY - 8);
    text("2",  sX + w + 33 + tileWidth / 2, sY - 8);
    text("3",  sX + w*2 + 68 + tileWidth / 2, sY - 8);
    text("4",  sX + w*3 + 103 + tileWidth / 2, sY - 8);
    text("5",  sX + w*4 + 141 + tileWidth / 2, sY - 8);
    
    
    //tower 1 stats
    textSize(8);
    text(towers[0].getDamage(0), sX + tileWidth + 22, sY + 8);
    text(towers[0].health, sX + tileWidth + 22, sY + 28);
    text(fireSpeedConvert(towers[0].getFireSpeed(0)), sX + tileWidth + 22, sY + 48);
    //tower 2 stats
    text(towers[1].getDamage(0), sX + w + 57 + tileWidth, sY + 8);
    text(towers[1].health,  sX + w + 57 + tileWidth, sY + 28);
    text(fireSpeedConvert(towers[1].getFireSpeed(0)), sX + w + 57 + tileWidth, sY + 48);
    //tower 3 stats
    text(towers[2].getDamage(0), sX + w * 2 + 92 + tileWidth, sY + 8);
    text(towers[2].health, sX + w * 2 + 92 + tileWidth, sY + 28);
    text(fireSpeedConvert(towers[2].getFireSpeed(0)), sX + w * 2 + 92 + tileWidth, sY + 48);
    //tower 4 stats
    text(towers[3].getDamage(0), sX + w * 3 + 127 + tileWidth, sY + 8);
    text(towers[3].health, sX + w * 3 + 127 + tileWidth, sY + 28);
    text(fireSpeedConvert(towers[3].getFireSpeed(0)), sX + w * 3 + 127 + tileWidth, sY + 48);
    //tower 5 stats
    text(towers[4].getDamage(0), sX + w * 4 + 172 + tileWidth, sY + 8);
    text(towers[4].health, sX + w * 4 + 172 + tileWidth, sY + 28);
    text(fireSpeedConvert(towers[4].getFireSpeed(0)), sX + w * 4 + 172 + tileWidth, sY + 48);
    if (player.fans >= towers[0].fanCost)
      tint(255, 255);
    else 
      tint(255, 50);
      
    image(Images.standardTower, sX, sY, tileWidth, tileHeight);

    if (player.fans >= towers[1].fanCost)
      tint(255, 255);
    else
      tint(255, 50);
  
    image(Images.bruiserTower, sX + w + 35, sY, tileWidth, tileHeight);

    if (player.fans >= towers[2].fanCost)
      tint(255, 255);
    else
      tint(255, 125);
    
    image(Images.glacierTower, sX + w*2 + 70, sY, tileWidth, tileHeight);

    if (player.fans >= towers[3].fanCost)
      tint(255, 255);
    else
      tint(255, 125);
    
    image(Images.lightningTower, sX + w*3 + 105, sY, tileWidth, tileHeight);
    
    if (player.fans >= towers[4].fanCost)
      tint(255, 255);
    else
      tint(255, 125);
    
    image(Images.wall, sX + w*4 + 143, sY, tileWidth, tileHeight);
    textSize(12);
    noTint();
  }
}
