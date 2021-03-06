
class Isopleth
{
  float u, v, w;

  float x1, y1;
  float x2, y2;
  float x3, y3;

  float offsetScaleU, offsetScaleW;
  float uMin, uMax;
  float wMin, wMax;

  NomogramScales scales;

  Isopleth(NomogramScales scales)
  {
    this.scales = scales;

    u = (scales.scalesUVW.get(0).uMax - scales.scalesUVW.get(0).uMin) / 2 + scales.scalesUVW.get(0).uMin;
    v = (scales.scalesUVW.get(1).uMax - scales.scalesUVW.get(1).uMin) / 2 + scales.scalesUVW.get(1).uMin;
    w = (scales.scalesUVW.get(2).uMax - scales.scalesUVW.get(2).uMin) / 2 + scales.scalesUVW.get(2).uMin;
    
    uMin = scales.scalesUVW.get(0).uMin;
    uMax = scales.scalesUVW.get(0).uMax;
    
    wMin = scales.scalesUVW.get(2).uMin;
    wMax = scales.scalesUVW.get(2).uMax;
    
    PVector puMax = scales.value2wc(scales.scalesUVW.get(0).uMax, 0);
    PVector puMin = scales.value2wc(scales.scalesUVW.get(0).uMin, 0);
    
    offsetScaleU = (uMax - uMin) / PVector.dist(puMax, puMin);
    
    PVector pwMax = scales.value2wc(scales.scalesUVW.get(2).uMax, 2);
    PVector pwMin = scales.value2wc(scales.scalesUVW.get(2).uMin, 2);
    
    offsetScaleW = (wMax - wMin) / PVector.dist(pwMax, pwMin);    
    
  }

  void updateLine()
  {
    v = scales.vFromUW(u, w);
    
    PVector pu = scales.value2wc(u, 0);
    PVector pv = scales.value2wc(v, 1);
    PVector pw = scales.value2wc(w, 2);

    x1 = pu.x;
    y1 = pu.y;

    x2 = pv.x;
    y2 = pv.y;
    
    x3 = pw.x;
    y3 = pw.y;
  }
  
  void move(boolean moveU, float offset)
  {
    if (moveU)
    {
      u = u + offset * offsetScaleU;
      
      if (u<uMin) u = uMin;
      if (u>uMax) u = uMax;
    }
    else
    {
      w = w + offset * offsetScaleW;
      
      if (w<wMin) w = wMin;
      if (w>wMax) w = wMax;
    }
    
    updateLine();
  }

  void doDraw(boolean moveU)
  {
    updateLine();
    
    stroke(255,41,78);
    strokeWeight(1.2);
    line(x1, y1, x3, y3);
    
    stroke(0);
    noFill();
    int r = 8;
    ellipse(x1,y1,r,r);
    ellipse(x2,y2,r,r);
    ellipse(x3,y3,r,r);     
    
    strokeWeight(1.0);
    
    if (moveU)
    {      
      PVector pu1 = scales.value2wc(uMin, 0);
      PVector pu = scales.value2wc(uMax, 0);
      
      if (pu1.y < pu.y)
      {
        pu = pu1;
      }
      
      line (pu.x,   pu.y-3, pu.x-5, pu.y-7);
      line (pu.x-5, pu.y-7, pu.x+5, pu.y-7);
      line (pu.x+5, pu.y-7, pu.x,   pu.y-3);
    }
    else
    {
      PVector pw1 = scales.value2wc(wMin, 2);
      PVector pw = scales.value2wc(wMax, 2);
      
      if (pw1.y < pw.y)
      {
        pw = pw1;
      }
      
      line (pw.x,   pw.y-3, pw.x-5, pw.y-7);
      line (pw.x-5, pw.y-7, pw.x+5, pw.y-7);
      line (pw.x+5, pw.y-7, pw.x,   pw.y-3);
    }
    
    stroke(0);
    fill(0);
    textSize(16);
    textAlign(LEFT, BOTTOM);    
    
    String curentValues = "";
    float  precision = 0.0;
    
    precision = pow(10, scales.scalesUVW.get(0).digits);
    curentValues = scales.scalesUVW.get(0).name + ": " + round(u*precision)/precision + "[" +scales.scalesUVW.get(0).unit + "] ";
    text(curentValues, 10 + width/3*0, height - 5); 
    
    precision = pow(10, scales.scalesUVW.get(1).digits);
    curentValues = scales.scalesUVW.get(1).name + ": " + round(v*precision)/precision + "[" +scales.scalesUVW.get(1).unit + "] ";
    text(curentValues, 10 + width/3*1, height - 5); 

    precision = pow(10, scales.scalesUVW.get(2).digits);
    curentValues = scales.scalesUVW.get(2).name + ": " + round(w*precision)/precision + "[" +scales.scalesUVW.get(2).unit + "] ";
    text(curentValues, 10 + width/3*2, height - 5); 
    
  }
}
