import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


HashMap<Integer, Tile> tiles = new HashMap<Integer, Tile>();
Scene scene;
AudioPlayer song;
Minim minim;

final int tileHeight = 38;
final int tileWidth = 40;

final int worldRows = 10;
final int worldCols = 20;

final int GRID_START_X = 100;
final int GRID_START_Y = 120;

void setup() {
  size(1000, 500);
  minim = new Minim(this);
  //colorMode(HSB);
  tiles.put(0, new RedTile());
  tiles.put(1, new BlueTile());
  tiles.put(2, new YellowTile());
  tiles.put(3, new OrangeTile());
  tiles.put(4, new SpawnTile());
  scene = new GameSceneMultiplayer();
  scene.onSceneEnter();
}

void draw() {
  background(128);
  Time.update(millis());
  
  Scene newScene = scene.update();
  if(newScene != null) {
    scene.onSceneExit();
    scene = newScene;
    scene.onSceneEnter();
    Time.newScene();
  }
}

void mousePressed() {
  scene.onMousePressed();
}

void keyPressed() {
  scene.onKeyPressed();
}
