
NomogramScales nomogram;
Isopleth isopleth;

float yOffset;

void setup()
{
  size(600, 600);
  yOffset = height/2;

  ArrayList<Scale> scales = new ArrayList<Scale>();

  scales.add(new Scale(
  "U", "X", 0.0, 10000.0, 400.0, "%6.0f", 
  new Equation() 
  {
    public float evalX(float u, float delta, float mu) { 
      return -delta;
    }
    public float evalY(float u, float delta, float mu) { 
      return mu * (1.22 * sqrt(u));
    }
  }
  ));

  scales.add(new Scale(
  "V", "X", 0.0, 250.0, 30.0, "%6.0f", 
  new Equation() 
  {
    public float evalX(float u, float delta, float mu) { 
      return 0.0;
    }
    public float evalY(float u, float delta, float mu) { 
      return ((mu*mu)/(mu*2)) * u;
    }
  }
  ));

  scales.add(new Scale(
  "U", "X", 0.0, 10000.0, 400.0, "%6.0f", 
  new Equation() 
  {
    public float evalX(float u, float delta, float mu) { 
      return delta;
    }
    public float evalY(float u, float delta, float mu) { 
      return mu * sqrt( u / 0.672);
    }
  }
  ));

  nomogram = new NomogramScales(scales, 400, 8, 50);
  
  isopleth = new Isopleth(nomogram);
}

void draw()
{
  background(255);
  stroke(0);  
  //ellipse(mouseX, mouseY, 5, 5);
  
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
