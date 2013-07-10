/*
 * Based on SparkChime, by Gregory Bush
 */

private void drawLine(PVector from, PVector to) {
  line(from.x, from.y, to.x, to.y);
}

private void drawPoint(PVector p) {
   point(p.x, p.y);
  }

public void drawLine(PVector from, PVector to, float weight) {
  strokeWeight(weight);
  drawLine(from, to);
}

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

public class Particle {
  private PVector location;
  private color c;

  public Particle(PVector location, color c) {
    this.location = location;
    this.c = c;
  }

  /*
   * Draw a motion-blurred trajectory of a particular stroke weight and opacity.
   * The stroke weight will be scaled based on the Particle's distance from the
   * viewer.
   */
  private void drawMotion(PVector from, PVector to, float weight, float opacity) {
    stroke(c, opacity);
    drawLine(from, to, weight);
  }

  private void drawMotionBright(PVector from, PVector to, float weight, float opacity) {
    stroke(amplifyColor(c), opacity);
    drawLine(from, to, weight);
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

