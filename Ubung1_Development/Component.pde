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

class SchragBallMovement extends Component
{
  //die Y Speed beim Aufkommen sollte 0 betragen
  //for gorund hit
  float timeOfGroundHit;
  float groundHitX;
  float groundHitY;
  float groundHitSpeedX;
  float groundHitSpeedY;
  float alpha = 0;
  
  SchragBallMovement(float groundHitSpeedX, float groundHitSpeedY, float alpha)
  {
    this.alpha = alpha;
    timeOfGroundHit = t;
    this.groundHitSpeedX = groundHitSpeedX;
    this.groundHitSpeedY = groundHitSpeedY;
  }
  
  @Override
  void SetGameObject(GameObject gameObject)
  {
    this.gameObject = gameObject;
    this.groundHitX = gameObject.posX;
    this.groundHitY = gameObject.posY;
  }
  
  void run()
  {
        
        float hangabtriebskraft = (float)((gravitation * 1) * Math.sin(radians(alpha))); //erstmal nehmen wir die Masse 1
        
        //hangabtriebskraft in x und y Komponente zerlegen
        float Fhx = (float)(hangabtriebskraft * Math.cos(radians(alpha)));
        float Fhy = (float)(hangabtriebskraft * Math.sin(radians(alpha)));
        //System.out.println("not in air");
        //Bewegungsgleichung in x und y Richtung
        //float x = groundHitX;
        //float y = groundHitY;
        float x =(float)(-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedX * (t-timeOfGroundHit) - groundHitX);
        float y = (float)(-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedY * (t-timeOfGroundHit) + groundHitY);
        
        gameObject.posX = x;
        gameObject.posY = y;
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
  
  float velocityY ;
  float velocityX;
  
  Boolean inAir; //this is true as long as the ball is in Air
  //für die Bodenbewegung
  GameObject untergrund; //- ist entweder eine der Wippen oder null falls wir den boden berührt haben
  GameObject wippeRechts;
  GameObject wippeLinks;
  
  CollidersUbung4 collidersUbung4;
  
  
  //for gorund hit
  float timeOfGroundHit;
  float groundHitX;
  float groundHitY;
  float groundHitSpeedX;
  float groundHitSpeedY;


  
  BallThrowerUbung4(CollidersUbung4 collidersUbung4, GameObject wippeLinks, GameObject wippeRechts)
  {
    this.collidersUbung4 = collidersUbung4;
    this.wippeRechts = wippeRechts;
    this.wippeLinks = wippeLinks;
    throwing = false;
  }
  
  void run()
  {
    //physics Formel für freien Fall aus der Übung
    if(throwing)
    {
      if(inAir)  // wenn sich der Ball in der Luft befindet nutzen wir die Formel des Schrägen Wurfs
      {
        //groundHitSpeedY = (float)(startYPosition + velocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2)) - gameObject.posY;
        groundHitSpeedY = 0;
        gameObject.posY =   (float)(startYPosition + velocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2));
        
       
        
        //hier cheken wir ob er mit dem Boden kollidieren würde im nächsten Frame
        if(gameObject.posY<=0  + gameObject.scaleY/2)
        {
          gameObject.posY = 0 + gameObject.scaleY/2;
          inAir=false;
          untergrund = null;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          System.out.println(groundHitX);
          groundHitY = gameObject.posY;

          return;
        }
        else if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  //hier chechen wir ob wir mit einer der Wippen collidieren
        {
          inAir=false;
          gameObject.posY = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
          untergrund = wippeLinks;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;

          return;
          
        }
        else if(collidersUbung4.CollidesWithWippeRight(gameObject)!=null)
        {
          inAir=false;
          gameObject.posY = collidersUbung4.CollidesWithWippeRight(gameObject).y;
          untergrund = wippeRechts;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;

          return;
        }
        else
        {
           //dies ist zur vereinfachung, der bool right direction wechselt einfach die Richtung, sodass wir für beide Wippen den gleichen Winkel benutzen können, erstmal nur zu testzwecken
          if(rightDirection) 
          {
            groundHitSpeedX = (float)(startXPosition + velocityX * (t-startTime) - gameObject.posX)*6;
            gameObject.posX = (float)(startXPosition + velocityX * (t-startTime));
          }
            else
          {
            groundHitSpeedX = (float)(startXPosition - velocityX * (t-startTime) - gameObject.posX)*6;
            gameObject.posX = (float)(startXPosition - velocityX * (t-startTime));
          }
        }
        
        
      }
      else       // wenn der Ball auf den Boden ankommt, nutzen wird die andere Formel - schiefe Ebene
      {
        //1. checke ob wir unseren Untergrund geändert haben:
        if(untergrund == null)
        {
          if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  //hier chechen wir ob wir mit einer der Wippen collidieren
          {
            System.out.println("collides with left");
            gameObject.posY = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
            untergrund = wippeLinks;
            timeOfGroundHit =t;
            groundHitX = gameObject.posX;
            groundHitY = gameObject.posY;
          }
          else if(collidersUbung4.CollidesWithWippeRight(gameObject)!=null)
          {
            gameObject.posY = collidersUbung4.CollidesWithWippeRight(gameObject).y;
            untergrund = wippeRechts;
            timeOfGroundHit =t;
            groundHitX = gameObject.posX;
            groundHitY = gameObject.posY;
          }
        }
        
        
        float alpha = 0; //der Winkel falls es eine Schräge Ebene ist
        //groundHitSpeedX = 0.01;
        if(untergrund != null) // wenn auf Wippe
        {
          PVector up = new PVector(1,0);
          
          alpha = -(90-degrees(PVector.angleBetween(up, untergrund.GetVectorUp())));
          //System.out.println("aplha: " + alpha);
        }
        else
        {
          alpha = 0;
        }
        
        float hangabtriebskraft = (float)((gravitation * 1) * Math.sin(radians(alpha))); //erstmal nehmen wir die Masse 1
        
        //hangabtriebskraft in x und y Komponente zerlegen
        float Fhx = (float)(hangabtriebskraft * Math.cos(radians(alpha)));
        float Fhy = (float)(hangabtriebskraft * Math.sin(radians(alpha)));
        
        //Bewegungsgleichung in x und y Richtung
        //float x = 0;
        //float y = 0;
        float x =(float)(-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedX * (t-timeOfGroundHit) + groundHitX);
        float y = (float)(-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedY * (t-timeOfGroundHit) + groundHitY);
        
        if(y<=0  + gameObject.scaleY/2 && untergrund !=null)
        {
          untergrund = null;
          alpha = 0;

          groundHitSpeedX = x-gameObject.posX*3;

          timeOfGroundHit = t;
          groundHitSpeedY = 0;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          
          
          x =(float)(-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedX * (t-timeOfGroundHit) + groundHitX);
          y = (float)(-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedY * (t-timeOfGroundHit) + groundHitY);
          
        }
        
        gameObject.posX = x;
        gameObject.posY = y;
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
    velocityY = (float)(startVelocity * Math.sin(radians(angle)));
    velocityX = (float)(startVelocity * Math.cos(radians(angle)));
  }
  
  void SetStartVelocity(float startVelocity) //called by slider
  {
    this.startVelocity = startVelocity;
    velocityY = (float)(startVelocity * Math.sin(radians(angle)));
    velocityX = (float)(startVelocity * Math.cos(radians(angle)));
  }
  
  void ShootBall()
  {
    throwing = true;
    inAir = true;
    startYPosition = gameObject.posY;
    startXPosition = gameObject.posX;
    startTime = t;
    
  }
}
