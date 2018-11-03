class CollidersUbung4
{
  float steigungLinks;
  float nLinks;
  
  float steigungRechts;
  float nRechts;
  
  //diese Klasse , hat die 2 Wippen gespiehcert, sie ibt nur dessen Positionen zurück für die CollisionAbfrage
  CollidersUbung4(GameObject wippeLinks, GameObject wippeRechts)
  {
    //lineare Gleichungen für die beiden Wippen anhand der 2 oberen Eckpunkte erstellen
    
    //linke wippe
    PVector[] eckpunkteLinks = wippeLinks.GetRectanglePoints();
    //steigung m berechnen
    steigungLinks = (eckpunkteLinks[1].y-eckpunkteLinks[0].y)/(eckpunkteLinks[1].x-eckpunkteLinks[0].x);
    System.out.println(steigungLinks);
    // y Abschnitt n berechnen 
    nLinks = -(steigungLinks * eckpunkteLinks[0].x -  eckpunkteLinks[0].y);
    System.out.println(nLinks);
    
    //recghtee wippe
    PVector[] eckpunkteRechts = wippeRechts.GetRectanglePoints();
    //steigung m berechnen
    steigungRechts = (eckpunkteRechts[1].y-eckpunkteRechts[0].y)/(eckpunkteRechts[1].x-eckpunkteRechts[0].x);
    // y Abschnitt n berechnen 
    nRechts = -(steigungRechts * eckpunkteRechts[0].x -  eckpunkteRechts[0].y);
  }
  
  // im zu schauen ob der Ball oberhalb oder Unterhalb der Wippengeraden ist, setzten wir den x Punkt vom Ball ein in die lineare Funktion und schauen was y sagt returnt die korrektierete y Position wenn wir colliden
  PVector CollidesWithWippeLeft(GameObject ball)
  {
    float y = steigungLinks * ball.posX + nLinks;
    //System.out.println("y: " +  y);
    // System.out.println("y ball: r" + ball.posX);
    if(y> ball.posY - ball.scaleY/2)
    {
      System.out.println("under");
      return new PVector(ball.posX,y + ball.scaleY/2);
    }
    else
    {
     System.out.println("over");
      return null;
    }
  }
  
  PVector CollidesWithWippeRight(GameObject ball)
  {
    float y = steigungRechts * ball.posX + nRechts;
    //System.out.println("y: " +  y);
    // System.out.println("y ball: r" + ball.posX);
    if(y> ball.posY - ball.scaleY/2)
    {
      System.out.println("under");
      return new PVector(ball.posX,y + ball.scaleY/2);
    }
    else
    {
     System.out.println("over");
      return null;
    }
  }
}
