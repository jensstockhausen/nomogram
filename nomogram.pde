
NomogramScales nomogram;
Isopleth isopleth;

boolean dragging;
boolean moveU;
float yOffset;


void setup()
{
  size(600, 600);
  
  yOffset = height/2;
  dragging = false;
  moveU = true;

  NomogamCreator nomogramCreator = new NomogamCreator();  
 
  nomogram = nomogramCreator.create("ohms_law");
  
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

void keyPressed()
{
  if (key == ' ')
  {
    moveU = !moveU;
  }
}
