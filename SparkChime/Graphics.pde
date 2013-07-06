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
  strokeWeight(weight);
  drawLine(from, to);
}

/**
 * Draw a point in 3D.
 */
public void drawPoint(PVector p, float weight) {
  strokeWeight(weight);
  drawPoint(p);
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
   * The Particle's color.
   */
  private color c;

  /**
   * Create a Particle with a specified color and characteristic sound.
   */
  public Particle(PVector location, float red, float green, float blue) {
    this.location = location;
    this.c = color(red, green, blue);
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

  public void move(PVector to) {
    paint(location, to);
    location = to;
  }
}

