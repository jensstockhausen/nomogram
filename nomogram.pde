
NomogamCreator nomogramCreator;
NomogramScales nomogram;
Isopleth isopleth;

boolean dragging;
boolean moveU;
float yOffset;

void setup()
{
  size(900, 700);
  
  yOffset = height/2;
  dragging = false;
  moveU = true;

  nomogramCreator = new NomogamCreator();  
  
  /*
  if (name == "earth_curve" ) return createEarthCurvature();
  if (name == "ohms_law" )    return createOhmsLaw();
  if (name == "bmi" )         return createBMI();
  if (name == "resistors")    return cresteResists();
  */

  nomogram = nomogramCreator.create("resistors");
  
  isopleth = new Isopleth(nomogram);
}

void draw()
{
  background(255);
  
  nomogram.doDraw();
  isopleth.doDraw(moveU);  
}

void mousePressed()
{
  if (!dragging)
  {
    dragging = true;
    yOffset = mouseY;
    return;
  }

  if (dragging)
  {
    dragging = false;
    return;
  }
  
}

void mouseMoved(MouseEvent mEvent)
{
  if (dragging)
  {
    isopleth.move(moveU, yOffset- mouseY);
    yOffset = mouseY;
  }
}
