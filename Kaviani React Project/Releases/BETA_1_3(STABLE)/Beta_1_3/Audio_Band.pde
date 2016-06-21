//Ariana Kaviani ft. Jose Sanchez

import ddf.minim.*;
class AudioBandLine {
  Minim minim;
  // GLOBAL VARIABLES
  int _iInvX, _iInvY, _iSR, _iSG, _iSB, _iFR, _iFG, _iFB, _iSA, _iFA;
  // CONSTRUCTOR
  AudioBandLine(AudioPlayer player, int iInvX, int iInvY, int iSR, int iSG, int iSB, int iSA, int iFR, int iFG, int iFB, int iFA) {
    _iInvX = iInvX; // Invert X
    _iInvY = iInvY; // Invert Y
    _iSR = iSR; // Stroke RBG
    _iSG = iSG;
    _iSB = iSB;                      // I feel like all this RGB stuff could have been done better with Arrays?
    _iFR = iFR; // Fill RGB
    _iFG = iFG;
    _iFB = iFB;
    _iSA = iSA; // Stroke Alpah
    _iFA = iFA; // Fill Alpha
  }

  // FUNCTIONS

  void display() {

    int bSize = player.bufferSize(); 


    beginShape(); // beginShape and endShape are extremely useful

    stroke(_iSR, _iSG, _iSB, _iSA); // when dealing with large amounts of customization
    fill(_iFR, _iFG, _iFG, _iFA); // basically opening and closing brackets for stroke, fill, etc.

    for (int i = 0; i < bSize - 1; i+=5)
    {
      float x = (r)*cos(i*2*PI/bSize); 
      float y = (r)*sin(i*2*PI/bSize); 
      float x2 = (r + player.mix.get(i)*_iInvX)*cos(i*2*PI/bSize); // math from WIP 2
      float y2 = (r + player.mix.get(i)*_iInvY)*sin(i*2*PI/bSize); // https://forum.processing.org/two/discussion/823/issue-displaying-fft-in-a-circle-minim
      line(x, y, x2, y2);
    }
    endShape();
  }

  void run () {
    display();
  }
}