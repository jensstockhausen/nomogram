
class NomogamCreator
{
  NomogamCreator(){}
  
  public NomogramScales create(String name)
  {
    if (name == "earth_curve" ) return createEarthCurvature();
    if (name == "ohms_law" )    return createOhmsLaw();
  
    return null;
  }

  public NomogramScales createEarthCurvature()
  { 
    ArrayList<Scale> scales = new ArrayList<Scale>();

    scales.add(new Scale("Antenna Height", "feet",  0.0, 10000.0, 400.0, 0));
    scales.add(new Scale("Distance",       "miles", 0.0, 250.0,    30.0, 0));
    scales.add(new Scale("Object Height",  "feet",  0.0, 10000.0, 400.0, 0));

    Determinant det = new ParallelScale( 
      new Function() { public float eval(float u) { return 1.22 * sqrt(u);    }; },
      new Function() { public float eval(float v) { return v;                 }; },
      new Function() { public float eval(float w) { return sqrt( w / 0.672);  }; });

    float delta = 120;
    float mu1   = 2;
    float mu2   = mu1;
    float mu3   = mu2;
 
    return new NomogramScales(scales, det, delta, mu1, mu2, mu3, 60);
  }

  public NomogramScales createOhmsLaw()
  { 
    ArrayList<Scale> scales = new ArrayList<Scale>();
    
    scales.add(new Scale("Volage",       "V",    2.0,  12.0,  1.0, 0));
    scales.add(new Scale("Current",     "mA",   2.0,   50.0,  5.0, 0));
    scales.add(new Scale("Resistance", "ohm",  50.0, 1000.0, 50.0, 0));

    Determinant det = new NScale( 
      new Function() { public float eval(float u) { return u;      }; },
      new Function() { public float eval(float v) { return v/1000; }; },
      new Function() { public float eval(float w) { return w;      }; });

    float delta = 900;
    float mu1   = 100;
    float mu2   = 1.3;
    float mu3   = 1;
   
    return new NomogramScales(scales, det, delta, mu1, mu2, mu3, 60);
  }
  
}
