public static class AI {
  
  private static PApplet applet;
  
  public static void chooseComputerTowers(GameSceneSingleplayer scene) {
    scene.aiTowers.clear();
    scene.aiPos.clear();
    scene.aiUpgrades.clear();
    int tempFans = scene.player2.fans;
    if(scene.turns == 0) {
      scene.aiTowers.add(6);
      scene.aiPos.add(new PVector(16, 3));
      scene.aiTowers.add(6);
      scene.aiPos.add(new PVector(16, 4));
      scene.aiTowers.add(6);
      scene.aiPos.add(new PVector(16, 6));
    } else {
      boolean restart = true;
      switch(scene.difficulty) {
        case 1:
          restart = true;
          while(restart) {
            if(scene.turns < 5) {
              if(tempFans >= 120) {
                float rand = applet.random(0, 1);
                if(rand <= .75f) {
                  scene.aiTowers.add(6);
                  scene.aiPos.add(chooseNonRepeatingTile(scene));
                  scene.aiTowers.add(6);
                  scene.aiPos.add(chooseNonRepeatingTile(scene));
                  tempFans -= 120;
                } else {
                  int rand1 = (int)applet.random(1, 3);
                  scene.aiUpgrades.add(rand1);
                  tempFans -= (rand1 == 1 ? 100 : 75);
                }
              } else if(tempFans >= 60) {
                scene.aiTowers.add(6);
                scene.aiPos.add(chooseNonRepeatingTile(scene));
                tempFans -= 60;
              } else restart = false;
            } else {
              if(tempFans >= 400) {
                if(applet.random(0,1) > .33f) {
                  scene.aiTowers.add(9);
                  scene.aiPos.add(new PVector((int)applet.random(12, 19), (int)applet.random(0, 9)));  
                  tempFans -= 400;
                }
              }
              if(tempFans >= 200) {
                float rand = applet.random(0,1);
                if(rand < .15f) {
                  scene.aiTowers.add(7);
                  scene.aiPos.add(new PVector((int)applet.random(12, 19), (int)applet.random(0, 9)));
                  tempFans -= 200;
                } else if(rand < .3f) {
                  scene.aiTowers.add(8);
                  scene.aiPos.add(new PVector((int)applet.random(12, 19), (int)applet.random(0, 9)));
                  tempFans -= 200;
                }
              } else if(tempFans >= 125) {
                if(applet.random(0,1) > .5f) {
                  scene.aiUpgrades.add(3);
                  tempFans -= 125;
                }
              } else if(tempFans >= 100) {
                if(applet.random(0,1) > .25f) {
                  scene.aiUpgrades.add(1);
                  tempFans -= 100;
                }
              } else if(tempFans >= 75) {
                if(applet.random(0,1) > .5f) {
                  scene.aiUpgrades.add(2);
                  tempFans -= 75;
                }
              } else if(tempFans >= 60) {
                scene.aiTowers.add(6);
                scene.aiPos.add(new PVector((int)applet.random(12, 19), (int)applet.random(0, 9)));
                tempFans -= 60;
              } else restart = false;             
            }
          }
          break;
        case 2:
          //temporary hard ai, its the same as easy
          restart = true;
          while(restart) {
            if(scene.turns < 5) {
              if(tempFans >= 120) {
                float rand = applet.random(0, 1);
                if(rand <= .75f) {
                  scene.aiTowers.add(6);
                  scene.aiPos.add(chooseNonRepeatingTile(scene));
                  scene.aiTowers.add(6);
                  scene.aiPos.add(chooseNonRepeatingTile(scene));
                  tempFans -= 120;
                } else {
                  int rand1 = (int)applet.random(1, 3);
                  scene.aiUpgrades.add(rand1);
                  tempFans -= (rand1 == 1 ? 100 : 75);
                }
              } else if(tempFans >= 60) {
                scene.aiTowers.add(6);
                scene.aiPos.add(chooseNonRepeatingTile(scene));
                tempFans -= 60;
              } else restart = false;
            } else {
              if(tempFans >= 400) {
                if(applet.random(0,1) > .33f) {
                  scene.aiTowers.add(9);
                  scene.aiPos.add(new PVector((int)applet.random(12, 19), (int)applet.random(0, 9)));  
                  tempFans -= 400;
                }
              }
              if(tempFans >= 200) {
                float rand = applet.random(0,1);
                if(rand < .15f) {
                  scene.aiTowers.add(7);
                  scene.aiPos.add(new PVector((int)applet.random(12, 19), (int)applet.random(0, 9)));
                  tempFans -= 200;
                } else if(rand < .3f) {
                  scene.aiTowers.add(8);
                  scene.aiPos.add(new PVector((int)applet.random(12, 19), (int)applet.random(0, 9)));
                  tempFans -= 200;
                }
              } else if(tempFans >= 125) {
                if(applet.random(0,1) > .5f) {
                  scene.aiUpgrades.add(3);
                  tempFans -= 125;
                }
              } else if(tempFans >= 100) {
                if(applet.random(0,1) > .25f) {
                  scene.aiUpgrades.add(1);
                  tempFans -= 100;
                }
              } else if(tempFans >= 75) {
                if(applet.random(0,1) > .5f) {
                  scene.aiUpgrades.add(2);
                  tempFans -= 75;
                }
              } else if(tempFans >= 60) {
                scene.aiTowers.add(6);
                scene.aiPos.add(new PVector((int)applet.random(12, 19), (int)applet.random(0, 9)));
                tempFans -= 60;
              } else restart = false;             
            }
          }
          break;
        default:
      }
    }
  }
  
  private static PVector chooseNonRepeatingTile(GameSceneSingleplayer scene) {
    PVector p;
    do {
      p = new PVector((int)applet.random(12, 19), (int)applet.random(3, 7));
    } while(scene.worldTiles[(int)p.y][(int)p.x].index > 5);
    return p;
  }
}
