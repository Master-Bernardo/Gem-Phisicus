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
//klasse zu Testzwecken der schiefen Ebene
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

//klasse zu Testzwecken der schiefen Ebene
class SchragBallMovementMitReibung extends Component
{
  //die Y Speed beim Aufkommen sollte 0 betragen
  //for gorund hit
  float timeOfGroundHit;
  float groundHitX;
  float groundHitY;
  float groundHitSpeed;
  float alpha = 0;
  float mRollreibung;
  float mHaftreibung;
  Boolean moving; //bewegt sich das Objekt oder liegt es auf dem Untergrund?
  PVector currentVelocity;
  
  SchragBallMovementMitReibung(float groundHitX, float groundHitY, float groundHitSpeed, float alpha,float mRollreibung, float mHaftreibung)
  {
    this.alpha = alpha;
    timeOfGroundHit = t;
    this.groundHitX = groundHitX;
    this.groundHitY = groundHitY;
    this.groundHitSpeed = groundHitSpeed;
    this.mRollreibung = mRollreibung;
    this.mHaftreibung = mHaftreibung;
    moving = false;
    currentVelocity = new PVector(0,0);
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
    
        if(moving)
        {
                    
          //wenn sich der Ball bewegt, schauen wir ob ér seine Richtung in diesem frame wechseln wird, falls dies erfolgen würde, stoppen wir den Ball - der Ball würde seine Richtung ändern, wenn die Reibungskraft zu stark wird
          // außerdem muss die richtung der Reibungskraft angepasst werden
          if(groundHitSpeed<0)
          {
             mRollreibung = abs(mRollreibung);
        
            if(currentVelocity.x>0)//befor er anfängt in die andere Reichtung zu rollen durch die entgegengesetzte Reibungskaraft, stoppen iwr ihn
            {
              moving = false;
              groundHitSpeed = 0;
              timeOfGroundHit = t;
              groundHitX = gameObject.posX;
              groundHitY = gameObject.posY;
            }
          }
          else if(groundHitSpeed>0)
          {
            mRollreibung = -abs(mRollreibung);
        
            if(currentVelocity.x<0) //befor er anfängt in die andere Reichtung zu rollen durch die entgegengesetzte Reibungskaraft, stoppen iwr ihn
            {
              moving = false;
              groundHitSpeed = 0;
              timeOfGroundHit = t;
              groundHitX = gameObject.posX;
              groundHitY = gameObject.posY;
            }
          }
          else
          {
          }
            
          
          if(moving)
          {
            float strecke = (float)(0 + groundHitSpeed*(t-timeOfGroundHit) - gravitation * (sin(radians(alpha)) - mRollreibung * cos(radians(alpha))) * (Math.pow((t-timeOfGroundHit),2)/2));

            
            currentVelocity.x = groundHitX + (float)(strecke * Math.cos(radians(alpha)))-gameObject.posX;
            currentVelocity.y = groundHitY + (float)(strecke * Math.sin(radians(alpha)))-gameObject.posY;
            
              
            gameObject.posX += currentVelocity.x;
            gameObject.posY += currentVelocity.y;
          }

          
        }
        else
        {
            if(abs(alpha)>degrees(atan(mHaftreibung)) || abs(groundHitSpeed)>0)
            {
              moving = true;
              timeOfGroundHit = t;
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
  Boolean throwing; // true if we hit the throw button
  float startYPosition;
  float startXPosition;
  float startTime;
  float startVelocity;   //startGeschwindigkeit des Vrufes, in richtung des angles
  float angle; //alpha - die Rotation in welche richtung der wurf beginnt, wird von der IWppe übernommen
  
  float startVelocityY;   //x und y Komponenten des Startgeschwindigkeit, genutzt bei der Formel des schrägen wurfes, sowie bei der schiefen Ebene
  float startVelocityX;

  PVector currentVelocity;
  
  Boolean inAir; //this is true as long as the ball is in Air
  
  //für die Bodenbewegung
  GameObject untergrund; //- ist entweder eine der Wippen oder null falls wir den boden berührt haben
  GameObject wippeRechts;
  GameObject wippeLinks;
  
  CollidersUbung4 collidersUbung4;
  
  //for den GroundHit
  float timeOfGroundHit;
  float groundHitX;
  float groundHitY;
  
  //Reibung
  float mRollreibung = 0.2;


  
  BallThrowerUbung4(CollidersUbung4 collidersUbung4, GameObject wippeLinks, GameObject wippeRechts, float mRollreibung)
  {
    this.collidersUbung4 = collidersUbung4;
    this.wippeRechts = wippeRechts;
    this.wippeLinks = wippeLinks;
    throwing = false;
    currentVelocity = new PVector(0,0);
    this.mRollreibung = mRollreibung;
  }
  
  void run()
  {
    //physics Formel für freien Fall aus der Übung
    if(throwing)
    {
      if(inAir)  // wenn sich der Ball in der Luft befindet nutzen wir die Formel des Schrägen Wurfs
      {
        //1. movement berechnen
        currentVelocity.y = (float)(startYPosition + startVelocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2) - gameObject.posY)/deltaTime;  
        gameObject.posY += currentVelocity.y*deltaTime;//(float)(startYPosition + startVelocityY * (t-startTime) - gravitation/2 * Math.pow((t-startTime),2));
          
        currentVelocity.x = (float)(startXPosition + startVelocityX * (t-startTime) - gameObject.posX)/deltaTime;
        gameObject.posX += currentVelocity.x*deltaTime; //(flo/frmRateat)(startXPosition + startVelocityX * (t-startTime));
        

        //2. collisionChekck, ggf, movement korrigieren
        
        //hier cheken wir ob er mit dem Boden kollidieren
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
          
          ConvertVelocity();
          return;
        }
        //hier chechen wir ob wir mit einer der  Wippen collidieren
        else if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null)  
        {
          inAir=false;
          gameObject.posY = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
          gameObject.posX = gameObject.posX;
          untergrund = wippeLinks;
          timeOfGroundHit =t;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          
          ConvertVelocity();
          
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
          
          ConvertVelocity();


          return;
        }    
      }
      
      else    // wenn der Ball auf den Boden ankommt, nutzen wird die andere Formel - schiefe Ebene
      {
        

        //1. movement berechnen
        float alpha = 0; //der Winkel falls es eine Schräge Ebene ist
        if(untergrund != null) // wenn auf Wippe
        {
          PVector up = new PVector(1,0);
          
          alpha = -(90-degrees(PVector.angleBetween(up, untergrund.GetVectorUp())));
        }
        /*
        currentVelocity.x = (float)((-gravitation*Math.sin(radians(alpha))*Math.cos(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+startVelocityX * (t-timeOfGroundHit) + groundHitX)-gameObject.posX)/deltaTime;
        gameObject.posX += currentVelocity.x * deltaTime;

        currentVelocity.y = (float)((-gravitation*Math.sin(radians(alpha))*Math.sin(radians(alpha))*(Math.pow((t-timeOfGroundHit),2)/2)+startVelocityY * (t-timeOfGroundHit) + groundHitY)-gameObject.posY)/deltaTime;
        gameObject.posY += currentVelocity.y * deltaTime;
        */
        //mit Reibung
        PVector startVelocityVector = new PVector(startVelocityX,startVelocityY);
        float startVelocityFloat = startVelocityVector.mag();

        if(startVelocityX<0)
        {
          startVelocityFloat = -startVelocityFloat;
        }
                System.out.println(startVelocityFloat);

        System.out.println(startVelocityFloat);
        float hangabtriebskraft =(float)( -gravitation * (sin(radians(alpha))- mRollreibung *cos(radians(alpha))) * (Math.pow((t-timeOfGroundHit),2)/2))+ startVelocityFloat * (t-timeOfGroundHit) - 0;
        //System.out.println(hangabtriebskraft);
        //if(alpha>atan(mHaftreibung)) System.out.println("jetzt");
        //float y = (float)(0 + groundHitSpeedY + (t-timeOfGroundHit) + -gravitation * (sin(radians(alpha))- mRollreibung *cos(radians(alpha))) * (Math.pow((t-timeOfGroundHit),2)/2));
        
        float Fhx = (float)(hangabtriebskraft * Math.cos(radians(alpha)));
        float Fhy = (float)(hangabtriebskraft * Math.sin(radians(alpha)));
        
        currentVelocity.x = (groundHitX + Fhx)-gameObject.posX;
        currentVelocity.y = (groundHitY + Fhy)-gameObject.posY;
        
        gameObject.posX += currentVelocity.x ;
        gameObject.posY += currentVelocity.y;
       
        //2. collision checks, korrigieren
      
        //falls der untergrund null ist - also sich der Ball auf dem Boden bewegt, schauen wir ob er mit einer der Wippen kollidiert
        if(untergrund == null)
        {
          if(collidersUbung4.CollidesWithWippeLeft(gameObject)!=null) 
          {
            gameObject.posY = collidersUbung4.CollidesWithWippeLeft(gameObject).y;
            untergrund = wippeLinks;
            timeOfGroundHit =t;
            groundHitX = gameObject.posX;
            groundHitY = gameObject.posY;
            //startgeschwindigkeit bestimmen
            ConvertVelocity();
          }
          else if(collidersUbung4.CollidesWithWippeRight(gameObject)!=null)
          {
            gameObject.posY = collidersUbung4.CollidesWithWippeRight(gameObject).y;
            untergrund = wippeRechts;
            timeOfGroundHit =t;
            groundHitX = gameObject.posX;
            groundHitY = gameObject.posY;
             //startgeschwindigkeit bestimmen - erstmal nur anhand der xGeschwindigkeit
            ConvertVelocity();
            }
        }
        //falls der Ball auf einer der Wippen ist, schauen wir ob er mit dem Boden kollidiert
        else if(gameObject.posY<=0  + gameObject.scaleY/2)
        {
          gameObject.posY = gameObject.scaleY/2;

          untergrund = null;
          timeOfGroundHit =t;
          alpha = 0;
          groundHitX = gameObject.posX;
          groundHitY = gameObject.posY;
          
          //vs = v* cos(alpha)
          
          ConvertVelocity();
        }
      }
    }
  }
  
  //diese Funktion übersetzt die aktuelle Geschwindigkeit des Balles in dieselbe geschwindigkeit, jedoch entland des Freiheitsgrades des untergrunds - noch nicht genutzt
  //wir nehmen uns jeweils die xKomponente des geshwindigkeitsvektors relativ zum Untergrund
  PVector ConvertVelocity()
  {
    PVector newVelocity;
    
    if(untergrund!=null)
    {
      newVelocity = untergrund.GetVectorRight().mult(currentVelocity.x *  cos(untergrund.rot));
    }
    else
    {
       newVelocity = new PVector(1,0).mult(currentVelocity.x);
    }

    startVelocityX = newVelocity.x;
    startVelocityY = newVelocity.y;
    
    return newVelocity;
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
