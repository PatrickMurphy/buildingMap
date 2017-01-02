import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam camera;
PVector lookAtPoint;

final int OVERALL_SCALE = 50;
final int CELL_SCALE = 1*OVERALL_SCALE;
final int GRID_WIDTH = 30*OVERALL_SCALE;
final int GRID_HEIGHT = 30*OVERALL_SCALE;

// Numbers of Columns and Rows for cell grid, (over all width / width of one cell)
final int GRID_COLUMNS = GRID_WIDTH/CELL_SCALE;
final int GRID_ROWS = GRID_HEIGHT/CELL_SCALE;

// Settings
final int MAX_BUILDINGS = 900;
final int MAX_TREES = 175;
final int MAP_HEIGHT_SCALE = 20*CELL_SCALE;

boolean displayCity = false; // colors terrain with grey where the population map says we should have a city
Boolean showVisAid = true; // default state, toggled with "q"
int mapPopFilter = 15; // this will effect how much of the map is categorized as "city"
// End settings

// state variable for what we are showing
int displayMode = 0; // 0 = normal, 1 = heightMap2d, 2 = pop map 2d

// Values for loading screen
boolean loading = true;
float loadPCT = 0.00;
String loadStep = "Initialize";

// collection of trees to display
Forest forest;

// Collection of CompiledCells that store cell position, cell height, terrain type and more
CompiledMap cMap;

// array of pre loaded textures
PImage[] building_textures; 

void setup() {
  camera = new PeasyCam(this, GRID_WIDTH/2, GRID_HEIGHT/2, 200, 4000);
  size(800, 800, P3D);
  noStroke();

  // Default camera look position, center of grid
  lookAtPoint = new PVector(GRID_COLUMNS/2, GRID_ROWS/2);

  println(GRID_COLUMNS, GRID_ROWS, GRID_COLUMNS*GRID_ROWS); // print the grid width and length, and the total number of cells

  // texture mode for buildings
  textureMode(NORMAL);
  textureWrap(REPEAT);
  preLoadTextures();

  // start other thread for generating map so loading screen is displayed
  thread("startLoading"); // string of function name below
}

// thread for initializing the map
void startLoading() {
  cMap = new CompiledMap(OVERALL_SCALE, GRID_COLUMNS, GRID_ROWS); // random terrain and buildings 
  forest = new Forest(MAX_TREES); // create up to maxTrees # of random trees
}

void preLoadTextures() {
  building_textures = new PImage[11];
  for (int i = 0; i<11; i++) {
    building_textures[i] = loadImage("building_office"+(i+3)+".png");
  }
}

// Main Draw loop, called every frame
void draw() {
  background(15);
  if (loading) {
    drawLoading();
  } else {
    if (displayMode==0) {
      // draw the terrain, and the buildings
      cMap.drawMap();

      // draw the trees
      forest.display();

      if (showVisAid) {
        // draw a ray up and down at camera look point
        stroke(255, 0, 0); // red
        line(cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.x, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.y, 0, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.x, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.y, 1000);
        noStroke();
      }
    } else {
      camera.beginHUD(); // function to draw 2D
      if (displayMode == 1) {
        // display height map 2D noise values
        cMap.hMap.display2D();
      } else {
        // display population map 2D noise values
        cMap.pMap.display2D();
      }
      camera.endHUD();
    }
  }
}

void drawLoading() {
  // display loading screen
  camera.beginHUD();
  fill(255, 0, 0);
  text("LOADING... ", width/2, height/2);
  text("Step: " + loadStep  +" "+ (loadPCT*100) + "%", width/2, (height/2)+26);
  camera.endHUD();
}

// Keyboard Input 
void keyPressed() {
  int CameraFocusX = (int)lookAtPoint.x;
  int CameraFocusY = (int)lookAtPoint.y;
  if (key == 'w' || keyCode == UP) {
    // up
    CameraFocusY++;
  } 
  if (key == 'a' || keyCode == LEFT) {
    //left
    CameraFocusX--;
  }
  if (key == 'd' || keyCode == RIGHT) {
    //right
    CameraFocusX++;
  }
  if (key == 's' || keyCode == DOWN) {
    //back
    CameraFocusY--;
  }

  if (key == 'e') {
    // toggle display mode
    displayMode = (displayMode+1)%3;
  }

  if (key == 'q') {
    // toggle vis aid
    // in draw we show a red line on the z axis
    showVisAid = !showVisAid;
  }

  // Set camera look position
  lookAtPoint.x = min(max(0, CameraFocusX), GRID_COLUMNS-1);
  lookAtPoint.y = min(max(0, CameraFocusY), GRID_ROWS-2);
  camera.lookAt(cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.x, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.y, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.z);
}

// extension function for my own vector class // not used yet
void vertex(Vector3 v) {
  vertex(v.x, v.y, v.z);
}