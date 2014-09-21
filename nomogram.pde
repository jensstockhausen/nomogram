
NomogramScales nomogram;
Isopleth isopleth;

float yOffset;

void setup()
{
  size(600, 600);

  NomogamCreator nomogramCreator = new NomogamCreator();  
  nomogram = nomogramCreator.createEarthCurvature();
  
  isopleth = new Isopleth(nomogram);
}

void draw()
{
  background(255);
  
  nomogram.doDraw();
  isopleth.doDraw();  
}

void mousePressed()
{
  yOffset = mouseY;
}

void mouseDragged()
{
  isopleth.move(yOffset- mouseY);
  yOffset = mouseY;
}
