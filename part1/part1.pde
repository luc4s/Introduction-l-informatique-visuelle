import java.lang.Math;

void setup() {
  size(400, 400, P2D);
}
void draw() {
  My3DPoint eye = new My3DPoint(-100, -100, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0); //The first vertex of your cuboid
  My3DBox input3DBox = new My3DBox(origin, 100,150,300);
  projectBox(eye, input3DBox).render();
}


class My2DPoint{
  float x;
  float y;
  My2DPoint(float x, float y){
    this.x = x;
    this.y = y;
  }
}

class My3DPoint{
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z){
    this.x=x;
    this.y=y;
    this.z=z;
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p){
 double factor = - eye.z / (p.z  - eye.z);
 return new My2DPoint((float)((p.x - eye.x) /factor),(float)((p.y- eye.y)/factor));
}


class My2DBox{
My2DPoint[] s;
My2DBox(My2DPoint[] s){
this.s = s;
}
void render(){
 line(s[0].x, s[0].y, s[1].x, s[1].y);
 line(s[0].x, s[0].y, s[3].x, s[3].y);
 line(s[0].x, s[0].y, s[4].x, s[4].y);
 line(s[1].x, s[1].y, s[2].x, s[2].y);
 line(s[1].x, s[1].y, s[5].x, s[5].y);
 line(s[2].x, s[2].y, s[3].x, s[3].y);
 line(s[2].x, s[2].y, s[6].x, s[6].y);
 line(s[3].x, s[3].y, s[7].x, s[7].y);
 line(s[4].x, s[4].y, s[5].x, s[5].y);
 line(s[4].x, s[4].y, s[7].x, s[7].y);
 line(s[5].x, s[5].y, s[6].x, s[6].y);
 line(s[6].x, s[6].y, s[7].x, s[7].y);
}
}

class My3DBox {
My3DPoint[] p;
My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ){
  float x = origin.x;
  float y = origin.y;
  float z = origin.z;
  this.p = new My3DPoint[]{new My3DPoint(x,y+dimY,z+dimZ),
  new My3DPoint(x,y,z+dimZ),
  new My3DPoint(x+dimX,y,z+dimZ),
  new My3DPoint(x+dimX,y+dimY,z+dimZ),
  new My3DPoint(x,y+dimY,z),
  origin,
  new My3DPoint(x+dimX,y,z),
  new My3DPoint(x+dimX,y+dimY,z)
  };
}
My3DBox(My3DPoint[] p) {
this.p = p;
}
}

My2DBox projectBox( My3DPoint eye, My3DBox box){
 My2DPoint[] box2d = new My2DPoint[8];
 for(int i=0; i<8;i++){
   box2d[i] = projectPoint(eye, box.p[i]);
 }
 return new My2DBox(box2d);
 }
 

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z , 1};
  return result;
}

float[] matrixProduct(float[][] a, float[] b) {
 float m1 = a[0][0] * b[0] + a[1][0] * b[1] + a[2][0] * b[2] + a[3][0] * b[3]; // faisable avec boucle for, mais plus rapide comme ça car grandeur fixe.  
 float m2 = a[0][1] * b[0] + a[1][1] * b[1] + a[2][1] * b[2] + a[3][1] * b[3];
 float m3 = a[0][2] * b[0] + a[1][2] * b[1] + a[2][2] * b[2] + a[3][2] * b[3];
 float m4 = a[0][3] * b[0] + a[1][3] * b[1] + a[2][3] * b[2] + a[3][3]* b[3];
 return new float[]{m1,m2,m3,m4};
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] listOfPoints = box.p;
  My3DPoint[] newBoxPoints = new My3DPoint[listOfPoints.length];
  for(int i=0; i<listOfPoints.length ; i++){
  newBoxPoints[i] = euclidian3DPoint( matrixProduct(transformMatrix, new float[]{box.p[i].x, box.p[i].y, box.p[i].z})); 
}
  return new My3DBox(newBoxPoints);
}


My3DPoint euclidian3DPoint (float[] a) {
My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
return result;
}

 float[][] rotateXMatrix(float angle){
     return (new float[][] {
     {1, 0, 0, 0},
     {0, cos(angle), sin(angle), 0},
     {0, -sin(angle), cos(angle), 0},
     {0, 0, 0, 1}});
 }
 
 float[][] rotateYMatrix(float angle){
     return (new float[][] {
    {cos(angle), 0, sin(angle), 0},
    {0, 1, 0, 0},
    {-sin(angle), 0, cos(angle), 0},
    {0, 0, 0, 1}}
   );
 }

float[][] rotateZMatrix(float angle){
  return (new float[][] {
    {cos(angle), -sin(angle), 0, 0},
    {sin(angle), cos(angle), 0, 0},
    {0, 0, 1, 0},
    {0, 0, 0, 1}}
);
    
float[][] scaleMatrix(float x, float y, float z){
  return (new float[][] {
     {x,0,0, 0},
     {0, y, 0, 0},
     {0, 0, z, 0},
     {0, 0, 0, 1}}
   );
}

float translationMatrix(float x, float y, float z){
  return (new float[][] {
      {1, 0, 0, x},
      {0, 1, 0, y},
      {0, 0, 1, z},
      {0, 0, 0, 1}}
     );

