class Slider
{
  int posX, posY, scaleX, scaleY;
  color sliderColor;
  String text;
  float sliderPosition; //slider position in Percent
  //max and min values we want to recieve
  float maxValue = 100;
  float minValue; //immer 0
  
  Slider(int posX, int posY, int scaleX, int scaleY, String text, color sliderColor, float startSliderPosition)
  {
    this.posX = posX;
    this.posY = posY;
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    this.text = text;
    this.sliderColor = sliderColor;
    sliderPosition = startSliderPosition;
  }
  
  void UpdateSlider()
  {
    
  }
  
  void OnClick()
  {
    //execute the code on click
    sliderPosition = (float)-(mouseY-(posY+scaleY/2))/scaleY;
    GetValue();
  }
  
  //retunrs the value determines by the min and max
  float GetValue()
  {
    System.out.println(maxValue*sliderPosition);
    return maxValue*sliderPosition;
  }
}
