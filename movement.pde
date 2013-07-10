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
