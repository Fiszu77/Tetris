class Level
{
  int level =1;
  int obieg = 0;

  void linesCleared(int cleared)
  {
    if (level<11) {
      if (cleared+obieg >= 10)
      {
        obieg = cleared + obieg - 10;
        level++;
      } else
        obieg +=cleared;
    }
  }
  void show()
  {
    fill(255);
    //textSize(30);
    textFont(pixFont);
    text("level: "+level, 11*var, 19*var);
  }
}