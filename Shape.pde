interface Shape {
  color getFill();
  color getStroke();
  void setFill(color c);
  void setStroke(color c);

  void display2D();
  void display();
  boolean containsPoint(int x1, int y1);
  float getArea();
  float getHeight();
  void setHeight(float h);
}