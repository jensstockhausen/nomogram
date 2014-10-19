
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

class ConcurrentScale extends Determinant
{
  ConcurrentScale(Func fu, Func fv, Func fw, Func invFv)
  {
    super(fu,fv,fw, invFv);
  }
  
  public PVector evalU(float u, float delta, float mu1, float mu2, float mu3)
  {
    float x,y; 
    
    x = delta * fu.ev(u); 
    y = 0.0; 
    
    return new PVector(x,y);
  };
  
  public PVector evalV(float v, float delta, float mu1, float mu2, float mu3)
  {
    float x,y;
    
    x = delta * fv.ev(v); 
    y = mu3   * fv.ev(v); 
        
    return new PVector(x,y);
  };
  
  public PVector evalW(float w, float delta, float mu1, float mu2, float mu3)
  {
    float x,y; 
    
    x = 0.0;
    y = mu3   * fw.ev(w);
    
    return new PVector(x,y);
  };
  
  
  public float crossing(float u, float w)
  {
    return invFv.ev( (fu.ev(u)*fw.ev(w))  / (fu.ev(u)+fw.ev(w)) );
  }
  
}


/*
* basic interface for all nomogramfunctions
*/

interface Func
{
  public float ev(float value);
}

class Determinant
{
  Func fu,fv,fw;
  Func invFv;
  
  Determinant(Func fu, Func fv, Func fw, Func invFv)
  {
    this.fu = fu;
    this.fv = fv;
    this.fw = fw;
    this.invFv = invFv;
  }

  public PVector evalU(float u, float delta, float mu1, float mu2, float mu3) { return new PVector(); };
  public PVector evalV(float v, float delta, float mu1, float mu2, float mu3) { return new PVector(); };
  public PVector evalW(float w, float delta, float mu1, float mu2, float mu3) { return new PVector(); };
  
  public float crossing(float u, float w) { return 0.0; };

  public PVector ev(int scaleNr, float value, float delta, float mu1, float mu2, float mu3)
  {
    switch (scaleNr)
    {
      case 0: return evalU(value, delta, mu1, mu2, mu3);
      case 1: return evalV(value, delta, mu1, mu2, mu3);
      case 2: return evalW(value, delta, mu1, mu2, mu3);
    }
    
    return new PVector(0,0);
  } 
}

class NScale extends Determinant
{
  NScale(Func fu, Func fv, Func fw, Func invFv)
  {
    super(fu,fv,fw, invFv);
  }
  
  public PVector evalU(float u, float delta, float mu1, float mu2, float mu3)
  {
    float x,y; 
    
    x = 0; 
    y = mu1 * fu.ev(u); 
    
    return new PVector(x,y);
  };
  
  public PVector evalV(float v, float delta, float mu1, float mu2, float mu3)
  {
    float x,y;
    
    x = (delta * mu1 * (fv.ev(v)/(fv.ev(v)+1.0)))/((mu1-mu3)*(fv.ev(v)/(fv.ev(v)+1.0)) + mu3);
    y = 0.0 + (x * mu2);
        
    return new PVector(x,y);
  };
  
  public PVector evalW(float w, float delta, float mu1, float mu2, float mu3)
  {
    float x,y; 
    
    x = delta;
    y = -mu3 * fw.ev(w) + (x * mu2);
    
    return new PVector(x,y);
  };
  
  
  public float crossing(float u, float w)
  {
    return invFv.ev( fu.ev(u)  / fw.ev(w) );
  }
  
}

class ParallelScale extends Determinant
{
  ParallelScale(Func fu, Func fv, Func fw, Func invFv)
  {
    super(fu,fv,fw,invFv);
  }
  
  public PVector evalU(float u, float delta, float mu1, float mu2, float mu3)
  {
    float x,y; 
    
    x = -delta; 
    y = mu1 * fu.ev(u); 
    
    return new PVector(x,y);
  };
  
  public PVector evalV(float v, float delta, float mu1, float mu2, float mu3)
  {
    float x,y;
    
    x = 0;
    y = ((mu1*mu3)/(mu1+mu3)) * fv.ev(v);
        
    return new PVector(x,y);
  };
  
  public PVector evalW(float w, float delta, float mu1, float mu2, float mu3)
  {
    float x,y; 
    
    x = delta;
    y = mu3 * fw.ev(w);
    
    return new PVector(x,y);
  };
  
  
  public float crossing(float u, float w)
  {
    return invFv.ev( fu.ev(u) + fw.ev(w) );
  }
  
}

class Isopleth
{
  float u, v, w;

  float x1, y1;
  float x2, y2;
  float x3, y3;

  float offsetScaleU, offsetScaleW;
  float uMin, uMax;
  float wMin, wMax;

  NomogramScales scales;

  Isopleth(NomogramScales scales)
  {
    this.scales = scales;

    u = (scales.scalesUVW.get(0).uMax - scales.scalesUVW.get(0).uMin) / 2 + scales.scalesUVW.get(0).uMin;
    v = (scales.scalesUVW.get(1).uMax - scales.scalesUVW.get(1).uMin) / 2 + scales.scalesUVW.get(1).uMin;
    w = (scales.scalesUVW.get(2).uMax - scales.scalesUVW.get(2).uMin) / 2 + scales.scalesUVW.get(2).uMin;
    
    uMin = scales.scalesUVW.get(0).uMin;
    uMax = scales.scalesUVW.get(0).uMax;
    
    wMin = scales.scalesUVW.get(2).uMin;
    wMax = scales.scalesUVW.get(2).uMax;
    
    PVector puMax = scales.value2wc(scales.scalesUVW.get(0).uMax, 0);
    PVector puMin = scales.value2wc(scales.scalesUVW.get(0).uMin, 0);
    
    offsetScaleU = (uMax - uMin) / PVector.dist(puMax, puMin);
    
    PVector pwMax = scales.value2wc(scales.scalesUVW.get(2).uMax, 2);
    PVector pwMin = scales.value2wc(scales.scalesUVW.get(2).uMin, 2);
    
    offsetScaleW = (wMax - wMin) / PVector.dist(pwMax, pwMin);    
    
  }

  void updateLine()
  {
    v = scales.vFromUW(u, w);
    
    PVector pu = scales.value2wc(u, 0);
    PVector pv = scales.value2wc(v, 1);
    PVector pw = scales.value2wc(w, 2);

    x1 = pu.x;
    y1 = pu.y;

    x2 = pv.x;
    y2 = pv.y;
    
    x3 = pw.x;
    y3 = pw.y;
  }
  
  void move(boolean moveU, float offset)
  {
    if (moveU)
    {
      u = u + offset * offsetScaleU;
      
      if (u<uMin) u = uMin;
      if (u>uMax) u = uMax;
    }
    else
    {
      w = w + offset * offsetScaleW;
      
      if (w<wMin) w = wMin;
      if (w>wMax) w = wMax;
    }
    
    updateLine();
  }

  void doDraw(boolean moveU)
  {
    updateLine();
    
    stroke(255,41,78);
    strokeWeight(1.2);
    line(x1, y1, x3, y3);
    
    stroke(0);
    noFill();
    int r = 8;
    ellipse(x1,y1,r,r);
    ellipse(x2,y2,r,r);
    ellipse(x3,y3,r,r);     
    
    strokeWeight(1.0);
    
    if (moveU)
    {      
      PVector pu1 = scales.value2wc(uMin, 0);
      PVector pu = scales.value2wc(uMax, 0);
      
      if (pu1.y < pu.y)
      {
        pu = pu1;
      }
      
      line (pu.x,   pu.y-3, pu.x-5, pu.y-7);
      line (pu.x-5, pu.y-7, pu.x+5, pu.y-7);
      line (pu.x+5, pu.y-7, pu.x,   pu.y-3);
    }
    else
    {
      PVector pw1 = scales.value2wc(wMin, 2);
      PVector pw = scales.value2wc(wMax, 2);
      
      if (pw1.y < pw.y)
      {
        pw = pw1;
      }
      
      line (pw.x,   pw.y-3, pw.x-5, pw.y-7);
      line (pw.x-5, pw.y-7, pw.x+5, pw.y-7);
      line (pw.x+5, pw.y-7, pw.x,   pw.y-3);
    }
    
    stroke(0);
    fill(0);
    textSize(16);
    textAlign(LEFT, BOTTOM);    
    
    String curentValues = "";
    float  precision = 0.0;
    
    precision = pow(10, scales.scalesUVW.get(0).digits);
    curentValues = scales.scalesUVW.get(0).name + ": " + round(u*precision)/precision + "[" +scales.scalesUVW.get(0).unit + "] ";
    text(curentValues, 10 + width/3*0, height - 5); 
    
    precision = pow(10, scales.scalesUVW.get(1).digits);
    curentValues = scales.scalesUVW.get(1).name + ": " + round(v*precision)/precision + "[" +scales.scalesUVW.get(1).unit + "] ";
    text(curentValues, 10 + width/3*1, height - 5); 

    precision = pow(10, scales.scalesUVW.get(2).digits);
    curentValues = scales.scalesUVW.get(2).name + ": " + round(w*precision)/precision + "[" +scales.scalesUVW.get(2).unit + "] ";
    text(curentValues, 10 + width/3*2, height - 5); 
    
  }
}

class NomogamCreator
{
  NomogamCreator(){}
  
  public NomogramScales create(String name)
  {
    if (name == "earth_curve" ) return createEarthCurvature();
    if (name == "ohms_law" )    return createOhmsLaw();
    if (name == "bmi" )         return createBMI();
    if (name == "resistors")    return cresteResists();
  
    return null;
  }

  public NomogramScales createEarthCurvature()
  { 
    ArrayList<Scale> scales = new ArrayList<Scale>();

    scales.add(new Scale("Antenna Height", "feet",  0.0, 10000.0, 400.0, 4, 0));
    scales.add(new Scale("Distance",       "miles", 0.0, 250.0,    30.0, 3, 0));
    scales.add(new Scale("Object Height",  "feet",  0.0, 10000.0, 400.0, 4, 0));

    Determinant det = new ParallelScale( 
      new Func() { public float ev(float u) { return 1.22 * sqrt(u);    }; },
      new Func() { public float ev(float v) { return v;                 }; },
      new Func() { public float ev(float w) { return sqrt( w / 0.672);  }; },
      new Func() { public float ev(float v) { return v;                 }; }
    );

    float delta = 220;
    float mu1   = 2.5;
    float mu2   = mu1;
    float mu3   = mu2;
 
    return new NomogramScales("Earth Curvature",scales, det, delta, mu1, mu2, mu3, 80);
  }

  public NomogramScales createOhmsLaw()
  { 
    ArrayList<Scale> scales = new ArrayList<Scale>();
    
    scales.add(new Scale("Volage",       "V",   2.0,   12.5,  1.0, 5, 0));
    scales.add(new Scale("Current",     "mA",   2.0,   50.0,  5.0, 5, 0));
    scales.add(new Scale("Resistance", "Ohm",  50.0, 1000.0, 50.0, 5, 0));

    Determinant det = new NScale( 
      new Func() { public float ev(float u) { return u;      }; },
      new Func() { public float ev(float v) { return v/1000.0; }; },
      new Func() { public float ev(float w) { return w;      }; },
      new Func() { public float ev(float v) { return v*1000.0; }; }
    );

    float delta = 1800;
    float mu1   = 130;
    float mu2   = 0.9;
    float mu3   = 1.5;
   
    return new NomogramScales("Ohm's Law (U=R*I)", scales, det, delta, mu1, mu2, mu3, 60);
  }
  
  
  public NomogramScales createBMI()
  { 
    ArrayList<Scale> scales = new ArrayList<Scale>();
    
    scales.add(new Scale("Weight",       "kg",  30.0, 115.0,   5.0, 5, 0));
    scales.add(new Scale("BMI",            "",  7.0,   50.0,   5.0, 5, 0));
    scales.add(new Scale("Height",       "cm", 150.0, 201.0,   2.0, 5, 0));

    Determinant det = new NScale( 
      new Func() { public float ev(float u) { return u;    }; },
      new Func() { public float ev(float v) { return v;    }; },
      new Func() { public float ev(float w) { return (w/100.0)*(w/100.0);  }; },
      new Func() { public float ev(float v) { return v;    }; }
    );

    float delta = 300;
    float mu1   = 2.5;
    float mu2   = 1.9;
    float mu3   = 120.0;
   
    return new NomogramScales("Body Mass Index", scales, det, delta, mu1, mu2, mu3, 60);
  }
  
  public NomogramScales cresteResists()
  { 
    ArrayList<Scale> scales = new ArrayList<Scale>();
    
    scales.add(new Scale("R1",       "Ohm",  30.0, 200.0,  10.0, 5, 0));
    scales.add(new Scale("R",        "Ohm",  10.0, 100.0,   5.0, 5, 0));
    scales.add(new Scale("R2",       "Ohm",  30.0, 200.0,  10.0, 5, 0));

    Determinant det = new ConcurrentScale( 
      new Func() { public float ev(float u) { return u;    }; },
      new Func() { public float ev(float v) { return v;    }; },
      new Func() { public float ev(float w) { return w;    }; },
      new Func() { public float ev(float v) { return v;    }; }
    );

    float delta = 900;
    float mu1   = 0.0;
    float mu2   = 0.0;
    float mu3   = 700;
   
    return new NomogramScales("Parallel Resistors (1/R=1/R1+1/R2)", scales, det, delta, mu1, mu2, mu3, 60);
  }  
  
  
}

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
      
//      print("I " + i);
//      print(" U " + s.uMin + " " + s.uMax);
//      print(" X " + xMin + "-" +xMax);
//      println("| Y " + yMin + "-" +yMax);

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
    
   // println("Scale " + scale);
    
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
class Scale
{
  String name;
  String unit;
  
  float uMin;
  float uMax;
  float uStep;
  float uSubTicks;
  
  int digits;
  
  Scale(String name, String unit, 
        float uMin, float uMax, float uStep, float uSubTicks, int digits)
  {
    this.name  = name;
    this.unit  = unit;
    this.uMin  = uMin;
    this.uMax  = uMax;
    this.uStep = uStep;
    this.uSubTicks = uSubTicks;
    this.digits = digits;
  }
}

