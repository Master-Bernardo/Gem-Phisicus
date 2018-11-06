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

class BallThrowerUbung4Old extends Component
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


  
  BallThrowerUbung4Old(CollidersUbung4 collidersUbung4, GameObject wippeLinks, GameObject wippeRechts)
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
       //System.out.println("hgspX: " + groundHitSpeedX);
      if(inAir)  // wenn sich der Ball in der Luft befindet nutzen wir die Formel des Schrägen Wurfs
      {
        groundHitSpeedY = (float)(startYPosition + velocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2) - gameObject.posY)*frmRate;
        //groundHitSpeedY = 0;
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
            groundHitSpeedX = (float)(startXPosition + velocityX * (t-startTime) - gameObject.posX)*frmRate;
            gameObject.posX = (float)(startXPosition + velocityX * (t-startTime));
          }
            else
          {
            groundHitSpeedX = (float)(startXPosition - velocityX * (t-startTime) - gameObject.posX)*frmRate;
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
            //System.out.println("collides with left");
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
        
        float hangabtriebskraft = (float)((gravitation * 1) * Math.sin(radians(alpha))); //erstmal nehmen wir die Masse 1
        
        //hangabtriebskraft in x und y Komponente zerlegen
        float Fhx = (float)(hangabtriebskraft * Math.cos(radians(alpha)));
        float Fhy = (float)(hangabtriebskraft * Math.sin(radians(alpha)));
        
        //Bewegungsgleichung in x und y Richtung
        //float x = 0;
        //float y = 0;
        float x =(float)(-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedX * (t-timeOfGroundHit) + groundHitX);
        float y = (float)(-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedY * (t-timeOfGroundHit) + groundHitY);
        
        if(gameObject.posY<=0  + gameObject.scaleY/2 && untergrund !=null)
        {
           System.out.println("yep");
          untergrund = null;
          alpha = 0;

          groundHitSpeedX = (x-gameObject.posX)*frmRate;

          timeOfGroundHit = t;
          groundHitSpeedY = 0;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          
          
          x = (float)(-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedX * (t-timeOfGroundHit) + groundHitX);
          y = (float)(-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedY * (t-timeOfGroundHit) + groundHitY);
          
        }else if(gameObject.posY<=0  + gameObject.scaleY/2)
        {
          y = gameObject.scaleY/2;
        }
        //vllcht
        else if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  //hier chechen wir ob wir mit einer der Wippen collidieren
        {
            y = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
        }
        else if(collidersUbung4.CollidesWithWippeRight(gameObject)!=null)
        {
            y = collidersUbung4.CollidesWithWippeRight(gameObject).y;
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

class BallThrowerUbung4Old2 extends Component
{
  Boolean throwing; // true if we hit the throw button
  float startYPosition;
  float startXPosition;
  float startTime;
  float startVelocity;   //startGeschwindigkeit des Vrufes, in richtung des angles
  float angle; //alpha - die Rotation in welche richtung der wurf beginnt, wird von der IWppe übernommen
  
  float startVelocityY;   //x und y Komponenten des Startgeschwindigkeit, genutzt bei der Formel des schrägen wurfes, sowie bei der schiefen Ebene
  float startVelocityX;
  
  float currentVelocityY;   
  float currentVelocityX;
  
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


  
  BallThrowerUbung4Old2(CollidersUbung4 collidersUbung4, GameObject wippeLinks, GameObject wippeRechts)
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
        //1. movement berechnen
        currentVelocityY = (float)(startYPosition + startVelocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2) - gameObject.posY)*frmRate;  
        gameObject.posY += currentVelocityY/frmRate;//(float)(startYPosition + startVelocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2));
          
        currentVelocityX = (float)(startXPosition + startVelocityX * (t-startTime) - gameObject.posX)*frmRate;
        gameObject.posX += currentVelocityX/frmRate; //(float)(startXPosition + startVelocityX * (t-startTime));

        //2. collisionChekck, ggf, movement korrigieren
        //hier cheken wir ob er mit dem Boden kollidieren würde im nächsten Frame
        if(gameObject.posY<=0  + gameObject.scaleY/2)
        {
          gameObject.posY = 0 + gameObject.scaleY/2;
          gameObject.posX = gameObject.posX;
          inAir=false;
          untergrund = null;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          System.out.println(groundHitX);
          groundHitY = gameObject.posY;

          return;
        }
        else if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  //hier chechen wir ob wir mit einer der linken Wippen collidieren
        {
          inAir=false;
          gameObject.posY = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
          gameObject.posX = gameObject.posX;
          untergrund = wippeLinks;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;

          return;
          
        }
        else if(collidersUbung4.CollidesWithWippeRight(gameObject)!=null)//hier chechen wir ob wir mit einer der lrechten Wippen collidieren
        {
          inAir=false;
          gameObject.posY = collidersUbung4.CollidesWithWippeRight(gameObject).y;
          gameObject.posX = gameObject.posX;
          untergrund = wippeRechts;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;

          return;
        }    
      }
      
      else    // wenn der Ball auf den Boden ankommt, nutzen wird die andere Formel - schiefe Ebene
      {
        

        startVelocityY = 0;
        startVelocityX = 0;
        //1. movement 
        float alpha = 0; //der Winkel falls es eine Schräge Ebene ist
        //groundHitSpeedX = 0.01;
        if(untergrund != null) // wenn auf Wippe
        {
          PVector up = new PVector(1,0);
          
          alpha = -(90-degrees(PVector.angleBetween(up, untergrund.GetVectorUp())));
          //System.out.println("aplha: " + alpha);
        }
        /*
        float hangabtriebskraft = (float)((gravitation * 1) * Math.sin(radians(alpha))); //erstmal nehmen wir die Masse 1
        
        //hangabtriebskraft in x und y Komponente zerlegen
        float Fhx = (float)(hangabtriebskraft * Math.cos(radians(alpha)));
        float Fhy = (float)(hangabtriebskraft * Math.sin(radians(alpha)));
        
        //Bewegungsgleichung in x und y Richtung
        //float x = 0;
        //float y = 0;
        */
        //groundHitSpeedX = (float)((-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedX * (t-timeOfGroundHit) + groundHitX)-gameObject.posX)*frmRate;
        gameObject.posX =(float)(-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+startVelocityX * (t-timeOfGroundHit) + groundHitX);
        //groundHitSpeedY = (float)((-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedX * (t-timeOfGroundHit) + groundHitX)-gameObject.posX)*frmRate;
        gameObject.posY = (float)(-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+startVelocityY * (t-timeOfGroundHit) + groundHitY);

        //2. collision checks, korrigieren
        
        if(untergrund == null)
        {
          if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  //hier chechen wir ob wir mit einer der Wippen collidieren
          {
            //System.out.println("collides with left");
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
        else if(gameObject.posY<=0  + gameObject.scaleY/2)
        {
          gameObject.posY = gameObject.scaleY/2;
          System.out.println("yep");
          untergrund = null;
          timeOfGroundHit =t;
          alpha = 0;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          startVelocityX = -0.1f;
        }
        /*else  // falls wir von einer Wippe weg sind
        {
          if(untergrund == wippeLinks)
          {
            if(collidersUbung4.CollidesWithWippeLeft(gameObject)==null)
            {
              futureY = 0 + gameObject.scaleY/2;
          futureX = gameObject.posX;
          inAir=false;
          untergrund = null;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          System.out.println(groundHitX);
          groundHitY = gameObject.posY;
            }
          }else if(untergrund == wippeRechts)
          {
             if(collidersUbung4.CollidesWithWippeRight(gameObject)==null)
            {
              futureY = 0 + gameObject.scaleY/2;
          futureX = gameObject.posX;
          inAir=false;
          untergrund = null;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          System.out.println(groundHitX);
          groundHitY = gameObject.posY;
            }
          }
        }*/
          
        /*
        //wenn wir von einer Wippe auf den Boden aufkommen
        if(futureY<=0  + gameObject.scaleY/2 && untergrund !=null)
        {
          System.out.println("yep");
          untergrund = null;
          alpha = 0;

          groundHitSpeedX = (futureX-gameObject.posX)*frmRate;
          futureY = gameObject.scaleY/2;
          timeOfGroundHit = t;
          //groundHitSpeedY = 0;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          
          
          //futureX = (float)(-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedX * (t-timeOfGroundHit) + groundHitX);
          //futureY = (float)(-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+groundHitSpeedY * (t-timeOfGroundHit) + groundHitY);
          
        //wenn wir auf dem Boden sind und trotzdem tiefer sinken  
        }else if(gameObject.posY<=0  + gameObject.scaleY/2)
        {
          futureY = gameObject.scaleY/2;
        }
        //wenn wir auf der linken oder rechten Wippe zu tief kommen
        else if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  //hier chechen wir ob wir mit einer der Wippen collidieren
        {
            futureY = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
        }
        else if(collidersUbung4.CollidesWithWippeRight(gameObject)!=null)
        {
            futureY = collidersUbung4.CollidesWithWippeRight(gameObject).y;
        }
        */

      }
    }
  }
  
  void SetGameObject(GameObject gameObject)
  {
    this.gameObject = gameObject;
  }
  
  void SetShootProperties(float startVelocity, float angle)
  {
    this.startVelocity = startVelocity;
    this.angle = angle;
    startVelocityY = (float)(startVelocity * Math.sin(radians(angle)));
    startVelocityX = (float)(startVelocity * Math.cos(radians(angle)));
  }
  
  void SetStartVelocity(float startVelocity) //called by slider
  {
    this.startVelocity = startVelocity;
    startVelocityY = (float)(startVelocity * Math.sin(radians(angle)));
    startVelocityX = (float)(startVelocity * Math.cos(radians(angle)));
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

class BallThrowerUbung4 extends Component
{
  Boolean throwing; // true if we hit the throw button
  float startYPosition;
  float startXPosition;
  float startTime;
  float startVelocity;   //startGeschwindigkeit des Vrufes, in richtung des angles
  float angle; //alpha - die Rotation in welche richtung der wurf beginnt, wird von der IWppe übernommen
  
  float startVelocityY;   //x und y Komponenten des Startgeschwindigkeit, genutzt bei der Formel des schrägen wurfes, sowie bei der schiefen Ebene
  float startVelocityX;
  
  float currentVelocityY;   
  float currentVelocityX;
  
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
      System.out.println("currentVelocityY: " + currentVelocityY);
      System.out.println("currentVelocityX: " + currentVelocityX);
      if(inAir)  // wenn sich der Ball in der Luft befindet nutzen wir die Formel des Schrägen Wurfs
      {
        //1. movement berechnen
        currentVelocityY = (float)(startYPosition + startVelocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2) - gameObject.posY)*frmRate;  
        gameObject.posY += currentVelocityY/frmRate;//(float)(startYPosition + startVelocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2));
          
        currentVelocityX = (float)(startXPosition + startVelocityX * (t-startTime) - gameObject.posX)*frmRate;
        gameObject.posX += currentVelocityX/frmRate; //(float)(startXPosition + startVelocityX * (t-startTime));

        //2. collisionChekck, ggf, movement korrigieren
        //hier cheken wir ob er mit dem Boden kollidieren würde im nächsten Frame
        if(gameObject.posY<=0  + gameObject.scaleY/2)
        {
          gameObject.posY = 0 + gameObject.scaleY/2;
          gameObject.posX = gameObject.posX;
          inAir=false;
          untergrund = null;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          System.out.println(groundHitX);
          groundHitY = gameObject.posY;
          
          //long conversion of the current velocity length to the new on in another direction
          PVector velocityX = new PVector(currentVelocityX,0);
          PVector velocityY = new PVector(0,currentVelocityY);
          PVector velocity =  velocityX.add(velocityY);
          PVector newVelocity;
          if(currentVelocityX>0) newVelocity = new PVector(velocity.mag(),0);
          else   newVelocity = new PVector(-velocity.mag(),0);
          startVelocityY = 0;
          startVelocityX = newVelocity.x;
          return;
        }
        else if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  //hier chechen wir ob wir mit einer der linken Wippen collidieren
        {
          inAir=false;
          gameObject.posY = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
          gameObject.posX = gameObject.posX;
          untergrund = wippeLinks;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          
          //startgeschwindigkeit bestimmen
          PVector velocityX = new PVector(currentVelocityX,0);
          PVector velocityY = new PVector(0,currentVelocityY);
          PVector velocity =  velocityX.add(velocityY);
          
          PVector newVelocity = untergrund.GetVectorRight().mult(velocity.mag());
          startVelocityX = -newVelocity.x;
          startVelocityY = -newVelocity.y;
          
          return;
          
        }
        else if(collidersUbung4.CollidesWithWippeRight(gameObject)!=null)//hier chechen wir ob wir mit einer der lrechten Wippen collidieren
        {
          inAir=false;
          gameObject.posY = collidersUbung4.CollidesWithWippeRight(gameObject).y;
          gameObject.posX = gameObject.posX;
          untergrund = wippeRechts;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          
          //startgeschwindigkeit bestimmen - erstmal nur anhand der xGeschwindigkeit
          //startgeschwindigkeit bestimmen
          PVector velocityX = new PVector(currentVelocityX,0);
          PVector velocityY = new PVector(0,currentVelocityY);
          PVector velocity =  velocityX.add(velocityY);
          
          PVector newVelocity = untergrund.GetVectorRight().mult(velocity.mag());
          startVelocityX = newVelocity.x;
          startVelocityY = newVelocity.y;
          //startVelocityX = (float)(currentVelocityX * Math.cos(radians(gameObject.rot)));
          //startVelocityY = (float)(currentVelocityX * Math.sin(radians(gameObject.rot)));

          return;
        }    
      }
      
      else    // wenn der Ball auf den Boden ankommt, nutzen wird die andere Formel - schiefe Ebene
      {
        

        //1. movement 
        float alpha = 0; //der Winkel falls es eine Schräge Ebene ist
        //groundHitSpeedX = 0.01;
        if(untergrund != null) // wenn auf Wippe
        {
          PVector up = new PVector(1,0);
          
          alpha = -(90-degrees(PVector.angleBetween(up, untergrund.GetVectorUp())));
          //System.out.println("aplha: " + alpha);
        }

        currentVelocityX = (float)((-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+startVelocityX * (t-timeOfGroundHit) + groundHitX)-gameObject.posX)*frmRate;
        gameObject.posX += currentVelocityX/frmRate;
        currentVelocityY = (float)((-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+startVelocityY * (t-timeOfGroundHit) + groundHitY)-gameObject.posY)*frmRate;
        gameObject.posY += currentVelocityY/frmRate;
        //2. collision checks, korrigieren
        
        if(untergrund == null)
        {
          if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  //hier chechen wir ob wir mit einer der Wippen collidieren
          {
            gameObject.posY = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
            untergrund = wippeLinks;
            timeOfGroundHit =t;
            groundHitX = gameObject.posX;
            groundHitY = gameObject.posY;
            //startgeschwindigkeit bestimmen
            //startgeschwindigkeit bestimmen
          PVector velocityX = new PVector(currentVelocityX,0);
          PVector velocityY = new PVector(0,currentVelocityY);
          PVector velocity =  velocityX.add(velocityY);
          
          PVector newVelocity = untergrund.GetVectorRight().mult(velocity.mag());
          startVelocityX = -newVelocity.x;
          startVelocityY = -newVelocity.y;
          }
          else if(collidersUbung4.CollidesWithWippeRight(gameObject)!=null)
          {
            gameObject.posY = collidersUbung4.CollidesWithWippeRight(gameObject).y;
            untergrund = wippeRechts;
            timeOfGroundHit =t;
            groundHitX = gameObject.posX;
            groundHitY = gameObject.posY;
             //startgeschwindigkeit bestimmen - erstmal nur anhand der xGeschwindigkeit
            //startgeschwindigkeit bestimmen
          PVector velocityX = new PVector(currentVelocityX,0);
          PVector velocityY = new PVector(0,currentVelocityY);
          PVector velocity =  velocityX.add(velocityY);
          
          PVector newVelocity = untergrund.GetVectorRight().mult(velocity.mag());
          startVelocityX = newVelocity.x;
          startVelocityY = newVelocity.y;
          }
        }
        else if(gameObject.posY<=0  + gameObject.scaleY/2)
        {
          gameObject.posY = gameObject.scaleY/2;
          System.out.println("yep");

          untergrund = null;
          timeOfGroundHit =t;
          alpha = 0;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          
          //long conversion of the current velocity length to the new on in another direction
          PVector velocityX = new PVector(currentVelocityX,0);
          PVector velocityY = new PVector(0,currentVelocityY);
          PVector velocity =  velocityX.add(velocityY);
          PVector newVelocity;
          if(currentVelocityX>0) newVelocity = new PVector(velocity.mag(),0);
          else   newVelocity = new PVector(-velocity.mag(),0);
          startVelocityY = 0;
          startVelocityX = newVelocity.x;
        }
      }
    }
  }
  
  void SetGameObject(GameObject gameObject)
  {
    this.gameObject = gameObject;
  }
  
  void SetShootProperties(float startVelocity, float angle)
  {
    this.startVelocity = startVelocity;
    this.angle = angle;
    startVelocityY = (float)(startVelocity * Math.sin(radians(angle)));
    startVelocityX = (float)(startVelocity * Math.cos(radians(angle)));
  }
  
  void SetStartVelocity(float startVelocity) //called by slider
  {
    this.startVelocity = startVelocity;
    startVelocityY = (float)(startVelocity * Math.sin(radians(angle)));
    startVelocityX = (float)(startVelocity * Math.cos(radians(angle)));
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
