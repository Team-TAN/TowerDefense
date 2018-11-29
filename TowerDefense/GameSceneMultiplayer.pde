public class GameSceneMultiplayer extends Scene {

  private RhythmGame miniGame = null;

  public Player player1 = new Player(new PVector(0,0));
  public Player player2 = new Player(new PVector(19, 0));
  
  UI p1TowerUI = new UI(10, player1);
  UI p2TowerUI = new UI(545, player2);

  private boolean isBuildingState;
  private boolean isMiniGame = false;
  private boolean isGameOver = false;
  private boolean player1Won;
  private boolean restart = false;
  private final int healthBarLength = 100;

  private final float MAX_BUILD_TIME = 30;
  private float buildTimeLeft = MAX_BUILD_TIME;

  private float maxRhythmTime = 10;
  private float rhythmTimeLeft = maxRhythmTime;
  
  private int startingColorIndex = 0;
  private int beats = 0;
  private int turns = 0;
  private float creepHealthMult = 1;

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


  public Scene update() {
    if (isMiniGame) {
      miniGame.draw();
      if (rhythmTimeLeft <= 0) {
        onMiniGameEnd();
      } else rhythmTimeLeft -= Time.deltaTime;
    } else {
      mapUpdate();
       if(isGameOver) {
        gameOverUpdate();
        if(restart) return new GameSceneMultiplayer();
      } else if (isBuildingState) {
        buildingUpdate();
      }else {
        attackUpdate();
      }
    }
    
    return null;
  }

  

  public void onSceneEnter() {
    for (int i = 0; i < worldRows; ++i)
    {
      for (int j = 0; j < worldCols; ++j) {
        if ((i >= 3 && i <= 6) && (j == 0 || j == 19)) {
          world[i][j] = 5;
          instantiate(i,j);
        } else {
          instantiate(i,j);
        }
      }
    }
      
    setDanceFloor();
    isBuildingState = true;
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

  public void onSceneExit() {
    Time.timeScale = 1;
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
    fill(0, 200, 0);
    rect(100, 10, healthBarLength * player1.healthPercent(), 25);
    //enemy health bar
    fill(0, 200, 0);
    rect(825, 10, healthBarLength * player2.healthPercent(), 25);
    //fan icon placeholder
    fill(0, 255, 255);
    rect(250, 10, 40, 20);
    rect(610, 10, 40, 20);
    //fan count
    fill(255);
    text(player1.fans, 310, 25); // p1
    text(player2.fans, 670, 25); //p2
    //dj tower 1
    image(Images.djStand1, 10, 170, 90, 280);
    //dj tower 2
    image(Images.djStand2, 900, 170, 90, 280);
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
      image(Images.creepNormal1, 60, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player1.creepSpeedMultiplyer * 100) + "%", 110, 80);
      //#2
      text("2:", 170, 80);
      image(Images.creepNormal1, 190, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player1.creepHealthMultiplyer * 100) + "%", 255, 80);
      //#3
      text("3:", 310, 80);
      image(Images.creepNormal1, 330, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player1.creepSpawnMultiplyer * 100) + "%", 395, 80);
    } else {
      // display tower upgrade options
      PImage img;
      TowerTile tileObj = (TowerTile) worldTiles[(int)p.y][(int)p.x];
      switch(tile) {
        case 6: img = Images.standardTower; break;
        case 7: img = Images.bruiserTower; break;
        case 8: img = Images.glacierTower; break;
        case 9: img = Images.lightningTower; break;
        default: img = Images.wall; break;
      }
      
      image(img, 30, 60, tileWidth, tileHeight);
      fill(255);
      if(tile == 10) {
        //info for current tower
        text(tileObj.health, 100, 85);
      } else {
        // info for current tower
        textSize(8);
        text(tileObj.health, 90, 52);
        text(tileObj.getDamage(0), 90, 72);
        text(fireSpeedConvert(tileObj.getFireSpeed(0)), 90, 92);
        text(tileObj.getRange(0), 90, 112);
        // radius around tower
        tileObj.displayRadius();
        textSize(12);
      }
      fill(255);
      if(tileObj.upgradeIndex + 1 < tileObj.upgrades.length) {
        noStroke();
        rect(135, 75, 25, 10);
        triangle(160, 70, 160, 90, 180, 80);
        text("1.", 195, 85);
        image(img, 215, 60, tileWidth, tileHeight);
        if(tile == 10) {
          // info for upgraded tower
          text(tileObj.upgrades[tileObj.upgradeIndex + 1].health + " (+" + (tileObj.upgrades[tileObj.upgradeIndex + 1].health - tileObj.health) + ")", 290, 70);
          text(tileObj.getUpgradeFanCost(1), 290, 100);
        } else {
          textSize(8);
          text(tileObj.upgrades[tileObj.upgradeIndex + 1].health + " (+" + (tileObj.upgrades[tileObj.upgradeIndex + 1].health - tileObj.health) + ")", 275, 57);
          text(tileObj.getDamage(1) + " (+" + (tileObj.getDamage(1) - tileObj.getDamage(0)) + ")", 275, 82);
          text(fireSpeedConvert(tileObj.getFireSpeed(1)) + " (+" + (fireSpeedConvert(tileObj.getFireSpeed(1)) - fireSpeedConvert(tileObj.getFireSpeed(0))) + ")", 275, 107);
          text(tileObj.getRange(1) + " (+" + (tileObj.getRange(1) - tileObj.getRange(0)) + ")", 360, 70);
          text(tileObj.getUpgradeFanCost(1), 360, 95);
          textSize(12);
        }
      }
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
      image(Images.creepNormal2, 600, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player2.creepSpeedMultiplyer * 100) + "%", 650, 80);
      //#2
      text("2:", 710, 80);
      image(Images.creepNormal2, 730, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player2.creepHealthMultiplyer * 100) + "%", 795, 80);
      //#3
      text("3:", 850, 80);
      image(Images.creepNormal2, 870, 75 - halfHeight, tileWidth, tileHeight);
      text((int)(player2.creepSpawnMultiplyer * 100) + "%", 945, 80);
    } else {
      // display tower upgrade options
      PImage img;
      TowerTile tileObj = (TowerTile) worldTiles[(int)p.y][(int)p.x];
      switch(tile) {
        case 6: img = Images.standardTower; break;
        case 7: img = Images.bruiserTower; break;
        case 8: img = Images.glacierTower; break;
        case 9: img = Images.lightningTower; break;
        default: img = Images.wall; break;
      }
      
      image(img, 570, 60, tileWidth, tileHeight);
      fill(255);
      if(tile == 10) {
        // info for current tower
        text(tileObj.health, 640, 85);
      } else {
        // info for current tower
        textSize(8);
        text(tileObj.health, 630, 52);
        text(tileObj.getDamage(0), 630, 72);
        text(fireSpeedConvert(tileObj.getFireSpeed(0)), 630, 92);
        text(tileObj.getRange(0), 630, 112);
        // radius around tower
        tileObj.displayRadius();
        textSize(12);
      }
      fill(255);
      if(tileObj.upgradeIndex + 1 < tileObj.upgrades.length) {
        noStroke();
        rect(685, 75, 25, 10);
        triangle(700, 70, 700, 90, 720, 80);
        text("1.", 735, 85);
        image(img, 755, 60, tileWidth, tileHeight);
        if(tile == 10) {
          // info for upgraded tower
          text(tileObj.upgrades[tileObj.upgradeIndex + 1].health + " (+" + (tileObj.upgrades[tileObj.upgradeIndex + 1].health - tileObj.health) + ")", 830, 70);
          text(tileObj.getUpgradeFanCost(1), 830, 100);
        } else {
          textSize(8);
          text(tileObj.upgrades[tileObj.upgradeIndex + 1].health + " (+" + (tileObj.upgrades[tileObj.upgradeIndex + 1].health - tileObj.health) + ")", 815, 57);
          text(tileObj.getDamage(1) + " (+" + (tileObj.getDamage(1) - tileObj.getDamage(0)) + ")", 815, 82);
          text(fireSpeedConvert(tileObj.getFireSpeed(1)) + " (+" + (fireSpeedConvert(tileObj.getFireSpeed(1)) - fireSpeedConvert(tileObj.getFireSpeed(0))) + ")", 815, 107);
          text(tileObj.getRange(1) + " (+" + (tileObj.getRange(1) - tileObj.getRange(0)) + ")", 900, 70);
          text(tileObj.getUpgradeFanCost(1), 900, 95);
          textSize(12);
        }
      }
    }
    
    if (buildTimeLeft <= 0) {
      startMiniGame();
    } else buildTimeLeft -= Time.deltaTime;
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

    if (player1.creeps.isEmpty() && player2.creeps.isEmpty()) {
      isBuildingState = true;
    }
  }
  
  public void creepLoop(boolean isPlayer1, int i) {
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
    miniGame = new RhythmGame(player1, player2, 0, maxRhythmTime, creepHealthMult);
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
  
  public void onMousePressed() {
    if (isBuildingState) {
      startMiniGame();
    } else if (isGameOver) {
      restart = true;
    }
  }

  public void onKeyPressed() {
    if (isMiniGame) {
      miniGame.onKeyPressed();
    } else if (isBuildingState) {
      //player 1 movements + towers
      PVector p = player1.selectedBuildTile;
      int tile = world[(int)p.y][(int)p.x];
      if(key == 'w' && p.y > 0)
        p.y--;
      else if(key == 's' && p.y < worldRows-1)
        p.y++;
      else if(key == 'a' && p.x > 0)
        p.x--;
      else if(key == 'd' && p.x < 8)
        p.x++;
      else if(tile < 5) {
        if(key == '1') setTile(p, 6, true);
        else if(key == '2') setTile(p, 7, true);
        else if(key == '3') setTile(p, 8, true);
        else if(key == '4') setTile(p, 9, true);
        else if(key == '5') setTile(p, 10, true);
      } else if(tile == 5) {
        if(key == '1' && player1.fans - 100 >= 0 && player1.creepSpeedMultiplyer < 3.5f) {
          player1.creepSpeedMultiplyer += .25f;
          player1.fans -= 100;
        } else if(key == '2' && player1.fans - 75 >= 0) {
          player1.creepHealthMultiplyer += .25f;
          player1.fans -= 75;
        } else if(key == '3' && player1.fans - 125 >= 0 && player1.creepSpawnMultiplyer < 2.0f) {
          player1.creepSpawnMultiplyer += .2f;
          player1.fans -= 125;
        }
      } else if(tile > 5) {
        TowerTile tileObj = (TowerTile) worldTiles[(int)p.y][(int)p.x];
        if(key == '1' && player1.fans - tileObj.getUpgradeFanCost(1) >= 0) {
          if(tileObj.upgrade()) { 
            player1.fans -= tileObj.getUpgradeFanCost(0);
            tileObj.upgradeHealth();
          }
        } else if (key == '2') {
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
          player2.fans -= 100;
        } else if((key == '7' || keyCode == 98) && player2.fans - 75 >= 0) {
          player2.creepHealthMultiplyer += .25f;
          player2.fans -= 75;
        } else if((key == '8' || keyCode == 99) && player2.fans - 125 >= 0 && player2.creepSpawnMultiplyer < 2.0f) {
          player2.creepSpawnMultiplyer += .2f;
          player2.fans -= 125;
        }
      } else if(tile > 5) {
        TowerTile tileObj = (TowerTile) worldTiles[(int)p.y][(int)p.x];
        if((key == '6' || keyCode == 97) && player1.fans - tileObj.getUpgradeFanCost(1) >= 0) {
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
}
