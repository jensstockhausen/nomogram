
interface Crossing
{
  public float evalV(float u, float v);
}

class Tick
{
  PVector p;
  PVector n;
  String l;

  Tick(PVector p, PVector n, String label)
  {
    this.p = p;
    this.n = n;
    this.l = label;
  }
}


class NomogramScales
{
  ArrayList<Scale> scalesUVW;
  Crossing crossing;

  float delta;
  float mu1, mu2, mu3;

  float xMin, xMax;
  float yMin, yMax;

  float scale;
  float border;

  ArrayList<ArrayList<PVector>> pointsUVW;
  ArrayList<ArrayList<Tick>> ticksUVW;

  NomogramScales(ArrayList<Scale> scalesUVW, Crossing crossing, float delta, float mu1, float mu2, float mu3, float border)
  {
    this.scalesUVW = scalesUVW;
    this.crossing = crossing;
    this.delta = delta;
    this.mu1    = mu1;
    this.mu2    = mu2;
    this.mu3    = mu3;

    this.border = border; 
    pointsUVW = new ArrayList<ArrayList<PVector>>();
    ticksUVW  = new ArrayList<ArrayList<Tick>>();

    calc();
  }

  NomogramScales(ArrayList<Scale> scalesUVW, Crossing crossing, float delta, float mu, float border)
  {
    this.scalesUVW = scalesUVW;
    this.crossing = crossing;
    this.delta = delta;
    this.mu1    = mu;
    this.mu2    = mu;
    this.mu3    = mu;

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

    for (int i=0; i<scalesUVW.size(); i++)
    {
      Scale s = scalesUVW.get(i);

      // point for drawing the axis
      ArrayList<PVector> points = new ArrayList<PVector>();

      float step = (s.uMax - s.uMin) / 100.0;

      for (float u = s.uMin; u <= s.uMax; u += step)
      {
        float x = s.equ.evalX(u, delta, mu1, mu2, mu3);
        float y = s.equ.evalY(u, delta, mu1, mu2, mu3);

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
        float x = s.equ.evalX(u, delta, mu1, mu2, mu3);
        float y = s.equ.evalY(u, delta, mu1, mu2, mu3);

        float xn = s.equ.evalX(u-s.uStep, delta, mu1, mu2, mu3);
        float yn = s.equ.evalY(u-s.uStep, delta, mu1, mu2, mu3);
        
        PVector n = new PVector((y-yn), (x-xn));
        
        n.normalize();

        ticks.add(new Tick(new PVector(x, y), n, nfc(u, s.digits)));
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
    
    float x = s.equ.evalX(u, delta, mu1, mu2, mu3);
    float y = s.equ.evalY(u, delta, mu1, mu2, mu3);
  
    return mc2wc(new PVector(x,y));
  }


  public void doDraw()
  {
    stroke(0);
    fill(0);
    smooth();


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
    
    textSize(10);
    textAlign(RIGHT, CENTER);
    for (int i=0; i<ticksUVW.size (); i++)
    {
      ArrayList<Tick> ticks = ticksUVW.get(i);

      for ( int j=0; j<ticks.size (); j++)
      {
        Tick t = ticks.get(j);

        PVector p = mc2wc(t.p);
        PVector n = new PVector(t.n.x, t.n.y);
        n.mult(5);
        
        PVector pp = new PVector(p.x, p.y);
        pp.sub(n);

        line(p.x, p.y, pp.x, pp.y);
        
        pp.sub(n);
        text(t.l, pp.x, pp.y);
      }
    }
    
    // lables on scales

    textSize(10);
    textAlign(CENTER, CENTER);
    
    for (int i=0; i<scalesUVW.size(); i++)
    {
      Scale s = scalesUVW.get(i);
      ArrayList<PVector> pts = pointsUVW.get(i);

      PVector p1 = mc2wc(pts.get(0));
      PVector p2 = mc2wc(pts.get(pts.size()-1));
      
      float offset = 20;

      if (p1.y < p2.y)
      {
        text(s.name, p2.x, p2.y+offset);
        text("["+s.unit+"]", p1.x, p1.y-offset);      
      }     
      else
      {
        text(s.name, p1.x, p1.y+offset);
        text("["+s.unit+"]", p2.x, p2.y-offset);      
      }
      
    }
  }
}
