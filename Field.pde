
public static class Field
{
  private static boolean[] x0= new boolean[30];
  private static boolean[] x1= new boolean[30];
  private static boolean[] x2= new boolean[30];
  private static boolean[] x3= new boolean[30];
  private static boolean[] x4= new boolean[30];
  private static boolean[] x5= new boolean[30];
  private static boolean[] x6= new boolean[30];
  private static boolean[] x7= new boolean[30];
  private static boolean[] x8= new boolean[30];
  private static boolean[] x9= new boolean[30];

  private static boolean[][] arrays = new boolean[][]{x0, x1, x2, x3, x4, x5, x6, x7, x8, x9};
  private static int[] maxFall = new int[10];
  private static boolean isGameOver = false;
  int tet = 0;
  Field() {
  }
  Field(String reset) {
    x0= new boolean[30];
    x1= new boolean[30];
    x2= new boolean[30];
    x3= new boolean[30];
    x4= new boolean[30];
    x5= new boolean[30];
    x6= new boolean[30];
    x7= new boolean[30];
    x8= new boolean[30];
    x9= new boolean[30];
    isGameOver = false;
    arrays = new boolean[][]{x0, x1, x2, x3, x4, x5, x6, x7, x8, x9};
    maxFall = new int[10];
  }

  int getBottom(int x, int y)
  {
    int currCheck = y;
    while (currCheck<30)
    {
      if (isEmpty(x, currCheck) == false)
      {               
        return currCheck-1;
      }
      currCheck++;
    }
    return currCheck-1;
  }
  boolean getGameOver()
  {
    return isGameOver;
  }
  boolean isEmpty(int x, int y)
  {

    if (x<0 || x>9 || y>=x1.length)
      return false;
    if (arrays[x][y])
    {
      return false;
    } else
    {
      return true;
    }
  }

  void settle(int x, int y)
  {
    if (x>=0 && x<=11 && y>=0)
    {
      arrays[x][y]=true;
    } else
    {
      print("settle error on x or y value" + "\n" + "x = "+ x +"\n" + "y = "+y+"\n");
    }  
    for (int u =0; u<maxFall.length; u++)
    {
      int hght=0;      
      while (isEmpty(u, hght))
      {
        hght++;
      }
      maxFall[u]=hght;
    }
    if (y<8)
    {
      isGameOver = true;
    }
  }
  void move(int x, int y)
  {
    arrays[x][y]=false;
  }
  int[] toKill()
  {
    int[] toKill = new int[]{-10, -10, -10, -10};
    tet = 0;
    for (int i = 29, ile = 0; i>=0; i--)
    {
      ile=0;
      for (int u = 0; u<10; u++)
      {
        if (arrays[u][i])
          ile++;
      }
      if (ile==10)
      {
        toKill[tet]=i;
        tet++;
      }
      if (tet==4)      
        break;
    }
    return toKill;
  }
}