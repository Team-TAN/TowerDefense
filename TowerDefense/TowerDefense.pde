/* TODO:
Art:
  Icons - coins/fans, speed for creep upgrades, spawn time (little clock), range(maybe just a circle with a reticle in it), a red x to delete towers
  UI - a better background for the ui, and around the dj stands
  Other - projectile art (something like a lightning bolt, possibly different for each tower, would need to be able to be strechted up to 300 pixels and not look grainy).
Music:
  More mini game songs
Code:
  Possible do player select. Would need art assets for each player, would probably need greyscale images to tint for each player
  Possibly have a game over scene, or just a prettier game over message when the game is over
  Balance the Game
Rhythm Game:
  Revamp art, fade out volume near the end.
Main Menu:
  play button, instructions button, credits page for all the music
*/

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.Queue;
import java.util.LinkedList;


HashMap<Integer, Tile> tiles = new HashMap<Integer, Tile>();
AudioPlayer[] miniGameSongs;// = new AudioPlayer[3];
AudioPlayer[] miniGameSongsDummy;
Scene scene;
AudioPlayer[] backgroundMusic;// = new AudioPlayer[3];
AudioPlayer currentMusic;
int currentMusicIndex = 0;
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
  initMusic();
  initImages();
  tiles.put(0, new RedTile());
  tiles.put(1, new OrangeTile());
  tiles.put(2, new YellowTile());
  tiles.put(5, new SpawnTile());
  tiles.put(6, new StandardTower());
  tiles.put(7, new BruiserTower());
  tiles.put(8, new GlacierTower());
  tiles.put(9, new LightningTower());
  tiles.put(10, new WallTower());
  scene = new MainMenu();
  scene.onSceneEnter();
}

void draw() {
  background(128);
  Time.update(millis());
  
  if(!currentMusic.isPlaying() && !musicPaused) {
    currentMusic.rewind();
    currentMusicIndex = (currentMusicIndex + 1) % backgroundMusic.length;
    currentMusic = backgroundMusic[currentMusicIndex];
    currentMusic.play();
  }
  scene.update();
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

private void initMusic() {
  minim = new Minim(this);
  beat = new BeatDetect();
  miniGameSongs = new AudioPlayer[]{ minim.loadFile("MGM-A_Meeting_of_Genres.mp3"), minim.loadFile("MGM-Funky_Love_Disco_Pump.mp3"), minim.loadFile("MGM-Party_in_the_Jungle.mp3") };
  miniGameSongsDummy = new AudioPlayer[]{ minim.loadFile("MGM-A_Meeting_of_Genres.mp3"), minim.loadFile("MGM-Funky_Love_Disco_Pump.mp3"), minim.loadFile("MGM-Party_in_the_Jungle.mp3") };
  backgroundMusic = new AudioPlayer[] { minim.loadFile("backgroundMusic1.mp3"), minim.loadFile("backgroundMusic2.mp3"), minim.loadFile("BGM-Disco_Attempt_1.mp3")};
  currentMusicIndex = (int) random(0, backgroundMusic.length);
  currentMusic = backgroundMusic[currentMusicIndex];
  currentMusic.play();
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
  
  Images.healthbar = loadImage("health_bar.png");
  Images.healthbarBackground = loadImage("health_bar_empty.png");
  
  Images.damageIcon = loadImage("stat_icons_damage.png");
  Images.healthIcon = loadImage("stat_icons_health.png");
  Images.fireSpeedIcon = loadImage("stat_icons_firerate.png");
}

void changeScene(Scene newScene) {
  scene.onSceneExit();
  scene = newScene;
  scene.onSceneEnter();
  Time.newScene();
}
