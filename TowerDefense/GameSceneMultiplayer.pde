public class GameSceneMultiplayer extends Scene {

  private RhythmGame miniGame = null;

  public Player player1 = new Player(new PVector(0,0));
  public Player player2 = new Player(new PVector(19, 0));
  
  private UI p1TowerUI = new UI(10, player1);
  private UI p2TowerUI = new UI(545, player2);

  private boolean isBuildingState;
  private boolean isMiniGame = false;
  private boolean isGameOver = false;
  private boolean player1Won;
  private final int healthBarLength = 50;

  private final float MAX_BUILD_TIME = 30;
  private float buildTimeLeft = MAX_BUILD_TIME;

  private float maxRhythmTime = 10;
  private float rhythmTimeLeft = maxRhythmTime;
  
  private int startingColorIndex = 0;
  private int beats = 0;
  private int turns = 0;
  private float creepHealthMult = 1;
  private int creepSpeedCost = 100;
  private int creepHealthCost = 75;
  private int creepSpawnCost = 125;

  private int[][] world = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
  };
  
  public Tile[][] worldTiles = new Tile[10][20];

  @Override
  public void update() {
    if (isMiniGame) {
      miniGame.draw();
      if (rhythmTimeLeft <= 0)
        onMiniGameEnd();
      else rhythmTimeLeft -= Time.deltaTime;
    } else {
      mapUpdate();
       if(isGameOver) {
        gameOverUpdate();
      } else if (isBuildingState)
        buildingUpdate();
      else 
        attackUpdate();
    }
  }

  @Override
  public void onSceneEnter() {
    for (int i = 0; i < worldRows; ++i) {
      for (int j = 0; j < worldCols; ++j) {
        if ((i >= 3 && i <= 6) && (j == 0 || j == 19)) {
          world[i][j] = 5;
          instantiate(i,j);
        } else
          instantiate(i,j);
      }
    }
    setDanceFloor();
    isBuildingState = true;
  }
  
  @Override
  public void onSceneExit() {
    Time.timeScale = 1;
  }
  
  @Override
  public void onMousePressed() {
    if (isBuildingState) {
      startMiniGame();
    } else if (isGameOver) {
      changeScene(new GameSceneMultiplayer());
    }
  }

  @Override
  public void onKeyPressed() {
    if (isMiniGame) {
      miniGame.onKeyPressed();
    } else if (isBuildingState) {
      //player 1 movements + towers
      PVector p = player1.selectedBuildTile;
      int tile = world[(int)p.y][(int)p.x];
      if((key == 'w' || key == 'W') && p.y > 0)
        p.y--;
      else if((key == 's' || key == 'S') && p.y < worldRows-1)
        p.y++;
      else if((key == 'a' || key == 'A') && p.x > 0)
        p.x--;
      else if((key == 'd' || key == 'D') && p.x < 8)
        p.x++;
      else if(tile < 5) {
        if(keyCode == 49) setTile(p, 6, true);
        else if(keyCode == 50) setTile(p, 7, true);
        else if(keyCode == 51) setTile(p, 8, true);
        else if(keyCode == 52) setTile(p, 9, true);
        else if(keyCode == 53) setTile(p, 10, true);
      } else if(tile == 5) {
        if(keyCode == 49 && player1.fans - 100 >= 0 && player1.creepSpeedMultiplyer < 3.5f) {
          player1.creepSpeedMultiplyer += .25f;
          player1.fans -= creepSpeedCost;
        } else if(keyCode == 50 && player1.fans - 75 >= 0) {
          player1.creepHealthMultiplyer += .25f;
          player1.fans -= creepHealthCost;
        } else if(keyCode == 51 && player1.fans - 125 >= 0 && player1.creepSpawnMultiplyer < 2.0f) {
          player1.creepSpawnMultiplyer += .2f;
          player1.fans -= creepSpawnCost;
        }
      } else if(tile > 5) {
        TowerTile tileObj = (TowerTile) worldTiles[(int)p.y][(int)p.x];
        if(keyCode == 49 && player1.fans - tileObj.getUpgradeFanCost(1) >= 0) {
          if(tileObj.upgrade()) { 
            player1.fans -= tileObj.getUpgradeFanCost(0);
            tileObj.upgradeHealth();
          }
        } else if (keyCode == 50) {
          player1.fans += tileObj.fanCost / 2;
          world[(int)p.y][(int)p.x] = tileObj.backgroundTile.index;
          worldTiles[(int)p.y][(int)p.x] = tileObj.backgroundTile;
        }
      }
        
      // player 2 movements + towers
      p = player2.selectedBuildTile;
      tile = world[(int)p.y][(int)p.x];
      if(keyCode == 38 && p.y > 0)
        p.y--;
      else if(keyCode == 40 && p.y < worldRows-1)
        p.y++;
      else if(keyCode == 37 && p.x > 11)
        p.x--;
      else if(keyCode == 39 && p.x < 19)
        p.x++;
      else if(tile < 5) {
        if(key == '6' || keyCode == 97) setTile(p, 6, false);
        else if(key == '7' || keyCode == 98) setTile(p, 7, false);
        else if(key == '8' || keyCode == 99) setTile(p, 8, false);
        else if(key == '9' || keyCode == 100) setTile(p, 9, false);
        else if(key == '0' || keyCode == 101) setTile(p, 10, false);
      } else if(tile == 5) {
        if((key == '6' || keyCode == 97) && player2.fans - 100 >= 0 && player2.creepSpeedMultiplyer < 4) {
          player2.creepSpeedMultiplyer += .25f;
          player2.fans -= creepSpeedCost;
        } else if((key == '7' || keyCode == 98) && player2.fans - 75 >= 0) {
          player2.creepHealthMultiplyer += .25f;
          player2.fans -= creepHealthCost;
        } else if((key == '8' || keyCode == 99) && player2.fans - 125 >= 0 && player2.creepSpawnMultiplyer < 2.0f) {
          player2.creepSpawnMultiplyer += .2f;
          player2.fans -= creepSpawnCost;
        }
      } else if(tile > 5) {
        TowerTile tileObj = (TowerTile) worldTiles[(int)p.y][(int)p.x];
        if((key == '6' || keyCode == 97) && player2.fans - tileObj.getUpgradeFanCost(1) >= 0) {
          if(tileObj.upgrade()) { 
            player2.fans -= tileObj.getUpgradeFanCost(0);
            tileObj.upgradeHealth();
          }
        } else if (key == '7' || keyCode == 98) {
          player2.fans += tileObj.fanCost / 2;
          world[(int)p.y][(int)p.x] = tileObj.backgroundTile.index;
          worldTiles[(int)p.y][(int)p.x] = tileObj.backgroundTile;
        }
      }
    }
  }
  
  private void setDanceFloor() {
    int index = startingColorIndex;
    for(int i = 0; i < worldRows; ++i) {
      for(int j = i, k = 0; j >=0 && k < worldCols; --j, ++k) {
        changeTile(j,k,index);
      }
      index = (index + 1) % 3;
    }
      
      for(int i = 1; i < worldCols; ++i) {
        for(int j = 9, k = i; j >= 0 && k < worldCols; --j, ++k) {
          changeTile(j,k,index);
        }
        index = (index + 1) % 3;
      }
  }
  
  private void setupScene() {
    //initializing fans and health
    textAlign(LEFT);
    //health bar area
    fill(0, 0, 0, 150);
    noStroke();
    rect(0, 0, 1000, 120);
    //player 1 text
    fill(255);
    text("You: ", 40, 25);
    //enemy text
    text("Enemy: ", 750, 25);
    //player 1 health bar
    image(Images.healthbarBackground, 78, 12, healthBarLength + 2, 20);
    image(Images.healthbar, 79, 13, healthBarLength * player1.healthPercent(), 18);
    //enemy health bar
    image(Images.healthbarBackground, 806, 12, healthBarLength + 2, 20);
    image(Images.healthbar, 807, 13, healthBarLength * player2.healthPercent(), 18);
    //fan icon placeholder
    fill(0, 255, 255);
    rect(250, 10, 40, 20);
    rect(610, 10, 40, 20);
    //fan count
    fill(255);
    text(player1.fans, 310, 25); // p1
    text(player2.fans, 670, 25); //p2
    //dj tower 1
    tint(100, 200, 255);
    image(Images.djStand1, 10, 170, 90, 280);
    noTint();
    //dj tower 2
    image(Images.djStand2, 900, 170, 90, 280);
  }
  
  public void changeTile(int j, int k, int index) {
    if(world[j][k] > 5) {
      worldTiles[j][k].setBackgroundTile(index);
    } else {
      if (!(j >= 3 && j <= 6) || !(k == 0 || k == 19)) {
        world[j][k] = index;
        instantiate(j,k);
      }
    }
  }
  
  private void instantiate(int i, int j) {
    worldTiles[i][j] = tiles.get(world[i][j]).getInstance();
    worldTiles[i][j].pos = tileToCorner(new PVector(j, i));
  }
  
  private void instantiate(int i, int j, int index) {
    worldTiles[i][j] = tiles.get(world[i][j]).getInstance(tiles.get(index));
    PVector p = tileToCorner(new PVector(j, i));
    worldTiles[i][j].pos = p;
    worldTiles[i][j].backgroundTile.pos = p;
  }
  
  private void setTile(PVector p, int num, boolean isPlayer1) {
    Player player = (isPlayer1 ? player1 : player2);
    
    if(player.fans - tiles.get(num).fanCost >= 0) {
      int i = world[(int)p.y][(int)p.x];
      world[(int)p.y][(int)p.x] = num;
      instantiate((int)p.y, (int)p.x, i);
      player.fans -= tiles.get(num).fanCost;
    }
  }
  
  private void gameOver(boolean player1Lost) {
   Time.timeScale = 0;
   isGameOver = true;
   player1Won = !player1Lost;
  }
  
  private void mapUpdate() {
    setupScene();
    beat.detect(currentMusic.mix);
    if(beat.isOnset()) {
      beats++;
      if(beats % 3 == 0)
        startingColorIndex = (startingColorIndex + 1) % 3;
    }
    setDanceFloor();
    for (int i = 0; i < worldRows; ++i)
    {
      for (int j = 0; j < worldCols; ++j) {
        worldTiles[i][j].display();
      }   
    }
  }
  
  private void gameOverUpdate() {
    fill(0);
    textSize(80);
    text("Game Over", 260, 200);
    text("Player " + (player1Won ? "1" : "2") + " won", 240, 300);
    text("Click to restart", 220, 400);
    textSize(12);
  }
  
  private void attackUpdate() {
    for (int i = player1.creeps.size() - 1; i >= 0; --i) {
      creepLoop(true, i);
    }

    for (int i = player2.creeps.size() - 1; i >= 0; --i) {
      creepLoop(false, i);
    }
    
    for (int i = 0; i < worldRows; ++i)
    {
      for (int j = 0; j < worldCols; ++j) {
        worldTiles[i][j].update(this, j < 10);
      }   
    }

    if (player1.creeps.isEmpty() && player2.creeps.isEmpty())
      isBuildingState = true;
  }

  private void buildingUpdate() {
    fill(255);
    text("Building State", 465, 20);

    float startAngle = HALF_PI * -1;
    colorMode(HSB);
    int fillColor = 0;
    float percent = buildTimeLeft / MAX_BUILD_TIME;
    fillColor = (percent > .5 ? 100 : (percent > .25 ? 25 : 5));
    fill(fillColor, 255, 255);
    arc(500, 70, 60, 60, startAngle, startAngle + TWO_PI * percent);  
    colorMode(RGB);
    
    // highlighting player 1 selected tile
    PVector p = player1.selectedBuildTile;
    stroke(0);
    strokeWeight(2);
    noFill();
    PVector t = worldTiles[(int)p.y][(int)p.x].pos;
    rect(t.x, t.y, tileWidth, tileHeight);
    
    // player 1 ui options
    int tile = world[(int)p.y][(int)p.x];
    if(tile < 5) {
      // display tower options 
      p1TowerUI.display();
    } else if (tile == 5) {
      // display creep upgrade options
      fill(255);
      //#1
      text("1:", 30, 80);
      float halfHeight = tileHeight / 2;
      tint(100, 200, 255);
      image(Images.creepNormal1, 60, 75 - halfHeight, tileWidth, tileHeight);
      noTint();
      text((int)(player1.creepSpeedMultiplyer * 100) + "%", 110, 80);
      textSize(10);
      text(creepSpeedCost, 120, 105);
      textSize(12);
      //#2
      text("2:", 170, 80);
      tint(100, 200, 255);
      image(Images.creepNormal1, 190, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player1.creepHealthMultiplyer * 100) + "%", 255, 80);
      tint(220, 0, 0);
      image(Images.healthIcon, 223, 80);
      noTint();
      textSize(10);
      text(creepHealthCost, 260, 105);
      textSize(12);
      //#3
      text("3:", 310, 80);
      tint(100, 200, 255);
      image(Images.creepNormal1, 330, 75 - halfHeight, tileWidth, tileHeight);
      noTint();
      text((int)(player1.creepSpawnMultiplyer * 100) + "%", 395, 80);
      textSize(10);
      text(creepSpawnCost, 400, 105);
      textSize(12);
    } else {
      // display tower upgrade options
      displayUpgradeUI(player1, 30);
      noTint();
    }    
    
    //highlighting player 2 selected tile
    p = player2.selectedBuildTile;
    stroke(0);
    strokeWeight(2);
    noFill();
    t = worldTiles[(int)p.y][(int)p.x].pos;
    rect(t.x, t.y, tileWidth, tileHeight);
    noStroke();
    
    //player 2 ui options
    tile = world[(int)p.y][(int)p.x];
    if(tile < 5) {
      // display tower options 
      p2TowerUI.display();
    } else if (tile == 5) {
      // display creep upgrade options
      fill(255);
      //#1
      text("1:", 570, 80);
      float halfHeight = tileHeight / 2;
      image(Images.creepNormal2, 590, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player2.creepSpeedMultiplyer * 100) + "%", 655, 80);
      textSize(10);
      text(creepSpeedCost, 660, 105);
      textSize(12);
      //#2
      text("2:", 710, 80);
      image(Images.creepNormal2, 745, 75 - halfHeight, tileWidth, tileHeight);
      tint(220, 0, 0);
      image(Images.healthIcon, 735, 80);
      noTint();
      text((int)(player2.creepHealthMultiplyer * 100) + "%", 795, 80);
      textSize(10);
      text(creepHealthCost, 810, 105);
      textSize(12);
      //#3
      text("3:", 850, 80);
      image(Images.creepNormal2, 885, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player2.creepSpawnMultiplyer * 100) + "%", 945, 80);
      textSize(10);
      text(creepHealthCost, 960, 105);
      textSize(12);
    } else {
      displayUpgradeUI(player2, 570);
      noTint();
    }
    
    if (buildTimeLeft <= 0) {
      startMiniGame();
    } else buildTimeLeft -= Time.deltaTime;
  }
  
  private void displayUpgradeUI(Player player, int sX) { //sX = starting X coord
    PVector p = player.selectedBuildTile;
    TowerTile tileObj = (TowerTile) worldTiles[(int)p.y][(int)p.x];
      
    image(tileObj.img, sX, 60, tileWidth, tileHeight);
    fill(255);
    if(tileObj.index == 10) {
      //info for current tower
      image(Images.healthIcon, sX + 48, 73);
      text(tileObj.health, sX + 70, 85);
    } else {
      // info for current tower
      textSize(8);
      image(Images.healthIcon, sX + 38, 42);
      text(tileObj.health, sX + 60, 52);
      image(Images.damageIcon, sX + 38, 62);
      text(tileObj.getDamage(0), sX + 60, 72);
      image(Images.fireSpeedIcon, sX + 38, 82);
      text(fireSpeedConvert(tileObj.getFireSpeed(0)), sX + 60, 92);
      text(tileObj.getRange(0), sX + 60, 112);
      // radius around tower
      tileObj.displayRadius();
      textSize(12);
    }
    fill(255);
    if(tileObj.upgradeIndex + 1 < tileObj.upgrades.length) {
      if(player.fans >= tileObj.getUpgradeFanCost(1))
        tint(255, 255);
      else
        tint(255, 125);
      noStroke();
      rect(sX + 105, 75, 25, 10);
      triangle(sX + 130, 70, sX + 130, 90, sX + 150, 80);
      text("1.", sX + 165, 85);
      image(tileObj.img, sX + 185, 60, tileWidth, tileHeight);
      if(tileObj.index == 10) {
        // info for upgraded tower
        image(Images.healthIcon, sX + 238, 58);
        text(tileObj.upgrades[tileObj.upgradeIndex + 1].health + " (+" + (tileObj.upgrades[tileObj.upgradeIndex + 1].health - tileObj.health) + ")", sX + 260, 70);
        //image(Images.healthIcon, 268, 88);
        text(tileObj.getUpgradeFanCost(1), sX + 260, 100);
        text("2.", sX + 370, 50);
      } else {
        textSize(8);
        image(Images.healthIcon, sX + 223, 47);
        text(tileObj.upgrades[tileObj.upgradeIndex + 1].health + " (+" + (tileObj.upgrades[tileObj.upgradeIndex + 1].health - tileObj.health) + ")", sX + 245, 57);
        image(Images.damageIcon, sX + 225, 72);
        text(tileObj.getDamage(1) + " (+" + (tileObj.getDamage(1) - tileObj.getDamage(0)) + ")", sX + 245, 82);
        image(Images.fireSpeedIcon, sX + 225, 97);
        text(fireSpeedConvert(tileObj.getFireSpeed(1)) + " (+" + (fireSpeedConvert(tileObj.getFireSpeed(1)) - fireSpeedConvert(tileObj.getFireSpeed(0))) + ")", sX + 245, 107);
        text(tileObj.getRange(1) + " (+" + (tileObj.getRange(1) - tileObj.getRange(0)) + ")", sX + 315, 70);
        text(tileObj.getUpgradeFanCost(1), sX + 315, 95);
        textSize(12);
        text("2.", sX + 390, 50);
      }
    }
  }
   
  private void creepLoop(boolean isPlayer1, int i) {
    Player player = (isPlayer1 ? player1 : player2);
    Player enemy = (isPlayer1 ? player2 : player1);
    Creep c = player.creeps.get(i);
    if(c.timeToLeave <= 0) c.update();
    else c.timeUpdate();
    
    Tile t = null;
    boolean isOwnTower = false;
    if(c.nextTile != null) {
      t = worldTiles[(int)c.nextTile.y][(int)c.nextTile.x];
      isOwnTower = (isPlayer1 && c.nextTile.x < 9) || (!isPlayer1 && c.nextTile.x > 9);
    }
      
    if(t != null && t.index > 5 && !isOwnTower) {
      TowerTile tt = (TowerTile) t;
      if(tt.health - 25 > 0) tt.health -= 25;
      else {
        world[(int)c.nextTile.y][(int)c.nextTile.x] = t.backgroundTile.index;
        worldTiles[(int)c.nextTile.y][(int)c.nextTile.x] = t.backgroundTile;
      }
      player.creeps.remove(i);
    } else if (c.isDead) {
      if(c.health > 0) {
          if(enemy.health - 25 > 0)
            enemy.health -= 25;
          else
            gameOver(!isPlayer1);
        player.fans += 20;
      } else {
        player.fans += 10;
      }
      player.creeps.remove(i);
    }
  }

  private void startMiniGame() {
    isBuildingState = false;
    buildTimeLeft = MAX_BUILD_TIME;
    isMiniGame = true;
    miniGame = new RhythmGame(player1, player2, (int) random(0, miniGameSongs.length), maxRhythmTime, creepHealthMult);
    maxRhythmTime += 3;
    turns++;
    if(turns % 3 == 0) {
      creepHealthMult += .3f;
    }
    
    //pause background music
    currentMusic.pause();
    musicPaused = true;
  }
  
  private void onMiniGameEnd() {
    rhythmTimeLeft = maxRhythmTime;
    miniGame.player.pause();
    isMiniGame = false;
    // resume background music
    currentMusic.play();
    musicPaused = false;
    
    //remake map for pathfinder
    for(int i = 0; i < worldRows; ++i) {
      for(int j = 0; j < worldCols; ++j) {
        PathTile pt = new PathTile();
        Tile t = tiles.get(world[i][j]);
        
        pt.cost = t.cost;
        pt.x = j;
        pt.y = i;
        
        Pathfinder.worldTiles[i][j] = pt;
      }
    }
    
    for(int i = 0; i < worldRows; ++i) {
      for(int j = 0; j < worldCols; ++j) {
        Pathfinder.worldTiles[i][j].setNeighbors();
      }
    }
    
    // find paths
    for (int i = 0; i < player1.creeps.size(); ++i) {
      player1.creeps.get(i).findPath();
    }

    for (int i = 0; i < player2.creeps.size(); ++i) {
      player2.creeps.get(i).findPath();
    }
  }
}
