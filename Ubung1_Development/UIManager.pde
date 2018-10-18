class UIManager
{
  ArrayList<Button> buttons;
  
  UIManager()
  {
    buttons = new ArrayList<Button>();
  }
  
  void AddButton(Button button)
  {
    buttons.add((button));
  }
  
  void DisplayUI()
  {
    //placeholder, for now it just shows text, not the real points of the game
    UpdateButtons();
    DrawButtons();
  
    textSize(32);
    fill(0);
    textAlign(CENTER);
    text("Treffer 0:0", width/2, 30); 
  }
  
  void MousePressed(int mousePosX, int mousePosY)
  {
    for(Button button: buttons)
    {
      if(mousePosX < button.posX + button.scaleX/2 && mousePosX > button.posX - button.scaleX/2 && mousePosY < button.posY + button.scaleY/2 && mousePosY > button.posY - button.scaleY/2)
      {
        button.OnClick();
      }
    }
  }
  
  
  void UpdateButtons()
  {
    for(Button button: buttons)
    {
      button.UpdateButton();
    }
  }
  
  void DrawButtons()
  {
    for(Button button: buttons)
    {
      rectMode(CENTER);
      if(!button.active)
      {
        fill(button.inactiveColor);
      }
      else if(mouseX < button.posX + button.scaleX/2 && mouseX > button.posX - button.scaleX/2 && mouseY < button.posY + button.scaleY/2 && mouseY > button.posY - button.scaleY/2)
      {
        fill(button.hoverColor);
      }
      else
      {
        fill(button.buttonColor);
      }
      rect(button.posX, button.posY, button.scaleX, button.scaleY);
      //text(button.text, button.posX-button.scaleX/2, button.posY-button.scaleY/2, button.posX+button.scaleX/2, button.posY+button.scaleY/2);
      fill(0);
      textAlign(CENTER);
      text(button.text, button.posX, button.posY);
    }
  }
}
