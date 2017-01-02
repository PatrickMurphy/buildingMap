public class Vector3 {

    float x, y, z; // package-private variables; nice encapsulation if you place this in a maths package of something

    Vector3(PVector v){
      convert(v);
    }

    Vector3(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    float getX(){
      return x;
    }
    float getY(){
      return y;
    }
    float getZ(){
      return z;
    }
    
    float[] getVectorArray(){
      return new float[]{this.x,this.y,this.z};
    }
    
    PVector convert(){
      return new PVector(this.x,this.y,this.z);
    }
    
    void convert(PVector v){
      this.x = v.x;
      this.y = v.y;
      this.z = v.z;
    }

    public Vector3 add(Vector3 vector) {
        x += vector.x;
        y += vector.y;
        z += vector.z;
        return this; // method chaining would be very useful
    }
   
}