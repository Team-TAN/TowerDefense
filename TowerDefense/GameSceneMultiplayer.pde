public class GameSceneMultiplayer extends Scene {

  private RhythmGame miniGame = null;

  public Player player1 = new Player(new PVector(0,0));
  public Player player2 = new Player(new PVector(19, 0));


  private boolean isBuildingState;
  private boolean isMiniGame = false;
  private final int healthBarLength = 100;

  private final float MAX_BUILD_TIME = 20;
  private float buildTimeLeft = MAX_BUILD_TIME;

  private final float MAX_RHYTHM_TIME = 10;
  private float rhythmTimeLeft = MAX_RHYTHM_TIME;
  
  private int startingColorIndex = 0;

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
    
    //highlighting player 2 selected tile
    p = player2.selectedBuildTile;
    stroke(0);
    strokeWeight(2);
    noFill();
    t = worldTiles[(int)p.y][(int)p.x].pos;
    rect(t.x, t.y, tileWidth, tileHeight);
    noStroke();
    
    if (buildTimeLeft <= 0) {
      startMiniGame();
    } else buildTimeLeft -= Time.deltaTime;
  }
  
  private void attackUpdate() {
    for (int i = player1.creeps.size() - 1; i >= 0; --i) {
      Creep c = player1.creeps.get(i);
      if(c.timeToLeave <= 0) c.update();
      else c.timeUpdate(); 
      
      if (c.isDead)
        player1.creeps.remove(i);
    }

    for (int i = player2.creeps.size() - 1; i >= 0; --i) {
      Creep c = player2.creeps.get(i);
      if(c.timeToLeave <= 0) c.update();
      else c.timeUpdate(); 
      
      if (c.isDead)
        player2.creeps.remove(i);
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
    miniGame = new RhythmGame(player1, player2, 0, MAX_RHYTHM_TIME);
    //pause background music
  }
  
  private void onMiniGameEnd() {
    rhythmTimeLeft = MAX_RHYTHM_TIME;
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
      //player 1 movements ++ towers
      PVector p = player1.selectedBuildTile;
      if(key == 'w' && p.y > 0 && !(p.y == 7 && p.x == 0))
        p.y--;
      else if(key == 's' && p.y < worldRows-1 && !(p.y == 2 && p.x == 0))
        p.y++;
      else if(key == 'a' && p.x > 0 && !(p.x == 1 && p.y > 2 && p.y < 7))
        p.x--;
      else if(key == 'd' && p.x < 8)
        p.x++;
      else if(world[(int)p.y][(int)p.x] < 5) {
        if(key == '1') setTile(p, 6);
        else if(key == '2') setTile(p, 7);
        else if(key == '3') setTile(p, 8);
        else if(key == '4') setTile(p, 9);
        else if(key == '5') setTile(p, 10);
      }
        
      // player 1 movements + towers
      p = player2.selectedBuildTile;
      if(keyCode == 38 && p.y > 0 && !(p.y == 7 && p.x == 19))
        p.y--;
      else if(keyCode == 40 && p.y < worldRows-1 && !(p.y == 2 && p.x == 19))
        p.y++;
      else if(keyCode == 37 && p.x > 11)
        p.x--;
      else if(keyCode == 39 && p.x < 19 && !(p.x == 18 && p.y > 2 && p.y < 7))
        p.x++;
      else if(world[(int)p.y][(int)p.x] < 5) {
        if(key == '6') setTile(p, 6);
        else if(key == '7') setTile(p, 7);
        else if(key == '8') setTile(p, 8);
        else if(key == '9') setTile(p, 9);
        else if(key == '0') setTile(p, 10);
      }
      
    }
  }
  
  private void setTile(PVector p, int num) {
    int i = world[(int)p.y][(int)p.x];
    world[(int)p.y][(int)p.x] = num;
    instantiate((int)p.y, (int)p.x, i);
  }
}
