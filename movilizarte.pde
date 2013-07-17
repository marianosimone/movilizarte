import processing.net.*;

ArrayList<PositionRepresentation> reps;
Server server;
boolean running = true;

void setup() {
  size(640, 480);
  reps = new ArrayList<PositionRepresentation>();
  server = new Server(this, 5204);
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run() {
      running = false;
      for (PositionRepresentation rep : reps) {
        rep.quit();
      }
      server.stop();
    }
  }));
}

long lastFrameDrawn = millis();
float averageElapsedMillis = 20.0;

void draw() {
  if (running) {
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
}

void serverEvent(Server server, Client client) {
  println("New client from " + client.ip());
  PositionRepresentation rep = new SparkPositionRepresentation(new NetworkPositionProvider(client), color(random(256), random(256), random(256)));
  reps.add(rep);
  rep.begin();
}

void disconnectEvent(Client client) {
  //TODO: Do something when someone disconnects
}
