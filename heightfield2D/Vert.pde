//////////////////////////////////
// Vertex class
// A simple data object wrapper for a 3D vector
// liorbengai
// Jan 2018

// 1. PROPERTIES
// 2. CLASS SETUP
// 3. UPDATE
///////////////////////////////

class Vert{

  ////////////////////////
  // CLASS PROPERTIES
  //////////////////////

  PVector initPosition;
  PVector position;
  float tempU;
  float u;
  float v;

  ////////////////////////
  // CLASS SETUP
  //////////////////////

  // Constructor
  Vert(float x, float y, float z){
    // set position according to parameters
    initPosition  = new PVector(x, y, z);
    position = initPosition.copy();
    tempU = position.z;
    u = tempU;
  }

  ////////////////////////
  // UPDATE PROPERTIES
  //////////////////////

  // modulate the position on runtime
  void update(){
    u = tempU;
    position.z = u;
  }


} // class Vert












//