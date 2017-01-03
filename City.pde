// A collection of trees for displaying easier
import java.util.*;
class City {
  ArrayList <RandomBuilding> buildings;
  int buildingsPlaced = 0;
  int buildAttempts = MAX_BUILDINGS * 3;
  TreeSet<CompiledCell> originSet;

  City() {
    buildings = new ArrayList<RandomBuilding>();
    loadStep = "Generate Buildings";
    loadPCT = 0;
    originSet = new TreeSet<CompiledCell>();
    cellularAutomata();
    generateRandomBuildings();
  }

  void cellularAutomata() {
    for (int y = 0; y<GRID_ROWS-1; y++) {
      for (int x = 0; x<GRID_COLUMNS-1; x++) {
        CompiledCell testCell = cMap.getCell(x, y);
        boolean tooClose = false;
        for (CompiledCell c : originSet) {
          if (testCell.distanceTo(c)<11) {
            tooClose = true;
          }
        }
        if (!tooClose) {
          addOrigin(testCell);
        }
      }
    }
    CompiledCell lastCell = null;
    for (CompiledCell c : originSet) {
      println(c);
      c.setColor(color(255, 0, 0));
      if (lastCell != null) {
        addRoad(lastCell, c);
      }
      lastCell = c;
    }
    addRoad(lastCell, originSet.first());
  }

  public void addOrigin (CompiledCell c) {
    if (originSet.size() < 3) {
      originSet.add(c);
    } else {
      CompiledCell first = originSet.first();
      if (first.getPopulation() < c.getPopulation()) {
        originSet.pollFirst();
        originSet.add(c);
      }
    }
  }

  void generateRandomBuildings() {
    CompiledCell  testCell;
    while (buildAttempts > 0 && buildingsPlaced < MAX_BUILDINGS) {
      buildAttempts--;
      testCell = cMap.getCell((int)random(0, GRID_COLUMNS-1), (int)random(0, GRID_ROWS-1));

      // max 400 buildings, don't place on steep hills, population density over 30
      if (testCell.isCity() && !testCell.isRoad() && !testCell.hasBuilding() && testCell.getPopulation() > 30 && testCell.getSlope() < 45 && testCell.x < GRID_COLUMNS-1) { 
        buildingsPlaced++;
        loadPCT = buildingsPlaced/(float)MAX_BUILDINGS;
        testCell.setHasBuilding();
        buildings.add(new RandomBuilding((int)testCell.v1.x, (int)testCell.v1.y, (int)testCell.getMaxHeight(), CELL_SCALE, testCell.getPopulation()));
      }
    }
    println("buildings "+ buildingsPlaced);
  }

  void addRoad(CompiledCell c1, CompiledCell c2) {
    boolean testCorners = false;
    int direction = c1.x>c2.x ? -1 : 1;
    CompiledCell north = cMap.getCell(c1.x, c1.y-1);
    CompiledCell south = cMap.getCell(c1.x, c1.y+1);
    CompiledCell east = cMap.getCell(c1.x+1, c1.y);
    CompiledCell west = cMap.getCell(c1.x-1, c1.y);
    CompiledCell northeast = cMap.getCell(c1.x+1, c1.y-1);
    CompiledCell northwest = cMap.getCell(c1.x-1, c1.y-1);
    CompiledCell southeast = cMap.getCell(c1.x+1, c1.y+1);
    CompiledCell southwest = cMap.getCell(c1.x-1, c1.y+1);
    float nDist, sDist, eDist, wDist, neDist, nwDist, seDist, swDist;
    if (north == null) {
      nDist = 1000000;
    } else {
      nDist = north.distanceTo(c2);
    }
    if (south == null) {
      sDist = 1000000;
    } else {
      sDist = south.distanceTo(c2);
    }
    if (east == null) {
      eDist = 1000000;
    } else {
      eDist = east.distanceTo(c2);
    }
    if (west == null) {
      wDist = 1000000;
    } else {
      wDist = west.distanceTo(c2);
    }

    if (northeast == null || !testCorners) {
      neDist = 1000000;
    } else {
      neDist = northeast.distanceTo(c2);
    }
    if (southeast == null || !testCorners) {
      seDist = 1000000;
    } else {
      seDist = southeast.distanceTo(c2);
    }
    if (northwest == null || !testCorners) {
      nwDist = 1000000;
    } else {
      nwDist = northwest.distanceTo(c2);
    }
    if (southwest == null || !testCorners) {
      swDist = 1000000;
    } else {
      swDist = southwest.distanceTo(c2);
    }


    float minDist = min(new float[]{nDist, sDist, eDist, wDist, neDist, nwDist, seDist, swDist});

    CompiledCell newRoad = null;

    if (nDist == minDist) {
      newRoad = north;
    } else if (sDist == minDist) {
      newRoad = south;
    } else if (eDist == minDist) {
      newRoad = east;
    } else if (wDist == minDist) {
      newRoad = west;
    }
    if (neDist == minDist) {
      newRoad = northeast;
    } else if (nwDist == minDist) {
      newRoad = northwest;
    } else if (seDist == minDist) {
      newRoad = southeast;
    } else if (swDist == minDist) {
      newRoad = southwest;
    }
    if (newRoad != null && !(c1.x == c2.x && c1.y == c2.y) && !newRoad.isRoad()) {
      newRoad.setRoad();
      cMap.compiledCells[newRoad.x][newRoad.y] = newRoad;
      addRoad(newRoad, c2);
    }

    //for (int x = c1.x; x <= c2.x; x = x+direction) {
    // if (cMap.getCell(x, c1.y).getColor() != color(255, 0, 0)) {
    //    cMap.getCell(x, c1.y).setColor(color(255, 80, 150));
    //  }
    //}
  }

  void display2D() {
    for (RandomBuilding b : buildings) {
      b.display2D();
    }
  }

  void display() {
    for (RandomBuilding b : buildings) {
      b.display();
    }
  }
}