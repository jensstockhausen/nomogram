class Scale
{
  String name;
  String unit;
  
  float uMin;
  float uMax;
  float uStep;
  float uSubTicks;
  
  int digits;
  
  Scale(String name, String unit, 
        float uMin, float uMax, float uStep, float uSubTicks, int digits)
  {
    this.name  = name;
    this.unit  = unit;
    this.uMin  = uMin;
    this.uMax  = uMax;
    this.uStep = uStep;
    this.uSubTicks = uSubTicks;
    this.digits = digits;
  }
}
