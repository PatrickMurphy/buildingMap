// A collection of trees for displaying easier

class City {
  ArrayList <RandomBuilding> buildings;
  int buildingsPlaced = 0;
  int buildAttempts = MAX_BUILDINGS * 3;
  
  City() {
    buildings = new ArrayList<RandomBuilding>();
    loadStep = "Generate Buildings";
    loadPCT = 0;
    CompiledCell  testCell;
    while (buildAttempts > 0 && buildingsPlaced < MAX_BUILDINGS) {
      buildAttempts--;
      testCell = cMap.getCell((int)random(0, GRID_COLUMNS-1), (int)random(0, GRID_ROWS-1));

      // max 400 buildings, don't place on steep hills, population density over 30
      if (testCell.isCity() && !testCell.hasBuilding() && testCell.getPopulation() > 30 && testCell.getSlope() < 45 && testCell.x < GRID_COLUMNS-1) { 
        buildingsPlaced++;
        loadPCT = buildingsPlaced/(float)MAX_BUILDINGS;
        testCell.setHasBuilding();
        buildings.add(new RandomBuilding((int)testCell.v1.x, (int)testCell.v1.y, (int)testCell.getMaxHeight(), CELL_SCALE, testCell.getPopulation()));
      }
    }
    println("buildings "+ buildingsPlaced);
  }

  City display() {
    for (RandomBuilding b : buildings) {
      b.display();
    }
    return this;
  }
}