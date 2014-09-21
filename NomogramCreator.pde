
class NomogamCreator
{
  NomogamCreator()
  {}

  public NomogramScales createEarthCurvature()
  {
    
    ArrayList<Scale> scales = new ArrayList<Scale>();

    scales.add(new Scale(
    "Antenna Height", "feet", 0.0, 10000.0, 400.0, 0, 
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
    "Distance", "miles", 0.0, 250.0, 30.0, 0, 
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
    "Object Height", "feet", 0.0, 10000.0, 400.0, 0, 
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

    return new NomogramScales(scales, 500, 8, 60);
  }
}
