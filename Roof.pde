class Roof extends Rectangle implements Shape {

  Roof(Rectangle r) {
    this(r.x, r.y, r.z, r.wid, r.len, r.getFill(), r.getStroke(), null);
    this.z += r.getHeight();
    this.buildingHeight = r.getHeight()/5;
  }

  Roof(float x, float y, float z, int wid, int len, PImage text) {
    this(x, y, z, wid, len, color(25), color(55), text);
  }
  Roof(float x, float y, float z, int wid, int len, color fill, color stroke, PImage texture) {
    super(x, y, z, wid, len, fill, stroke, texture);
  }

  void display() {
    // make base
    fill(55);
    //stroke(stroke);
    noStroke();
    beginShape();
    vertex(x, y, this.z);
    vertex(x, y+len, this.z);
    vertex(x+wid, y+len, this.z);
    vertex(x+wid, y, this.z);
    endShape();

    // make front
    beginShape();
    vertex(x, y, this.z);
    vertex(x+(wid/2), y, this.z+this.buildingHeight);
    vertex(x+wid, y, this.z);
    endShape();

    // make back
    beginShape();
    vertex(x+wid, y+len, this.z);
    vertex(x+(wid/2), y+len, this.z+this.buildingHeight);
    vertex(x, y+len, this.z);
    endShape();

    // make right
    beginShape();
    vertex(x, y, this.z);
    vertex(x+(wid/2), y, this.z+this.buildingHeight);
    vertex(x+(wid/2), y+len, this.z+this.buildingHeight, 3, 3);
    vertex(x, y+len, this.z, 3, 0);
    endShape();

    // make left
    beginShape();
    vertex(x+wid, y, this.z);
    vertex(x+(wid/2), y, this.z+this.buildingHeight);
    vertex(x+(wid/2), y+len, this.z+this.buildingHeight);
    vertex(x+wid, y+len, this.z);
    endShape();
  }
}