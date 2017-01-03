class CompiledCell {
  float cellPopulation;
  color cellColor;
  Vector3 v1, v2, v3, v4;
  boolean cityTile = false;
  boolean hasBuilding = false;
  boolean forestTile = false;
  int x, y;

  int id; // 0:water, 1:beach, 2:lowlands, 3:hills, 4:foothills,5:mountainstart, 6:mountainmid, 7:mountainpeak

  CompiledCell(Vector3 cv1, Vector3 cv2, Vector3 cv3, Vector3 cv4, int x, int y, float cPop) {
    this.v1 = cv1;
    this.v2 = cv2;
    this.v3 = cv3;
    this.v4 = cv4;
    this.x = x;
    this.y = y;
    this.cellPopulation = cPop;
    this.getTerrain();
  }

  void drawCell() {
    fill(getColor());
    vertex(getVector1().getX(), getVector1().getY(), getVector1().getZ());
    vertex(getVector2().getX(), getVector2().getY(), getVector2().getZ());
    vertex(getVector3().getX(), getVector3().getY(), getVector3().getZ());
    vertex(getVector4().getX(), getVector4().getY(), getVector4().getZ());
  }

  Vector3 getVector1() {
    return this.v1;
  }
  Vector3 getVector2() {
    return this.v2;
  }
  Vector3 getVector3() {
    return this.v3;
  }
  Vector3 getVector4() {
    return this.v4;
  }

  boolean isCity() {
    return cityTile;
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
  void setForest() {
    this.setForest(true);
  }

  void setForest(boolean f) {
    this.forestTile = f;
  }

  boolean isForest() {
    return forestTile;
  }

  float getHeightAt(int x, int y) {
    //http://keisan.casio.com/exec/system/1223596129
    PVector A = v1.convert();
    
    // if in the bottom triangle use other plane
    if(y-((CELL_SCALE-1)-x) > 0){
      A = v4.convert();
    }
    PVector B = v3.convert();
    PVector C = v2.convert();

    PVector AB = B.copy().sub(A);
    PVector AC = C.copy().sub(A);

    PVector ABAC = AB.copy().cross(AC);

    float d = -((ABAC.x*A.x) + (ABAC.y*A.y) + (ABAC.z * A.z));



    float zHeight = ((ABAC.x*(v1.x+float(x)))+(ABAC.y*(v1.y+float(y)))-v1.z+d)/-ABAC.z;
    //println(ABAC,d,zHeight);
    return zHeight;
  }

  float getSlope() {
    return degrees(PVector.angleBetween(this.v1.convert(), this.v2.convert()));
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

  void getTerrain() {
    float heightValue = this.v1.z;
    float populationDensity = this.cellPopulation;
    int popFilter = mapPopFilter;
    float heightScale = MAP_HEIGHT_SCALE;
    color tempcolor = color(0, 0, 0);

    if (heightValue <= .32*heightScale) { // water
      tempcolor = color(30, 144, 255);
      this.id = 0;
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
      tempcolor = color(50, 200, 15);
      if (populationDensity >= (popFilter+12)) {
        this.cityTile = true;
        if (displayCity)
          tempcolor = color(100, 100, 100);
      }
    } else if (heightValue > .50*heightScale && heightValue <= .60*heightScale) {
      // hills
      this.id = 3;
      tempcolor = color(28, 165, 94);
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
      tempcolor = color(124, 83, 7);
    } else {
      //peaks
      //other
      this.id = 7;
      tempcolor = color(map(heightValue, 0, heightScale, 0, 255));
    }

    this.cellColor = tempcolor;
  }
}