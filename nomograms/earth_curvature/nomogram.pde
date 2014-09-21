
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

class Isopleth
{

  float u, v, w;

  float x1, y1;
  float x2, y2;

  NomogramScales scales;

  Isopleth(NomogramScales scales)
  {
    this.scales = scales;

    u = (scales.scalesUVW.get(0).uMax - scales.scalesUVW.get(0).uMin) / 2 + scales.scalesUVW.get(0).uMin;
    v = (scales.scalesUVW.get(1).uMax - scales.scalesUVW.get(1).uMin) / 2 + scales.scalesUVW.get(1).uMin;
    w = (scales.scalesUVW.get(2).uMax - scales.scalesUVW.get(2).uMin) / 2 + scales.scalesUVW.get(2).uMin;
  }

  void updateLine()
  {
    PVector pu = scales.value2wc(u, 0);
    PVector pv = scales.value2wc(v, 1);
    PVector pw = scales.value2wc(w, 2);

    x1 = pu.x;
    y1 = pu.y;

    x2 = pw.x;
    y2 = pw.y;
  }
  
  void move(float offset)
  {
    u = u + offset * 10.0;
    updateLine();
  }

  void doDraw()
  {
    updateLine();

    stroke(0);
    line(x1, y1, x2, y2);
  }
}


class Tick
{
  PVector p;
  String l;

  Tick(PVector p, String label)
  {
    this.p = p;
    this.l = label;
  }
}


class NomogramScales
{
  ArrayList<Scale> scalesUVW;

  float delta;
  float mu;

  float xMin, xMax;
  float yMin, yMax;

  float scale;
  float border;

  ArrayList<ArrayList<PVector>> pointsUVW;
  ArrayList<ArrayList<Tick>> ticksUVW;

  NomogramScales(ArrayList<Scale> scalesUVW, float delta, float mu, float border)
  {
    this.scalesUVW = scalesUVW;
    this.delta = delta;
    this.mu    = mu;

    this.border = border; 
    pointsUVW = new ArrayList<ArrayList<PVector>>();
    ticksUVW  = new ArrayList<ArrayList<Tick>>();

    calc();
  }


  private void calc()
  {
    xMin = +10000; 
    xMax = -10000;
    yMin = +10000; 
    yMax = -10000;

    for (int i=0; i<scalesUVW.size (); i++)
    {
      Scale s = scalesUVW.get(i);

      // point for drawing the axis
      ArrayList<PVector> points = new ArrayList<PVector>();

      float step = (s.uMax - s.uMin) / 100.0;

      for (float u = s.uMin; u <= s.uMax; u += step)
      {
        float x = s.equ.evalX(u, delta, mu);
        float y = s.equ.evalY(u, delta, mu);

        if (x<=xMin) xMin = x;
        if (x>=xMax) xMax = x;
        if (y<=yMin) yMin = y;
        if (y>=yMax) yMax = y;

        points.add(new PVector(x, y));
      }

      pointsUVW.add(points);
      
      // points for drawing the ticks
      ArrayList<Tick> ticks = new ArrayList<Tick>();

      for (float u = s.uMin; u<= s.uMax; u += s.uStep)
      {
        float x = s.equ.evalX(u, delta, mu);
        float y = s.equ.evalY(u, delta, mu);

        ticks.add(new Tick(new PVector(x, y), nfc(u, 0)));
      }

      ticksUVW.add(ticks);
    }

    if ( (xMax-xMin)/width > (yMax-yMin)/height )
    {
      scale = (width - 2*border)/(xMax-xMin);
    } else
    {
      scale = (height - 2*border)/(yMax-yMin);
    }
  }


  private PVector mc2wc(PVector model)
  {
    return new PVector(
    (model.x - xMin) * scale + border, 
    height - border - (model.y - yMin) * scale);
  }


  public PVector value2wc(float u, int i)
  {
    Scale s = scalesUVW.get(i);
    
    float x = s.equ.evalX(u, delta, mu);
    float y = s.equ.evalY(u, delta, mu);
  
    return mc2wc(new PVector(x,y));
  }


  public void doDraw()
  {
    stroke(0);
    fill(0);
    smooth();
    textSize(10);
    textAlign(RIGHT, CENTER);

    // axis
    for (int i=0; i<pointsUVW.size (); i++)
    {
      ArrayList<PVector> points = pointsUVW.get(i);

      for ( int j=0; j<points.size ()-1; j++)
      {

        PVector p1 = mc2wc(points.get(j));
        PVector p2 = mc2wc(points.get(j+1));

        line(p1.x, p1.y, p2.x, p2.y);
      }
    }

    // major ticks incl. values
    for (int i=0; i<ticksUVW.size (); i++)
    {
      ArrayList<Tick> ticks = ticksUVW.get(i);

      for ( int j=0; j<ticks.size (); j++)
      {
        Tick t = ticks.get(j);

        PVector p = mc2wc(t.p);

        line(p.x, p.y, p.x-5, p.y);
        text(t.l, p.x-15, p.y);
      }
    }

    for (int i=0; i<scalesUVW.size (); i++)
    {
      Scale s = scalesUVW.get(i);
      ArrayList<PVector> pts = pointsUVW.get(i);

      PVector p1 = mc2wc(pts.get(0));
      text(s.name, p1.x, p1.y+15);

      PVector p2 = mc2wc(pts.get(pts.size()-1));
      text(s.unit, p2.x, p2.y-15);
    }
  }
}

interface Equation 
{
  public float evalX(float u, float delta, float mu);
  public float evalY(float u, float delta, float mu);
}


class Scale
{
  String name;
  String unit;
  
  float uMin;
  float uMax;
  float uStep;
  
  String tickFormat;
  
  Equation equ;
  
  Scale(String name, String unit, 
        float uMin, float uMax, float uStep, String tickFormat,
        Equation equation)
  {
    this.name  = name;
    this.unit  = unit;
    this.uMin  = uMin;
    this.uMax  = uMax;
    this.uStep = uStep;
    this.tickFormat = tickFormat;
    this.equ = equation;
  }
}

