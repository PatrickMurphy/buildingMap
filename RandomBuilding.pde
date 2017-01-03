class RandomBuilding implements TileObject {
  int x, y, z;
  int wid, len, padding;
  int centerX, centerY;
  int influence; // 0 = classic, 1 = modern
  int maxHeight;
  PImage texture;
  float pop;

  int shapeCount;

  ArrayList<Shape> shapes = new ArrayList<Shape>();

  RandomBuilding(PVector v, int SquareLength, float pop) {
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
    this.padding = 10;
    this.centerX = wid/2;
    this.centerY = len/2;
    this.influence = influence;
    this.shapeCount = (int)random(2, 3);
    this.maxHeight = (int)random(wid, wid*map(this.pop, 0, 100, 1, 5));
    this.texture = building_textures[(int)random(0, 100)%(building_textures.length)]; // random texture

    this.addRandomShapes();
  }

  void addRandomShapes() {
    while (shapes.size() < this.shapeCount) {
      tryAddShape();
    }
  }

  void tryAddShape() {
    if (shapes.size() < this.shapeCount) {
      // try and place another shape
      int testX = (int)random(this.padding, wid-this.padding);
      int testY = (int)random(this.padding, len-this.padding);

      Shape r1;

      if (this.pop >= 50) {
        // sky scaper
        if (random(0, 100)>60) {
          r1 = new Circle(testX+x, testY+y, this.z, (int)random(min(testX, wid-testX)), (int)random(min(testY, len-testY)), texture);
        } else {
          r1 = new Rectangle(testX+x, testY+y, this.z, (int)random(wid/4, wid-testX), (int)random(len/4, len-testY), texture);
        }

        if (r1.containsPoint(centerX+x, centerY+y)) {
          r1.setHeight(map(r1.getArea(), 0, wid*len, this.maxHeight, 10));
          shapes.add(r1);
        }
      } else {
        // house
        this.shapeCount = 1;
        r1 = new Rectangle(testX+x, testY+y, this.z, (int)random(wid/4, wid-testX), (int)random(len/4, len-testY), texture);
        if (r1.containsPoint(centerX+x, centerY+y)) {
          r1.setHeight(map(r1.getArea(), 0, wid*len, this.maxHeight/4, 10));
          Roof tempRoof = new Roof((Rectangle)r1);
          shapes.add(tempRoof);
          shapes.add(r1);
        }
      }
    }
  }

  PVector getPosition() {
    return new PVector(x, y, z);
  }

  void display2D() {
    for (Shape s : shapes) {
      s.display2D();
    }
  }

  void display() {
    for (Shape s : shapes) {
      s.display();
    }
  }
}