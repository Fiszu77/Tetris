import java.util.ArrayList;
class Hof
{
  String hofLines[] = new String[5];
  ArrayList <Integer>table = new ArrayList <Integer>();
  int highScore;
  Hof()
  {
    String lines[] = loadStrings("scores.txt"); 
    for (int i = 0; i < lines.length; i++) 
    {
      table.add(int(lines[i]));
    }
    highScore = table.get(0);
  }
  void saveScore(int score)
  {
    for (int i = 0; i<table.size(); i++)
    {
      if (score>table.get(i))
      {
        table.add(i, score);
        break;
      }
    }
    for (int i =0; i<hofLines.length; i++)
    {
      hofLines[i] =str(table.get(i));
    }
    saveStrings("data/scores.txt", hofLines);
  }
}