/*******************************************************************************
 * SparkChime: Drag the mouse to release a colorful spray of sparks that produce
 * musical tones as they bounce.
 *
 * @author Gregory Bush
 */

Particle spark;

/**
 * Perform initial setup needed for the sketch.
 *
 * @author Gregory Bush
 */
void setup() {
  size(640, 480);
  background(0);
  /*
   * Create the 3D canvas to draw on.
   */
  spark = new Particle(PVector(mouseX, mouseY), random(256), random(256), random(256));
}

void mouseMoved() {
  PVector current = PVector(mouseX, mouseY);

  /*
   * If the interaction point is above the ground, create a spark.
   */
  if (current.y < height) {
    /*
     * The spark's initial velocity is the difference between the current and prior
     * points, randomized a bit to create a "spray" effect and scaled by the elapsed
     * time.
     */
    spark.move(current);
  }
}
long lastFrameDrawn = millis();

float averageElapsedMillis = 20.0;

/**
 * Draw an animation frame.
 *
 * @author Gregory Bush
 */
void draw() {
  /*
   * Determine how long it has been since we last drew a frame.
   */
  long now = millis();
  long elapsedMillis = now - lastFrameDrawn;
  lastFrameDrawn = now;
  averageElapsedMillis = .90 * averageElapsedMillis + .10 * elapsedMillis;
  /*
   * Fade the screen's current contents a bit more toward black.
   */
  noStroke();    
  fill(0, 0, 0, constrain(2 * elapsedMillis, 0, 255));
  rect(0, 0, width, height);
}

