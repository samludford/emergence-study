////////////////////////////////////////////////////////////////////////
// RipplePlane class
// samludford
// April 2018

// This class extends the Artifact class to create a custom plane
// you can modify or extend it to create other 3D structures

// 1. PROPERTIES
// 2. CONSTRUCTOR
// 3. METHODS
//  * setup
//  * draw
////////////////////////////////////////////////////////////////////////
public class RipplePlane extends Artifact {

  // PROPERTIES
  int wid;
  int hei;
  float scl;
  float speed = 1;
  
  ArrayList<Float> vels;

  // CONSTRUCTOR
  RipplePlane(){
    super();
  }

  // SETUP
  // override setup function to create a plane
  public void setup(){
    vels = new ArrayList<Float>();
    vertices = new ArrayList<Vert>();
    wid = 128;
    hei = 128;
    scl = 10;
    for(int i = 0; i < wid; i++){
      for(int j = 0; j < hei; j++){
        
        //float z = noise(i / 100.0, j / 100.0) * 1000;
        //float s = noise(i / 10.0, j / 10.0) * 100;
        float s = 20.0;
        float z = (sin(i * TWO_PI / wid) + sin(j * 1.5 * TWO_PI / hei) + cos(i * j * TWO_PI / 1000.0)) * s;
        
        pushVert(i*scl - (wid*scl/2.0),
                 j*scl - (hei*scl/2.0),
                 z);
      }
    }
  }

  // DRAW
  // override draw function to draw a plane
  public void draw(PGraphics pg){

    pushTransform(pg);

    // draw vertices on plane with triangles
    for(int i = 0; i < wid -1;i++){
      pg.beginShape(TRIANGLE_STRIP);
      for(int j = 0; j < hei ;j++){

        PVector p = vertices.get( (i * wid) + j ).position;
        PVector p2 = vertices.get( ((i+1) * hei) + j).position;

        pg.vertex(p.x, p.y, p.z);
        pg.vertex(p2.x, p2.y, p2.z);
      }
      pg.endShape();
    }
    popTransform(pg);
  }
  
  // UPDATE
  // override update function to implement heightfield map
  public void update() {
    
    float speedSqr = speed * speed;
    float sclSqr = scl * scl;
    
    for(int n = 0 ; n < vertices.size() ; n++) {
      
      Vert thisVert = vertices.get(n);
      int i = floor( n / (float) wid );
      int j = n % wid;
      
      int iNext = (i==hei-1) ? 0 : i+1;
      int iPrev = (i==0) ? hei-1 : i-1;
      int jNext = (j==wid-1) ? 0 : j+1;
      int jPrev = (j==0) ? wid-1 : j-1;
      
      float u_iNext_j = vertices.get( iNext * hei + j ).u;
      float u_iPrev_j = vertices.get( iPrev * hei + j ).u;
      float u_i_jNext = vertices.get( i * hei + jNext ).u;
      float u_i_jPrev = vertices.get( i * hei + jPrev ).u;
      float u_i_j = thisVert.u;
      
      // calculate force
      float force = speedSqr * ( u_iNext_j + u_iPrev_j + u_i_jNext + u_i_jPrev - 4 * u_i_j ) / sclSqr;
      
      float forceMult = noise( i * 0.01 , j * 0.01);
      //forceMult -= 0.5;
      forceMult *= 20.0;
      force *= forceMult;
      
      // calculate horizontal velocity
      thisVert.v = thisVert.v + force;
      
      // store new value in temp array
      thisVert.tempU = thisVert.u + thisVert.v;
    }
    
    for(int n = 0 ; n < vertices.size() ; n++) {
      vertices.get(n).update();
    }
    
  }
} // END class RipplePlane








//