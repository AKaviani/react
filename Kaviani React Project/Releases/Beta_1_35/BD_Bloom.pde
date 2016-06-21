//Ariana Kaviani

import ddf.minim.*;
class BD_Bloom { //BeatDetect_Bloom
  Minim minim;
  // VARIABLES
  int  iRad, iFR, iFG, iFB;
  float fBR, fRRMin, fRRMax, fRBMin, fRBMax, fRAMin, fRAMax, fRR, fRB, fRA, fRXMin, fRXMax, fRYMin, fRYMax, fRX, fRY;
  // CONSTRUCTOR
  BD_Bloom(BeatDetect beat, float _fBR, int _iFR, int _iFG, int _iFB, int _iRad, float _fRRMin, float _fRRMax, float _fRBMin,
  float _fRBMax, float _fRAMin, float _fRAMax, float _fRXMin, float _fRXMax, float _fRYMin, float _fRYMax) {
    
    fBR = _fBR; // Bloom Rate
    iFR = _iFR; // Fill RGB
    iFG = _iFG;
    iFB = _iFB;
    iRad = _iRad; // Radius
    fRRMin = _fRRMin; //Red Value Min/Max (for random)
    fRRMax = _fRRMax;
    fRBMin = _fRBMin; //Blue Value Min/Max (for random)
    fRBMax = _fRBMax;
    fRAMin = _fRAMin; //Alpha Value Min/Max (for random)
    fRAMax = _fRAMax;
    fRXMin = _fRXMin;
    fRXMax = _fRXMax;
    fRYMin = _fRYMin;
    fRYMax = _fRYMax;
  }

  // FUNCTIONS

  void display() {
    beginShape();
    noStroke(); 
    if (beat.isOnset()) { // if beat is detected
      fRad = fRad*(fBR); // exponentially enlarge the ellipse
      fRR = random(fRRMin, fRRMax); //randomize
      fRB = random(fRBMin, fRBMax);
      fRA = random(fRAMin, fRAMax);
      fRX = random(fRXMin, fRXMax);
      fRY = random(fRYMin, fRYMax);
    } else {
      fRad = iRad; // if beat is not detected, return the ellipse to a default size
    }
    fill(iFR + fRR , iFG, iFB + fRB, fRA); // I could have made this a full rainbow spectrum                                                                            // slightly adjusting the red and blue values looks better though
    ellipse(fRX, fRY, 2*fRad, 2*fRad); // I want a common hue
    endShape();
  }

  void run () {
    display();
  }
}