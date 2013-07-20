interface PositionProvider {
  Point getPosition();
  void begin();
  void quit();
}

abstract class PositionProviderThread extends Thread implements PositionProvider {

  boolean running;
  int wait;  // How many milliseconds should we wait in between executions?

  PositionProviderThread() {
    wait = 0;
    running = false;
  }

  void start() {
    running = true;
    println("Starting " + this); 
    super.start();
  }
  void begin() { start(); }

  void run() {
    while (running) {
      try {
        sleep((long)(wait));
      } catch (Exception e) {
      }
    }
  }

  abstract Point getPosition();

  void quit() {
    System.out.println("Shutting down " + this); 
    running = false;
    // In case the thread is waiting. . .
    interrupt();
  }
}

class Point {
  final int x;
  final int y;
  final int z;
  public Point(final int x, final int y, final int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class MousePositionProvider extends PositionProviderThread {
  public Point getPosition() {
    return new Point(mouseX, mouseY, int(random(0,100)));
  }
}

class NetworkPositionProvider implements PositionProvider {
  final Client client;
  Point lastPoint = new Point(0,0,0);
  int clientWidth = 0;
  int clientHeight = 0;

  public NetworkPositionProvider(Client client) {
    this.client = client;
  }

  public Point getPosition() {
    if (client.available() > 0) {
      final String data = client.readStringUntil(10);
      if (data != null) {
        String[] splitted = data.replace("\n", "").split(",");
        if (splitted.length == 3) {
          return new Point(int(map(int(splitted[0]), 0, clientWidth, 0, width)), int(map(int(splitted[1]), 0, clientHeight, 0, height)), int(splitted[2]));
        } else if (splitted.length == 2) {
          clientWidth = int(splitted[0]);
          clientHeight = int(splitted[1]);
        }
      }
    }
    return null;
  }
  
  void begin() {}

  void quit() {
    this.client.stop();  
  }
}
