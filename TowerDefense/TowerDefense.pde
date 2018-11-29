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
AudioPlayer backgroundMusic1;
AudioPlayer backgroundMusic2;
AudioPlayer currentMusic;
boolean musicPaused = false;
BeatDetect beat;
Minim minim;

final int tileHeight = 38;
final int tileWidth = 40;

final int worldRows = 10;
final int worldCols = 20;

final int GRID_START_X = 100;
final int GRID_START_Y = 120;

void setup() {
  size(1000, 500);
  initImages();
  minim = new Minim(this);
  beat = new BeatDetect();
  songs = new String[]{ "song.mp3", "Dragonforce - Through the Fire and Flames(Lyrics).mp3"};
  backgroundMusic1 = minim.loadFile("backgroundMusic1.mp3");
  backgroundMusic2 = minim.loadFile("backgroundMusic2.mp3");
  currentMusic = backgroundMusic1;
  currentMusic.play();
  tiles.put(0, new RedTile());
  tiles.put(1, new OrangeTile());
  tiles.put(2, new YellowTile());
  tiles.put(5, new SpawnTile());
  tiles.put(6, new StandardTower());
  tiles.put(7, new BruiserTower());
  tiles.put(8, new GlacierTower());
  tiles.put(9, new LightningTower());
  tiles.put(10, new WallTower());
  scene = new GameSceneMultiplayer();
  scene.onSceneEnter();
}

void draw() {
  background(128);
  Time.update(millis());
  
  if(!currentMusic.isPlaying() && !musicPaused) {
    currentMusic = (currentMusic.equals(backgroundMusic1) ? backgroundMusic2 : backgroundMusic1);
    currentMusic.play();
  }
  
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

PVector tileToCorner(PVector p) {
  return new PVector(p.x * tileWidth + GRID_START_X, p.y * tileHeight + GRID_START_Y);
}

int fireSpeedConvert(float fireSpeed) {
  if(fireSpeed == 0)
    return 0;
  return (int)(1 / (fireSpeed * 4) * 100);
}

private void initImages() {
  Images.standardTower = loadImage("tower_1_standard.png");
  Images.bruiserTower = loadImage("tower_2_bruiser.png");
  Images.glacierTower = loadImage("tower_3_glacier.png");
  Images.lightningTower = loadImage("tower_4_lightning.png");
  Images.wall = loadImage("tower_5_wall.png");
  
  Images.djStand1 = loadImage("DJ_Stand_Player1.png");
  Images.djStand2 = loadImage("DJ_Stand_Player2.png");
  
  Images.creepNormal1 = loadImage("Creep_Player1_Normal.png");
  Images.creepNormal2 = loadImage("Creep_Player2_Normal.png");
  Images.creepUpgraded1 = loadImage("Creep_Player1_Upgraded.png");
  Images.creepUpgraded2 = loadImage("Creep_Player2_Upgraded.png");
  
  Images.orangeTile = loadImage("floor_tiles_orange.png");
  Images.yellowTile = loadImage("floor_tiles_yellow.png");
  Images.redTile = loadImage("floor_tiles_red.png");
  Images.spawnTile = loadImage("floor_tiles_purple.png");
}
