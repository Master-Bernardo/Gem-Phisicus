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
