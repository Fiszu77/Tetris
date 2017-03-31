import java.util.Random; 
Random generator = new Random();
class Pouch
{  
  protected LinkedList<Integer> pouch = new LinkedList<Integer>();
  protected LinkedList<Integer> nextPouch = new LinkedList<Integer>();
  protected LinkedList<Integer> toDraw = new LinkedList<Integer>();
  Pouch()
  {
    newNextPouch();
    pouch =(LinkedList) nextPouch.clone();
    newNextPouch();
  }
  void newNextPouch()
  {
    nextPouch.clear();
    toDraw.clear();
    for (int i = 0; i<7; i++)
    {
      toDraw.add(i);
    }
    for (int i = 0, u=0; i<7; i++)
    {
      u = generator.nextInt(toDraw.size());
      nextPouch.add(toDraw.get(u));
      toDraw.remove(u);
    }
  }
  int getShape()
  {
    int toRet;
    if (pouch.size() == 0)
    {

      pouch =(LinkedList) nextPouch.clone();
      newNextPouch();
    }
    //print(pouch.getFirst());
    toRet = pouch.getFirst();
    pouch.removeFirst();
    return toRet;
  }
}