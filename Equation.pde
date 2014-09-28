

/*
* basic interface for all nomogramfunctions
*/

interface Equation 
{
  public float evalX(float u, float delta, float mu1, float mu2, float mu3);
  public float evalY(float u, float delta, float mu1, float mu2, float mu3);
}

interface Function
{
  public float eval(float value);
}

abstract class Determinant
{
  Function fu,fv,fw;
  
  Determinant(Function fu, Function fv, Function fw)
  {
    this.fu = fu;
    this.fv = fv;
    this.fw = fw;
  }

  public abstract PVector evalU(float u, float delta, float mu1, float mu2, float mu3);
  public abstract PVector evalV(float v, float delta, float mu1, float mu2, float mu3);
  public abstract PVector evalW(float w, float delta, float mu1, float mu2, float mu3);
  
  public abstract float crossing(float u, float w);

  public PVector eval(int scaleNr, float value, float delta, float mu1, float mu2, float mu3)
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
