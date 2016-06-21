//Ariana K

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer dank;
FFT         fft;

void setup()
{
  size(512, 200, P3D);
  minim = new Minim(this);
  // specify that we want the audio buffers of the AudioPlayer
  // to be 1024 samples long because our FFT needs to have 
  // a power-of-two buffer size and this is a good size.
  dank = minim.loadFile("dank.mp3", 1024);
  
  // loop the file
  dank.loop();
  
  smooth(4);
  
  // fft time buffer needs to be a power of 2
  // spectrum is half as size
  fft = new FFT( dank.bufferSize(), dank.sampleRate());
  
}

void draw()
{
  background(25);
  fill(255);
  stroke(#9161EA);
  
  
  // forward fft. on the sound file
  // mix = the frequency of both left and right channels
  fft.forward( dank.mix );
  
  for(int i = 0; i < fft.specSize(); i++)
  {
    // draw the line for frequency band i, making it bigger so I can see it
    line( i, height, i, height - fft.getBand(i)*8 );
  }
}