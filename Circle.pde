class Circle implements Shape {
  int x, y, z;
  int wid, len;
  color fill, stroke;
  float cirlceHeight;
  PImage texture;
  Circle(int x, int y, int z, int r) {
    this(x, y, z, r, r, color(43), color(43), null);
  }
  Circle(int x, int y, int z, int wid, int len, PImage text) {
    this(x, y, z, wid, len, color(43), color(43), text);
  }
  Circle(int x, int y, int z, int wid, int len) {
    this(x, y, z, wid, len, color(43), color(43), null);
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
  }
  void display() {
    fill(fill);
    stroke(stroke);
    ellipse(x, y, wid, len);
  }
  void display3d() {
    fill(fill);
    stroke(stroke);
    noStroke();
    float sides = 30;
    float h = this.getHeight();
    float r = wid;

    float angle = 360 / sides;
    float halfHeight = h;
    // draw top shape
    beginShape();
    for (int i = 0; i < sides; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( this.x+x, this.y+y, this.z+halfHeight );
    }
    endShape(CLOSE);

    // draw body
    beginShape(TRIANGLE_STRIP);
    texture(texture);
    for (int i = 0; i < sides + 1; i++) {
      float tc = (i/(float)(2*PI))*3;
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( this.x+x, this.y+y, this.z+halfHeight, tc, 0);
      vertex( this.x+x, this.y+y, this.z, tc, 3);
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
    return this.cirlceHeight;
  }
  void setHeight(float h) {
    this.cirlceHeight = h;
  }
}