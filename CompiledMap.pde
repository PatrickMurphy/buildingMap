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
    //this.hSeed = 2025;
    //this.pSeed = 11399;
    this.heightScale = mapHeightScale;
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
      for (int x = 0; x<cols; x++) {
        loadPCT = float(y*(rows-1)+x)/(float)((rows-1)*cols);
        float cellHeight = hMap.getValue(x, y);
        float nextCellHeight = hMap.getValue(x, y+1);

        // if this cell or it's neighbor is water, make the height at water level
        if (cellHeight<=.32*heightScale) {
          cellHeight = .32*heightScale;
        }
        if (nextCellHeight <= .32*heightScale) {
          nextCellHeight = .32*heightScale;
        }

        float cellPopulation = pMap.getValue(x, y);

        // compute vectors for the corners of each cell according to scale
        Vector3 v1 = new Vector3(x*cellScale, y*cellScale, cellHeight);
        Vector3 v2 = new Vector3(x*cellScale, (y+1)*cellScale, nextCellHeight);
        // Create Cell, realPosition Vectors and X,Y on the grid, population
        CompiledCell newCell = new CompiledCell(v1, v2, x, y, cellPopulation);

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
    int buildAttempts = maxBuildings * 3;
    CompiledCell  testCell;
    while (buildAttempts > 0 && buildingsPlaced < maxBuildings) {
      buildAttempts--;
      testCell = this.getCell((int)random(0, cols), (int)random(0, rows-1));

      // max 400 buildings, don't place on steep hills, population density over 30
      if (testCell.isCity() && testCell.getPopulation() > 30 && testCell.getSlope() < 45 && testCell.x < cols-1) { 
        buildingsPlaced++;
        loadPCT = buildingsPlaced/(float)maxBuildings;
        buildings.add(new RandomBuilding(testCell.v1, cellScale, testCell.getPopulation()));
      }
    }
    println("buildings "+ buildingsPlaced);
  }
  
  void drawMap() {
    for (int y = 0; y<rows-1; y++) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x<cols; x++) {
        fill(compiledCells[x][y].getColor());
        vertex(compiledCells[x][y].getVector1().getX(), compiledCells[x][y].getVector1().getY(), compiledCells[x][y].getVector1().getZ());
        vertex(compiledCells[x][y].getVector2().getX(), compiledCells[x][y].getVector2().getY(), compiledCells[x][y].getVector2().getZ());
      }
      endShape();
    }

    for (RandomBuilding b : buildings) {
      b.display();
    }
  }
}