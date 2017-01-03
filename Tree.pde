class Tree {
  Vector3 pos;
  float age;
  float treeAngle;
  int treeHeight = 75;
  Vector3 topPoint;

  Tree(int x, int y, int z) {
    this(x, y, z, random(.25, 1));
  }

  Tree(int x, int y, float z, float age) {
    this(new Vector3(x, y, z), age);
  }
  Tree(Vector3 v) {
    this(v, random(.25, 1));
  }
  Tree(Vector3 v, float age) {
    this.age = age;
    this.pos = v;
    this.treeAngle = PI/((int) random(1, 6));
    this.topPoint = new Vector3(this.pos.x, this.pos.y, this.pos.z+(treeHeight*this.age));
  }
  
  void update(){
    // wind
    float angle = (millis()/3+(this.pos.x))%360;
    float strength = map((second()+this.pos.y)%100,0,100,-1,1);
    this.topPoint.x = this.pos.x + ((2*this.age * cos(radians(angle)))*strength);
    this.topPoint.y = this.pos.y + ((2*this.age * sin(radians(angle)))*strength);
  }
  
  void display() {
    fill(112, 74, 12);
    // add cylindar
    // draw body
    int sides = 6;
    float angle = 360 / sides;
    float r = 4*this.age;
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( this.pos.x+x, this.pos.y+y, this.pos.z+(treeHeight*age)/3.75);
      vertex( this.pos.x+x, this.pos.y+y, this.pos.z-(treeHeight*age)/10);
    }
    endShape(CLOSE);
    
    sides = 10;
    angle = 360 / sides;
    
    // add leaves/branches
    fill(20,175,10); //green
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < sides + 1; i++) {
      float x = cos( radians( i * angle ) ) * r*4.3;
      float y = sin( radians( i * angle ) ) * r*4.3;
      vertex( this.topPoint.x, this.topPoint.y,this.topPoint.z);
      vertex( this.pos.x+x, this.pos.y+y, this.pos.z+(treeHeight*age)/4);
    }
    endShape(CLOSE);
  }
}