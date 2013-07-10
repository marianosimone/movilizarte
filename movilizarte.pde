ArrayList<PositionRepresentation> reps;

void setup() {
  size(640, 480);
  reps = new ArrayList<PositionRepresentation>();
  reps.add(new TextPositionRepresentation(new MousePositionProvider(), 10, 20));
  reps.add(new SparkPositionRepresentation(new MousePositionProvider(), color(random(256), random(256), random(256)), 0));
  reps.add(new SparkPositionRepresentation(new MousePositionProvider(), color(random(256), random(256), random(256)), 20));
  for (final PositionRepresentation rep : reps) {
    rep.begin();
  }

  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run() {
      for (PositionRepresentation rep : reps) {
        rep.quit();
      }
    }
  }));
}

long lastFrameDrawn = millis();
float averageElapsedMillis = 20.0;

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
  for (PositionRepresentation rep : reps) {
    rep.represent();
  }
}
