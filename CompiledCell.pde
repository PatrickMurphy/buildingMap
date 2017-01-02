class CompiledCell {
  float cellPopulation;
  color cellColor;
  Vector3 v1, v2;
  boolean cityTile = false;
  boolean forestTile = false;
  int x, y;
  
  int id; // 0:water, 1:beach, 2:lowlands, 3:hills, 4:foothills,5:mountainstart, 6:mountainmid, 7:mountainpeak

  CompiledCell(Vector3 cv1, Vector3 cv2, int x, int y, float cPop) {
    this.v1 = cv1;
    this.v2 = cv2;
    this.x = x;
    this.y = y;
    this.cellPopulation = cPop;
    this.getTerrain();
  }

  Vector3 getVector1() {
    return this.v1;
  }
  Vector3 getVector2() {
    return this.v2;
  }

  boolean isCity(){
    return cityTile;
  }
  
  void setForest(){
    this.setForest(true);
  }
  
  void setForest(boolean f){
    this.forestTile = f;
  }
  
  boolean isForest(){
    return forestTile;
  }

  float getSlope() {
    return degrees(PVector.angleBetween(this.v1.convert(),this.v2.convert()));
  }

  float getPopulation() {
    return this.cellPopulation;
  }
  color getColor() {
    return this.cellColor;
  }

  void getTerrain() {
    float heightValue = this.v1.z;
    float populationDensity = this.cellPopulation;
    int popFilter = mapPopFilter;
    float heightScale = mapHeightScale;
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