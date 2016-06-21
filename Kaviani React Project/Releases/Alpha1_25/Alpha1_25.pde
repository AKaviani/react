import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer dank;
FFT fft;
 
void setup()
{
  size(512, 200);
  frameRate(60);
  smooth (100);
  // always start Minim first!
  minim = new Minim(this);
 
  // specify 512 for the length of the sample buffers
  // the default buffer size is 1024
  dank = minim.loadFile("dank.mp3", 1024);
  dank.play();
 
  // an FFT needs to know how 
  // long the audio buffers it will be analyzing are
  // and also needs to know 
  // the sample rate of the audio it is analyzing
  fft = new FFT(dank.bufferSize(), dank.sampleRate());
}
 
void draw()
{
  
  // first perform a forward fft on one of dank's buffers
  // I'm using the mix buffer
  //  but you can use any one you like
  fft.forward(dank.mix);
  for(int i = 0; i < fft.specSize(); i++)
  { background(i, 0 , 255, 50);
  }
 
  stroke(145, 0, 225, 255);
  // draw the spectrum as a series of vertical lines
  // I multiple the value of getBand by 4 
  // so that we can see the lines better
  
  for(int i = 0; i < fft.specSize(); i++)
  {
    
    line(i, height, i, height - fft.getBand(i)*8);
  }

  stroke(150, 0 , 255 ,50);
  // I draw the waveform by connecting 
  // neighbor values with a line. I multiply 
  // each of the values by 50 
  // because the values in the buffers are normalized
  // this means that they have values between -1 and 1. 
  // If we don't scale them up our waveform 
  // will look more or less like a straight line.
  for(int i = 0; i < dank.mix.size() - 1; i++)
  {
    line(i, 100 + dank.mix.get(i)*50, i+1, 50 + dank.mix.get(i+1)*20);
  }
}