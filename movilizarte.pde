PositionProviderThread thread1;
PositionProviderThread thread2;
PositionProviderThread thread3;

void setup() {
  size(200,200);
  thread1 = new MousePositionProvider();
  thread1.start();

  thread2 = new MousePositionProvider();
  thread2.start();

  thread3 = new MousePositionProvider();
  thread3.start();

  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run() {
      thread1.quit();
      thread2.quit();
      thread3.quit();
    }
  }));
}

void draw() {
  background(255);
  fill(0);
 
  Point a = thread1.getPosition();
  text(a.x,10,50);

  Point b = thread2.getPosition();
  text(b.y,10,150);

  Point c = thread3.getPosition();
  text(c.z,50,150);
}
