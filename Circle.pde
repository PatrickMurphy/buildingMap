class Circle implements Shape {
  int x, y, z;
  int wid, len;
  color fill, stroke;
  float circleHeight;
  PImage texture;
  float sides, angle;

  Circle(int x, int y, int z, int r) {
    this(x, y, z, r, r, color(43), color(43), null);
  }
  Circle(int x, int y, int z, int wid, int len) {
    this(x, y, z, wid, len, color(43), color(43), null);
  }
  Circle(int x, int y, int z, int wid, int len, PImage text) {
    this(x, y, z, wid, len, color(43), color(43), text);
  }
  Circle(int x, int y, int z, int wid, int len, color fill) {
    this(x, y, z, wid, len, fill, color(43), null);
  }
  Circle(int x, int y, int z, int wid, int len, color fill, color stroke, PImage texture) {
    // generate random shapes
    this.x = x;
    this.y = y;
    this.z = z;
    this.wid = wid;
    this.len = len;
    this.fill = fill;
    this.stroke = stroke;
    this.texture = texture;
    this.sides = 10;
    this.angle = 360 / this.sides;
  }
  void display2D() {
    fill(fill);
    //stroke(stroke);
    ellipse(map(x, 0, GRID_WIDTH-CELL_SCALE, 0, width), map(y, 0, GRID_HEIGHT-CELL_SCALE, 0, height), width*(this.wid/((float)GRID_WIDTH-CELL_SCALE)), height*(this.len/((float)GRID_HEIGHT-CELL_SCALE)));
  }
  void display() {
    fill(55);
    noStroke();
    // draw top shape
    beginShape();
    for (int i = 0; i < sides; i++) {
      float x = cos( radians( i * angle ) ) * wid;
      float y = sin( radians( i * angle ) ) * wid;
      vertex( this.x+x, this.y+y, this.z+this.circleHeight);
    }
    endShape(CLOSE);
    fill(fill);
    // draw body
    beginShape(TRIANGLE_STRIP);
    if (texture != null) {
      texture(texture);
    }
    for (int i = 0; i < sides + 1; i++) {
      float tc = (i/(float)(2*PI));
      float x = cos( radians( i * angle ) ) * wid;
      float y = sin( radians( i * angle ) ) * wid;
      vertex( this.x+x, this.y+y, this.z+this.circleHeight, tc, 0);
      vertex( this.x+x, this.y+y, this.z, tc, 1);
    }
    endShape(CLOSE);
  }
  boolean containsPoint(int x1, int y1) {
    return pow(x1-this.x, 2)/sq(wid/2) + pow(y1-this.y, 2)/sq(len/2) <= 1;
  }

  float getArea() {
    return PI*wid*len;
  }

  color getFill() {
    return fill;
  }
  color getStroke() {
    return stroke;
  }
  void setFill(color fill) {
    this.fill = fill;
  }
  void setStroke(color stroke) {
    this.stroke = stroke;
  }

  float getHeight() {
    return this.circleHeight;
  }
  void setHeight(float h) {
    this.circleHeight = h;
  }
}