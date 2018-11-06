/* Bernard Zaborniak s0558930 -08.10.2018 */

float scaleFactor = 750f;           // 750 pixels are one meter
float cameraMovementSpeed;          //how fast does our camera move in this world
Boolean cameraMovementActivated;    

Scene currentScene;
UIManager uiManager;

float timeScale;
float tRealLife = 1;       // Zeitfaktor 1:1 
float vRealLife = 1.388;   // 5 km/h (Fußgänger) 
float tCosmic = 10000;     // Zeitraffer 1:10000 
float vCosmic = 1023;      // 1,023 km/s (Mond um Erde) 
float tBullet = 0.1;       // Zeitlupe 10:1 
float vBullet = 800;       // 800 m/s (Geschoss) 

float t = 0;               // Zeitvariable
static float deltaTime;    // Zeitquant zwischen den Frames 
float frmRate;             // Screen-Refreshrate 

static float gravitation = 9.81f;


void setup()
{
  timeScale = 0.25;
  size(1200,1000);
  smooth(8);
  frmRate = 60;        
  frameRate(frmRate);   
  deltaTime = 1/frmRate * timeScale;    // Zeitquant 
  
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
  Component rotator = new Rotator(15,true);
  ruler.AttachComponent(rotator);
  
  //Background
  GameObject ground = new GameObject(0, -0.1,0,5,0.2, GameObjectType.Rectangle, color(189,183,107));
  currentScene.AddObjectToScene(ground);
  GameObject ground2 = new GameObject(0, -0.1,0,1.2,0.2, GameObjectType.Rectangle, color(240,230,140));
  currentScene.AddObjectToScene(ground2);
  
  //Player1 - left
  GameObject player1Marker = new GameObject(-0.4,-0.01,0,0.1,0.02, GameObjectType.Rectangle, color(255,0,0));
  currentScene.AddObjectToScene(player1Marker);
  GameObject player1Triangle = new GameObject(-0.6,0.026,0,0.05,0.05, GameObjectType.Triangle, color(#A2DFFF));
  currentScene.AddObjectToScene(player1Triangle);
  GameObject player1Wippe = new GameObject(-0.6,0.06, 25,0.25,0.01, GameObjectType.Rectangle, color(#A2DFFF));
  currentScene.AddObjectToScene(player1Wippe);
  PVector[] testVectors = player1Wippe.GetRectanglePoints();
  for(PVector vector: testVectors)
  {
    System.out.println(vector);
    GameObject testTriangle = new GameObject(vector.x,vector.y,0,0.05,0.05, GameObjectType.Circle, color(#A2DFFF));
    currentScene.AddObjectToScene(testTriangle);
  }
  GameObject player1WippenDreieck = new GameObject(-0.05,0.02, 0,0.2,3, GameObjectType.Triangle, color(#A2DFFF));
  player1Wippe.AddChild(player1WippenDreieck);
  
  GameObject player1Ball = new GameObject(-0.68,0.13, 0,0.03,0.03, GameObjectType.Circle, color(230));
  currentScene.AddObjectToScene(player1Ball);    //wird erstmal als child angehängt, muss aber später geändert weren falls sich der Ball bewegen soll
  
  //Player 2 - right
  GameObject player2Marker = new GameObject(0.4,-0.01,0,0.1,0.02, GameObjectType.Rectangle, color(255,0,0));
  currentScene.AddObjectToScene(player2Marker);
  GameObject player2Triangle = new GameObject(0.6,0.026,0,0.05,0.05, GameObjectType.Triangle, color(#A2DFFF));
  currentScene.AddObjectToScene(player2Triangle);
  GameObject player2Wippe = new GameObject(0.6,0.06,-25,0.25,0.01, GameObjectType.Rectangle, color(#A2DFFF));
  currentScene.AddObjectToScene(player2Wippe);
   GameObject testTriangle = new GameObject(player2Wippe.posX + player2Wippe.GetVectorUp().x*0.1 , player2Wippe.posY + player2Wippe.GetVectorUp().y*0.1,0,0.05,0.05, GameObjectType.Circle, color(255,0,0));
  currentScene.AddObjectToScene(testTriangle);
  GameObject testTriangle2 = new GameObject(player2Wippe.posX + player2Wippe.GetVectorRight().x*0.1 , player2Wippe.posY + player2Wippe.GetVectorRight().y*0.1,0,0.05,0.05, GameObjectType.Circle, color(0,255,0));
  currentScene.AddObjectToScene(testTriangle2);
  /*
  PVector[] testVectors2 = player2Wippe.GetRectanglePoints();
  for(PVector vector: testVectors2)
  {
   // System.out.println(vector);
    GameObject testTriangle = new GameObject(vector.x,vector.y,0,0.05,0.05, GameObjectType.Circle, color(#A2DFFF));
    currentScene.AddObjectToScene(testTriangle);
  }
  */
  GameObject player2WippenDreieck = new GameObject(0.05,0.02, 0,0.2,3, GameObjectType.Triangle, color(#A2DFFF));
  player2Wippe.AddChild(player2WippenDreieck);
  
  GameObject player2Ball = new GameObject(0.68,0.13, 0,0.03,0.03, GameObjectType.Circle, color(230));
   currentScene.AddObjectToScene(player2Ball);
  
  //the ball
  GameObject ball = new GameObject(0,0.016, 0,0.032,0.032, GameObjectType.Circle, color(#FF7A15));
  currentScene.AddObjectToScene(ball);
  RedBallMovement rBMovement = new RedBallMovement(0.138, true, player1Marker, player2Marker);  //0.138 m/s entsprechen 0.5km/h
  ball.AttachComponent(rBMovement);
  
  //schräge ebene testung ball
   GameObject schregball = new GameObject(0.01 ,0.05, 0, 0.032,0.032, GameObjectType.Circle, color(#08FCDA));
  currentScene.AddObjectToScene(schregball);
  SchragBallMovement schragMovement = new SchragBallMovement(0,0,-45);  
  schregball.AttachComponent(schragMovement);
  
  /*Übung 3 Objekte*/
  
  //Die Components für den freien Fall der Übung 3
  BallThrowerUbung3 thrower1 = new BallThrowerUbung3();
  player1Ball.AttachComponent(thrower1);
  BallThrowerUbung3 thrower2 = new BallThrowerUbung3();
  player2Ball.AttachComponent(thrower2);
  
  /*Übung 4 Objekte*/
  //der Collider sammller der Wippen
  CollidersUbung4 colliderSammleUbung4 = new CollidersUbung4(player1Wippe,player2Wippe);
  
  BallThrowerUbung4 throwerSchrag1 = new BallThrowerUbung4(colliderSammleUbung4, player1Wippe, player2Wippe);
  System.out.println("player1Wippe.rot: " + player1Wippe.rot);
   System.out.println("player2Wippe.rot: " + player2Wippe.rot);
  throwerSchrag1.SetShootProperties(3.5, 90-player1Wippe.rot);
  player1Ball.AttachComponent(throwerSchrag1);
  BallThrowerUbung4 throwerSchrag2 = new BallThrowerUbung4(colliderSammleUbung4, player1Wippe, player2Wippe);
  throwerSchrag2.SetShootProperties(2, 90-player2Wippe.rot);
  player2Ball.AttachComponent(throwerSchrag2);
  
  
  
  //zeichne Funktion
  for(float y = 0; y<=0.5; y=y+0.001)
  {
    //System.out.println((y*1f-colliderSammleUbung4.nLinks)/colliderSammleUbung4.steigungLinks);
    GameObject testball = new GameObject((y*1f-colliderSammleUbung4.nLinks)/colliderSammleUbung4.steigungLinks,y,0,0.005,0.005, GameObjectType.Circle, color(#A2DFFF));
    currentScene.AddObjectToScene(testball);
  }
  
  //UI
  
  uiManager = new UIManager();
  //uiManager.AddButton(new StartButtonUbung3(170,850,150,50,"thrower1", color(0,255,100), color(255,180,180), color(15), thrower1));
  //uiManager.AddButton(new StartButtonUbung3(1030,850,150,50,"thrower2", color(0,255,100), color(255,180,180), color(15), thrower2));
  uiManager.AddButton(new StartButtonUbung4(170,850,150,50,"thrower1", color(0,255,100), color(255,180,180), color(15), throwerSchrag1));
  uiManager.AddButton(new StartButtonUbung4(1030,850,150,50,"thrower2", color(0,255,100), color(255,180,180), color(15), throwerSchrag2));
  
  uiManager.AddSlider(new Slider(100, 400, 10, 200, "starting velocity: ", color(0f,0f,200f), 0.9, throwerSchrag1));
  uiManager.AddSlider(new Slider(1100, 400, 10, 200, "starting velocity: ", color(0f,0f,200f), 0.9, throwerSchrag2));
  
  
  
 
}

void draw()
{
  //another way of calculating time
  /*t = (float)millis()/1000;
  deltaTime = t - lastT;
  lastT = t;*/
  
  t += deltaTime; 
  
  clear();                                       //clears the whole scene of previously drawn objects
  HandlePlayerInput();                           //checks if the camera and thus the whole coordinate system of the scene has moved
  currentScene.UpdateGameObjects();              //updates all objects - for example move- this will be done here and all compoinents call their methods
  currentScene.DrawScene();                      // draws all the previously updatet gameObjects
  uiManager.DisplayUI();
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

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(cameraMovementActivated) currentScene.CameraZoom(e);
}

void mousePressed() {
  uiManager.MousePressed(mouseX,mouseY);
}
  
