Timer watch;
public static int score = 0;
class Score
{
  boolean active[] =new boolean[4];
  float alpha = 255;
  int lvl = 1;
  Score()
  {
    watch = new Timer();
  }
  void scoreFF()
  {
    score++;
  }
  void scoreLines(int lines, int level)
  {
    lvl = level;
    switch(lines)
    {
    case 1:
      score += 40*level;
      active[0]=true;
      //watch.getTime();
      alpha=255;
      break;
    case 2:
      active[1]=true;
      score += 100*level;
      alpha=255;
      break;
    case 3:
      active[2] = true;
      score += 300*level;
      alpha=255;
      break;
    case 4:
      active[3]=true;
      //watch.getTime();
      alpha=255;
      score += 1200*level;
      break;
    }
  }
  void show()
  {
    fill(255);
    textFont(pixFont20);
    text("score: ", 11*var, 21*var);
    text(score, 11*var, 22.75*var);
    if (active[0])
    {
      fill(purple, alpha);
      textFont(pixFont);
      text("+"+lvl*40, 11*var, 25*var);
      alpha-=2;
      if (alpha<1)
        active[0]=false;
    }
    if (active[1])
    {
      fill(green, alpha);
      textFont(pixFont);
      text("+"+lvl*100, 11*var, 25*var);
      alpha-=2;
      if (alpha<1)
        active[1]=false;
    }
    if (active[2])
    {
      fill(blue, alpha);
      textFont(pixFont);
      text("+"+lvl*300, 11*var, 25*var);
      alpha-=2;
      if (alpha<1)
        active[2]=false;
    }
    if (active[3])
    {
      fill(orange, alpha);
      textFont(pixFont);
      text("TETRIS!", 11*var, 25*var);
      text("+"+lvl*1200, 11*var, 26.75*var);
      alpha-=2;
      if (alpha<1)
        active[3]=false;
    }
  }
}