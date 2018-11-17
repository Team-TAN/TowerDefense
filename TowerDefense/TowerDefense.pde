import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.Queue;
import java.util.LinkedList;


HashMap<Integer, Tile> tiles = new HashMap<Integer, Tile>();
String[] songs;
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
  songs = new String[]{ "song.mp3", "Dragonforce - Through the Fire and Flames(Lyrics).mp3"};
  //colorMode(HSB);
  tiles.put(0, new RedTile());
  tiles.put(1, new OrangeTile());
  tiles.put(2, new YellowTile());
  tiles.put(3, new BlueTile());
  tiles.put(4, new GreenTile());
  tiles.put(5, new SpawnTile());
  tiles.put(6, new StandardTower());
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

PVector tileToPoint(PVector p) {
  return new PVector((p.x + 0.5)* tileWidth + GRID_START_X, (p.y + 0.5) * tileHeight + GRID_START_Y);
}
