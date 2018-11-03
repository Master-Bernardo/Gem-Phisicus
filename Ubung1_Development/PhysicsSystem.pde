class PhysicsSystem
{
  ArrayList<GameObject> gameObjectsWithColliders;
  
  PhysicsSystem()
  {
    gameObjectsWithColliders = new ArrayList<GameObject>();
  }
  
  //returns all objects which currently collide with the GameObject object
  ArrayList<GameObject> GetCollidingGameObjects(GameObject objectToCheck)
  {
    ArrayList<GameObject> collidingObjects = new ArrayList<GameObject>();
    
    for(GameObject currentObject : collidingObjects)
    {
      //erstmal gehts nur wenn Object ein Ball ist
      switch(currentObject.type)
      {
       case Rectangle:
         //collision between rectangle and circle: there are only 2 cases when they collide
         // - either the cirlces center is inside the rectangle,
         // - or one of the rectangles points is within the circle
         
         //check if one of the rectangles Points is within the circle
         break;
       
       case Circle:
         //first calculate distance between the 2 circles center
          float distX = objectToCheck.posX - currentObject.posX;
          float distY = objectToCheck.posY - currentObject.posY;
          float distance = sqrt( (distX*distX) + (distY*distY));
          
          if(distance<=objectToCheck.scaleX + currentObject.scaleX)
          {
            //collides
          }
          
          
        break;
        
      case Triangle :
      
        break;
      }
    }
    
    return collidingObjects;
  }
}
