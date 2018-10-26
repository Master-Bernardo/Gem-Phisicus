/*holds a collection of Gameobjects and draws the accordingly to their positions relative to the scene origin*/
class Scene
{
  float originX, originY, rotation, scale; // can also be rotated and scaled
  ArrayList <GameObject> gameObjects;
  Boolean cameraMovementActivated = true;
  
  Scene()
  {
    //scene origin is on the bottom left corner at start
    originX = width/2;  //the origin of the scene in screenSpace
    originY = height -200;
    scale = 1;
    rotation = 0;
    gameObjects = new ArrayList<GameObject>();
  }
  
  void AddObjectToScene(GameObject gameObject)
  {
    gameObjects.add(gameObject); 
  }
  
  //runs all the components on the GameObjects
  void UpdateGameObjects()
  {
     for(GameObject gameObject : gameObjects)
     {
      gameObject.RunComponents();
     }
  }
  
  void DrawScene()
  {
    
    background(255,255,255);
    
    //camera movement - rotation and scale
    pushMatrix();        
    translate(width/2, height/2);
    rotate(rotation);
    scale(scale);
    translate(-width/2, -height/2);
    translate(originX ,originY);
    
    for(GameObject gameObject : gameObjects)
    {
      gameObject.DrawObject();
    }
    
    popMatrix();

  }
  
  PVector SceneToScreenCoordinates(float sceneSpaceX, float sceneSpaceY)
  {
    float screenSpaceX = originX + sceneSpaceX;
    float screenSpaceY = originY - sceneSpaceY;
    return new PVector(screenSpaceX, screenSpaceY);
  }
  
  // for camera movement
  void MoveOrigin(float moveX, float moveY)
  {
    originX += moveX;
    originY += moveY;
  }
  
  void CameraZoom(float zoom)
  {
    scale -= zoom/60;
  }
  
  void CameraRotate(float rotation)
  {
    this.rotation += rotation/100;
  }
  
}
