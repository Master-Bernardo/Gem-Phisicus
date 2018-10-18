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
  
  void run(GameObject gameObject)
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
  GameObject targetToThrow;
  float startYPosition;
  Boolean throwing;
  float startTime;
  
  BallThrowerUbung3(GameObject targetToThrow)
  {
    this.targetToThrow = targetToThrow;
    throwing = false;
    startYPosition = targetToThrow.posY;
    startTime = t;
  }
  
  void run(GameObject gameObject)
  {
    
    
    //physics code
    if(throwing)
    {
      targetToThrow.posY = (float)(-9.81/2f * Math.pow(t-startTime,2f) + 0.001 * (t-startTime) + startYPosition);
    }
    
    if(targetToThrow.posY==startYPosition) throwing = false;
  }
  
  void ShootBall()
  {
    throwing = true;
  }
}
