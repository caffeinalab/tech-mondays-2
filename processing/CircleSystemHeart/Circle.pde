class Circle {

  PVector velocity;
  float lifespan = 255;
  float maxLife = 255;
  
  float partSize;
  float angle;
  float radius;
  float t;

  Circle() {
    maxLife = 500;
    partSize = 20;
    angle = radians(360) / partSize;
    radius = min(width, height*2)*2;
    t = random(1, 100);
    lifespan = random(1, maxLife);
  }
  
  void reset() {
    lifespan = 0; 
  }
  
  boolean isDead() {
    if (lifespan > maxLife) {
     return true;
    } else {
     return false;
    } 
  }
  

  public void update() {
    t += 0.01;
    float f = (lifespan/maxLife);
    
    beginShape();
    strokeWeight(8 * (1-f));
    stroke(255, 0, 0, 255 * (1-f) );
    for (int i = 0; i < partSize + 3; i++) {
      float a = angle * i;
      float r = radius * f;
      float x = cos(a)*r;
      float y = sin(a)*r;
      
      float n = noise(i+t) * f;
      curveVertex(x + 200 * n, y - 200 * n, -900* n);
    }
    
    endShape(CLOSE);
    lifespan = lifespan + 1;
  }
}
