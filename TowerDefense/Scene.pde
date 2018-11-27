public abstract class Scene {
  
  public abstract Scene update();
  
  public abstract void onSceneEnter();
  public abstract void onSceneExit();
  
  public abstract void onMousePressed();
  public abstract void onKeyPressed();
}
