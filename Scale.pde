
interface Equation 
{
  public float evalX(float u, float delta, float mu);
  public float evalY(float u, float delta, float mu);
}


class Scale
{
  String name;
  String unit;
  
  float uMin;
  float uMax;
  float uStep;
  
  int digits;
  
  Equation equ;
  
  Scale(String name, String unit, 
        float uMin, float uMax, float uStep, int digits,
        Equation equation)
  {
    this.name  = name;
    this.unit  = unit;
    this.uMin  = uMin;
    this.uMax  = uMax;
    this.uStep = uStep;
    this.digits = digits;
    this.equ = equation;
  }
}
