class Rectangle implements Shape {
  float x, y, z;
  int wid, len;
  color fill, stroke;
  float buildingHeight;
  PImage texture;
  float[] terrainHeights = new float[4];
  Rectangle(float x, float y, float z, int wid, int len, PImage text) {
    this(x, y, z, wid, len, color(55), color(55), text);
  }
  Rectangle(float x, float y, float z, int wid, int len, color fill, color stroke, PImage texture) {
    // generate random shapes
    this.x = x;
    this.y = y;
    this.z = z;
    this.wid = wid;
    this.len = len;
    this.fill = fill;
    this.stroke = stroke;
    this.texture = texture;    
    this.terrainHeights[0] = cMap.getHeightAt(x, y);
    this.terrainHeights[1] = cMap.getHeightAt(x, y+len);
    this.terrainHeights[2] = cMap.getHeightAt(x+wid, y);
    this.terrainHeights[3] = cMap.getHeightAt(x+wid, y+len);
    this.z = max(terrainHeights);
  }
  void display2D() {
    fill(fill);
    //stroke(stroke);
   // println(x, map(x, 0, GRID_WIDTH, 0, width), width*(this.wid/(float)GRID_WIDTH));
    rect(map(x, 0, GRID_WIDTH-CELL_SCALE, 0, width), map(y, 0, GRID_HEIGHT-CELL_SCALE, 0, height), (float)width*(this.wid/((float)GRID_WIDTH-(float)CELL_SCALE)), (float)height*(this.len/((float)GRID_HEIGHT-(float)CELL_SCALE)));
  }
  void display() {    
    // make top
    fill(fill);
    //stroke(stroke);
   // noStroke();
    beginShape();
    vertex(x, y, this.z+this.buildingHeight);
    vertex(x, y+len, this.z+this.buildingHeight);
    vertex(x+wid, y+len, this.z+this.buildingHeight);
    vertex(x+wid, y, this.z+this.buildingHeight);
    endShape();

    // make front
    beginShape();
    texture(texture);
    vertex(x, y, this.z, 0, 0);
    vertex(x, y, this.z+this.buildingHeight, 0, 3);
    vertex(x+wid, y, this.z+this.buildingHeight, 3, 3);
    vertex(x+wid, y, this.z, 3, 0);
    endShape();

    // make back
    beginShape();
    texture(texture);
    vertex(x+wid, y+len, this.z, 0, 0);
    vertex(x+wid, y+len, this.z+this.buildingHeight, 0, 3);
    vertex(x, y+len, this.z+this.buildingHeight, 3, 3);
    vertex(x, y+len, this.z, 3, 0);
    endShape();

    // make right
    beginShape();
    texture(texture);
    vertex(x, y, this.z, 0, 0);
    vertex(x, y, this.z+this.buildingHeight, 0, 3);
    vertex(x, y+len, this.z+this.buildingHeight, 3, 3);
    vertex(x, y+len, this.z, 3, 0);
    endShape();

    // make left
    beginShape();
    texture(texture);
    vertex(x+wid, y, this.z, 0, 0);
    vertex(x+wid, y, this.z+this.buildingHeight, 0, 3);
    vertex(x+wid, y+len, this.z+this.buildingHeight, 3, 3);
    vertex(x+wid, y+len, this.z, 3, 0);
    endShape();

    drawBase();
  }

  void drawBase() {
    fill(100);
    // make front
    beginShape();
    vertex(x, y, this.z);
    vertex(x, y, terrainHeights[0]);
    vertex(x+wid, y, terrainHeights[2]);
    vertex(x+wid, y, this.z);
    endShape();

    // make back
    beginShape();
    vertex(x+wid, y+len, this.z);
    vertex(x+wid, y+len, terrainHeights[3]);
    vertex(x, y+len, terrainHeights[1]);
    vertex(x, y+len, this.z);
    endShape();

    // make right
    beginShape();
    vertex(x, y, this.z);
    vertex(x, y, terrainHeights[0]);
    vertex(x, y+len, terrainHeights[1]);
    vertex(x, y+len, this.z);
    endShape();

    // make left
    beginShape();
    vertex(x+wid, y, this.z);
    vertex(x+wid, y, terrainHeights[2]);
    vertex(x+wid, y+len, terrainHeights[3]);
    vertex(x+wid, y+len, this.z);
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
    return this.buildingHeight;
  }
  void setHeight(float h) {
    this.buildingHeight = h;
  }
}