

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
    pushMatrix();
    // move the origin to the pivot point
    translate(posX * scaleFactor, -posY * scaleFactor); 

    rotate(radians(rot));

    // and draw the square at the origin
    fill(objectColor);

    switch(type)
    {

      case Rectangle:

        rectMode(CENTER);
        if (parent==null) rect(0, 0, scaleX*scaleFactor, scaleY*scaleFactor);
        else rect(0, 0, scaleX*scaleFactor * parent.scaleX, scaleY*scaleFactor * parent.scaleY);

        break;

      case Circle:

        if (parent==null) ellipse(0, 0, scaleX*scaleFactor, scaleY*scaleFactor);
        else ellipse(0, 0, scaleX*scaleFactor * parent.scaleX, scaleY*scaleFactor * parent.scaleY);

        break;

      case Triangle:
  
        float h = 0;
        h = (float)Math.sqrt((Math.pow(1, 2)+Math.pow(1/2, 2)));


        if (parent == null) 
          triangle(
            0-h/2 * scaleX * scaleFactor, 0+h/2 * scaleY * scaleFactor, 
            0+h/2 * scaleX * scaleFactor, 0+h/2 * scaleY * scaleFactor, 
            0 * scaleX * scaleFactor, 0-h/2 * scaleY * scaleFactor
          );
        else 
          triangle(
            0-h/2 * parent.scaleX * scaleX * scaleFactor, 0+h/2 * parent.scaleY * scaleY * scaleFactor, 
            0+h/2 * parent.scaleX * scaleX * scaleFactor, 0+h/2* parent.scaleY * scaleY * scaleFactor, 
            0* parent.scaleX * scaleX * scaleFactor, 0-h/2* parent.scaleY * scaleY * scaleFactor
          );

        break;
    }

    for (GameObject child : children)
    {
      child.DrawObject();
    }

    popMatrix();
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
    component.SetGameObject(this);
  }

  void RunComponents()
  {
    for (Component component : components)
    {
      component.run();
    }
    for (GameObject child : children)
    {
      child.RunComponents();
    }
  }
}
