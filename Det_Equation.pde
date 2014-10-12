

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
