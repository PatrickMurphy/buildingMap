class CompiledCell implements Comparable<CompiledCell> {
  float cellPopulation;
  color cellColor;
  PVector v1, v2, v3, v4;
  float maxHeight;
  boolean cityTile = false;
  boolean hasBuilding = false;
  boolean forestTile = false;
  boolean roadTile = false;
  int x, y;
  PImage texture;
  boolean[] cityNeighbors;
  ArrayList<TileObject> tileObjects;

  int id; // 0:water, 1:beach, 2:lowlands, 3:hills, 4:foothills,5:mountainstart, 6:mountainmid, 7:mountainpeak
  String[] types = new String[]{"Water", "Beach", "Low Lands", "Hills", "Foothils", "Mountain Start", "Mountain Mid", "Mountain Peak"};

  CompiledCell(PVector cv1, PVector cv2, PVector cv3, PVector cv4, int x, int y, float cPop) {
    this.v1 = cv1;
    this.v2 = cv2;
    this.v3 = cv3;
    this.v4 = cv4;
    this.maxHeight = max(new float[]{v1.z, v2.z, v3.z, v4.z});
    this.x = x;
    this.y = y;
    this.cellPopulation = cPop;

    this.cityNeighbors = new boolean[4];
    tileObjects = new ArrayList<TileObject>();

    this.getTerrain();
    texture = terrain_textures[this.id].getTexture();
  }

  void drawCell() {
    //fill(getColor());
    vertex(getVector1().x, getVector1().y, getVector1().z, this.x/float(GRID_COLUMNS-1), 0);
    vertex(getVector2().x, getVector2().y, getVector2().z, this.x/float(GRID_COLUMNS-1), 1);
    if (x == GRID_COLUMNS-2) {
      vertex(getVector3().x, getVector3().y, getVector3().z, 1, 0);
      vertex(getVector4().x, getVector4().y, getVector4().z, 1, 1);
    }
  }

  boolean[] getNeighbors() {
    return this.cityNeighbors;
  }

  void findNeighbors() {
    
    CompiledCell north = cMap.getCell(x, y-1);
    CompiledCell south = cMap.getCell(x, y+1);
    CompiledCell east = cMap.getCell(x+1, y);
    CompiledCell west = cMap.getCell(x-1, y);

    boolean[] ret_values = new boolean[]{false, false, false, false};

    if (west != null && west .isCity()) {
      ret_values[0] = true;
    }
    if (north != null && north.isCity()) {
      ret_values[1] = true;
    }
    if (east != null && east.isCity()) {
      ret_values[2] = true;
    }
    if (south != null && south.isCity()) {
      ret_values[3] = true;
    }

    this.cityNeighbors = ret_values;
  }

  void drawCellDetail() {
    drawObjects();
  }

  void drawObjects() {
    // draw trees and buildings
    for (int i = 0; i < this.tileObjects.size(); i++) {
      this.tileObjects.get(i).update();
      this.tileObjects.get(i).display();
    }
  }

  void drawCell2D() {
    int xwid = width/GRID_COLUMNS+1;
    int ywid = height/GRID_ROWS+1;
    fill(this.cellColor);
    rect(x*xwid, y*ywid, x+xwid, y+ywid);
  }

  int compareTo(CompiledCell c) {
    int comp = 0;
    if (this.getPopulation() < c.getPopulation()) {
      comp = -1;
    } else if (this.getPopulation() > c.getPopulation()) {
      comp = 1;
    }
    return comp;
  }

  float distanceTo(CompiledCell c) {
    return sqrt(sq(c.x-this.x)+sq(c.y-this.y));
  }

  String getType() {
    return this.types[this.id];
  }

  PVector getVector1() {
    return this.v1;
  }
  PVector getVector2() {
    return this.v2;
  }
  PVector getVector3() {
    return this.v3;
  }
  PVector getVector4() {
    return this.v4;
  }

  boolean isCity() {
    return cityTile;
  }

  void addBuilding(RandomBuilding b) {
    this.setHasBuilding();
    tileObjects.add((TileObject)b);
  }
  void setHasBuilding() {
    this.setHasBuilding(true);
  }

  void setHasBuilding(boolean b) {
    this.hasBuilding = b;
  }

  boolean hasBuilding() {
    return this.hasBuilding;
  }

  void addTree(Tree t) {
    this.setForest();
    tileObjects.add((TileObject)t);
  }
  void setForest() {
    this.setForest(true);
  }

  void setForest(boolean f) {
    this.forestTile = f;
  }

  void setRoad() {
    setRoad(true);
  }

  void setRoad(boolean r) {
    this.roadTile = true;
    if (this.cellColor != color(255, 0, 0)) {
      this.cellColor = color(0);
    }
  }

  boolean isRoad() {
    return this.roadTile;
  }

  boolean isForest() {
    return forestTile;
  }

  float getMaxHeight() {
    return maxHeight;
  }

  float getHeightAt(int x, int y) {
    //http://keisan.casio.com/exec/system/1223596129
    PVector A = v1.copy();

    // if in the bottom triangle use other plane
    if (y+x-(CELL_SCALE-1) > 0) {
      A = v4.copy();
      print("using bottom    ");
    } else {
      print("using top    ");
    }
    PVector B = v3.copy();
    PVector C = v2.copy();

    PVector AB = B.copy().sub(A);
    PVector AC = C.copy().sub(A);

    PVector ABAC = AB.copy().cross(AC);

    float d = -((ABAC.x*A.x) + (ABAC.y*A.y) + (ABAC.z * A.z));



    float zHeight = ((ABAC.x*(v1.x+float(x)))+(ABAC.y*(v1.y+float(y)))-v1.z+d)/-ABAC.z;
    println(x, y, ABAC, d, zHeight);
    return zHeight;
  }

  float getSlope() {
    return degrees(PVector.angleBetween(this.v1, this.v2));
  }

  float getPopulation() {
    return this.cellPopulation;
  }

  void setColor(color c) {
    this.cellColor = c;
  }

  color getColor() {
    return this.cellColor;
  }

  String toString() {
    return "Cell Type: "+this.getType() + " x: " + this.x + ", y: " + this.y + " Population: " + this.cellPopulation + " City: " + this.cityTile + " Forest: " + this.forestTile;
  }

  void getTerrain() {
    float heightValue = this.v1.z;
    float populationDensity = this.cellPopulation;
    int popFilter = mapPopFilter;
    float heightScale = MAP_HEIGHT_SCALE;
    color tempcolor = color(0, 0, 0);

    if (heightValue <= .32*heightScale) { // water
      tempcolor = color(30, 144, 255);
      this.id = 0;
      this.cellPopulation = 0;
    } else if (heightValue > .32*heightScale && heightValue <= .35*heightScale) {
      // beach
      this.id = 1;
      tempcolor = color(222, 184, 135);
      if (populationDensity >= (popFilter+33)) {
        this.cityTile = true;
        if (displayCity)
          tempcolor = color(160, 160, 160);
      }
    } else if (heightValue > .35*heightScale && heightValue <= .5*heightScale) {
      // low lands
      this.id = 2;
      tempcolor = color(75, 147, 65);
      if (populationDensity >= (popFilter+12)) {
        this.cityTile = true;
        if (displayCity)
          tempcolor = color(100, 100, 100);
      }
    } else if (heightValue > .50*heightScale && heightValue <= .60*heightScale) {
      // hills
      this.id = 3;
      tempcolor = color(85, 165, 94);
      if (populationDensity >=  (popFilter+20)) {
        this.cityTile = true;
        if (displayCity)
          tempcolor = color(140, 140, 140);
      }
    } else if (heightValue>.60*heightScale && heightValue <= .65*heightScale) {
      // foot hills
      this.id = 4;
      tempcolor = color(6, 109, 51);
      if (populationDensity >=  (popFilter+30)) {
        this.cityTile = true;
        if (displayCity)
          tempcolor = color(80, 80, 80);
      }
    } else if (heightValue > .65*heightScale && heightValue <= .70*heightScale) {
      // mountain start
      this.id = 5;
      tempcolor = color(155, 105, 12);
      if (populationDensity >=  (popFilter+42)) {
        this.cityTile = true;
        if (displayCity)
          tempcolor = color(20, 20, 20);
      }
    } else if (heightValue > .70*heightScale && heightValue <= .75*heightScale) {
      // mountain mid
      this.id = 6;
      this.cellPopulation = 0;
      tempcolor = color(124, 83, 7);
    } else {
      //peaks
      //other
      this.id = 7;
      tempcolor = color(map(heightValue, 0, heightScale, 0, 255));
      this.cellPopulation = 0;
    }

    this.cellColor = tempcolor;
  }
}