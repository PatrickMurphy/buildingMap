import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam camera;
PVector lookAtPoint;

int cols, rows;
int overall_scale = 50;
int cellScale = 1*overall_scale;
int w = 30*overall_scale;
int h = 30*overall_scale;

// Settings
int maxBuildings = 100;
int maxTrees = 75;
int mapHeightScale = 25*cellScale;
boolean displayCity = false; // colors terrain with grey where the population map says we should have a city
Boolean showVisAid = true; // default state, toggled with "q"
// End settings

int mapPopFilter = 15;

// state variable for what we are showing
int displayMode = 0; // 0 = normal, 1 = heightMap2d, 2 = pop map 2d

// Values for loading screen
boolean loading = true;
float loadPCT = 0.0;
String loadStep = "Initialize";

Forest forest;
CompiledMap cMap;

void setup() {
  camera = new PeasyCam(this, w/2, h/2, 200, 4000);
  size(800, 800, P3D);
  noStroke();

  cols = w/cellScale;
  rows = h/cellScale;

  lookAtPoint = new PVector(cols/2, rows/2); // look at center

  println(cols, rows, cols*rows); // print the grid width and length, and the total number of cells

  // texture mode for buildings
  textureMode(NORMAL);
  textureWrap(REPEAT);

  // start other thread for generating map so loading screen is displayed
  thread("startLoading");
}

// thread for initializing the map
void startLoading() {
  cMap = new CompiledMap(overall_scale, cols, rows); // random terrain and buildings 
  forest = new Forest(maxTrees); // create up to 50 random trees
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
  lookAtPoint.x = min(max(0, CameraFocusX), cols-1);
  lookAtPoint.y = min(max(0, CameraFocusY), rows-2);
  camera.lookAt(cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.x, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.y, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.z);
}

// extension function for my own vector class // not used yet
void vertex(Vector3 v) {
  vertex(v.x, v.y, v.z);
}