
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
  String title;
  
  ArrayList<Scale> scalesUVW;
  Determinant det;

  float delta;
  float mu1, mu2, mu3;

  float xMin, xMax;
  float yMin, yMax;

  float scale;
  float border;

  ArrayList<ArrayList<PVector>> pointsUVW;
  ArrayList<ArrayList<Tick>> ticksUVW;
  ArrayList<ArrayList<Tick>> ticksSub;

  NomogramScales(String title, ArrayList<Scale> scalesUVW, Determinant det, float delta, float mu1, float mu2, float mu3, float border)
  {
    this.title = title;
    
    this.scalesUVW = scalesUVW;
    this.det = det;
    
    this.delta = delta;
    this.mu1    = mu1;
    this.mu2    = mu2;
    this.mu3    = mu3;

    this.border = border; 
    pointsUVW = new ArrayList<ArrayList<PVector>>();
    ticksUVW  = new ArrayList<ArrayList<Tick>>();
    ticksSub  = new ArrayList<ArrayList<Tick>>();

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
        PVector p = det.ev(i, u, delta, mu1, mu2, mu3);
        
        float x = p.x;
        float y = p.y;

        if (x<=xMin) xMin = x;
        if (x>=xMax) xMax = x;
        if (y<=yMin) yMin = y;
        if (y>=yMax) yMax = y;

        points.add(p);
      }
      
      print("I " + i);
      print(" U " + s.uMin + " " + s.uMax);
      print(" X " + xMin + "-" +xMax);
      println("| Y " + yMin + "-" +yMax);

      pointsUVW.add(points);

      // points for drawing the ticks Main and Sub
      ArrayList<Tick> ticksM = new ArrayList<Tick>();
      ArrayList<Tick> ticksS = new ArrayList<Tick>();
   
      for (float u = s.uMin; u<=s.uMax; u += s.uStep)
      {
        PVector p  = det.ev(i, u, delta, mu1, mu2, mu3);
        
        PVector n  = det.ev(i, u+s.uStep, delta, mu1, mu2, mu3);
        PVector pp = det.ev(i, u-s.uStep, delta, mu1, mu2, mu3);
 
        n.sub(pp);
        n.normalize();
        n.set(-n.y, n.x);

        ticksM.add(new Tick(p, n, nfc(u, s.digits)));
        
        for (float uu = u; ((uu<u+s.uStep)&&(uu<s.uMax)); uu += s.uStep/s.uSubTicks)
        {
          PVector p_s  = det.ev(i, uu, delta, mu1, mu2, mu3);
        
          PVector n_s  = det.ev(i, uu+s.uStep, delta, mu1, mu2, mu3);
          PVector pp_s = det.ev(i, uu-s.uStep, delta, mu1, mu2, mu3);    
       
          n_s.sub(pp_s);
          n_s.normalize();
          n_s.set(-n_s.y, n_s.x);
          
          ticksS.add(new Tick(p_s, n_s, ""));
        }
        
        
      }
      
      ticksUVW.add(ticksM);
      ticksSub.add(ticksS);
      
    }

    if ( (xMax-xMin)/width > (yMax-yMin)/height )
    {
      scale = (width - 2*border)/(xMax-xMin);
    } 
    else
    {
      scale = (height - 2*border)/(yMax-yMin);
    }
    
    println("Scale " + scale);
    
  }


  private PVector mc2wc(PVector model)
  {
    return new PVector(
      (model.x - xMin) * scale + border, 
      height - border - (model.y - yMin) * scale  );
  }


  public PVector value2wc(float value, int i)
  {
    return mc2wc( det.ev(i, value, delta, mu1, mu2, mu3) );
  }
  
  public float vFromUW(float u, float w)
  {
    return det.crossing(u, w);
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
    
    for (int i=0; i<ticksUVW.size (); i++)
    {
      ArrayList<Tick> ticks  = ticksUVW.get(i);
      ArrayList<Tick> ticksS = ticksSub.get(i);

      PVector p1 = mc2wc(pointsUVW.get(i).get(0));
      PVector p2 = mc2wc(pointsUVW.get(i).get(pointsUVW.get(i).size()-1));
      
      for ( int j=0; j<ticksS.size(); j++)
      {
        Tick t = ticksS.get(j);

        PVector p = t.p;
        PVector n = new PVector(t.n.x, t.n.y);
        n.mult(4/scale);
        
        PVector pp = new PVector(p.x, p.y);
        pp.add(n);
        
        p  = mc2wc(p);
        PVector tEnd = mc2wc(pp);

        line(p.x, p.y, tEnd.x, tEnd.y);     
      }

      for ( int j=0; j<ticks.size(); j++)
      {
        Tick t = ticks.get(j);

        PVector p = t.p;
        PVector n = new PVector(t.n.x, t.n.y);
        n.mult(8/scale);
        
        PVector pp = new PVector(p.x, p.y);
        pp.add(n);
        
        p  = mc2wc(p);
        PVector tEnd = mc2wc(pp);

        line(p.x, p.y, tEnd.x, tEnd.y);

        if (p1.y < p2.y)
        {
          textAlign(LEFT, CENTER);
        }
        else
        {
          textAlign(RIGHT, CENTER);
        }
        
        pp.add(n);
        pp = mc2wc(pp);
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
      
      float offset = 25;

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
    
    // title
    textSize(24);
    textAlign(CENTER, CENTER);       
    text(title, width/2, 15);
    
  }
}
