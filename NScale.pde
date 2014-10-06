
class NScale extends Determinant
{
  NScale(Func fu, Func fv, Func fw)
  {
    super(fu,fv,fw);
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
    return fu.ev(u)  / ( fu.ev(u) + fw.ev(w));
  }
  
}
