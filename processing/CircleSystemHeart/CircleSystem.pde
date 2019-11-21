class CircleSystem {
  ArrayList<Circle> circles;

  CircleSystem(int n) {
    circles = new ArrayList<Circle>();

    for (int i = 0; i < n; i++) {
      Circle p = new Circle();
      circles.add(p);
    }
  }

  void update() {
    for (Circle c : circles) {
      if (!c.isDead() ) { 
        c.update();
      }
    }
  }

  void newCircle() {
    boolean done = false;
    for (Circle c : circles) {
      if (c.isDead() && !done) {
        done = true;
        c.reset();
      }
    }
  }
}
