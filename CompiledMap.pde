class CompiledMap {
  int cols, rows;
  int popFilter;
  int hSeed;
  int pSeed;
  int heightScale;

  NoiseMap hMap;
  NoiseMap pMap;

  CompiledCell[][] compiledCells;

  String textName;
  ArrayList<RandomBuilding> buildings;

  CompiledMap(int overall_scale, int cols, int rows) {
    this.cols = cols;
    this.rows = rows;
    this.hSeed = int(random(500, 15000));
    this.pSeed = int(random(500, 15000));
    this.hSeed = 2025;
    this.pSeed = 11399;
    this.heightScale = MAP_HEIGHT_SCALE;
    noiseSeed(50);

    this.hMap = new NoiseMap(cols, rows, this.heightScale, 0.05, this.hSeed); // lower scale = more zoomed in
    this.pMap = new NoiseMap(cols, rows, 100, 0.08, this.pSeed);

    //  popFilter = (int)random(12, 20);// max of 80, lower = more people
    this.popFilter = mapPopFilter;
    compiledCells = new CompiledCell[cols][rows-1];
    buildings = new ArrayList<RandomBuilding>();
    this.setupMap();
    this.addBuildings();
    loading = false;
  }

  CompiledCell getCell(int x, int y) {
    return compiledCells[x][y];
  }

  void setupMap() {
    loadStep = "Generate Terrain";
    // for all the cells compute location in 3D space, use height to assign terrain type, and popu lation density map to determine if it is a city
    for (int y = 0; y<rows-1; y++) {
      for (int x = 0; x<cols-1; x++) {
        loadPCT = float(y*(rows-1)+x)/(float)((rows-1)*cols);
        float cellHeight = hMap.getValue(x, y);
        float nextCellHeight = hMap.getValue(x, y+1);
        float cellHeight2 = hMap.getValue(x+1, y);
        float nextCellHeight2= hMap.getValue(x+1, y+1);

        float cellPopulation = pMap.getValue(x, y);
        
        // If lower than 32 percent, it is water, set it at 32 percent height
        cellHeight = max(cellHeight, .32*heightScale);
        nextCellHeight = max(nextCellHeight, .32*heightScale);
        cellHeight2 = max(cellHeight2, .32*heightScale);
        nextCellHeight2 = max(nextCellHeight2, .32*heightScale);

        // compute vectors for the corners of each cell according to scale
        Vector3 v1 = new Vector3(x*CELL_SCALE, y*CELL_SCALE, cellHeight);
        Vector3 v2 = new Vector3(x*CELL_SCALE, (y+1)*CELL_SCALE, nextCellHeight);
        Vector3 v3 = new Vector3((x+1)*CELL_SCALE, y*CELL_SCALE, cellHeight2);
        Vector3 v4 = new Vector3((x+1)*CELL_SCALE, (y+1)*CELL_SCALE, nextCellHeight2);
        
        // Create Cell, realPosition Vectors and X,Y on the grid, population
        CompiledCell newCell = new CompiledCell(v1, v2, v3, v4, x, y, cellPopulation);

        //println(newCell.getSlope());

        // Save Cell
        compiledCells[x][y] = newCell;
      }
    }
  }

  void addBuildings() {
    loadStep = "Generate Buildings";
    loadPCT = 0;
    int buildingsPlaced = 0;
    int buildAttempts = MAX_BUILDINGS * 3;
    CompiledCell  testCell;
    while (buildAttempts > 0 && buildingsPlaced < MAX_BUILDINGS) {
      buildAttempts--;
      testCell = this.getCell((int)random(0, cols-1), (int)random(0, rows-1));

      // max 400 buildings, don't place on steep hills, population density over 30
      if (testCell.isCity() && !testCell.hasBuilding() && testCell.getPopulation() > 30 && testCell.getSlope() < 45 && testCell.x < cols-1) { 
        buildingsPlaced++;
        loadPCT = buildingsPlaced/(float)MAX_BUILDINGS;
        testCell.setHasBuilding();
        buildings.add(new RandomBuilding(testCell.v1, CELL_SCALE, testCell.getPopulation()));
      }
    }
    println("buildings "+ buildingsPlaced);
  }
  
  float getHeightAt(int x, int y){
    // takes real x and y
    int tempx = floor(x/CELL_SCALE);
    int tempy = floor(y/CELL_SCALE);
    
    return this.getCell(tempx,tempy).getHeightAt(x-(tempx*CELL_SCALE),y-(tempy*CELL_SCALE));
  }

  void drawMap() {
    for (int y = 0; y<rows-1; y++) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x<cols-1; x++) {
        compiledCells[x][y].drawCell();
      }
      endShape();
    }

    for (RandomBuilding b : buildings) {
      b.display();
    }
  }
}