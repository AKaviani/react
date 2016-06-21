// Ariana Kaviani
import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
BeatDetect beat;
AudioMetaData meta;
Audio_Band Band1;
Audio_Band Band2;
BD_Bloom Bloom1;
BD_Bloom Bloom2;
BD_Bloom Bloom3;
BD_Bloom RBloom; // random bloom
ArrayList<BD_Bloom> alRBlooms = new ArrayList<BD_Bloom>();

PFont f;
int  r = 200, iSong = 1, bSize;
float fRad = 20, fDAlpha = 100, fDR;
boolean bRunOnce = true, bShow = true;
public void setup()
{
  minim = new Minim(this);
  player = minim.loadFile("Music"+iSong+".mp3");
  beat = new BeatDetect();
  player.play();
  fullScreen();
  frameRate(60);
  f = createFont("Tahoma", 16, true);
  smooth(8); // anti-aliasing (smooths edges). Depends on hardware, x4 and x8 will not work on all
  // computers, switch to x2 if it runs poorly. https://processing.org/reference/smooth_.html

  Band1 = new Audio_Band (player, 100, 100, 149, 52, 255, 255, 149, 52, 255, 255); // Good Ol' Jose Sanchez taught me classes
  Band2 = new Audio_Band (player, -300, 300, 255, 255, 255, 155, 0, 0, 0, 155);   // https://www.youtube.com/watch?v=PP4_96YzBnM
  Bloom1 = new BD_Bloom (beat, 1.3, 75, 82, 124, 70, 0, 50, 0, 255, 15, 100, 0, 0, 0, 0);
  Bloom2 = new BD_Bloom (beat, 0.9, 56, 32, 78, 55, 0, 200, 0, 100, 15, 75, 0, 0, 0, 0);
  //RBloom = new BD_Bloom (beat, 0.5, 75, 82, 124, 55, 0, 50, 0, 255, fDAlpha, fDAlpha, -width, width, -height, height);
}

float timerX(float fPosX) {
  for (int i = 0; i < player.length(); i++); 
  {
    fPosX = random(0 - width, width); // tried to mess with decay, didn't work
    //delay(2000);
  }
  return fPosX;
}

float timerY(float fPosY) {
  for (int i = 0; i < player.length(); i++); 
  {
    fPosY = random(0 - height, height); // tried to mess with decay, didn't work
    //delay(2000);
  }
  return fPosY;
}

public void draw()
{ 
  //float t = map(mouseX, 0, width, 0, 1);
  beat.detect(player.mix);
  fill(#C3C3E5, 35); // here we create a rectangle with a low opacity
  noStroke();       // I used this instead of a background() in order to create
  rect(0, 0, width, height);     // the fading away effect with everything on screen
  translate(width/2, height/2); // layers and layers draw ontop of eachother every frame 
  beginShape();                // the higher the alpha value the quicker it "fades"
  noStroke();




  if (bRunOnce == true) {
    meta = player.getMetaData();
    textFont(f, 46);                 
    fill(25, 255);    
    textAlign(CENTER);
    text("Track #:" + iSong, 0, height*-0.3); // Display the metadata of the first track on launch
    text(meta.title(), 0, height*-0.4);
    text(meta.author(), 0, height*0.4);
    bRunOnce = false;
  }

  int bSize = player.bufferSize();

  beginShape(); 
  stroke(27, 0, 57, 255); 

  for (int i = 0; i < bSize; i+=5)
  {
    float x2 = (r + player.mix.get(i)*100)*cos(i*2*PI/bSize); // using the same math as before
    float y2 = (r + player.mix.get(i)*100)*sin(i*2*PI/bSize); 
    vertex(x2, y2);       // this time creating vertex's on the x and y's pulled from the band
    //  joins all the points together with lines
    pushStyle();        //]  
    stroke(-1);        // |
    strokeWeight(2);  //  |  Visual Fluff
    point(x2, y2);   //   |
    popStyle();     //    ]  push and pop Style explained https://processing.org/reference/pushStyle_.html
  }
  endShape(); 

  beginShape(); 
  stroke(27, 0, 57, 255); 
  fill (255, 255); 
  for (int i = 0; i < bSize - 1; i+=5)
  {
    float x2 = (r + player.mix.get(i)*100)*cos(i*2*PI/bSize);  // same thing again, except just putting tiny circles
    float y2 = (r + player.mix.get(i)*100)*sin(i*2*PI/bSize); // on the x and ys pulled from the band
    ellipse(x2, y2, 3, 3);                                   // looks cool
  }

  endShape();

  Band2.run();
  Band1.run();
  Bloom2.run();
  Bloom1.run();

  ////if (beat.isOnset()) {
  //alRBlooms.add(new BD_Bloom(beat, 1.3, 75, 82, 124, 150, 0, 50, 0, 255, fDAlpha, fDAlpha, -width, width, -height, height));
  ////}
  //for (int i = 0; i <alRBlooms.size(); i++) {
  //  BD_Bloom RBloom = (BD_Bloom) alRBlooms.get(i);
  //  fDR = 0.1;
    
  //  if (i%259 == 1) {
  //    RBloom.run();
  //    fDAlpha = fDAlpha*fDR;               // Not quite able to wrap my head around how to apply array lists to my program
  //    //println(i);                       // I know exactly what I am trying to do, just not how to execute it
  //  }                                    // commented out for now, Beta_1_3 is the latest stable build
  //  if (fDAlpha < 0.001) {
  //    alRBlooms.remove(RBloom);
  //    //} else {
  //  }
  //  println(alRBlooms.size());
  //}
}


public void keyPressed() {
  if (key==' ')exit();       // esc key = exit
  if (player.isPlaying()) { // little pause and play action http://code.compartmental.net/minim/audioplayer_method_pause.html
    if (key == 'p') {
      player.pause();
    }
  } else {
    if (key == 'p') {
      player.play();
    }
  }

  if (key == 'd' && iSong < 4) {
    iSong++;
    player.pause();
    player = minim.loadFile("Music"+iSong+".mp3"); // Song selection
    player.play();
    meta = player.getMetaData();
    textFont(f, 46);                 
    fill(25, 255);    
    textAlign(CENTER);
    text("Track #:" + iSong, 0, height*-0.3); // pulling and displaying meta data
    text(meta.title(), 0, height*-0.4);      // http://code.compartmental.net/minim/audioplayer_method_getmetadata.html
    text(meta.author(), 0, height*0.4);
  } else if (key == 'a' && iSong > 1) {
    iSong--;
    player.pause();
    player = minim.loadFile("Music"+iSong+".mp3");
    player.play();
    meta = player.getMetaData();
    textFont(f, 46);                 
    fill(25, 255);    
    textAlign(CENTER);
    text("Track #:" + iSong, 0, height*-0.3);
    text(meta.title(), 0, height*-0.4);
    text(meta.author(), 0, height*0.4);
  } else {
    if ( key == 'a' || key == 'd') {
      textFont(f, 46);                 
      fill(25, 255);    
      textAlign(CENTER);
      text("No More Tracks", 0, height*0.4);
    }
  }
}