public class GameSceneMultiplayer extends Scene {

  private RhythmGame miniGame = null;

  public Player player1 = new Player(new PVector(0,0));
  public Player player2 = new Player(new PVector(19, 0));

  private boolean isBuildingState;
  private boolean isMiniGame = false;
  private final int healthBarLength = 100;

  private final float MAX_BUILD_TIME = 20;
  private float buildTimeLeft = MAX_BUILD_TIME;

  private float maxRhythmTime = 10;
  private float rhythmTimeLeft = maxRhythmTime;
  
  private int startingColorIndex = 0;
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
      if (isBuildingState) {
        buildingUpdate();
      } else {
        attackUpdate();
      }
    }
    return null;
  }

  

  public void onSceneEnter() {
    // start background music
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
      index = (index + 1) % 2;
    }
      
      for(int i = 1; i < worldCols; ++i) {
        for(int j = 9, k = i; j >= 0 && k < worldCols; --j, ++k) {
          changeTile(j,k,index);
        }
        index = (index + 1) % 2;
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
    text("You: ", 40, 30);
    //enemy text
    text("Enemy: ", 750, 30);
    //player 1 health bar
    fill(0, 200, 0);
    rect(100, 15, healthBarLength * player1.healthPercent(), 25);
    //enemy health bar
    fill(0, 200, 0);
    rect(825, 15, healthBarLength * player2.healthPercent(), 25);
    //fan icon placeholder
    fill(0, 255, 255);
    rect(250, 15, 40, 30);
    rect(610, 15, 40, 30);
    //fan count
    fill(255);
    text(player1.fans, 310, 34); // p1
    text(player2.fans, 670, 34); //p2
    //dj tower 1
    image(Images.djStand1, 10, 170, 90, 280);
    //dj tower 2
    image(Images.djStand2, 900, 170, 90, 280);
  }

  private void mapUpdate() {
    setupScene();
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
      switch(tile) {
        case 6: img = Images.standardTower; break;
        case 7: img = Images.bruiserTower; break;
        case 8: img = Images.glacierTower; break;
        case 9: img = Images.lightningTower; break;
        default: img = Images.wall; break;
      }
      
      image(img, 40, 60, tileWidth, tileHeight);
      if(tile == 10) {
        
      } else {
        
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
    }
    
    if (buildTimeLeft <= 0) {
      startMiniGame();
    } else buildTimeLeft -= Time.deltaTime;
  }
  
  private void attackUpdate() {
    for (int i = player1.creeps.size() - 1; i >= 0; --i) {
      Creep c = player1.creeps.get(i);
      if(c.timeToLeave <= 0) c.update();
      else c.timeUpdate(); 
      
      if (c.isDead) {
        player1.creeps.remove(i);
        player1.fans += (c.health > 0 ? 20 : 10);
      }
    }

    for (int i = player2.creeps.size() - 1; i >= 0; --i) {
      Creep c = player2.creeps.get(i);
      if(c.timeToLeave <= 0) c.update();
      else c.timeUpdate(); 
      
      if (c.isDead) {
        player2.creeps.remove(i);
        player2.fans += (c.health > 0 ? 20 : 10);
      }
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
  }
  
  private void onMiniGameEnd() {
    rhythmTimeLeft = maxRhythmTime;
    miniGame.player.pause();
    isMiniGame = false;
    // resume background music
    
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
    }
  }

  public void onKeyPressed() {
    if (isMiniGame) {
      miniGame.onKeyPressed();
    } else if (isBuildingState) {
      //player 1 movements + towers
      PVector p = player1.selectedBuildTile;
      int tile = world[(int)p.y][(int)p.x];
      Tile tileObj = worldTiles[(int)p.y][(int)p.x];
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
        if(key == '1' && player1.fans - tileObj.getUpgradeFanCost(1) >= 0) {
          if(tileObj.upgrade()) player1.fans -= tileObj.getUpgradeFanCost(0); 
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
        if(key == '6') setTile(p, 6, false);
        else if(key == '7') setTile(p, 7, false);
        else if(key == '8') setTile(p, 8, false);
        else if(key == '9') setTile(p, 9, false);
        else if(key == '0') setTile(p, 10, false);
      } else if(tile == 5) {
        if(key == '6' && player2.fans - 100 >= 0 && player2.creepSpeedMultiplyer < 4) {
          player2.creepSpeedMultiplyer += .25f;
          player2.fans -= 100;
        } else if(key == '7' && player2.fans - 75 >= 0) {
          player2.creepHealthMultiplyer += .25f;
          player2.fans -= 75;
        } else if(key == '8' && player2.fans - 125 >= 0 && player2.creepSpawnMultiplyer < 2.0f) {
          player2.creepSpawnMultiplyer += .2f;
          player2.fans -= 125;
        }
      } else if(tile > 5) {
        
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
}
