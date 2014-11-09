
/*
* scales are parallel
*/

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
