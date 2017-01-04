class TextureGenerator {
  color baseColor;
  int wid, len;

  TextureGenerator(int wid, int len, color c) {
    this.baseColor = c;
    this.wid = wid;
    this.len = len;
  }
  
  PImage getTexture(){
    return this.getTexture(false);
  }

  PImage getTexture(boolean city) {
    PImage texture = createImage(wid, len, RGB);
    for (int x = 0; x<wid; x++) {
      for (int y = 0; y<len; y++) {
        texture.set(x, y, baseColor);
      }
    }
    
    if(city){
      addRoad(texture);
    }

    return texture;
  }

  void addRoad(PImage texture) {
    int roadWidth = 6;
    int startX = 0;

    //left
    for (int x = startX; x<=startX+roadWidth; x++) {
      for (int y = 0; y<=len; y++) {
        if (x == startX && y%roadWidth>0 && y%roadWidth<5) {
          texture.set(x, y, color(255, 207, 13));
        } else if (x <= roadWidth && x >= roadWidth-(roadWidth*.2)) {
          texture.set(x, y, color(175));
        } else {
          texture.set(x, y, color(0));
        }
      }
    }
    startX = this.wid-(roadWidth);
    for (int x = startX; x<=startX+(roadWidth); x++) {
      for (int y = 0; y<=len; y++) {
        if (x <= startX+(roadWidth*.2) && x >= roadWidth) {
          texture.set(x, y, color(175));
        } else {
          texture.set(x, y, color(0));
        }
      }
    }
    // top
    int startY = 0;
    for (int x = 0; x<=wid; x++) {
      for (int y = startY; y<=startY+roadWidth; y++) {
        if  (y == startY && x%roadWidth>0 && x%roadWidth<5) {
          texture.set(x, y, color(255, 207, 13));
        } else if (y >= (startY+roadWidth)-(roadWidth*.2) && y <= startY+(roadWidth)) {
          if (texture.get(x, y) != color(0))
            texture.set(x, y, color(175));
        } else {
          texture.set(x, y, color(0));
        }
      }
    }
    // bottom
    startY = this.len-roadWidth;
    for (int x = 0; x<=wid; x++) {
      for (int y = startY; y<=startY+roadWidth; y++) {
        if (y <= startY+(roadWidth*.2) && y >= roadWidth) {
          if (texture.get(x, y) != color(0) && texture.get(x,y) != color(255, 207, 13))
            texture.set(x, y, color(175));
        } else {
          texture.set(x, y, color(0));
        }
      }
    }
  }
}