public class DifficultySelect extends Scene {
  
  public void update() {
    if(mouseX >= 0 && mouseX < 90 && mouseY >= 0 && mouseY < 70) {
      noStroke();
      fill(200, 0, 0, 150);
      rect(0, 0, 90, 70);
    }
    
    textSize(20);
    fill(0);
    textAlign(CENTER);
    text("Back", 45, 40);
    fill(255);
    
    textSize(38);
    text("Choose a Mode", 500, 75);
    textAlign(LEFT);
    image(Images.multiButton, 440, 150);
    textSize(20);
    text("Multiplayer", 580, 195);
    image(Images.singleButton, 440, 250);
    text("Singleplayer - Easy", 580, 295);
    image(Images.singleButton, 440, 350);
    text("Singleplayer - Hard", 580, 395);
    textSize(12);
  }
  
  public void onSceneEnter() {
  }
  
  public void onSceneExit() {
  }
  
  public void onMousePressed() {
    if(mouseX >= 440 && mouseX <= 560 && mouseY >= 150 && mouseY <= 230)
      changeScene(new GameSceneMultiplayer());
    else if(mouseX >= 440 && mouseX <= 560 && mouseY >= 250 && mouseY <= 330)
      changeScene(new GameSceneSingleplayer(1));
    else if(mouseX >= 440 && mouseX <= 560 && mouseY >= 350 && mouseY <= 430)
      changeScene(new GameSceneSingleplayer(2));
    else if(mouseX >= 0 && mouseX < 90 && mouseY >= 0 && mouseY < 70)
      changeScene(new MainMenu());
  }
  
  public void onKeyPressed() {
    
  }
}
