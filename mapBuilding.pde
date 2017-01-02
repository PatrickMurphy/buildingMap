import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
boolean loading = true;
PeasyCam camera;
int cols, rows;
int overall_scale = 50;
int cellScale = 1*overall_scale;
int w = 30*overall_scale;
int h = 30*overall_scale;

// Settings
int maxBuildings = 150;
int maxTrees = 75;
int mapHeightScale = 25*cellScale;
// End settings

int mapPopFilter = 15;
PVector lookAtPoint;
Boolean showVisAid = true;

// settings
boolean displayCity = false;

int displayMode = 0; // 0 = normal, 1 = heightMap2d, 2 = pop map 2d

float loadPCT = 0.0;
String loadStep = "Initialize";

Forest forest;
CompiledMap cMap;

void setup() {
  camera = new PeasyCam(this, w/2, h/2, 200, 4000);
  size(800, 800, P3D);
  //noSmooth();
  lights();

  cols = w/cellScale;
  rows = h/cellScale;
  //getTerrainAreaStats();
  noStroke();

  lookAtPoint = new PVector(cols/2, rows/2);

  println(cols, rows, cols*rows);

  textureMode(NORMAL);
  textureWrap(REPEAT);
  
  thread("startLoading");
}

void startLoading() {
  cMap = new CompiledMap(overall_scale, cols, rows); // random terrain and buildings 
  forest = new Forest(maxTrees); // create up to 50 random trees
}

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

  // Set 
  lookAtPoint.x = min(max(0, CameraFocusX), cols-1);
  lookAtPoint.y = min(max(0, CameraFocusY), rows-2);
  camera.lookAt(cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.x, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.y, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.z);
}

void draw() {
  background(15);
  if (loading) {
    camera.beginHUD();
    fill(255, 0, 0);
    text("LOADING... ", width/2, height/2);
    text("Step: " + loadStep  +" "+ (loadPCT*100) + "%", width/2, (height/2)+26);
    camera.endHUD();
  } else {
    if (displayMode==0) {
      cMap.drawMap();
      forest.display();

      if (showVisAid) {
        // draw a ray up and down
        stroke(255, 0, 0); // red
        line(cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.x, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.y, 0, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.x, cMap.getCell((int)lookAtPoint.x, (int)lookAtPoint.y).v1.y, 1000);
        noStroke();
      }
    } else {
      camera.beginHUD();
      if (displayMode == 1) {
        cMap.hMap.display2D();
      } else {
        cMap.pMap.display2D();
      }
      camera.endHUD();
    }
  }
}

void vertex(Vector3 v) {
  vertex(v.x, v.y, v.z);
}