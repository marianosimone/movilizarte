abstract class PositionRepresentation {
  final PositionProvider provider;

  PositionRepresentation(final PositionProvider provider) {
    this.provider = provider;
  }

  void begin() {
    provider.begin();
  }
  void quit() {
    provider.quit();
  }

  abstract void represent();
}

class TextPositionRepresentation extends PositionRepresentation {
  final int x;
  final int y;

  TextPositionRepresentation(final PositionProvider provider, final int x, final int y) {
    super(provider);
    this.x = x;
    this.y = y;
  }

  void represent() {
    Point pos = provider.getPosition();
    fill(255);
    text("x:" + pos.x + ", y:" + pos.y, x, y);
  }
}

/*
* Based on SparkChime by Gregory Bush
*/
class SparkPositionRepresentation extends PositionRepresentation {
  final Particle spark;

  SparkPositionRepresentation(final PositionProvider provider, final color c) {
    super(provider);
    spark = new Particle(new PVector(0, 0), c);
  }

  void represent() {
    Point pos = provider.getPosition();
    if (pos != null) {
      PVector current = new PVector(float(pos.x), float(pos.y));
      spark.move(current);
    }
  }     
}
