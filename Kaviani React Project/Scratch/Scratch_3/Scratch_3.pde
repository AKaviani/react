//Ariana Kaviani

// DECLARE
Ball myBall;
boolean bClick;
void setup() {
  size (600, 600);
  smooth();
  // INITIALIZE
  myBall = new Ball(300, 300);
}

void draw() {
  background(0);
  // CALL FUNCTIONALITY
  myBall.run();
}