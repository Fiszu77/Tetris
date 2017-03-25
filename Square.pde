Field area;

class Square
{
  PImage cactus;
  int x = 5, y =5, falls = 0;
  float posy = 0, alpha = 255; 
  color rgb = color(0), strokeRgb= color(0);
  int dead = 0;
  boolean screen = false;

  Square(int X, int Y, color Rgb)
  {
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
    posy=Y*var;
    rgb = Rgb;
    strokeRgb = 0;
    area = new Field();
  }
  Square(int X, int Y, color Rgb, int al)
  {
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

      fill(rgb, alpha);
      if (screen)
      {
        if (noShadow==false) {
          stroke(strokeRgb);
          recurect(var-var*0.1);
        }
      }
      stroke(0);
      image(cactus, x*var, y*var);
      //rect(x*var, y*var, var, var);
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
      image(cactus, x*var, posy);
      if (posy<y*var)
        posy+=0.1*var;
      else
      {
        settle();
        posy=y*var;
        dead=0;
      }
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
      posy=y*var;
      falls++;
      if (y<hgt[1])
        falls++;

      if (y<hgt[2])
        falls++;

      if (y<hgt[3])
        falls++;

      area.move(x, y);
      y+=falls;

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
  }

  void settle()
  {
    area.settle(x, y);
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