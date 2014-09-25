
class NomogamCreator
{
  NomogamCreator()
  {
  }
  
  public NomogramScales create(String name)
  {
    if (name == "earth_curve" )
    {
      return createEarthCurvature();
    }
    
    if (name == "ohms_law" )
    {
      return createOhmsLaw();
    }
  
    return null;
  }
  

  public NomogramScales createEarthCurvature()
  { 
    ArrayList<Scale> scales = new ArrayList<Scale>();

    scales.add(new Scale(
    "Antenna Height", "feet", 0.0, 10000.0, 400.0, 0, 
    new Equation() 
    {
      public float evalX(float u, float delta, float mu1, float mu2, float mu3) { 
        return -delta;
      }
      public float evalY(float u, float delta, float mu1, float mu2, float mu3) { 
        return mu1 * (1.22 * sqrt(u));
      }
    }
    ));

    scales.add(new Scale(
    "Distance", "miles", 0.0, 250.0, 30.0, 0, 
    new Equation() 
    {
      public float evalX(float v, float delta, float mu1, float mu2, float mu3) { 
        return 0.0;
      }
      public float evalY(float v, float delta, float mu1, float mu2, float mu3) { 
        return ((mu1*mu1)/(mu1*2)) * v;
      }
    }
    ));

    scales.add(new Scale(
    "Object Height", "feet", 0.0, 10000.0, 400.0, 0, 
    new Equation() 
    {
      public float evalX(float w, float delta, float mu1, float mu2, float mu3) { 
        return delta;
      }
      public float evalY(float w, float delta, float mu1, float mu2, float mu3) { 
        return mu1 * sqrt( w / 0.672);
      }
    }
    ));

    Crossing crossing = new Crossing()
    {
      public float evalV(float u, float w)
      {
        return (1.22 * sqrt(u) + sqrt( w/0.672));
      }
    };

    return new NomogramScales(scales, crossing, 500, 8, 60);
  }

  public NomogramScales createOhmsLaw()
  { 
    ArrayList<Scale> scales = new ArrayList<Scale>();

    scales.add(new Scale(
    "Voltage", "V", 2.0, 12.0, 1.0, 0, 
    new Equation() 
    {
      public float evalX(float u, float delta, float mu1, float mu2, float mu3) { 
        return 0.0;
      }
      public float evalY(float u, float delta, float mu1, float mu2, float mu3) { 
        return mu1 * u;
      }
    }
    ));

    scales.add(new Scale(
    "Current", "mA", 2.0, 100.0, 5.0, 0, 
    new Equation() 
    {
      public float evalX(float v, float delta, float mu1, float mu2, float mu3) { 
        return (delta * mu1 * (v/1000/(v/1000+1.0)))/((mu1-mu3)*(v/1000/(v/1000+1.0)) + mu3);
      }
      public float evalY(float v, float delta, float mu1, float mu2, float mu3) { 
        float x = evalX(v, delta, mu1, mu2, mu3);
        return 0.0 + (x * mu2);
      }
    }
    ));

    scales.add(new Scale(
    "Resistance", "Ohm", 50, 1000, 50.0, 0, 
    new Equation() 
    {
      public float evalX(float w, float delta, float mu1, float mu2, float mu3) 
      { 
        return delta;
      }
      public float evalY(float w, float delta, float mu1, float mu2, float mu3) { 
        float x = evalX(w, delta, mu1, mu2, mu3);
        return -mu3 * w + (x * mu2);
      }
    }
    ));


    Crossing crossing = new Crossing()
    {
      public float evalV(float u, float w)
      {
        return u/w * 1000;
      }
    };

    float delta = 900;
    float mu1   = 100;
    float mu2   = 1.3;
    float mu3   = 1;
    
    dumpValues(scales, delta, mu1, mu2, mu3);

    return new NomogramScales(scales, crossing,  delta, mu1, mu2, mu3, 60);
  }


  private void dumpValues(ArrayList<Scale> scales, float delta, float mu1, float mu2, float mu3)
  {
    for (int i=0; i<scales.size (); i++)
    {
      Scale s = scales.get(i);

      println("Scale: " + s.name);
      println("  delta : " + delta);
      println("  mu    : " + mu1 + " " + mu2 + " " +mu3);
      println("  uMin  : " + s.uMin + " X" + s.equ.evalX(s.uMin, delta, mu1, mu2, mu3) + "  Y"+ s.equ.evalY(s.uMin, delta, mu1, mu2, mu3));
      println("  uMax  : " + s.uMax + " X" + s.equ.evalX(s.uMax, delta, mu1, mu2, mu3) + "  Y"+ s.equ.evalY(s.uMax, delta, mu1, mu2, mu3));
    }
  }
}
