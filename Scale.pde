class Scale
{
  String name;
  String unit;
  
  float uMin;
  float uMax;
  float uStep;
  
  int digits;
  
  Scale(String name, String unit, 
        float uMin, float uMax, float uStep, int digits )
  {
    this.name  = name;
    this.unit  = unit;
    this.uMin  = uMin;
    this.uMax  = uMax;
    this.uStep = uStep;
    this.digits = digits;
  }
}
