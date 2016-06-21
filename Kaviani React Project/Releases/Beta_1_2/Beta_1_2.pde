import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
BeatDetect beat;
AudioMetaData meta;
PFont f;
int  r = 200, r2 = 200, iSong = 1;
float fRad = 20, fRad2 = 20, fRad3 = 300, fAlpha, fAlpha2;
float cfR, cfB, cfR2, cfB2, cfR3, cfB3; //cf = Colour Float
boolean bRunOnce = true;
public void setup()
{
  size(displayWidth, displayHeight);
  //size(600, 400);
  minim = new Minim(this);
  player = minim.loadFile("Music"+iSong+".mp3");
  beat = new BeatDetect();
  player.play();
  //player.loop();
  frameRate(60);
  f = createFont("Tahoma", 16, true);
  smooth(8); // anti-aliasing (smooths edges). Depends on hardware, x4 and x8 will not work on all
             // computers, switch to x2 if it runs poorly. https://processing.org/reference/smooth_.html
}

float timerX(float fPosX) {
  for (int i = 0; i < player.length(); i++); 
  {
    fPosX = random(0 - width, width); 
    //delay(2000);
  }
  return fPosX;
}

float timerY(float fPosY) {
  for (int i = 0; i < player.length(); i++); 
  {
    fPosY = random(0 - height, height); 
    //delay(2000);
  }
  return fPosY;
}

public void draw()
{ 
  //float t = map(mouseX, 0, width, 0, 1);
  beat.detect(player.mix);
  fill(255, 35); // here we create a rectangle with a low opacity
  noStroke();    // I used this instead of a background() in order to create
  rect(0, 0, width, height); // the fading away effect with everything on screen
  translate(width/2, height/2); // layers and layers draw ontop of eachother every frame 
  // the higher the alpha value the quicker it "fades"
  beginShape();
  noStroke();

  if (bRunOnce == true) {
    meta = player.getMetaData();
    textFont(f, 46);                 
    fill(25, 255);    
    textAlign(CENTER);
    text("Track #:" + iSong, 0, height*-0.3);
    text(meta.title(), 0, height*-0.4);
    text(meta.author(), 0, height*0.4);
    bRunOnce = false;
  }

  float posX = 0;
  float fBloomPosX = timerX(posX);
  float posY = 0;
  float fBloomPosY = timerY(posY); 
  if (beat.isOnset()) {

    fRad3 = fRad3*0.9f; 
    cfR3 = random(0, 200); 
    cfB3 = random(0, 100);
    fill(56 + cfR, 32, 78 + cfB, 75); 
    ellipse(fBloomPosX, fBloomPosY, 2*fRad3, 2*fRad3);
  } else {
    fRad3 = 700;
  }
  endShape();

  beginShape(); // beginShape and endShape are extremely useful
  stroke(0xff732881, 255); // when dealing with large amounts of customization
  fill(0xff732881, 255); // basically opening and closing brackets for stroke, fill, etc.

  int bsize = player.bufferSize(); 
  for (int i = 0; i < bsize - 1; i+=5)
  {
    float x = (r)*cos(i*2*PI/bsize); 
    float y = (r)*sin(i*2*PI/bsize); 
    float x2 = (r + player.mix.get(i)*100)*cos(i*2*PI/bsize); // math from WIP 2
    float y2 = (r + player.mix.get(i)*100)*sin(i*2*PI/bsize); // https://forum.processing.org/two/discussion/823/issue-displaying-fft-in-a-circle-minim
    line(x, y, x2, y2);
  }
  endShape(); 

  beginShape(); 
  stroke(0xffFFEA00, 100); 

  int bsize2 = player.bufferSize(); 
  for (int i = 0; i < bsize2 - 1; i+=4)
  {
    float x = (r)*cos(i*2*PI/bsize2); 
    float y = (r)*sin(i*2*PI/bsize2); 
    float x2 = (r + player.mix.get(i)*-300/* \u2660 */)*cos(i*2*PI/bsize2); // \u2660 here I messed with some values and got the cool yellow diamond
    float y2 = (r + player.mix.get(i)*300)*sin(i*2*PI/bsize2); // \u2660 essentially shaping the band into an inverted circle by making the value  a negative
    line(x, y, x2, y2);
  }

  endShape(); 

  beginShape(); 
  noFill(); 
  stroke(0, 255); 

  for (int i = 0; i < bsize; i+=5)
  {
    float x2 = (r + player.mix.get(i)*100)*cos(i*2*PI/bsize); // using the same math as before
    float y2 = (r + player.mix.get(i)*100)*sin(i*2*PI/bsize); 
    vertex(x2, y2); // this time creating vertex's on the x and y's pulled from the band
    // joins all the points together with lines
    pushStyle(); //     ]  
    stroke(-1); //      |
    strokeWeight(2); // |  Visual Fluff
    point(x2, y2); //   |
    popStyle(); //      ]  push and pop Style explained https://processing.org/reference/pushStyle_.html
  }
  endShape(); 

  beginShape(); 
  stroke(0, 255); 
  fill (0, 255); 
  for (int i = 0; i < bsize - 1; i+=5)
  {
    float x2 = (r + player.mix.get(i)*100)*cos(i*2*PI/bsize); // same thing again, except just putting tiny circles
    float y2 = (r + player.mix.get(i)*100)*sin(i*2*PI/bsize); // on the x and ys pulled from the band
    ellipse(x2, y2, 3, 3); // looks cool
  }

  endShape(); 
  beginShape(); 
  noStroke(); 

  if (beat.isOnset()) { // if beat is detected
    fRad = fRad*1.2f; // exponentially enlarge the ellipse
    fAlpha = random(15, 200); // randomize alpha value 0-100 (255 is max)
    cfR = random(0, 200); // randomize colour float for Red
    cfB = random(0, 100); // randomize colour float for Blue
  } else {
    fRad = 70; // if beat is not detected, return the ellipse to a default size
  }

  fill(118 + cfR, 82, 124 + cfB, fAlpha); // I could have made this a full rainbow spectrum
  //println(fAlpha);                        // slightly adjusting the red and blue values looks better though
  ellipse(0, 0, 2*fRad, 2*fRad); // I want a common hue 
  endShape(); 

  beginShape(); 
  noStroke(); 

  if (beat.isOnset()) {
    fRad2 = fRad2*0.9f; // same thing as above except the ellipse shrinks into itself on beat detect
    fAlpha2 = random(15, 100); 
    cfR2 = random(0, 50); // slightly adjusted colour values for diversity
    cfB2 = random(0, 255);
  } else {
    fRad2 = 55;
  }
  fill(75 + cfR2, 82, 124 + cfB2, fAlpha2); 
  ellipse(0, 0, 2*fRad2, 2*fRad2); 
  endShape();
}
public void keyPressed() {
  if (key==' ')exit();
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
    player = minim.loadFile("Music"+iSong+".mp3");
    player.play();
    meta = player.getMetaData();
    textFont(f, 46);                 
    fill(25, 255);    
    textAlign(CENTER);
    text("Track #:" + iSong, 0, height*-0.3);
    text(meta.title(), 0, height*-0.4);
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