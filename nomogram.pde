
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
  
  // tries to load the configuration from file
  String lines[] = loadStrings("type.txt");
  
  nomogram = nomogramCreator.create(lines[0]); 

  if (nomogram == null)
  {
    // defaults to "ohms_law"
    nomogram = nomogramCreator.create("ohms_law"); 
  }
   
  isopleth = new Isopleth(nomogram);
}

void draw()
{
  background(255);
  
  nomogram.doDraw();
  isopleth.doDraw(moveU);  
}


void keyPressed() 
{
  if (key == 't') 
  {
    moveU = !moveU;
  } 
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
