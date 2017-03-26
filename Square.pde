Field area;

class Square
{
  PImage cactus, flower, lCac, rCac;
  int x = 5, y =5, falls = 0, posy = 0;
  float alpha = 255, flowY=1, rCacX, lCacX,a=0; 
  color rgb = color(0), strokeRgb= color(0);
  int dead = 0;
  boolean screen = false, flowSpwn=false, flowMove=false, lcSpwn=false, rcSpwn=false;

  Square(int X, int Y, color Rgb)
  {
    if (Rgb == red)
      cactus =loadImage("cacR.png");
    if (Rgb==green){
      cactus=loadImage("cacG.png");
      cactus.resize(30,30);
    }
    if (Rgb==yellow)
      cactus=loadImage("cacY.png");
    if (Rgb==purple)
      cactus=loadImage("cacP.png");
    if (Rgb==orange)
      cactus=loadImage("cacO.png");
    if (Rgb==lightBlue)
      cactus=loadImage("cacLb.png");
    if (Rgb==blue)
      cactus=loadImage("cacB.png");

    flower =loadImage("flower.png");
    lCac = loadImage("lCac.png");
    rCac = loadImage("rCac.png");
    x = X;
    y=Y;
    posy=int(Y*var);
    rCacX=x*var;
    lCacX=x*var;
    rgb = Rgb;
    strokeRgb = 0;
    area = new Field();
  }
  Square(int X, int Y, color Rgb, int al)
  {
    flower =loadImage("flower.png");
    if (Rgb == red)
      cactus =loadImage("cacR.png");
    if (Rgb==green)
      cactus=loadImage("cacG.png");
    if (Rgb==yellow)
      cactus=loadImage("cacY.png");
    if (Rgb==purple)
      cactus=loadImage("cacP.png");
    if (Rgb==orange)
      cactus=loadImage("cacO.png");
    if (Rgb==lightBlue)
      cactus=loadImage("cacLb.png");
    if (Rgb==blue)
      cactus=loadImage("cacB.png");
    x = X;
    y=Y;
    flowY=y;
    alpha = 0;
    rgb = Rgb;
    strokeRgb = Rgb;
    screen=true;
  }
  void recurect(float len)
  {
    if (len>0) {
      rectMode(CENTER);
      // rect(x*var+0.5*var, y*var+0.5*var, len-var*0.1, len-var*0.1);
      rect(x*var+0.5*var, y*var+0.5*var, len-var, len-var);      
      recurect(len-var*0.1);
      rectMode(CORNER);
    }
  }
  int show()
  {

    if (dead == 0)
    {
      if (flowSpwn)
      {
        image(flower, x*var, flowY);
        flowGrow();
      }
      if (rcSpwn)
      {
        image(rCac, rCacX, y*var);
        rcGrow();
      }
      if (lcSpwn)
      {
        image(lCac, lCacX, y*var);
        lcGrow();
      }
      fill(rgb, alpha);
      if (screen)
      {
        if (noShadow==false) {
          stroke(strokeRgb);
          recurect(var+1);
        }
      } else {
        stroke(0);
        image(cactus, x*var, y*var);
        //rect(x*var, y*var, var, var);
      }
    } 
    if (dead == 1)
    {
      if (alpha>10)
      {
        stroke(strokeRgb, alpha);
        //fill(rgb, alpha);
        tint(255, alpha);
        image(cactus, x*var, y*var);
        alpha-=10;
        noTint();
        if (alpha<=10)
          return 1;
      }
    } 
    if (dead == 2)
    {
      stroke(strokeRgb);
      fill(rgb);
      if (rcSpwn)
      {
        image(rCac, rCacX, posy);
        rcGrow();
      }
      if (lcSpwn)
      {
        image(lCac, lCacX, posy);
        lcGrow();
      }
      if (flowSpwn)
      {
        if (flowMove)
          image(flower, x*var, flowY=posy);
        else
          image(flower, x*var, flowY=posy-var);
        //flowGrow();
      }
      image(cactus, x*var, posy);
      if (posy<y*var)
      {
        if(y*var-posy<5)
        posy+=1;
        else
        posy+=round(tan(a)*10.0)/10.0;
      }
      else
      {
        area.settle(x, y);
        posy=int(y*var);
        dead=0;
      }
      if(a<PI/2.2)
        a+=PI/70;
    }
    return 0;
  }
  int getState()
  {
    return dead;
  }
  void show(int shape)
  {
    stroke(0);
    fill(rgb);
    if (shape == 1)
    {
      rect(x*var - var/2, y*var, var, var);
    } else if (shape == 7)
    {
      rect(x*var - var/2, y*var - var/2, var, var);
    } else
    {
      rect(x*var, y*var, var, var);
    }
  }
  void fall(int[] hgt)
  {
    if (y<hgt[0] && dead == 0)
    { 
      falls = 0;
      posy=int(y*var);
      falls++;
      if (y<hgt[1])
        falls++;

      if (y<hgt[2])
        falls++;

      if (y<hgt[3])
        falls++;

      area.move(x, y);
      y+=falls;
      if (flowY>posy-var)
        flowMove=true;
      a=0;
      dead = 2;
    }
  }
  void kill(int[] hgt)
  {

    if (hgt[0] == y || hgt[1] == y || hgt[2] == y || hgt[3] == y)
    {
      dead = 1;
      area.move(x, y);
    }
    if (!area.isEmpty(x, y-1))
    {
      flowSpwn=false;
    }
    if (!area.isEmpty(x+1, y))
    {
      rcSpwn=false;
    }
    if (!area.isEmpty(x-1, y))
    {
      lcSpwn=false;
    }
  }

  void settle()
  {
    area.settle(x, y);
    posy=int(y*var);
    flowSpwn();
    cacSpwn();
  }
  void cacSpwn()
  {
    if (area.isEmpty(x+1, y))
    {
      if (random(1)>0.90)
        rcSpwn=true;
    }
    if (area.isEmpty(x-1, y))
    {
      if (random(1)>0.90)
        lcSpwn=true;
    }
  }
  void flowSpwn()
  {
    if (area.isEmpty(x, y-1))
    {
      if (flowSpwn)
        flowY=posy-var;
      else
        flowY=posy;

      if (random(1)>0.75)
        flowSpwn=true;
    } else
    {
      flowSpwn = false;
    }
  }
  void rcGrow()
  {
    if (rCacX<x*var+var)
    {
      rCacX++;
    }
  }
  void lcGrow()
  {
    if (lCacX>x*var-var)
    {
      lCacX--;
    }
  }
  void flowGrow()
  {
    if (flowY>posy-var)
    {
      flowY--;
    }
  }
  void goRight()
  {
    x++;
    rCacX=x*var;
    lCacX=x*var;
  }
  void goLeft()
  {
    x--;
    rCacX=x*var;
    lCacX=x*var;
  }
  boolean isDownEmpty()
  {
    if (area.isEmpty(x, y+1))
    {
      return true;
    } else
      return false;
  }
  boolean isRightEmpty()
  {
    if (area.isEmpty(x+1, y))
    {
      return true;
    } else
      return false;
  }
  boolean isLeftEmpty()
  {
    if (area.isEmpty(x-1, y))
    {
      return true;
    } else
      return false;
  }
}