
/*
* scales are parallel
*/


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
