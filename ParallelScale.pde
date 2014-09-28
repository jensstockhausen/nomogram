
class ParallelScale extends Determinant
{
  ParallelScale(Function fu, Function fv, Function fw)
  {
    super(fu,fv,fw);
  }
  
  public PVector evalU(float u, float delta, float mu1, float mu2, float mu3)
  {
    float x,y; 
    
    x = -delta; 
    y = mu1 * fu.eval(u); 
    
    return new PVector(x,y);
  };
  
  public PVector evalV(float v, float delta, float mu1, float mu2, float mu3)
  {
    float x,y;
    
    x = 0;
    y = ((mu1*mu3)/(mu1+mu3)) * fv.eval(v);
        
    return new PVector(x,y);
  };
  
  public PVector evalW(float w, float delta, float mu1, float mu2, float mu3)
  {
    float x,y; 
    
    x = delta;
    y = mu3 * fw.eval(w);
    
    return new PVector(x,y);
  };
  
  
  public float crossing(float u, float w)
  {
    return fu.eval(u) + fw.eval(w);
  }
  
  
  
  
}
