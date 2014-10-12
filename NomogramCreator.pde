
class NomogamCreator
{
  NomogamCreator(){}
  
  public NomogramScales create(String name)
  {
    if (name == "earth_curve" ) return createEarthCurvature();
    if (name == "ohms_law" )    return createOhmsLaw();
    if (name == "bmi" )         return createBMI();
  
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
 
    return new NomogramScales(scales, det, delta, mu1, mu2, mu3, 80);
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
   
    return new NomogramScales(scales, det, delta, mu1, mu2, mu3, 60);
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
   
    return new NomogramScales(scales, det, delta, mu1, mu2, mu3, 60);
  }
  
  
  
  
}
