import java.util.LinkedList;
public static class Graveyard
{
  public static LinkedList<Integer> deletedOnes = new LinkedList<Integer>();
  public static int deadNumber = 0;
  int resed = 0, toUpdt;
  Graveyard()
  {
  }
  Graveyard(String newww)
  {
    deletedOnes = new LinkedList<Integer>();
    deadNumber = 0;
  }
  void addToGraveyard(int blockId)
  {
    deletedOnes.add(blockId);
  }
  void cleanRezing(int rezed)
  {
    for (int i = 0; i<deletedOnes.size(); i++)
    {
      toUpdt = deletedOnes.get(i);
      if (toUpdt>rezed)
      {
        deletedOnes.set(i, toUpdt-1);
      }
    }
  }
  int resurrect()
  {
    resed = deletedOnes.get(0);
    deletedOnes.remove(0);
    cleanRezing(resed);
    return resed;
  }
  int getDeadNumber()
  {
    return deletedOnes.size();
  }
}