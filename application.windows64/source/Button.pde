class Button
{
  private color rgb = color(0);
  private float posx, posy;
  private float rectWid, rectHei, exRectWid, exRectHei, modWid, modHei, trns, txtSize;
  private boolean wasPressed, active, hover,noAnim, doHand;
  private String onButt;
  Button(float x, float y, color col, String onButtTxt)
  {
    active = false;
    rgb = col;
    posx = x; 
    posy = y;
    onButt = onButtTxt;
    rectWid=var*6;
    rectHei=2*var;
    exRectHei =rectHei*1.07;
    exRectWid = rectWid*1.07;
    modWid = rectWid;
    modHei = rectHei;
    wasPressed = false;
  }
  Button(float x, float y,float wdth,float hgt, color col, String onButtTxt)
  {
    noAnim = true;
    active = false;
    rgb = col;
    posx = x; 
    posy = y;
    onButt = onButtTxt;
    rectWid=wdth;
    rectHei=hgt;
    exRectHei =rectHei;
    exRectWid = rectWid;
    modWid = rectWid;
    modHei = rectHei;
    wasPressed = false;
  }
  Button(float x, float y, color col,String onButtTxt, float trans)
  {
    active = false;
    onButt = onButtTxt;
    trns = trans;
    rgb = col;
    posx = x; 
    posy = y;
    rectWid=var*6;
    rectHei=2*var;
    exRectHei = 2*var*1.07;
    exRectWid = var*6*1.07;
    modWid = rectWid;
    modHei = rectHei;
    wasPressed = false;
  }
  float getHeight()
  {
    return rectHei;
  }
  float getWidth()
  {
    return rectWid;
  }
  float getX()
  {
    return posx;
  }
  float getY()
  {
    return posy;
  }
  
  void noAnim(boolean anim)
  {
    noAnim = anim;
  }
  boolean show(Button[] other)
  {
    translate(0, trns);
    rectMode(CENTER);


    fill(rgb);

    if (mouseX>posx-modWid/2 && mouseX<posx+modWid/2 && mouseY>posy-modHei/2 && mouseY<posy+modHei/2)
    {
      cursor(HAND);
      hover = true;
      if(noAnim==false)
      rect(posx, posy, exRectWid, exRectHei);
      else
      rect(posx, posy, rectWid, rectHei);
      
      if (mousePressed == false && wasPressed)
      {
        wasPressed=false;
        exRectHei = rectHei*1.07;
        exRectWid = rectWid*1.07;
        rectMode(CORNER);
        cursor(ARROW);
        hover = false;
        return true;
      }
      if (mousePressed)
      {
        if (exRectWid>=rectWid*0.95)
          exRectWid-=0.04*rectWid;

        if (exRectHei>=rectHei*0.95)
          exRectHei-=0.04*rectHei;
        wasPressed=true;
        active =true;
      } else
      {
        active = false;
        modWid = exRectWid;
        modHei = exRectHei;
      }
    } else
    {
      hover = false;
      doHand=true;
      for(int i=0;i<other.length;i++)
      {
        if(other[i].hover)
        {
          doHand=false;
        }
      }
      if(doHand)
      cursor(ARROW);
      
      active=false;
      wasPressed=false;
      rect(posx, posy, rectWid, rectHei);
      exRectHei = rectHei*1.07;
      exRectWid = rectWid*1.07;
      modWid = rectWid;
      modHei = rectHei;
    }
    fill(0);
    textFont(pixFontMX);
    textAlign(CENTER);
    txtSize = ((modWid/rectWid)*100);
    if (active)
      txtSize = ((exRectWid/rectWid)*100);

    textSize(txtSize-15);
    text(onButt, posx, posy+0.6*var);
    
    rectMode(CORNER);
    return false;
  }
}