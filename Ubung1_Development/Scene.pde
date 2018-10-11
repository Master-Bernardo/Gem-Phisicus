/*holds a collection of Gameobjects and draws the accordingly to their positions relative to the scene origin*/
class Scene
{
  float originX, originY, rotation, scaleX, scaleY; // can also be rotated and scaled
  ArrayList <GameObject> gameObjects;
  
  Scene()
  {
    //scene origin is on the bottom left corner at start
    originX = width/2;  //the origin of the scene in screenSpace
    originY = height -200;
    scaleX = 1;
    scaleY = 1;
    rotation = 0;
    gameObjects = new ArrayList<GameObject>();
  }
  
  void AddObjectToScene(GameObject gameObject)
  {
    gameObjects.add(gameObject); 
  }
  
  //runns all the components on the GameObjects
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
    pushMatrix();
    translate(originX,originY);
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
    scaleX += zoom/100;
    scaleY += zoom/100;
    ;
  }
  
  void CameraRotate(float rotation)
  {
    this.rotation += rotation/100;
    System.out.println(this.rotation);
  }
  
}
