
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
    
    offsetScaleU = (uMax - uMin) / (puMax.y - puMin.y);
    
    PVector pwMax = scales.value2wc(scales.scalesUVW.get(2).uMax, 2);
    PVector pwMin = scales.value2wc(scales.scalesUVW.get(2).uMin, 2);
    
    offsetScaleW = (wMax - wMin) / (pwMax.y - pwMin.y);    
    
  }

  void updateLine()
  {
    //v = scales.crossing.evalV(u,w);
    
    PVector pu = scales.value2wc(u, 0);
    //PVector pv = scales.value2wc(v, 1);
    PVector pw = scales.value2wc(w, 2);

    x1 = pu.x;
    y1 = pu.y;

    //x2 = pv.x;
    //y2 = pv.y;
    
    x3 = pw.x;
    y3 = pw.y;
  }
  
  void move(boolean moveU, float offset)
  {
    if (moveU)
    {
      u = u - offset * offsetScaleU;
      
      if (u<uMin) u = uMin;
      if (u>uMax) u = uMax;
    }
    else
    {
      w = w - offset * offsetScaleW;
      
      if (w<wMin) w = wMin;
      if (w>wMax) w = wMax;
    }
    updateLine();
  }

  void doDraw(boolean moveU)
  {
    updateLine();

    stroke(250,0,0);

    line(x1, y1, x3, y3);
    
    stroke(0);
    fill(0);
    ellipse(x1,y1,2,2);
    ellipse(x2,y2,2,2);
    ellipse(x3,y3,2,2);    
    
    textSize(10);
    textAlign(RIGHT, CENTER);    
    
    if (moveU)
    {      
      PVector pu1 = scales.value2wc(uMin, 0);
      PVector pu = scales.value2wc(uMax, 0);
      
      if (pu1.y < pu.y)
      {
        pu = pu1;
      }
      
      line (pu.x, pu.y,     pu.x-5, pu.y-5);
      line (pu.x-5, pu.y-5, pu.x+5, pu.y-5);
      line (pu.x+5, pu.y-5, pu.x, pu.y);
    }
    else
    {
      PVector pw1 = scales.value2wc(wMin, 2);
      PVector pw = scales.value2wc(wMax, 2);
      
      if (pw1.y < pw.y)
      {
        pw = pw1;
      }
      
      line (pw.x, pw.y,     pw.x-5, pw.y-5);
      line (pw.x-5, pw.y-5, pw.x+5, pw.y-5);
      line (pw.x+5, pw.y-5, pw.x, pw.y);
    }
    
    
  }
}
