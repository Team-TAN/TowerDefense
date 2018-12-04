public class MainMenu extends Scene {
  
  public void update() {
    
    /*fill(100);
    noStroke();
    rect(300, 150, 400, 300);
    fill(255);*/
    
    image(Images.playButton, 400, 160);
    image(Images.instructionsButton, 319, 260);
    image(Images.creditsButton, 340, 360);
      
  }
  
  public void onSceneEnter() {//start music
  }
  public void onSceneExit() {//end music
  }
  
  public void onMousePressed() {
    if(mouseX >= 400 && mouseX <= 600 && mouseY >= 160 && mouseY <= 240)
      changeScene(new DifficultySelect());
    else if(mouseX >= 319 && mouseX <= 681 && mouseY >= 260 && mouseY <= 340)
      changeScene(new Instructions());
    else if(mouseX >= 340 && mouseX <= 760 && mouseY >= 360 && mouseY <= 440)
      changeScene(new Credits());
  }
  
  public void onKeyPressed() {}
}
