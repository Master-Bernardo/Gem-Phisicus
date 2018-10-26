class Slider
{
  int posX, posY, scaleX, scaleY;
  color sliderColor;
  String text;
  float sliderPosition; //slider position in Percent
  //max and min values we want to recieve
  float maxValue = 3.5;
  float minValue = 0; //immer 0
  BallThrowerUbung4 ballThrowerUbung4;
  
  Slider(int posX, int posY, int scaleX, int scaleY, String text, color sliderColor, float startSliderPosition, BallThrowerUbung4 ballThrowerUbung4)
  {
    this.posX = posX;
    this.posY = posY;
    this.scaleX = scaleX;
    this.scaleY = scaleY;
    this.text = text;
    this.sliderColor = sliderColor;
    sliderPosition = startSliderPosition;
    this.ballThrowerUbung4 = ballThrowerUbung4;
  }
  
  void UpdateSlider()
  {

  }
  
  void OnClick()
  {
    //execute the code on click
    sliderPosition = (float)-(mouseY-(posY+scaleY/2))/scaleY;
    ballThrowerUbung4.startVelocity = GetValue();
  }
  
  //retunrs the value determines by the min and max
  float GetValue()
  {
    float value = maxValue*sliderPosition;
    if (value>maxValue) value = maxValue;
    else if(value<minValue) value = minValue;
    return value;
  }
}
