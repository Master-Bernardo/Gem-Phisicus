/* can be attached to gameObjects , the run function is called every update on every component*/
class Component
{
  GameObject gameObject;
  
  void run()
  {
    
  }
  
  Component()
  {
    
  }
  
  void SetGameObject(GameObject gameObject)
  {
    this.gameObject = gameObject;
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
  
  void run()
  {
    if(rightDirectedRotation) gameObject.rot += rotationSpeed * deltaTime;
    else gameObject.rot -= rotationSpeed * deltaTime;
  }
    
}

class RedBallMovement extends Component
{
  //autoformat strg + t
  float movementSpeed;
  GameObject rightMarker;
  GameObject leftMarker;
  Boolean rightMovement = true;
  
  RedBallMovement(float movementSpeed, Boolean rightMovement, GameObject leftMarker, GameObject rightMarker)
  {
    this.movementSpeed = movementSpeed;
    this.rightMovement = rightMovement;
    this.leftMarker = leftMarker;
    this.rightMarker = rightMarker;
  }
  
  void run()
  {
    if(rightMovement)
    {
      gameObject.posX += movementSpeed * deltaTime;
      //wenn marker erreicht
    if(gameObject.posX > rightMarker.posX)
    {
      rightMovement = !rightMovement;
    }
    }else{
      gameObject.posX -= movementSpeed * deltaTime;
      if(gameObject.posX < leftMarker.posX )
      {
        rightMovement = !rightMovement;
      }
    } 
  }
}

class BallThrowerUbung3 extends Component
{

  float startYPosition;
  Boolean throwing;
  float startTime;
  float startVelocity;
  float lastPosY;        //the position of the last frame - needed for stopping the ball

  
  BallThrowerUbung3()
  {
    throwing = false;
    startTime = t;
    startVelocity = 4.8; //anfangsgeschwindigkeit beträgt 4,8 m/s
  }
  
  void run()
  {
    //physics Formel für freien Fall aus der Übung
    if(throwing)
    {
      gameObject.posY = (float)(-9.81/2f * Math.pow(t-startTime,2f) + startVelocity * (t-startTime) + startYPosition);
    }
    
    //ankommen prüfen
    if(lastPosY > startYPosition && gameObject.posY < startYPosition)
    {
      throwing = false;
      gameObject.posY = startYPosition;
    }
    
    lastPosY = gameObject.posY;
  }
  
  void SetGameObject(GameObject gameObject)
  {
    this.gameObject = gameObject;
    startYPosition = gameObject.posY;
    lastPosY = startYPosition;
  }
  
  void ShootBall()
  {
    throwing = true;
    startTime = t;
  }
}
