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
      gameObject.posY = (float)(-gravitation/2f * Math.pow(t-startTime,2f) + startVelocity * (t-startTime) + startYPosition);
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

class BallThrowerUbung4 extends Component
{

  float startYPosition;
  float startXPosition;
  Boolean throwing;
  float startTime;
  float startVelocity;  
  float angle; //alpha - die Rotation in welche richtung der wurf beginnt
  Boolean rightDirection; //true falls wir nach rechts schießen, false falls wir nach links schießen


  
  BallThrowerUbung4()
  {
    throwing = false;
  }
  
  void run()
  {
    //physics Formel für freien Fall aus der Übung
    if(throwing)
    {
      float velocityY = (float)(startVelocity * Math.sin(radians(angle)));
      float velocityX = (float)(startVelocity * Math.cos(radians(angle)));
      gameObject.posY = (float)(startYPosition + velocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2)); 
      if(rightDirection) 
      {
        gameObject.posX = (float)(startXPosition + velocityX * (t-startTime));
      }
        else
      {
        gameObject.posX = (float)(startXPosition - velocityX * (t-startTime));
      }
    }
  }
  
  void SetGameObject(GameObject gameObject)
  {
    this.gameObject = gameObject;
  }
  
  void SetShootProperties(float startVelocity, float angle, Boolean rightDirection)
  {
    this.rightDirection = rightDirection;
    this.startVelocity = startVelocity;
    this.angle = angle;
  }
  
  void ShootBall()
  {
    throwing = true;
    startYPosition = gameObject.posY;
    startXPosition = gameObject.posX;
    startTime = t;
    
  }
}
