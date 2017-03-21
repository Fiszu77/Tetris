import java.lang.Math.*; 
Field field;
Timer timer;
Score playerScore;
public color orange = color(255, 102, 0), purple = color(122, 55, 139), red = color(205, 0, 0), chosenOne= color(0), blue = color(0, 7, 205), 
  green = color(50, 180, 10), yellow = color(245, 211, 0), lightBlue = color(0, 188, 255);
class Blocks
{
  public color orange = color(255, 102, 0), purple = color(122, 55, 139), red = color(205, 0, 0), chosenOne= color(0), blue = color(0, 7, 205), 
    green = color(50, 180, 10), yellow = color(245, 211, 0), lightBlue = color(0, 188, 255);
  Square[] square = new Square[4];
  ShBlocks shBlocks;
  Graveyard graveyard = new Graveyard();
  private int shape, previous = 0, ID = 0, deadCount = 0;
  float speed = 0.6, time = 500;
  float bottom;
  boolean born = true, settled = false, turned1 = false, turned2 = false, moving = false;
  int x = 4, y = 8, numRot = 0;
  Blocks(int blockType, int blockNumber)
  {
    ID = blockNumber;
    shape = blockType;
    field = new Field();
    timer = new Timer();
    playerScore = new Score();

    switch(shape)
    {
    case 1:
      chosenOne = orange;
      square[0] = new Square(x, y, chosenOne);
      square[1] = new Square(x+1, y, chosenOne);
      square[2] = new Square(x+1, y-1, chosenOne);
      square[3] = new Square(x, y-1, chosenOne);

      break;
    case 2:
      chosenOne=purple;
      square[0] = new Square(x, y, chosenOne);
      square[1] = new Square(x+1, y, chosenOne);
      square[2] = new Square(x, y-1, chosenOne);
      square[3] = new Square(x-1, y-1, chosenOne);
      break;
    case 3: 
      chosenOne = red;
      square[0] = new Square(x, y, chosenOne);
      square[1] = new Square(x+1, y, chosenOne);
      square[2] = new Square(x-1, y, chosenOne);
      square[3] = new Square(x, y-1, chosenOne);
      break;
    case 4:
      chosenOne = blue;
      square[0] = new Square(x, y, chosenOne);
      square[1] = new Square(x-1, y, chosenOne);
      square[2] = new Square(x+1, y, chosenOne);
      square[3] = new Square(x-1, y-1, chosenOne);

      break;
    case 5:
      chosenOne = green;
      square[0] = new Square(x, y, chosenOne);
      square[1] = new Square(x-1, y, chosenOne);
      square[2] = new Square(x, y-1, chosenOne);
      square[3] = new Square(x+1, y-1, chosenOne);
      break;
    case 6:
      chosenOne = yellow;
      square[0] = new Square(x, y, chosenOne);
      square[1] = new Square(x-1, y, chosenOne);
      square[2] = new Square(x+1, y-1, chosenOne);
      square[3] = new Square(x+1, y, chosenOne);
      break;
    case 7:
      chosenOne = lightBlue;
      square[0] = new Square(x, y, chosenOne);
      square[1] = new Square(x-1, y, chosenOne);
      square[2] = new Square(x+1, y, chosenOne);
      square[3] = new Square(x+2, y, chosenOne);
      break;
    }
    shBlocks = new ShBlocks();
  }

  Blocks(int blockType, int screenX, int screenY)
  {
    shape = blockType;
    x=screenX;
    y=screenY;
    switch(shape)
    {
    case 1:
      chosenOne = orange;
      square[0] = new Square(x, y, chosenOne, 0);
      square[1] = new Square(x+1, y, chosenOne, 0);
      square[2] = new Square(x+1, y-1, chosenOne, 0);
      square[3] = new Square(x, y-1, chosenOne, 0);

      break;
    case 2:
      chosenOne=purple;
      square[0] = new Square(x, y, chosenOne, 0);
      square[1] = new Square(x+1, y, chosenOne, 0);
      square[2] = new Square(x, y-1, chosenOne, 0);
      square[3] = new Square(x-1, y-1, chosenOne, 0);
      break;
    case 3: 
      chosenOne = red;
      square[0] = new Square(x, y, chosenOne, 0);
      square[1] = new Square(x+1, y, chosenOne, 0);
      square[2] = new Square(x-1, y, chosenOne, 0);
      square[3] = new Square(x, y-1, chosenOne, 0);
      break;
    case 4:
      chosenOne = blue;
      square[0] = new Square(x, y, chosenOne, 0);
      square[1] = new Square(x-1, y, chosenOne, 0);
      square[2] = new Square(x+1, y, chosenOne, 0);
      square[3] = new Square(x-1, y-1, chosenOne, 0);

      break;
    case 5:
      chosenOne = green;
      square[0] = new Square(x, y, chosenOne, 0);
      square[1] = new Square(x-1, y, chosenOne, 0);
      square[2] = new Square(x, y-1, chosenOne, 0);
      square[3] = new Square(x+1, y-1, chosenOne, 0);
      break;
    case 6:
      chosenOne = yellow;
      square[0] = new Square(x, y, chosenOne, 0);
      square[1] = new Square(x-1, y, chosenOne, 0);
      square[2] = new Square(x+1, y-1, chosenOne, 0);
      square[3] = new Square(x+1, y, chosenOne, 0);
      break;
    case 7:
      chosenOne = lightBlue;
      square[0] = new Square(x, y, chosenOne, 0);
      square[1] = new Square(x-1, y, chosenOne, 0);
      square[2] = new Square(x+1, y, chosenOne, 0);
      square[3] = new Square(x+2, y, chosenOne, 0);
      break;
    }
  }

  private class ShBlocks
  {  
    Square[] shSquare = new Square[4];
    int div = 0;
    ShBlocks()
    {      
      getDiv();
    }
    void getDiv()
    {      
      div = getBottom();

      for (int i = 0; i<square.length; i++)
      {
        shSquare[i] = new Square(square[i].x, square[i].y + div, chosenOne, 150);
      }
    }
    void show()
    {
      for (int i = 0; i<square.length; i++)
      {
        shSquare[i].show();
      }
    }
  }
  int show(boolean prawo, boolean lewo, boolean accel, boolean obrotPrawo, boolean obrotLewo, int level, boolean drop)
  {
    if (accel)
      time=40;
    else
      time=((11- level)*50);

    showFigure();




    if (settled)
      return 1;

    if (born)
    {
      x=5;
      y=8;
    }

    if (born || timer.wait(time) && settled==false)
    {

      showFigure();      
      timer.getTime();
      zmiana(prawo, lewo, obrotPrawo, obrotLewo, drop);
      if (square[0].isDownEmpty() && square[1].isDownEmpty() && square[2].isDownEmpty() && square[3].isDownEmpty())
      {
        if (accel)
        {
          playerScore.scoreFF();
        }
        for (int i =0; i<square.length; i++)
        {
          square[i].y++;
        }
      } else
      {

        for (int i =0; i<square.length; i++)
        {
          square[i].settle();
        }
        settled = true;
      }
    } else
    {

      zmiana(prawo, lewo, obrotPrawo, obrotLewo, drop);
    }
    if (born)
    {
      shBlocks.getDiv();
    }
    if (moving==false && born == false)
      shBlocks.show();

    born = false;
    return 0;
  }

  void zmiana(boolean right, boolean left, boolean rotateRight, boolean rotateLeft, boolean drop)
  {
    if (drop && moving==false)
    {
      shBlocks.getDiv();
      for (int i = 0; i<square.length; i++)
      {
        square[i].y = shBlocks.shSquare[i].y;
        square[i].settle();
      }
      settled = true;
      score+=shBlocks.div*2;
    }

    if (rotateLeft)
    {                                                                   
      numRot++;
      if (numRot==4)
        numRot=0;
      if (rot() == false)
      {
        numRot--;
        if (numRot==-1)
          numRot=3;
      }
      // print(numRot + " ");
      shBlocks.getDiv();
    }
    if (rotateRight)
    {
      numRot--;
      if (numRot==-1)
        numRot=3;
      if (rot() == false)
      {
        numRot++;
        if (numRot==4)
          numRot=0;
      }
      shBlocks.getDiv();
    }
    if (right)
    {
      if (square[0].isRightEmpty() && square[1].isRightEmpty() && square[2].isRightEmpty() && square[3].isRightEmpty())
      {
        for (int i =0; i<square.length; i++)
        {
          square[i].x++;
        }
        shBlocks.getDiv();
      }
    }
    if (left)
    {
      if (square[0].isLeftEmpty() && square[1].isLeftEmpty() && square[2].isLeftEmpty() && square[3].isLeftEmpty())
      {
        for (int i =0; i<square.length; i++)
        {
          square[i].x--;
        }
        shBlocks.getDiv();
      }
    }
  }
  void setPermission(boolean permission)
  {
    moving = permission;
  }
  boolean isMoving()
  {
    for (int i = 0; i<square.length; i++)
    {
      if (square[i].getState() == 2)
        return true;
    }
    return false;
  }
  int getBottom()
  {
    int minim = 29, toCheck;
    for (int i =0; i<square.length; i++)
    {
      toCheck=field.getBottom(square[i].x, square[i].y);
      if (toCheck - square[i].y<minim)
        minim = toCheck - square[i].y;
    }
    //print(minim + " ");
    return minim;
  }
  void showFigure()
  {

    if (deadCount<4) 
    {
      for (int i = 0; i<square.length; i++)
      {
        deadCount += square[i].show();
      }
      if (this.deadCount==4) 
      {
        graveyard.addToGraveyard(ID);
      }
    }
  }
  void showFigureScreen()
  {
    for (int i = 0; i<square.length; i++)
    {
      square[i].show(shape);
    }
  }
  boolean rot()
  {    
    switch (shape)
    {
    case 2:
      if (numRot==0)
      {        
        if (field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x-1, square[0].y-1) && field.isEmpty(square[0].x+1, square[0].y) )          
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x, square[0].y-1, chosenOne);
          square[3] = new Square(square[0].x-1, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot==1)
      {        
        if (field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x+1, square[0].y-1) && field.isEmpty(square[0].x+1, square[0].y) )
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot == 2)
      {        
        if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x+1, square[0].y+1))
        {
          square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y+1, chosenOne);
          return true;
        }
      }
      if (numRot == 3)
      {
        if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x-1, square[0].y+1) && field.isEmpty(square[0].x, square[0].y-1)   )
        {
          square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x-1, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x, square[0].y-1, chosenOne);
          return true;
        }
      }
      break;
    case 3:
      if (numRot == 0)
      {
        if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y-1))
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot == 1)
      {
        if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x, square[0].y-1))
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot == 2)
      {
        if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y+1))
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x, square[0].y+1, chosenOne);
          return true;
        }
      }
      if (numRot==3)
      {
        if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x, square[0].y+1))
        {
          square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x, square[0].y-1, chosenOne);
          square[3] = new Square(square[0].x, square[0].y+1, chosenOne);
          return true;
        }
      }
      break;
    case 4:
      if (numRot == 0)
      {
        if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x-1, square[0].y-1))
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x-1, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot == 1)
      {
        if (field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x+1, square[0].y-1))
        {
          square[1] = new Square(square[0].x, square[0].y-1, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot == 2)
      {
        if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x+1, square[0].y+1))
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y+1, chosenOne);
          return true;
        }
      }
      if (numRot == 3)
      {
        if (field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x-1, square[0].y+1))
        {
          square[1] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[2] = new Square(square[0].x, square[0].y-1, chosenOne);
          square[3] = new Square(square[0].x-1, square[0].y+1, chosenOne);
          return true;
        }
      }
      break;
    case 5:
      if (numRot == 0)
      {
        if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x+1, square[0].y-1))
        {
          square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x, square[0].y-1, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot == 1)
      {
        if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x+1, square[0].y+1) && field.isEmpty(square[0].x, square[0].y-1))
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x+1, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot == 2)
      {
        if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x-1, square[0].y+1))
        {
          square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x-1, square[0].y+1, chosenOne);
          return true;
        }
      }
      if (numRot == 3)
      {
        if (field.isEmpty(square[0].x-1, square[0].y-1) && field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y+1))
        {
          square[1] = new Square(square[0].x-1, square[0].y-1, chosenOne);
          square[2] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x, square[0].y+1, chosenOne);
          return true;
        }
      }
      break;
    case 6:
      if (numRot == 0)
      {
        if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x+1, square[0].y-1))
        {
          square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y-1, chosenOne);
          return true;
        }
      }
      if (numRot == 1)
      {
        if (field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x+1, square[0].y+1))
        {
          square[1] = new Square(square[0].x, square[0].y-1, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y+1, chosenOne);
          return true;
        }
      }
      if (numRot == 2)
      {
        if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x-1, square[0].y+1))
        {
          square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x-1, square[0].y+1, chosenOne);
          return true;
        }
      }
      if (numRot == 3)
      {
        if (field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x-1, square[0].y-1))
        {
          square[1] = new Square(square[0].x, square[0].y-1, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x-1, square[0].y-1, chosenOne);
          return true;
        }
      }
      break;
    case 7:
      turned1=false;
      turned2=false;
      if (previous == 1 && numRot != 1)
      {
        if (field.isEmpty(square[0].x-1, square[0].y-2)) {
          square[0] = new Square(square[0].x-1, square[0].y-2, chosenOne);
          turned1 = true;
        }
      }
      if (previous == 2 && numRot != 2)
      {
        if (field.isEmpty(square[0].x-2, square[0].y-1)) {
          square[0] = new Square(square[0].x-2, square[0].y-1, chosenOne);
          turned2=true;
        }
      }


      if (numRot == 0)
      {
        if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x+2, square[0].y))
        {
          square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
          square[2] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x+2, square[0].y, chosenOne);        
          previous=0;
          return true;
        } else
        {
          ifTurned();
        }
      }

      if (numRot == 1)
      {
        if (field.isEmpty(square[0].x+1, square[0].y-1) && field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x+1, square[0].y+1) && field.isEmpty(square[0].x+1, square[0].y+2))
        {
          square[1] = new Square(square[0].x+1, square[0].y-1, chosenOne);
          square[2] = new Square(square[0].x+1, square[0].y, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y+1, chosenOne);
          square[0] = new Square(square[0].x+1, square[0].y+2, chosenOne);
          previous = 1;
          return true;
        } else
        {
          ifTurned();
        }
      }
      if (numRot == 2)
      {
        if (field.isEmpty(square[0].x-1, square[0].y+1) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x+1, square[0].y+1) && field.isEmpty(square[0].x+2, square[0].y+1))
        {
          square[1] = new Square(square[0].x-1, square[0].y+1, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x+1, square[0].y+1, chosenOne);
          square[0] = new Square(square[0].x+2, square[0].y+1, chosenOne);
          previous = 2;
          return true;
        } else
        {
          ifTurned();
        }
      }
      if (numRot == 3)
      {
        if (field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x, square[0].y+2))
        {
          square[1] = new Square(square[0].x, square[0].y-1, chosenOne);
          square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
          square[3] = new Square(square[0].x, square[0].y+2, chosenOne);
          previous = 3;
          return true;
        } else
        {
          ifTurned();
        }
      }
      break;
    }
    return false;
  }
  void ifTurned()
  {
    if (turned1)
    {
      square[0] = new Square(square[0].x+1, square[0].y+2, chosenOne);
    }
    if (turned2)
    {
      square[0] = new Square(square[0].x+2, square[0].y+1, chosenOne);
    }
  }
}