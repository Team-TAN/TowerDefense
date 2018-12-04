public class Credits extends Scene {
  
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
    textSize(12);
    textAlign(LEFT);
  }
  
  public void onSceneEnter() {
  }
  
  public void onSceneExit() {
  }
  
  public void onMousePressed() {
    if(mouseX >= 0 && mouseX < 90 && mouseY >= 0 && mouseY < 70)
      changeScene(new MainMenu());
  }
  
  public void onKeyPressed() {
  }
}
