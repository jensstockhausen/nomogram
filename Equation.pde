

/*
* basic interface for all nomogramfunctions
*/

/*
interface Equation 
{
  public float evalX(float u, float delta, float mu1, float mu2, float mu3);
  public float evalY(float u, float delta, float mu1, float mu2, float mu3);
}
*/

interface Func
{
  public float ev(float value);
}

class Determinant
{
  Func fu,fv,fw;
  
  Determinant(Func fu, Func fv, Func fw)
  {
    this.fu = fu;
    this.fv = fv;
    this.fw = fw;
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
