import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer player;
BeatDetect beat;
int  r = 200;
float rad = 20;
void setup()
{
  // set size to the users resolution
  size(displayWidth, displayHeight);
  //size(600, 400);
  minim = new Minim(this);
  player = minim.loadFile("dank.mp3");
  beat = new BeatDetect();
  player.play();
  //player.loop();
  background(100);
  frameRate(60);
}
 
void draw()
{ 
  float t = map(mouseX, 0, width, 0, 1);
  // Load both left and right channels of the player (that is playing dank.mp3)
  beat.detect(player.mix);
  fill(#1A1F18, 20);            // ]
  noStroke();                   // |
  rect(0, 0, width, height);    // |  Visual
  translate(width/2, height/2); // |  Fluff
  noFill();                     // |
  fill(-1, 10);                 // ]
  // Mutiply radius by 1.1 each time beat is detected (60fps = 60 checks/s)
  if (beat.isOnset()) rad = rad*1.15;
  else rad = 70;
  // increase the size of the elipse (x/y) by mutiplying with rad)
  ellipse(0, 0, 2*rad, 2*rad);
  beginShape();
  noFill();
  stroke(-1, 50);
  endShape();
}
void keyPressed() {
  // close program upon esc keypress
  if(key==' ')exit();
}