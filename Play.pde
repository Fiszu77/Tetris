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
  PImage matrix = createImage(int(10*var), int(20*var), RGB);
  Play()
  {
    score = 0;
    newBlock = 0;
    bCount=1;
    resOne =0;
    ile=1;
    varInt=int(var);
    hardDrop = false;
    gameOver= false;
    agdv = false;
    pause = false;
    resumePress = new Button(float(width)/2, 15*var, blue, "Resume", 10*varInt);
    restartPress =  new Button(float(width)/2, 19*var, yellow, "Menu", 10*varInt);
    guPress =  new Button(float(width)/2, 18*var, red, "GiveUp");
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
  void playTetris()
  {
    background(0);
    fill(255);
    translate(0, -10*var);
    rect(0, 10*var, 10*var, 20*var);  
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
      textAlign(RIGHT);
      text("CACTUSOFT", width-3, height+9.3*var);
      text("ENTERTAINMENT©", width-3, height+10*var-0.06*var);
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
        rect(width/2-5*var, height/2+3.5*var, 10*var, 7*var, 7);
        fill(0);
        textFont(pixFontMX);
        textAlign(CENTER);
        text("PAUSE", width/2, height/2+7.5*var);

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
        rect(width/2-7.5*var, height/2+4*var, 15*var, 10.5*var, 7);
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
void keyPressed()
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
void keyReleased()
{
  if (keyCode == DOWN)
    szybko = false;
}