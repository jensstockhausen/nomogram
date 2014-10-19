
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
  
  String lines[] = loadStrings("type.txt");

  nomogramCreator = new NomogamCreator();  

  nomogram = nomogramCreator.create(lines[0]);
  
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
