class NoiseMap {
  float[][] NoiseField;
  int cols, rows, octaves, seed, heightScale;
  float scale, persistance, lacunarity;

  NoiseMap(int c, int r) {
    this(c, r, 0.02);
  }
  NoiseMap(int c, int r, float s) {
    this(c, r, 1, s, int(random(500, 5000)));
  }

  NoiseMap(int c, int r, int hs, float s) {
    this(c, r, hs, s, int(random(500, 5000)));
  }

  NoiseMap(int c, int r, int hs, float s, int _seed) {
    this(c, r, hs, s, _seed, 1, .5, 2);
  }

  NoiseMap(int c, int r, int hs, float s, int _seed, int oct, float pers, float lacu) {
    cols = c;
    rows = r;
    scale = s;
    octaves = oct;
    persistance = pers;
    lacunarity = lacu;
    seed = _seed;
    heightScale = hs;

    NoiseField = new float[cols][rows];
    generateMap();
  }

  void generateMap() {
    float yoff = seed;
    for (int y = 0; y<rows; y++) {
      float xoff = seed;
      for (int x = 0; x<cols; x++) {
        //float amplitude = 1;
        //float frequency = 1;
        //float noiseHeight = 0;
        for (int o = 0; o<=octaves; o++) {
          NoiseField[x][y] = noise(xoff, yoff);
          //xoff = x/scale * frequency;
          //yoff = y/scale * frequency;
          //noiseHeight += terrain[x][y] * amplitude;

          //amplitude *= persistance;
          //frequency *= lacunarity;
        }
        xoff += scale;
      }
      yoff += scale;
    }
  }

  void display2D(color c1, color c2) {
    int xwid = width/cols;
    int ywid = height/rows;
    for (int y = 0; y<rows; y++) {
      for (int x = 0; x<cols; x++) {
        //fill(color(map(this.getValue(x, y), 0, this.heightScale, 0, 255)));
        fill(lerpColor(c1,c2,this.getValue(x, y)/this.heightScale));
        rect(x*xwid, y*ywid, x+xwid, y+ywid);
      }
    }
  }

  void display2D() {
    display2D(0,255);
  }

  float getValue(int x, int y) {
    return NoiseField[x][y]*heightScale;
  }
}