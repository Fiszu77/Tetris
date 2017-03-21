Blocks nextBlock;
class Screen extends Pouch
{
  Screen()
  {
    nextBlock = new Blocks(1, 13, 2);
  }

  int x = 13, y = 13;  
  int shape = 0, prev = 10;
  void change(int newShape)
  {
    shape = newShape;
    nextBlock = new Blocks(shape, x, y);
  }
  void show()
  {
    noFill();
    stroke(255);
    rect(11*var, 11*var, 5*var, 4*var);
    if (prev != pouch.size())
    {
      if (pouch.size() == 0)
      {
        //println(nextPouch[0]+1);
        change(nextPouch.getFirst()+1);
      } else
      {
        //println(pouch[amount]+1);
        change(pouch.getFirst()+1);
      }
      prev = pouch.size();
    }
    nextBlock.showFigureScreen();
  }
}