Hof table;
class ScoreBoard
{
  ScoreBoard()
  {
    table = new Hof();
  }
  void showTable()
  {
    fill(255);
    textFont(pixFont);
    try {
      text("1.", width/2-3*var, height/2-5*var);
      text(table.table.get(0), width/2-1*var, height/2-5*var);
      text("2.", width/2-3*var, height/2-3*var);
      text(table.table.get(1), width/2-1*var, height/2-3*var);
      text("3.", width/2-3*var, height/2-1*var);
      text(table.table.get(2), width/2-1*var, height/2-1*var);
      text("4.", width/2-3*var, height/2+1*var);
      text(table.table.get(3), width/2-1*var, height/2+1*var);
      text("5.", width/2-3*var, height/2+3*var);
      text(table.table.get(4), width/2-1*var, height/2+3*var);
    }
    catch(IndexOutOfBoundsException u)
    {
    }
  }
}