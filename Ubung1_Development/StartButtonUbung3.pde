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
