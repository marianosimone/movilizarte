/*******************************************************************************
 * SparkChime: Drag the mouse to release a colorful spray of sparks that produce
 * musical tones as they bounce.
 *
 * @author Gregory Bush
 */



/*
 * The variation in velocity of newly-created sparks.
 */
float SPRAY_SPREAD = 10.0;

/*
 * Some predefined gravity settings to play with.
 */
float EARTH_GRAVITY = 1.0 / 16.0;
float MOON_GRAVITY = EARTH_GRAVITY / 6.0;
float JUPITER_GRAVITY = EARTH_GRAVITY * 2.5;

/*
 * The amount of acceleration due to gravity.
 */
float GRAVITY = EARTH_GRAVITY;

/*
 * The amount of error allowed in model coordinate measurements.  Lowering
 * this will let sparks have tiny bounces longer.
 */
float TOLERANCE = 0.2;

/**
 * The focal length from the viewer to the screen in model coordinates.
 */
float FOCAL_LENGTH = 1000.0;

/**
 * The distance in model coordinates from the viewer to where new sparks are
 * created.  Increasing this number will move the created sparks further away.
 */
float INTERACTION_DISTANCE = 4 * FOCAL_LENGTH;

/*
 * A custom 3D canvas used to draw the world.
 */
Canvas3D canvas;

/*
 * A collection of Particles that represent the spraying sparks.
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
  canvas = new Canvas3D(FOCAL_LENGTH, INTERACTION_DISTANCE);
  spark = new Particle(canvas.toModelCoordinates(mouseX, mouseY), random(256), random(256), random(256));
}

void mouseMoved() {
  PVector current = canvas.toModelCoordinates(mouseX, mouseY);

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

  /*
   * Draw any active sparks and evolve them the amount of passed time
   * since the last frame was drawn.
   *
   * TODO: I'd like to draw these z-ordered from furthest to
   * closest, but the built-in Processing sorts don't
   * facilitate this.
   */
  //spark.evolve(elapsedMillis);
}

