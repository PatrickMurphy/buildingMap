class RandomBuilding {
  int x, y, z;
  int wid, len;
  int centerX, centerY;
  int influence; // 0 = classic, 1 = modern
  int maxHeight;
  PImage texture;
  float pop;

  int shapeCount;

  ArrayList<Shape> shapes = new ArrayList<Shape>();

  RandomBuilding(Vector3 v, int SquareLength, float pop) {
    this((int)v.x, (int)v.y, (int)v.z, SquareLength, SquareLength, pop);
  }

  RandomBuilding(int x, int y, int z, int SquareLength, float pop) {
    this(x, y, z, SquareLength, SquareLength, pop);
  }
  RandomBuilding(int x, int y, int z, int wid, int len, float pop) {
    this(x, y, z, wid, len, pop, 0);
  }

  RandomBuilding(int x, int y, int z, int wid, int len, float pop, int influence) {
    // generate random shapes
    this.x = x;
    this.y = y;
    this.z = z;
    this.wid = wid;
    this.len = len;
    this.pop = pop;
    this.centerX = wid/2;
    this.centerY = len/2;
    this.influence = influence;
    this.shapeCount = (int)random(1, 3);
    this.maxHeight = (int)random(wid, wid*map(this.pop, 0, 100, 1, 5));
    this.texture = loadImage("building_office"+(int)random(3, 13)+".png");

    while (shapes.size() <= this.shapeCount) {
      tryAddShape();
    }
  }

  void tryAddShape() {
    if (shapes.size() <= this.shapeCount) {
      // try and place another shape
      int testX = (int)random(0, wid);
      int testY = (int)random(0, len);

      Shape r1;

      if (random(0, 100)>60) {
        r1 = new Circle(testX+x, testY+y, this.z, (int)random(min(testX, wid-testX)), (int)random(min(testY, len-testY)), texture);
      } else {
        r1 = new Rectangle(testX+x, testY+y, this.z, (int)random(wid/4, wid-testX), (int)random(len/4, len-testY), texture);
      }

      if (r1.containsPoint(centerX+x, centerY+y)) {
        r1.setHeight(map(r1.getArea(), 0, wid*len, this.maxHeight, 10));
        shapes.add(r1);
      }
    }
  }

  void display() {
    noFill();
    stroke(255);
    rect(x, y, wid, len);
    fill(255, 0, 0);
    //noStroke();
    rect(x+centerX, y+centerY, wid/100, len/100);
    rect(x, y, wid/100, len/100);
    fill(0, 255, 0);
    rect(x, y+len, wid/100, len/100);
    fill(0, 0, 255);
    rect(x+wid, y, wid/100, len/100);
    for (Shape s : shapes) {
      s.display3d();
    }
  }
}