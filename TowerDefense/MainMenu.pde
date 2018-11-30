public class MainMenu extends Scene {
  
  private boolean moveToPlay = false;
  
  public Scene update() {
    if(moveToPlay)
      return new GameSceneMultiplayer();
      
    return null;
  }
  
  public void onSceneEnter() {//start music
  }
  public void onSceneExit() {//end music
  }
  
  public void onMousePressed() {
    moveToPlay = true;
  }
  
  public void onKeyPressed() {}
}
