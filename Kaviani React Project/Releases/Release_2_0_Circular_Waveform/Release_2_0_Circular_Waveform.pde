import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer player;
BeatDetect beat;
int  r = 200;
float rad = 20, rad2 = 20;
void setup()
{
  size(displayWidth, displayHeight);
  //size(600, 400);
  minim = new Minim(this);
  player = minim.loadFile("dank.mp3");
  beat = new BeatDetect();
  player.play();
  //player.loop();
  background(10);
  frameRate(60);
}
 
void draw()
{ 
  float t = map(mouseX, 0, width, 0, 1);
  beat.detect(player.mix);
  fill(#1A1F18, 20);
  noStroke();
  rect(0, 0, width, height);
  translate(width/2, height/2);
  noFill();
  
  fill(-1, 10);
  if (beat.isOnset()) rad2 = rad2*1.15;
  else rad2 = 70;
 
  ellipse(0, 0, 2*rad2, 2*rad2);
  
  fill(-1, 10);
  if (beat.isOnset()) rad = rad*0.9;
  else rad = 70;
 
  ellipse(0, 0, 2*rad, 2*rad);
  
  
  stroke(-1, 50);
  
  int bsize = player.bufferSize();
  for (int i = 0; i < bsize - 1; i+=5)
  {
   float x = (r)*cos(i*2*PI/bsize);
   float y = (r)*sin(i*2*PI/bsize);
   float x2 = (r + player.left.get(i)*100)*cos(i*2*PI/bsize);
   float y2 = (r + player.left.get(i)*100)*sin(i*2*PI/bsize);
   line(x, y, x2, y2);
  }
  beginShape();
  noFill();
  stroke(-1, 50);
  endShape();
}
void keyPressed() {
  if(key==' ')exit();
}