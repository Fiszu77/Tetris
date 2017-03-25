/*
NOTES:
 >sound
 */
import java.net.URI;
import java.awt.Desktop;
import java.io.IOException;
import java.net.URISyntaxException;
import java.awt.Cursor;

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
void setup()
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
  size(540, 720);
  var=int(height/24);
  frameRate(60);
  gButton = new Button(float(width)/2, 7*var, green, "Play");
  rButton = new Button(float(width)/2, 10*var, red, "Scores");
  bButton = new Button(float(width)/2, 13*var, blue, "Credits");
  linkButton = new Button(float(width)-var*2.45, float(height)-var*0.6, var*5.6, var*1.2, color(0), "");
  shadowButton = new Button(float(width)-var*4, var*10, var*1, var*1, color(255), "" );
  altRotButton = new Button(float(width)-var*4, var*12, var*1, var*1, color(255), "" );
  retButton = new Button(float(width)/2, 18*var, yellow, "Menu");
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
  //pixFont = createFont("pixelFont.TTF",30);
  //pixFont20 = createFont("pixelFont.TTF",20);
  // pixFont10 = createFont("pixelFont.TTF",10);
}

void draw()
{
  switch(mode)
  {
  case 0:
    background(0);
    textAlign(LEFT);
    fill(150);
    textFont(pixFont10);
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
      rect(altRotButton.getX()-var/4, altRotButton.getY()-var/4, altRotButton.getWidth()-0.5*var+1, altRotButton.getHeight()-0.5*var+1);
    }
    if (noShadow == false)
    {
      fill(purple);
      rect(shadowButton.getX()-var/4, shadowButton.getY()-var/4, shadowButton.getWidth()-0.5*var+1, shadowButton.getHeight()-0.5*var+1);
    }
    fill(150);
    textFont(pixFont10);
    textAlign(RIGHT);
    text("alt. rotations", width-0*var, 11.9*var);
    if (altRot)
      text("ON", width-2.2*var, 12.5*var);
    else
      text("OFF", width-2*var, 12.5*var);
    text("shadow", width-1.5*var, 9.9*var);
    if (noShadow)
      text("OFF", width-2*var, 10.5*var);
    else
      text("ON", width-2.2*var, 10.5*var);
    textAlign(LEFT);

    fill(150);
    textFont(pixFont10);
    textAlign(RIGHT);
    text("CACTUSOFT", width-3, height-0.7*var);
    text("ENTERTAINMENT©", width-3, height-0.06*var);
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
    text("CACTUSOFT", width-3, height-0.7*var);
    text("ENTERTAINMENT©", width-3, height-0.06*var);
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
    text("Programmed by\nFilip Szewczyk\n\n,,Simpixle'' font by\nJakub Niewiarowski", width/2, 5*var);
    textAlign(LEFT);
    if (retButton.show(allButtons))
      mode=0;

    fill(150);
    textFont(pixFont10);
    textAlign(RIGHT);
    text("CACTUSOFT", width-3, height-0.7*var);
    text("ENTERTAINMENT©", width-3, height-0.06*var);
    textAlign(LEFT);
    break;
  }
}