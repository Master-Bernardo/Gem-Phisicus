/* Bernard Zaborniak s0558930 -08.10.2018 */

float scaleFactor = 700f; // 500 pixels are one meter
float cameraMovementSpeed; //how fast does our camera move in this world
Boolean cameraMovementActivated;

Scene currentScene;
Boolean loop = true;

float timeScale = 1f;
float t = 0;                   // Zeitvariable
float lastT = 0;               // needed to determine deltaT
static float deltaTime;              // Zeitquant zwischen den Frames 
float frmRate;             // Screen-Refreshrate 

void setup()
{
  size(1200,1000);
  smooth(8);
  frmRate = 60;        
  frameRate(frmRate);   
  deltaTime = 1/frmRate;    // Zeitquant 
  
  // camera settings
  cameraMovementActivated = true;
  cameraMovementSpeed = 7f;
  
  // spawn the the objects and add them to the scene  
  currentScene = new Scene();
  
  /* Übung 1 Objekte */
  
  // ruler - 100 cm long, 10 high
  GameObject ruler = new GameObject(0, 1,0,1,0.1, GameObjectType.Rectangle, color(0));
  currentScene.AddObjectToScene(ruler);
  GameObject ruler10cmMarker1 = new GameObject(-0.35,0,0,0.1,1, GameObjectType.Rectangle, color(255));
  ruler.AddChild(ruler10cmMarker1);
  GameObject ruler10cmMarker2 = new GameObject(-0.35,0,0,0.1,1, GameObjectType.Rectangle, color(255));
  ruler.AddChild(ruler10cmMarker2);
  GameObject ruler10cmMarker3 = new GameObject(-0.15,0,0,0.1,1, GameObjectType.Rectangle, color(255));
  ruler.AddChild(ruler10cmMarker3);
  GameObject ruler10cmMarker4 = new GameObject(0.05,0,0,0.1,1, GameObjectType.Rectangle, color(255));
  ruler.AddChild(ruler10cmMarker4);
  GameObject ruler10cmMarker5 = new GameObject(0.25,0,0,0.1,1, GameObjectType.Rectangle, color(255));
  ruler.AddChild(ruler10cmMarker5);
  GameObject ruler10cmMarker6 = new GameObject(0.45,0,0,0.1,1, GameObjectType.Rectangle, color(255));
  ruler.AddChild(ruler10cmMarker6);
  
  //Background
  GameObject ground = new GameObject(0, 0,0,5,0.2, GameObjectType.Rectangle, color(189,183,107));
  currentScene.AddObjectToScene(ground);
  GameObject ground2 = new GameObject(0, 0,0,1.2,0.2, GameObjectType.Rectangle, color(240,230,140));
  currentScene.AddObjectToScene(ground2);
  
  //Player1 - left
  GameObject player1Marker = new GameObject(-0.4,0.09,0,0.1,0.02, GameObjectType.Rectangle, color(255,0,0));
  currentScene.AddObjectToScene(player1Marker);
  GameObject player1Triangle = new GameObject(-0.6,0.126,0,0.05,0.05, GameObjectType.Triangle, color(#A2DFFF));
  currentScene.AddObjectToScene(player1Triangle);
  GameObject player1Wippe = new GameObject(-0.6,0.16, 25,0.25,0.01, GameObjectType.Rectangle, color(#A2DFFF));
  currentScene.AddObjectToScene(player1Wippe);
  GameObject player1WippenDreieck = new GameObject(-0.05,0.02, 0,0.2,3, GameObjectType.Triangle, color(#A2DFFF));
  player1Wippe.AddChild(player1WippenDreieck);
  
  GameObject player1Ball = new GameObject(-0.1,0.03, 0,0.2,4.7, GameObjectType.Circle, color(230));
  player1Wippe.AddChild(player1Ball);    //wird erstmal als child angehängt, muss aber später geändert weren falls sich der Ball bewegen soll
  
  //Player 2 - right
  GameObject player2Marker = new GameObject(0.4, 0.09,0,0.1,0.02, GameObjectType.Rectangle, color(255,0,0));
  currentScene.AddObjectToScene(player2Marker);
  GameObject player2Triangle = new GameObject(0.6,0.126,0,0.05,0.05, GameObjectType.Triangle, color(#A2DFFF));
  currentScene.AddObjectToScene(player2Triangle);
  GameObject player2Wippe = new GameObject(0.6,0.16,-25,0.25,0.01, GameObjectType.Rectangle, color(#A2DFFF));
  currentScene.AddObjectToScene(player2Wippe);
  GameObject player2WippenDreieck = new GameObject(0.05,0.02, 0,0.2,3, GameObjectType.Triangle, color(#A2DFFF));
  player2Wippe.AddChild(player2WippenDreieck);
  
  GameObject player2Ball = new GameObject(0.1,0.03, 0,0.2,4.7, GameObjectType.Circle, color(230));
  player2Wippe.AddChild(player2Ball);
  
  //the ball
  GameObject ball = new GameObject(0,0.116, 0,0.032,0.032, GameObjectType.Circle, color(#FF7A15));
  currentScene.AddObjectToScene(ball);
  
  /* for testing 
  GameObject someCircle = new GameObject(width/2, height,45,2,2, GameObjectType.Rectangle, color(255));
  GameObject someOtherCircle = new GameObject(300, 200, 45, 2, 0.5, GameObjectType.Circle, color(255,0,0));
  GameObject childrenOfRotator = new GameObject(100,0,0,1,1, GameObjectType.Triangle, color(0,15,255f));
  GameObject childrenOfRect = new GameObject(100,0,0,0.1,0.1, GameObjectType.Rectangle, color(0,255,20f));
  currentScene.AddObjectToScene(someCircle);
  currentScene.AddObjectToScene(someOtherCircle);
  //currentScene.AddObjectToScene(childrenOfRotator);
  Component rotator = new Rotator(15,true);
  someOtherCircle.AttachComponent(rotator);
  someCircle.AddChild(childrenOfRect);
  someOtherCircle.AddChild(childrenOfRotator);
  */
  
  
  
}

void draw()
{
  //calculate the time and the time which passed since last frame (deltaTime)
  t = (float)millis()/1000;
  deltaTime = t - lastT;
  lastT = t;
  
  clear();                                                  //clears the whole scene of previously drawn objects
  HandlePlayerInput();                                     //checks if the camera and thus the whole coordinate system of the scene has moved
  currentScene.UpdateGameObjects();                         //updates all objects - for later if they have a bahaviour - for example move- this will be done here
  currentScene.DrawScene();  // draws all the previously updatet gameObjects
  DisplayUI();
}

// not yet implemented
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  currentScene.CameraZoom(e);
}

void DisplayUI()
{
  //placeholder, for now it just shows text, not the real points of the game

  textSize(32);
  fill(0);
  textAlign(CENTER);
  text("Treffer 0:0", width/2, 30); 
 
}

/* moves the scene origin according to our wasdd movement */
void HandlePlayerInput() 
{
  if(cameraMovementActivated && keyPressed)
  {
    PVector directionToMove = new PVector(0,0);
    
    if ((key == 'W') || (key == 'w')) 
    {
      directionToMove.add(new PVector(0, 1*cameraMovementSpeed));
    }
    if ((key == 'S') || (key == 's')) 
    {
      directionToMove.add(new PVector(0,-1*cameraMovementSpeed));
    }
    if ((key == 'A') || (key == 'a')) 
    {
       directionToMove.add(new PVector(1*cameraMovementSpeed,0));
    }
    if ((key == 'D') || (key == 'd')) 
    {
       directionToMove.add(new PVector(-1*cameraMovementSpeed,0));
    }
    
    currentScene.MoveOrigin(directionToMove.x,directionToMove.y);
    
    if ((key == 'Q') || (key == 'q')) 
    {
       currentScene.CameraRotate(1f);
    }
    if ((key == 'E') || (key == 'e')) 
    {
       currentScene.CameraRotate(-1f);
    }
  }
  
}
  

/*holds a collection of Gameobjects and draws the accordingly to their positions relative to the scene origin*/
class Scene
{
  float originX, originY, rotation, scaleX, scaleY; // can also be rotated and scaled
  ArrayList <GameObject> gameObjects;
  
  Scene()
  {
    //scene origin is on the bottom left corner at start
    originX = width/2;  //the origin of the scene in screenSpace
    originY = height;
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



enum GameObjectType
{
    Rectangle,
    Circle,
    Triangle
}

/* alle objecte sind standardmäßig 1m x 1m groß wenn der scale of 1 gesetzt ist*/
class GameObject
{
  float posX, posY, rot, scaleX, scaleY; //positions relative to the sceneOrigin
  GameObjectType type;
  color objectColor;
  
  ArrayList<Component> components;
  ArrayList<GameObject> children;
  GameObject parent;
  
  GameObject(float posX, float posY, float rot, float scaleX, float scaleY, GameObjectType type, color _objectColor)
  {
    this.posX = posX;
    this.posY = posY;
    this.rot = rot;
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    this.type = type;
    objectColor = _objectColor;
    components = new ArrayList<Component>();
    children = new ArrayList<GameObject>();
  }
  
  GameObject(float posX, float posY, GameObjectType type, color _objectColor)
  {
    this.posX = posX;
    this.posY = posY;
    this.rot = 0;
    this.scaleX = 1;
    this.scaleY = 1;
    this.type = type;
    objectColor = _objectColor;
    components = new ArrayList<Component>();
    children = new ArrayList<GameObject>();
  }
  
  void DrawObject()
  {
      switch(type)
      {
        
          case Rectangle:
          
            rectMode(CENTER);
            
            pushMatrix();
            // move the origin to the pivot point
            translate(posX * scaleFactor,-posY * scaleFactor); 
      
            rotate(radians(rot));
            
            // and draw the square at the origin
            fill(objectColor);
            if(parent==null) rect(0, 0, scaleX*scaleFactor, scaleY*scaleFactor);
            else rect(0,0, scaleX*scaleFactor * parent.scaleX, scaleY*scaleFactor * parent.scaleY);
            
            for(GameObject child : children)
            {
              child.DrawObject();
            }
            
            popMatrix();
            break;
            
          case Circle:
          
            pushMatrix();
            
            translate(posX * scaleFactor,-posY * scaleFactor); 
            rotate(radians(rot));
            fill(objectColor);
            
            if(parent==null) ellipse(0, 0, scaleX*scaleFactor, scaleY*scaleFactor);
            else ellipse(0, 0, scaleX*scaleFactor * parent.scaleX, scaleY*scaleFactor * parent.scaleY);
            
            for(GameObject child : children)
            {
              child.DrawObject();
            }
            
            popMatrix();
            break;
            
          case Triangle:
          
            float h = 0;
            h = (float)Math.sqrt((Math.pow(1,2)+Math.pow(1/2,2)));

            pushMatrix();
            translate(posX * scaleFactor,-posY * scaleFactor); 
            rotate(radians(rot));
            fill(objectColor);
            if(parent == null) triangle(
                    0-h/2 * scaleX * scaleFactor, 0+h/2 * scaleY * scaleFactor,
                    0+h/2 * scaleX * scaleFactor, 0+h/2 * scaleY * scaleFactor,
                    0 * scaleX * scaleFactor, 0-h/2 * scaleY * scaleFactor
                    );
            else triangle(
                    0-h/2 * parent.scaleX * scaleX * scaleFactor, 0+h/2 * parent.scaleY * scaleY * scaleFactor,
                    0+h/2 * parent.scaleX * scaleX * scaleFactor, 0+h/2* parent.scaleY * scaleY * scaleFactor,
                    0* parent.scaleX * scaleX * scaleFactor, 0-h/2* parent.scaleY * scaleY * scaleFactor
                    );
            
            for(GameObject child : children)
            {
              child.DrawObject();
            }
            
            popMatrix();
            break; 
        }
  }
 
  void SetParent( GameObject parent)
  {
    this.parent = parent;
  }
  
  void AddChild(GameObject child)
  {
    children.add(child); 
    child.SetParent(this);
  }
  
  void RemoveChild(GameObject child)
  {
    children.remove(child);
    child.SetParent(null);
  }
    
  
  void AttachComponent(Component component)
  {
    components.add(component);
  }
  
  void RunComponents()
  {
    for(Component component : components)
     {
      component.run(this);
     }
    for(GameObject child : children)
    {
      child.RunComponents();
    }
  }
}

/* can be attached to gameObjects , the run function is called every update on every component*/
class Component
{
  void run(GameObject gameObject)
  {
    
  }
  
  Component()
  {
    
  }
}

//just rotates an object over time - for testing
class Rotator extends Component
{
  float rotationSpeed;
  Boolean rightDirectedRotation;
  
  Rotator(float speed, Boolean right)
  {
    rotationSpeed = speed;
    rightDirectedRotation = right;
  }
  
  void run(GameObject gameObject)
  {
    if(rightDirectedRotation) gameObject.rot += rotationSpeed * deltaTime;
    else gameObject.rot -= rotationSpeed * deltaTime;
  }
    
}






/* Variablendeklaration */ 
/*
// Zeitmaßstäbe 
float timeScale;           // Zeitskalierungsfaktor 
float tRealLife = 1;       // Zeitfaktor 1:1 
float vRealLife = 1.388;   // 5 km/h (Fußgänger) 
float tCosmic = 10000;     // Zeitraffer 1:10000 
float vCosmic = 1023;      // 1,023 km/s (Mond um Erde) 
float tBullet = 0.1;       // Zeitlupe 10:1 
float vBullet = 800;       // 800 m/s (Geschoss) 

float t = 0;               // Zeitvariable
float dt;                  // Zeitquant 
float frmRate;             // Screen-Refreshrate 

String modus;

void setup () 
  { 
    size(1200,1000);
    frmRate = 50;          // Bildwechselfrequenz: 50 per sec 
    frameRate(frmRate);   
    dt = 1/frmRate;        // Zeitquant 
    modus = "realLife";
    
  } 
  
void draw()              // Hauptprogramm 
  { 
    // Zeitmaßstäbe 
    switch (modus) 
      { 
        case "realLife": timeScale = tRealLife;  // Fußgänger 
                  //v = vRealLife; 
                  timeScale = tRealLife;
                  break; 
        case "cosmic": timeScale = tCosmic;    // Mond um Erde 
                  //v = vCosmic; 
                  timeScale = tCosmic;
                  break;   
        case "slowMo": timeScale = tBullet;    // Geschoss 
                  //v = vBullet; 
                  timeScale = tBullet;
                  break;   
      } 

  
    t += timeScale*dt; 

  } 
*/




/* another

void draw()
{
  clear();
  background(122,5,122);
  if(mousePressed && mouseButton == LEFT)
  {
     myBall = new MovingBall(0,height/2,5,20);
  }
  
  if(myBall!=null)
  {
    myBall.MoveBall();
    myBall.DrawBall();
  }
  //clear();
  //background(155,15,155);
  rectMode(CENTER);
  fill(255,0,0,50);
  rect(mouseX,mouseY,50,50);
  
  
  
  textSize(32); // Set text size to 32
  fill(0);
  text("LAX", 0, 40);
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    if(!loop){
      loop();
      loop = true;
    }
    else{
      noLoop();
      loop = false;
    }
  }
}

class MovingBall
{
  int speed;
  int currentX = 0;
  int currentY = 0;
  int size;
  
  MovingBall(int x, int y,int _speed, int _size)
  {
    currentX = x;
    currentY = y;
    speed = _speed;
    size = _size;
  }
  
  void MoveBall()
  {
    currentX += speed;
  }
  
  void DrawBall()
  {
    ellipse(currentX,currentY,size,size);
  }
  
  void draw(){
    fill(0,255,0);
    rect(50,50,500,500);
  }
}

*/
