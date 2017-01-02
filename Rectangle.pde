class Rectangle implements Shape {
  int x, y, z;
  int wid, len;
  color fill, stroke;
  float height;
  PImage texture;
  Rectangle(int x, int y, int z, int wid, int len, PImage text) {
    this(x, y, z, wid, len, color(55), color(55), text);
  }
  Rectangle(int x, int y, int z, int wid, int len, color fill, color stroke, PImage texture) {
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
    rect(x, y, wid, len);
  }
  void display3d() {
    // make top
    fill(fill);
    //stroke(stroke);
    noStroke();
    beginShape();
    vertex(x, y, this.z+this.height);
    vertex(x, y+len, this.z+this.height);
    vertex(x+wid, y+len, this.z+this.height);
    vertex(x+wid, y, this.z+this.height);
    endShape();

    // make front
    beginShape();
    texture(texture);
    vertex(x, y, this.z, 0, 0);
    vertex(x, y, this.z+this.height, 0, 3);
    vertex(x+wid, y, this.z+this.height, 3, 3);
    vertex(x+wid, y, this.z, 3, 0);
    endShape();

    // make back
    beginShape();
    texture(texture);
    vertex(x+wid, y+len, this.z, 0, 0);
    vertex(x+wid, y+len, this.z+this.height, 0, 3);
    vertex(x, y+len, this.z+this.height, 3, 3);
    vertex(x, y+len, this.z, 3, 0);
    endShape();

    // make right
    beginShape();
    texture(texture);
    vertex(x, y, this.z, 0, 0);
    vertex(x, y, this.z+this.height, 0, 3);
    vertex(x, y+len, this.z+this.height, 3, 3);
    vertex(x, y+len, this.z, 3, 0);
    endShape();

    // make left
    beginShape();
    texture(texture);
    vertex(x+wid, y, this.z, 0, 0);
    vertex(x+wid, y, this.z+this.height, 0, 3);
    vertex(x+wid, y+len, this.z+this.height, 3, 3);
    vertex(x+wid, y+len, this.z, 3, 0);
    endShape();
  }
  boolean containsPoint(int x1, int y1) {
    return (x1 >= x && x1 <= x+wid && y1 >= y && y1 <= y+len);
  }

  float getArea() {
    return wid*len;
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
    return this.height;
  }
  void setHeight(float h) {
    this.height = h;
  }
}