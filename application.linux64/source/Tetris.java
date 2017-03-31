import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.net.URI; 
import java.awt.Desktop; 
import java.io.IOException; 
import java.net.URISyntaxException; 
import java.awt.Cursor; 
import java.lang.Math.*; 
import java.util.LinkedList; 
import java.util.ArrayList; 
import java.util.Random; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Tetris extends PApplet {

/*
NOTES:
 >sound
 */






PFont pixFont;
PFont pixFont20;
PFont pixFont10;
PFont pixFontMX;
Button gButton, rButton, bButton, linkButton, retButton, shadowButton, altRotButton;
Play play;
Desktop d;
Button[] allButtons;
ScoreBoard scores;
int mode = 0;
public static boolean noShadow = false, altRot = false;
public static float var =0;
String settings[];
public void setup()
{ 
  settings = loadStrings("settings.txt");
  try 
  {
    noShadow = Boolean.parseBoolean(settings[0]);
    altRot = Boolean.parseBoolean(settings[1]);
  }
  catch(NullPointerException e)
  {
    createWriter("data/settings.txt");
  }
  catch(ArrayIndexOutOfBoundsException u)
  {
    settings = new String[2];
    settings[0] = "false";
    settings[1] = "false";
    saveStrings("data/settings.txt", settings);
  }
  d = Desktop.getDesktop();
  
  var=PApplet.parseInt(height/24);
  frameRate(60);
  gButton = new Button(PApplet.parseFloat(width)/2, 7*var, green, "Play");
  rButton = new Button(PApplet.parseFloat(width)/2, 10*var, red, "Scores");
  bButton = new Button(PApplet.parseFloat(width)/2, 13*var, blue, "Credits");
  linkButton = new Button(PApplet.parseFloat(width)-var*2.45f, PApplet.parseFloat(height)-var*0.6f, var*5.6f, var*1.2f, color(0), "");
  shadowButton = new Button(PApplet.parseFloat(width)-var*4, var*10, var*1, var*1, color(255), "" );
  altRotButton = new Button(PApplet.parseFloat(width)-var*4, var*12, var*1, var*1, color(255), "" );
  retButton = new Button(PApplet.parseFloat(width)/2, 18*var, yellow, "Menu");
  allButtons = new Button[7];
  scores = new ScoreBoard();
  allButtons[0] = gButton;
  allButtons[1] = rButton;
  allButtons[2] = bButton;
  allButtons[3] = linkButton; 
  allButtons[4] = retButton;
  allButtons[5] = shadowButton;
  allButtons[6] = altRotButton;

  pixFont = createFont("Simpixle.ttf", 70);
  pixFont20 = createFont("Simpixle.ttf", 60);
  pixFont10 = createFont("Simpixle.ttf", 29);
  pixFontMX = createFont("Simpixle.ttf", 100);
}

public void draw()
{
  switch(mode)
  {
  case 0:
    background(0);
    textAlign(LEFT);
    fill(150);
    textFont(pixFont10);
    textSize(29*var/30);
    text("S or UP - rotate right\nA - rotate left\nLEFT and RIGHT - move a block\nDOWN - soft drop\nSPACE - hard drop\nESCAPE - pause game", width/2 - 3*var, height/2+4*var);

    if (linkButton.show(allButtons))
    {
      try {
        d.browse(new URI("http://cactusoft.cba.pl/#logo"));
      }
      catch(IOException e)
      {
        e.printStackTrace();
      }
      catch(URISyntaxException u)
      {
        u.printStackTrace();
      }
    }
    if (shadowButton.show(allButtons))
    {
      noShadow = !noShadow;
      try
      {
      settings[0] = String.valueOf(noShadow);
      }
      catch(NullPointerException e)
      {
        saveStrings("data/settings.txt", settings);
      }
      saveStrings("data/settings.txt", settings);
    }
    if (altRotButton.show(allButtons))
    {
      altRot = !altRot;
      try
      {
      settings[1] = String.valueOf(altRot);
      }
      catch(NullPointerException e)
      {
        saveStrings("data/settings.txt", settings);
      }
      saveStrings("data/settings.txt", settings);
    }
    if (altRot == true)
    {
      fill(orange);
      rect(altRotButton.getX()-var/4, altRotButton.getY()-var/4, altRotButton.getWidth()-0.5f*var+1, altRotButton.getHeight()-0.5f*var+1);
    }
    if (noShadow == false)
    {
      fill(purple);
      rect(shadowButton.getX()-var/4, shadowButton.getY()-var/4, shadowButton.getWidth()-0.5f*var+1, shadowButton.getHeight()-0.5f*var+1);
    }
    fill(150);
    textFont(pixFont10);
    textAlign(RIGHT);
    textSize(29*var/30);
    text("alt. rotations", width-0*var, 11.9f*var);
    if (altRot)
      text("ON", width-2.2f*var, 12.5f*var);
    else
      text("OFF", width-2*var, 12.5f*var);
    text("shadow", width-1.5f*var, 9.9f*var);
    if (noShadow)
      text("OFF", width-2*var, 10.5f*var);
    else
      text("ON", width-2.2f*var, 10.5f*var);
    textAlign(LEFT);

    fill(150);
    textFont(pixFont10);
    textAlign(RIGHT);
    textSize(29*var/30);
    text("CACTUSOFT", width-3, height-0.7f*var);
    text("ENTERTAINMENT\u00a9", width-3, height-0.06f*var);
    textAlign(LEFT);
    if (gButton.show(allButtons))
    {
      play = new Play();
      mode = 1;
    }
    if (rButton.show(allButtons))
    {
      mode = 2;
      scores = new ScoreBoard();
    }
    if (bButton.show(allButtons))
    {
      mode = 3;
    }
    break;
  case 1:
    play.playTetris();
    if (play.gameOver == true)
      mode=0;

    break;
  case 2:
    background(0);
    fill(150);
    textFont(pixFont10);
    textAlign(RIGHT);
    text("CACTUSOFT", width-3, height-0.7f*var);
    text("ENTERTAINMENT\u00a9", width-3, height-0.06f*var);
    textAlign(LEFT);
    scores.showTable();
    if (retButton.show(allButtons))
      mode=0;


    break;
  case 3:
    background(0);
    fill(255);
    textFont(pixFont20);
    textAlign(CENTER);
    textSize(60*var/30);
    text("Programmed by\nFilip Szewczyk\n\nFont and artwork by\nJakub Niewiarowski", width/2, 5*var);
    textAlign(LEFT);
    if (retButton.show(allButtons))
      mode=0;

    fill(150);
    textFont(pixFont10);
    textAlign(RIGHT);
    text("CACTUSOFT", width-3, height-0.7f*var);
    text("ENTERTAINMENT\u00a9", width-3, height-0.06f*var);
    textAlign(LEFT);
    break;
  }
}
 
Field field;
Timer timer;
Score playerScore;
public int orange = color(255, 102, 0), purple = color(122, 55, 139), red = color(205, 0, 0), chosenOne= color(0), blue = color(0, 7, 205), 
  green = color(50, 180, 10), yellow = color(245, 211, 0), lightBlue = color(0, 188, 255);
class Blocks
{
  public int orange = color(255, 102, 0), purple = color(122, 55, 139), red = color(205, 0, 0), chosenOne= color(0), blue = color(0, 7, 205), 
    green = color(50, 180, 10), yellow = color(245, 211, 0), lightBlue = color(0, 188, 255);
  Square[] square = new Square[4];
  ShBlocks shBlocks;
  Graveyard graveyard = new Graveyard();
  private int shape, previous = 0, ID = 0, deadCount = 0;
  float speed = 0.6f, time = 500;
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
    public void getDiv()
    {      
      div = getBottom();

      for (int i = 0; i<square.length; i++)
      {
        shSquare[i] = new Square(square[i].x, square[i].y + div, chosenOne, 150);
      }
    }
    public void show()
    {
      for (int i = 0; i<square.length; i++)
      {
        shSquare[i].show();
      }
    }
  }
  public int show(boolean prawo, boolean lewo, boolean accel, boolean obrotPrawo, boolean obrotLewo, int level, boolean drop)
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

  public void zmiana(boolean right, boolean left, boolean rotateRight, boolean rotateLeft, boolean drop)
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
          square[i].goRight();
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
          square[i].goLeft();
        }
        shBlocks.getDiv();
      }
    }
  }
  public void setPermission(boolean permission)
  {
    moving = permission;
  }
  public boolean isMoving()
  {
    for (int i = 0; i<square.length; i++)
    {
      if (square[i].getState() == 2)
        return true;
    }
    return false;
  }
  public int getBottom()
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
  public void showFigure()
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
  public void showFigureScreen()
  {
    for (int i = 0; i<square.length; i++)
    {
      square[i].show(shape);
    }
  }
  public boolean rot()
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
        if (altRot)
        {
          if (field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x-1, square[0].y-1) && field.isEmpty(square[0].x+1, square[0].y) )          
          {
            square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
            square[2] = new Square(square[0].x, square[0].y-1, chosenOne);
            square[3] = new Square(square[0].x-1, square[0].y-1, chosenOne);
            return true;
          }
        } else
        {
          if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x+1, square[0].y+1))
          {
            square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
            square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
            square[3] = new Square(square[0].x+1, square[0].y+1, chosenOne);
            return true;
          }
        }
      }
      if (numRot == 3)
      {
        if (altRot)
        {
          if (field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x+1, square[0].y-1) && field.isEmpty(square[0].x+1, square[0].y) )
          {
            square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
            square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
            square[3] = new Square(square[0].x+1, square[0].y-1, chosenOne);
            return true;
          }
        } else
        {
          if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x-1, square[0].y+1) && field.isEmpty(square[0].x, square[0].y-1)   )
          {
            square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
            square[2] = new Square(square[0].x-1, square[0].y+1, chosenOne);
            square[3] = new Square(square[0].x, square[0].y-1, chosenOne);
            return true;
          }
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
      if (numRot==2)
      {
        if (altRot)
        {
          if (field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y-1) && field.isEmpty(square[0].x+1, square[0].y-1))
          {
            square[1] = new Square(square[0].x-1, square[0].y, chosenOne);
            square[2] = new Square(square[0].x, square[0].y-1, chosenOne);
            square[3] = new Square(square[0].x+1, square[0].y-1, chosenOne);
            return true;
          }
        } else
        {
          if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x, square[0].y+1) && field.isEmpty(square[0].x-1, square[0].y+1))
          {
            square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
            square[2] = new Square(square[0].x, square[0].y+1, chosenOne);
            square[3] = new Square(square[0].x-1, square[0].y+1, chosenOne);
            return true;
          }
        }
      }
      if (numRot == 3)
      {
        if (altRot)
        {
          if (field.isEmpty(square[0].x+1, square[0].y) && field.isEmpty(square[0].x+1, square[0].y+1) && field.isEmpty(square[0].x, square[0].y-1))
          {
            square[1] = new Square(square[0].x+1, square[0].y, chosenOne);
            square[2] = new Square(square[0].x+1, square[0].y+1, chosenOne);
            square[3] = new Square(square[0].x, square[0].y-1, chosenOne);
            return true;
          }
        } else
        {
          if (field.isEmpty(square[0].x-1, square[0].y-1) && field.isEmpty(square[0].x-1, square[0].y) && field.isEmpty(square[0].x, square[0].y+1))
          {
            square[1] = new Square(square[0].x-1, square[0].y-1, chosenOne);
            square[2] = new Square(square[0].x-1, square[0].y, chosenOne);
            square[3] = new Square(square[0].x, square[0].y+1, chosenOne);
            return true;
          }
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
  public void ifTurned()
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
class Button
{
  private int rgb = color(0);
  private float posx, posy;
  private float rectWid, rectHei, exRectWid, exRectHei, modWid, modHei, trns, txtSize;
  private boolean wasPressed, active, hover,noAnim, doHand;
  private String onButt;
  Button(float x, float y, int col, String onButtTxt)
  {
    active = false;
    rgb = col;
    posx = x; 
    posy = y;
    onButt = onButtTxt;
    rectWid=var*6;
    rectHei=2*var;
    exRectHei =rectHei*1.07f;
    exRectWid = rectWid*1.07f;
    modWid = rectWid;
    modHei = rectHei;
    wasPressed = false;
  }
  Button(float x, float y,float wdth,float hgt, int col, String onButtTxt)
  {
    noAnim = true;
    active = false;
    rgb = col;
    posx = x; 
    posy = y;
    onButt = onButtTxt;
    rectWid=wdth;
    rectHei=hgt;
    exRectHei =rectHei;
    exRectWid = rectWid;
    modWid = rectWid;
    modHei = rectHei;
    wasPressed = false;
  }
  Button(float x, float y, int col,String onButtTxt, float trans)
  {
    active = false;
    onButt = onButtTxt;
    trns = trans;
    rgb = col;
    posx = x; 
    posy = y;
    rectWid=var*6;
    rectHei=2*var;
    exRectHei = 2*var*1.07f;
    exRectWid = var*6*1.07f;
    modWid = rectWid;
    modHei = rectHei;
    wasPressed = false;
  }
  public float getHeight()
  {
    return rectHei;
  }
  public float getWidth()
  {
    return rectWid;
  }
  public float getX()
  {
    return posx;
  }
  public float getY()
  {
    return posy;
  }
  
  public void noAnim(boolean anim)
  {
    noAnim = anim;
  }
  public boolean show(Button[] other)
  {
    translate(0, trns);
    rectMode(CENTER);


    fill(rgb);

    if (mouseX>posx-modWid/2 && mouseX<posx+modWid/2 && mouseY>posy-modHei/2 && mouseY<posy+modHei/2)
    {
      cursor(HAND);
      hover = true;
      if(noAnim==false)
      rect(posx, posy, exRectWid, exRectHei);
      else
      rect(posx, posy, rectWid, rectHei);
      
      if (mousePressed == false && wasPressed)
      {
        wasPressed=false;
        exRectHei = rectHei*1.07f;
        exRectWid = rectWid*1.07f;
        rectMode(CORNER);
        cursor(ARROW);
        hover = false;
        return true;
      }
      if (mousePressed)
      {
        if (exRectWid>=rectWid*0.95f)
          exRectWid-=0.04f*rectWid;

        if (exRectHei>=rectHei*0.95f)
          exRectHei-=0.04f*rectHei;
        wasPressed=true;
        active =true;
      } else
      {
        active = false;
        modWid = exRectWid;
        modHei = exRectHei;
      }
    } else
    {
      hover = false;
      doHand=true;
      for(int i=0;i<other.length;i++)
      {
        if(other[i].hover)
        {
          doHand=false;
        }
      }
      if(doHand)
      cursor(ARROW);
      
      active=false;
      wasPressed=false;
      rect(posx, posy, rectWid, rectHei);
      exRectHei = rectHei*1.07f;
      exRectWid = rectWid*1.07f;
      modWid = rectWid;
      modHei = rectHei;
    }
    fill(0);
    textFont(pixFontMX);
    textAlign(CENTER);
    txtSize = ((modWid/rectWid)*100)*var/30;
    if (active)
      txtSize = ((exRectWid/rectWid)*100)*var/30;

    textSize(txtSize-15);
    text(onButt, posx, posy+0.5f*var);
    
    rectMode(CORNER);
    return false;
  }
}

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

  public int getBottom(int x, int y)
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
  public boolean getGameOver()
  {
    return isGameOver;
  }
  public boolean isEmpty(int x, int y)
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

  public void settle(int x, int y)
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
  public void move(int x, int y)
  {
    arrays[x][y]=false;
  }
  public int[] toKill()
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
  public void addToGraveyard(int blockId)
  {
    deletedOnes.add(blockId);
  }
  public void cleanRezing(int rezed)
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
  public int resurrect()
  {
    resed = deletedOnes.get(0);
    deletedOnes.remove(0);
    cleanRezing(resed);
    return resed;
  }
  public int getDeadNumber()
  {
    return deletedOnes.size();
  }
}

class Hof
{
  String hofLines[] = new String[5];
  ArrayList <Integer>table = new ArrayList <Integer>();
  int highScore;
  Hof()
  {
    String lines[] = loadStrings("scores.txt");
    try{
    for (int i = 0; i < lines.length; i++) 
    {
      table.add(PApplet.parseInt(lines[i]));
    }
    highScore = table.get(0);
    }
    catch(NullPointerException e)
   {
    createWriter("scores.txt"); 
    }
   catch(IndexOutOfBoundsException u)
   {
     for(int i = 0; i<5; i++)
     {
       table.add(0);
       saveStrings("data/scores.txt", hofLines);
     }
   }
  }
  public void saveScore(int score)
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
class Level
{
  int level =1;
  int obieg = 0;

  public void linesCleared(int cleared)
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
  public void show()
  {
    fill(255);
    //textSize(30);
    textFont(pixFont);
    text("level: "+level, 11*var, 19*var);
  }
}
Graveyard cemetery;
Blocks[] block;
Field grid;
Level level;
Screen prediction;
Score points;
Button resumePress, restartPress, guPress;
Button[] allButts;
Hof hof;
boolean prawo=false, lewo=false, szybko=false, obrotLewo = false, obrotPrawo = false, hardDrop = false, doKill = false, adb = false, newHs = false, pause = false, agdv =false;

class Play
{
  Blocks[] block = new Blocks[400];
  int newBlock = 0, shp, varInt=0;
  int bCount=1, ile=1, resOne =0;
  boolean gameOver;
  int[] kill = new int[4];
  PImage toBlur = createImage(width, height, RGB);
  PImage matrix = createImage(PApplet.parseInt(10*var), PApplet.parseInt(20*var), RGB);
  PImage back = loadImage("back.png");
  Play()
  {
    score = 0;
    newBlock = 0;
    bCount=1;
    resOne =0;
    ile=1;
    varInt=PApplet.parseInt(var);
    hardDrop = false;
    gameOver= false;
    agdv = false;
    pause = false;
    resumePress = new Button(PApplet.parseFloat(width)/2, 15*var, blue, "Resume", 10*var);
    restartPress =  new Button(PApplet.parseFloat(width)/2, 19*var, yellow, "Menu", 10*var);
    guPress =  new Button(PApplet.parseFloat(width)/2, 18*var, red, "GiveUp");
    allButts = new Button[3];
    allButts[0] = resumePress;
    allButts[1] = restartPress;
    allButts[2] = guPress;
    hof = new Hof();
    cemetery = new Graveyard("newwwe");
    prediction = new Screen();
    grid = new Field("newe");
    level = new Level();
    points = new Score();    
    toBlur.loadPixels();
    back.resize(PApplet.parseInt(var*10),PApplet.parseInt(var*20));
    shp = prediction.getShape();
    block[0] = new Blocks(shp + 1, 0);

    for (int i = 0, x=0, y=1; i<matrix.width*matrix.height; i++, x++)
    {
      if (i%(varInt*10)==0)      
      {
        x=0;
        y++;
      }
      if (x==0||y==1||x%varInt==0||y%varInt==0)
        matrix.pixels[i]=color(0);
    }
  }
  public void playTetris()
  {
    background(0);
    fill(255);
    translate(0, -10*var);
    rect(0, 10*var, 10*var, 20*var);
    image(back, 0, 10*var);
    if(noShadow)
    image(matrix, 0, 10*var+2);
    



    bCount = 1;

    if (grid.getGameOver()==false && pause == false)
    {
      for (int i = 0; i<ile; i++) {
        newBlock = block[i].show(prawo, lewo, szybko, obrotPrawo, obrotLewo, level.level, hardDrop);
        bCount += newBlock;
      }


      if (doKill)
      {    
        kill = grid.toKill();
        for (int i= 0; i<bCount-1; i++)
        {
          block[i].square[0].kill(kill);
          block[i].square[1].kill(kill);
          block[i].square[2].kill(kill);
          block[i].square[3].kill(kill);
        }
        for (int i= 0; i<bCount-1; i++)
        {
          block[i].square[0].fall(kill);
          block[i].square[1].fall(kill);
          block[i].square[2].fall(kill);
          block[i].square[3].fall(kill);
        }   
        level.linesCleared(grid.tet);
        points.scoreLines(grid.tet, level.level);
        doKill = false;
      }
      for (int i =0; i<ile; i++)
      {
        if (block[i].isMoving())
        {
          block[ile-1].setPermission(true);
          adb=true;
          break;
        }
        if (adb==true)
        {
          block[ile-1].shBlocks.getDiv();
          adb = false;
        }

        block[ile-1].setPermission(false);
      }


      if (ile != bCount)
        doKill = true;

      if (ile != bCount)
      {
        shp = prediction.getShape();

        if (cemetery.getDeadNumber() > 0)
        {
          resOne = cemetery.resurrect();
          for (int i = resOne; i<bCount-2; i++)
          {
            block[i] = block[i+1];
            block[i].ID--;
          }

          block[bCount-2] = new Blocks(shp+1, bCount-2);
          bCount--;
        } else
          block[bCount-1] = new Blocks(shp + 1, bCount-1);
      }

      prediction.show();
      level.show();
      points.show();
      ile = bCount;
      fill(150);
      textFont(pixFont10);
      textSize(29*var/30);
      textAlign(RIGHT);
      text("CACTUSOFT", width-3, height+9.3f*var);
      text("ENTERTAINMENT\u00a9", width-3, height+10*var-0.06f*var);
      textAlign(LEFT);
      prawo=false;
      lewo=false;
      hardDrop = false;
      obrotPrawo=false;
      obrotLewo = false;
      if (grid.getGameOver() || agdv)
      {
        loadPixels();
        updatePixels();
        filter(BLUR, 5);
        loadPixels();
        if (agdv == false) {
          hof.saveScore(score);
          if (score>hof.highScore)
          {
            newHs = true;
          } else
            newHs=false;
        } else
          pause = true;
      }
    } else
    {   
      if (pause)
      {
        updatePixels();
        fill(green, 140);
        rect(width/2-5*var, height/2+3.5f*var, 10*var, 7*var, 7);
        fill(0);
        textFont(pixFontMX);
        textSize(100*var/30);
        textAlign(CENTER);
        text("PAUSE", width/2, height/2+7.5f*var);

        if (resumePress.show(allButts))
        {
          pause=false;
          agdv = !agdv;
        }

        if (guPress.show(allButts))
        {

          if (keyPressed && key == 'g' || key == 'G')
          {
            gameOver=true;
            pause=false;
          } else {
            try {
              d.browse(new URI("https://www.youtube.com/watch?v=dQw4w9WgXcQ"));
            }
            catch(IOException e)
            {
              e.printStackTrace();
            }
            catch(URISyntaxException u)
            {
              u.printStackTrace();
            }
          }
        }
      } else {
        updatePixels();
        fill(green, 140);
        rect(width/2-7.5f*var, height/2+4*var, 15*var, 10.5f*var, 7);
        fill(red);
        textFont(pixFontMX);
        textAlign(CENTER);
        text("Game Over", width/2, height/2+6*var);
        fill(orange);
        textFont(pixFontMX);
        textAlign(CENTER);
        text("Score: " + score, width/2, height/2+10*var);
        if (newHs)
        {
          fill(yellow);
          textFont(pixFontMX);
          textAlign(CENTER);
          text("New Highscore!", width/2, height/2+14*var);
        } else
        {
          fill(purple);
          textFont(pixFont);
          textAlign(CENTER);
          text("All time best: "+hof.highScore, width/2, height/2+14*var);
        }
        if (restartPress.show(allButts))
          gameOver = true;
      }
    }
  }
}
public void keyPressed()
{
  if (keyCode == RIGHT)
    prawo=true;

  if (keyCode == LEFT)
    lewo=true;

  if (keyCode == ESC) {
    key='p';
    agdv = !agdv;
    if (pause == true)
      pause =false;
  }

  if (keyCode == DOWN)
    szybko = true;

  if (key == 'a' || key == 'A' )
    obrotLewo = true;

  if (key == ' ')
    hardDrop = true;  

  if (key=='s' || key == 'S')
    obrotPrawo = true;

  if (keyCode == UP)
    obrotPrawo = true;
}
public void keyReleased()
{
  if (keyCode == DOWN)
    szybko = false;
}
 
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
  public void newNextPouch()
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
  public int getShape()
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
public static int score = 0;
class Score
{
  boolean active[] =new boolean[4];
  float alpha = 255;
  int lvl = 1;
  Score()
  {
  }
  public void scoreFF()
  {
    score++;
  }
  public void scoreLines(int lines, int level)
  {
    lvl = level;
    switch(lines)
    {
    case 1:
      score += 40*level;
      active[0]=true;
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
      alpha=255;
      score += 1200*level;
      break;
    }
  }
  public void show()
  {
    fill(255);
    textFont(pixFont20);
    text("score: ", 11*var, 21*var);
    text(score, 11*var, 22.75f*var);
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
      text("+"+lvl*1200, 11*var, 26.75f*var);
      alpha-=2;
      if (alpha<1)
        active[3]=false;
    }
  }
}
Hof table;
class ScoreBoard
{
  ScoreBoard()
  {
    table = new Hof();
  }
  public void showTable()
  {
    fill(255);
    textFont(pixFont);
    textSize(70*var/30);
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
Blocks nextBlock;
class Screen extends Pouch
{
  Screen()
  {
    nextBlock = new Blocks(1, 13, 2);
  }

  int x = 13, y = 13;  
  int shape = 0, prev = 10;
  public void change(int newShape)
  {
    shape = newShape;
    nextBlock = new Blocks(shape, x, y);
  }
  public void show()
  {
    noFill();
    stroke(255);
    rect(11*var, 11*var, 5*var, 4*var);
    if (prev != pouch.size())
    {
      if (pouch.size() == 0)
      {
        change(nextPouch.getFirst()+1);
      } else
      {
        change(pouch.getFirst()+1);
      }
      prev = pouch.size();
    }
    nextBlock.showFigureScreen();
  }
}
Field area;

class Square
{
  PImage cactus, flower, lCac, rCac;
  int x = 5, y =5, falls = 0, posy = 0;
  float alpha = 255, flowY=1, rCacX, lCacX,a=0; 
  int rgb = color(0), strokeRgb= color(0);
  int dead = 0;
  boolean screen = false, flowSpwn=false, flowMove=false, lcSpwn=false, rcSpwn=false;

  Square(int X, int Y, int Rgb)
  {
    if (Rgb == red)
      cactus =loadImage("cacR.png");
    if (Rgb==green){
      cactus=loadImage("cacG.png");
      
    }
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
    
    cactus.resize(PApplet.parseInt(var),PApplet.parseInt(var));
    flower =loadImage("flower.png");
    lCac = loadImage("lCac.png");
    rCac = loadImage("rCac.png");
    flower.resize(PApplet.parseInt(var),PApplet.parseInt(var));
    lCac.resize(PApplet.parseInt(var),PApplet.parseInt(var));
    rCac.resize(PApplet.parseInt(var),PApplet.parseInt(var));
    x = X;
    y=Y;
    posy=PApplet.parseInt(Y*var);
    rCacX=x*var;
    lCacX=x*var;
    rgb = Rgb;
    strokeRgb = 0;
    area = new Field();
  }
  Square(int X, int Y, int Rgb, int al)
  {
    flower =loadImage("flower.png");
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
    flowY=y;
    alpha = 0;
    rgb = Rgb;
    strokeRgb = Rgb;
    screen=true;
  }
  public void recurect(float len)
  {
    if (len>0) {
      rectMode(CENTER);
      // rect(x*var+0.5*var, y*var+0.5*var, len-var*0.1, len-var*0.1);
      rect(x*var+0.5f*var, y*var+0.5f*var, len-var, len-var);      
      recurect(len-var*0.1f);
      rectMode(CORNER);
    }
  }
  public int show()
  {

    if (dead == 0)
    {
      if (flowSpwn)
      {
        image(flower, x*var, flowY);
        flowGrow();
      }
      if (rcSpwn)
      {
        image(rCac, rCacX, y*var);
        rcGrow();
      }
      if (lcSpwn)
      {
        image(lCac, lCacX, y*var);
        lcGrow();
      }
      fill(rgb, alpha);
      if (screen)
      {
        if (noShadow==false) {
          stroke(strokeRgb);
          recurect(var+1);
        }
      } else {
        stroke(0);
        image(cactus, x*var, y*var);
        //rect(x*var, y*var, var, var);
      }
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
      if (rcSpwn)
      {
        image(rCac, rCacX, posy);
        rcGrow();
      }
      if (lcSpwn)
      {
        image(lCac, lCacX, posy);
        lcGrow();
      }
      if (flowSpwn)
      {
        if (flowMove)
          image(flower, x*var, flowY=posy);
        else
          image(flower, x*var, flowY=posy-var);
        //flowGrow();
      }
      image(cactus, x*var, posy);
      if (posy<y*var)
      {
        if(y*var-posy<5)
        posy+=1;
        else
        posy+=round(tan(a)*10.0f)/10.0f;
      }
      else
      {
        area.settle(x, y);
        posy=PApplet.parseInt(y*var);
        dead=0;
      }
      if(a<PI/2.16f)
        a+=PI/80;
    }
    return 0;
  }
  public int getState()
  {
    return dead;
  }
  public void show(int shape)
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
  public void fall(int[] hgt)
  {
    if (y<hgt[0] && dead == 0)
    { 
      falls = 0;
      posy=PApplet.parseInt(y*var);
      falls++;
      if (y<hgt[1])
        falls++;

      if (y<hgt[2])
        falls++;

      if (y<hgt[3])
        falls++;

      area.move(x, y);
      y+=falls;
      if (flowY>posy-var)
        flowMove=true;
      a=0;
      dead = 2;
    }
  }
  public void kill(int[] hgt)
  {

    if (hgt[0] == y || hgt[1] == y || hgt[2] == y || hgt[3] == y)
    {
      dead = 1;
      area.move(x, y);
    }
    if (!area.isEmpty(x, y-1))
    {
      flowSpwn=false;
    }
    if (!area.isEmpty(x+1, y))
    {
      rcSpwn=false;
    }
    if (!area.isEmpty(x-1, y))
    {
      lcSpwn=false;
    }
  }

  public void settle()
  {
    area.settle(x, y);
    posy=PApplet.parseInt(y*var);
    flowSpwn();
    cacSpwn();
  }
  public void cacSpwn()
  {
    if (area.isEmpty(x+1, y))
    {
      if (random(1)>0.85f)
        rcSpwn=true;
    }
    if (area.isEmpty(x-1, y))
    {
      if (random(1)>0.85f)
        lcSpwn=true;
    }
  }
  public void flowSpwn()
  {
    if (area.isEmpty(x, y-1))
    {
      if (flowSpwn)
        flowY=posy-var;
      else
        flowY=posy;

      if (random(1)>0.75f)
        flowSpwn=true;
    } else
    {
      flowSpwn = false;
    }
  }
  public void rcGrow()
  {
    if (rCacX<x*var+var)
    {
      rCacX++;
    }
  }
  public void lcGrow()
  {
    if (lCacX>x*var-var)
    {
      lCacX--;
    }
  }
  public void flowGrow()
  {
    if (flowY>posy-var)
    {
      flowY--;
    }
  }
  public void goRight()
  {
    x++;
    rCacX=x*var;
    lCacX=x*var;
  }
  public void goLeft()
  {
    x--;
    rCacX=x*var;
    lCacX=x*var;
  }
  public boolean isDownEmpty()
  {
    if (area.isEmpty(x, y+1))
    {
      return true;
    } else
      return false;
  }
  public boolean isRightEmpty()
  {
    if (area.isEmpty(x+1, y))
    {
      return true;
    } else
      return false;
  }
  public boolean isLeftEmpty()
  {
    if (area.isEmpty(x-1, y))
    {
      return true;
    } else
      return false;
  }
}
public static boolean stopTimers = false;
class Timer
{
  float start = 0;
  public void getTime()
  {
    start = millis();
  }

  public boolean wait(float time)
  {
    if (start+time<=millis())
    {
      return true;
    } else
      return false;
  }
}
  public void settings() {  size(520, 740); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Tetris" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
