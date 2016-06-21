
class Ball {
  // GLOBAL VARIABLES
  float x, y, fRad = 20;

  // CONSTRUCTOR
  Ball(float _x, float _y) {
    x = _x;
    y = _y;
  }

  // FUNCTIONS
  void keyPressed() {
    if (key == ' ') {
      fRad = fRad*1.2f;
    } else {
      fRad = 20;
    }
  }

  void display() {
    ellipse(x, y, fRad, fRad);
  }

  void run () {
    display();
    keyPressed();
  }
}