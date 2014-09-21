
class Isopleth
{

  float u, v, w;

  float x1, y1;
  float x2, y2;

  NomogramScales scales;

  Isopleth(NomogramScales scales)
  {
    this.scales = scales;

    u = (scales.scalesUVW.get(0).uMax - scales.scalesUVW.get(0).uMin) / 2 + scales.scalesUVW.get(0).uMin;
    v = (scales.scalesUVW.get(1).uMax - scales.scalesUVW.get(1).uMin) / 2 + scales.scalesUVW.get(1).uMin;
    w = (scales.scalesUVW.get(2).uMax - scales.scalesUVW.get(2).uMin) / 2 + scales.scalesUVW.get(2).uMin;
  }

  void updateLine()
  {
    PVector pu = scales.value2wc(u, 0);
    PVector pv = scales.value2wc(v, 1);
    PVector pw = scales.value2wc(w, 2);

    x1 = pu.x;
    y1 = pu.y;

    x2 = pw.x;
    y2 = pw.y;
  }
  
  void move(float offset)
  {
    u = u + offset * 10.0;
    updateLine();
  }

  void doDraw()
  {
    updateLine();

    stroke(0);
    line(x1, y1, x2, y2);
  }
}

