/******************************************************************************
 * A rudimentary 3D graphics library.
 *
 * @author Gregory Bush
 */

/**
 * A Canvas3D allows drawing graphics primitives in a 3D coordinate system.
 *
 * @author Gregory Bush
 */
public class Canvas3D {
  private final float focalLength;

  private final float interactionPlane;

  public Canvas3D(float focalLength, float interactionPlane) {
    this.focalLength = focalLength;
    this.interactionPlane = interactionPlane;
  }

  /**
   * Convert a point in the 3D model to a point on the 2D screen.
   */
  public PVector toScreenCoordinates(PVector p) {
    float scale = focalLength / p.z;

    return new PVector(p.x * scale + width / 2, p.y * scale + height / 2);
  }

  /**
   * Convert a point on the 2D screen to a point in the 3D model, projected on
   * the interaction plane.
   */
  public PVector toModelCoordinates(float x, float y) {
    float scale = interactionPlane / focalLength;

    return new PVector((x - width / 2) * scale, (y - height / 2) * scale, interactionPlane);
  }

  /**
   * Scale the diameter of a sphere whose center is at a particular Z distance to
   * its diameter on the screen.
   */
  public float scaleToScreen(float diameter, float distance) {
    return diameter * focalLength / distance;
  }

  private void drawLine(PVector from, PVector to) {
    line(from.x, from.y, to.x, to.y);
  }

  private void drawPoint(PVector p) {
    point(p.x, p.y);
  }

  /**
   * Draw a line between 3D points.
   */
  public void drawLine(PVector from, PVector to, float weight) {
    strokeWeight(scaleToScreen(weight, to.z));
    drawLine(toScreenCoordinates(from), toScreenCoordinates(to));
  }

  /**
   * Draw a point in 3D.
   */
  public void drawPoint(PVector p, float weight) {
    strokeWeight(scaleToScreen(weight, p.z));
    drawPoint(toScreenCoordinates(p));
  }

  /**
   * Draw a circle with vertical normal vector.
   */
  public void drawHorizontalCircle(PVector center, float radius, float weight) {
    float screenRadius = canvas.scaleToScreen(radius, center.z);
    PVector p = toScreenCoordinates(center);
    PVector back = toScreenCoordinates(PVector.add(center, new PVector(0, 0, radius)));
    float aspect = (back.y - p.y) * 2;
    
    /*
     * A reasonably good approximation of a circle in persepective.
     */
    strokeWeight(scaleToScreen(weight, center.z));    
    ellipse(p.x, p.y, screenRadius, aspect);
  }
}

/**
 * Increase the intensity of a color value.
 */
float amplify(float n) {
  return constrain(4 * n, 0, 255);
}

color amplifyColor(color c) {
  return color(amplify(red(c)), amplify(green(c)), amplify(blue(c)));
}

/******************************************************************************
 * A Particle is a representation of a bouncing, colored spark
 *
 * @author Gregory Bush
 */
public class Particle {
  /*
   * The coordinates of the Particle's current location.
   */
  private PVector location;

  /*
   * The Particle's velocity.
   */
  private PVector velocity;

  /*
   * The Particle's color.
   */
  private color c;

  /**
   * Create a Particle with a specified color and characteristic sound.
   */
  public Particle(float red, float green, float blue) {
    this.c = color(red, green, blue);
  }

  /**
   * Initialize or reset all variables describing the motion of the particle to
   * the specified values.
   */
  public void initializeMotion(PVector location, PVector velocity) {
    this.location = location;
    this.velocity = velocity;
  }

  /**
   * Returns true if the Particle should still be actively evolving in time.
   */
  public boolean isActive() {
    /*
     * We will consider the Particle active as long as it is on the other side
     * of the screen than the viewer. 
     */
    return location != null && location.z >= FOCAL_LENGTH;
  }

  /*
   * Draw a motion-blurred trajectory of a particular stroke weight and opacity.
   * The stroke weight will be scaled based on the Particle's distance from the
   * viewer.
   */
  private void drawMotion(PVector from, PVector to, float weight, float opacity) {
    stroke(c, opacity);
    canvas.drawLine(from, to, weight);
  }

  private void drawMotionBright(PVector from, PVector to, float weight, float opacity) {
    stroke(amplifyColor(c), opacity);
    canvas.drawLine(from, to, weight);
  }

  private void paint(PVector from, PVector to) {
    /*
     * Draw three motion blurs, successively narrower and brighter.
     */
    drawMotion(from, to, 64, 16);
    drawMotion(from, to, 16, 128);
    drawMotionBright(from, to, 8, 255);
  }

  private PVector flip(PVector v) {
    return new PVector(v.x, height + 2 * (height - v.y), v.z);
  }

  private void paintReflection(PVector from, PVector to) {
    from = flip(from);
    to = flip(to);

    drawMotion(from, to, 32, 4);
    drawMotionBright(from, to, 8, 8);
  }

  /*
   * Draw the splash when the Particle strikes the ground and play the
   * Particle's characteristic note if sound is enabled.
   */
  private void splash(PVector to) {
    /*
     * The splash is a circle on the ground with dim illumination in its
     * interior and a bright ring on its circumference.
     */
    stroke(c, 128);
    fill(c, 64);
    canvas.drawHorizontalCircle(to, 128, 8);

    /*
     * At the point where the Particle touched the ground, draw a small
     * but bright flash of light.
     */
    stroke(255, 255, 255, 255);
    canvas.drawPoint(to, 8);
  }

  /*
   * Various functions to determine the direction of the Particle's motion.
   */

  private boolean isMovingLeft() {
    return velocity.x <= -TOLERANCE;
  }

  private boolean isMovingRight() {
    return velocity.x >= TOLERANCE;
  }

  private boolean isMovingUp() {
    return velocity.y <= -TOLERANCE;
  }

  private boolean isMovingDown() {
    return velocity.y >= TOLERANCE;
  }

  private boolean isMovingVertically() {
    return isMovingUp() || isMovingDown();
  }

  /*
   * Give the particle an inactive status, indicating it no longer needs to be
   * evolved in time.
   */
  private void deactivate() {
    location.z = 0;
  }

  public void evolve(float elapsedMillis) {
    /*
     * Deactivate the particle if it has settled into the ground.
     */
    if (location.y > height && velocity.y > 0) {
      deactivate();
      return;
    }

    for (;;) {
      /*
       * Determine if the Particle collided with the ground.  If so, determine
       * where and when it collided.
       */
      boolean collided;
      float collisionMillis = (height - location.y) / velocity.y;

      PVector to;
      if (collisionMillis > 0 && collisionMillis < elapsedMillis) {
        to = PVector.add(location, PVector.mult(velocity, collisionMillis));
        elapsedMillis -= collisionMillis + 1;
        
  
      } 
      else {
        to = PVector.add(location, PVector.mult(velocity, elapsedMillis));
        collided = false;
      }

      paint(location, to);

      location = to;
      

        break;
    }

    /*
     * Apply the accleration due to gravity.
     */
    velocity.y += GRAVITY;
  }
}

