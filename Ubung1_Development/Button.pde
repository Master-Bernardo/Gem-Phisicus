class Button
{
  int posX, posY, scaleX, scaleY;
  color buttonColor, hoverColor, inactiveColor;
  String text;
  Boolean active;
  
  Button(int posX, int posY, int scaleX, int scaleY, String text, color buttonColor, color hoverColor, color inactiveColor)
  {
    this.posX = posX;
    this.posY = posY;
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    this.text = text;
    this.buttonColor = buttonColor;
    this.hoverColor = hoverColor;
    this.inactiveColor = inactiveColor;
    active = true;
  }
  
  Button(int posX, int posY, int scaleX, int scaleY)
  {
    this.posX = posX;
    this.posY = posY;
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    text = "";
    buttonColor = color(155);
    hoverColor = color(200);
  }
  
  void UpdateButton()
  {
    
  }
  
  void OnClick()
  {
    //execute the code on click
    System.out.println("button clicked");
  }
}




class StartButtonUbung3 extends Button
{
  
  // active ist true wenn der ball in der Ausgangsposition verharrt
  BallThrowerUbung3 ballThrower; //der zuständige Component
  
  
  StartButtonUbung3(int posX, int posY, int scaleX, int scaleY, String text, color buttonColor, color hoverColor, color inactiveColor, BallThrowerUbung3 ballThrower)
  {
    super(posX,posY,scaleX,scaleY,text,buttonColor,hoverColor,inactiveColor);
    this.ballThrower = ballThrower;
  }
  
  StartButtonUbung3(int posX, int posY, int scaleX, int scaleY, BallThrowerUbung3 ballThrower)
  {
    super(posX,posY,scaleX,scaleY);
    this.ballThrower = ballThrower;
  }
  
  void OnClick()
  {
    if(active)
    { 
      ballThrower.ShootBall();
      active = false;
    }
  }
  
  void UpdateButton()
  {
    if(!ballThrower.throwing) active = true;
    else active = false;
  }
}

class StartButtonUbung4 extends Button
{
  
  // active ist true wenn der ball in der Ausgangsposition verharrt
  BallThrowerUbung4 ballThrower; //der zuständige Component
  
  
  StartButtonUbung4(int posX, int posY, int scaleX, int scaleY, String text, color buttonColor, color hoverColor, color inactiveColor, BallThrowerUbung4 ballThrower)
  {
    super(posX,posY,scaleX,scaleY,text,buttonColor,hoverColor,inactiveColor);
    this.ballThrower = ballThrower;
  }
  
  StartButtonUbung4(int posX, int posY, int scaleX, int scaleY, BallThrowerUbung4 ballThrower)
  {
    super(posX,posY,scaleX,scaleY);
    this.ballThrower = ballThrower;
  }
  
  void OnClick()
  {
    if(active)
    { 
      ballThrower.ShootBall();
      active = false;
    }
  }
  
  void UpdateButton()
  {
    if(!ballThrower.throwing) active = true;
    else active = false;
  }
}
