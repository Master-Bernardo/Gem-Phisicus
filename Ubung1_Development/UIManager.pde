class UIManager
/* kümmer sich um alle Buttons und Texte - updatet die und zeichnet sie im screenspace - das heißt beim rauszoomen aus der Scene bleibt das UI gleich*/
{
  ArrayList<Button> buttons;
  ArrayList<Slider> sliders;
  
  UIManager()
  {
    buttons = new ArrayList<Button>();
    sliders = new ArrayList<Slider>();
  }
  
  void AddButton(Button button)
  {
    buttons.add((button));
  }
  
  void AddSlider(Slider slider)
  {
    sliders.add(slider);
  }
  
  void DisplayUI()
  {
    //placeholder, for now it just shows text, not the real points of the game
    UpdateUIElements();
    DrawUIElements();
  
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
    for(Slider slider: sliders)
    {
      if(mousePosX < slider.posX + slider.scaleX/2 && mousePosX > slider.posX - slider.scaleX/2 && mousePosY < slider.posY + slider.scaleY/2 && mousePosY > slider.posY - slider.scaleY/2)
      {
        slider.OnClick();
      }
    }
  }
  
  
  void UpdateUIElements()
  {
    for(Button button: buttons)
    {
      button.UpdateButton();
    }
    for (Slider slider: sliders)
    {
      slider.UpdateSlider();
    }
  }
  
  void DrawUIElements()
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
      text(button.text, button.posX, button.posY+10);
    }
    
    for(Slider slider: sliders)
    {
      rectMode(CENTER);
      fill(slider.sliderColor);
      rect(slider.posX, slider.posY, slider.scaleX, slider.scaleY);
      fill(color(255f,150f,100f));
      ellipse(slider.posX, slider.posY+slider.scaleY/2- (slider.sliderPosition*slider.scaleY), slider.scaleX/2, slider.scaleX/2);
    }
  }
}
