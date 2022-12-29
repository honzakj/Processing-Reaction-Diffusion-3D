//SIMULATION RESOLUTION
int boundarySize = 100;

int cols = boundarySize;
int rows = boundarySize;
int zAxis = boundarySize;

//HIDDEN OUTTER LAYER
int boundary = 20;


//CHEMICALS ARRAY
float[][][][] array3D = new float[cols][rows][zAxis][2];
float[][][][] newGen3D = new float[cols][rows][zAxis][2];


//INITIAL POUR SETTINGS
int pourX = cols/2;
int pourY = rows/2;
int pourZ = zAxis/2;
int pourOffset = 2;


//SIMULATION VARIABLES
float dA = 1;
float dB = 0.5;
float feed = 0.058;
float kill = 0.063;
float time = 1;

float isoLevel = 0.1;


//LAPLACIAN 3D VALUES
float center = -1;
float adjacent = 0.2/2.8;
float diagonal = 0.1/2.8;
float corner = 0.05/2.8;




void setup() {
  size(1920, 1080, P3D);
  initCam();
  initControl();
  initTable();


  //INITIAL CHEMICAL STATE
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      for (int z = 0; z < zAxis; z++) {
        array3D[x][y][z][0] = 1;
        array3D[x][y][z][1] = 0;
        newGen3D[x][y][z][0] = 1;
        newGen3D[x][y][z][1] = 0;
      }
    }
  }


  //INITIAL CHEMICAL POUR -> NOW ITS A BOX
  for (int x = pourX - pourOffset; x < pourX + pourOffset; x++) {
    for (int y = pourY - pourOffset; y < pourY + pourOffset; y++) {
      for (int z = pourZ - pourOffset; z < pourZ + pourOffset; z++) {
        array3D[x][y][z][1] = 1;
      }
    }
  }
}

void swap() {
  float[][][][] temp = array3D;
  array3D = newGen3D;
  newGen3D = temp;
}


float laplace3D(int x, int y, int z, int chem) {
  float sum = 0;

  sum += array3D[x][y][z-1][chem] * adjacent;
  sum += array3D[x-1][y][z-1][chem] * diagonal;
  sum += array3D[x+1][y][z-1][chem] * diagonal;
  sum += array3D[x][y+1][z-1][chem] * diagonal;
  sum += array3D[x][y-1][z-1][chem] * diagonal;
  sum += array3D[x-1][y-1][z-1][chem] * corner;
  sum += array3D[x+1][y-1][z-1][chem] * corner;
  sum += array3D[x+1][y+1][z-1][chem] * corner;
  sum += array3D[x-1][y+1][z-1][chem] * corner;


  sum += array3D[x][y][z][chem] * center;
  sum += array3D[x-1][y][z][chem] * adjacent;
  sum += array3D[x+1][y][z][chem] * adjacent;
  sum += array3D[x][y+1][z][chem] * adjacent;
  sum += array3D[x][y-1][z][chem] * adjacent;
  sum += array3D[x-1][y-1][z][chem] * diagonal;
  sum += array3D[x+1][y-1][z][chem] * diagonal;
  sum += array3D[x+1][y+1][z][chem] * diagonal;
  sum += array3D[x-1][y+1][z][chem] * diagonal;

  sum += array3D[x][y][z+1][chem] * adjacent;
  sum += array3D[x-1][y][z+1][chem] * diagonal;
  sum += array3D[x+1][y][z+1][chem] * diagonal;
  sum += array3D[x][y+1][z+1][chem] * diagonal;
  sum += array3D[x][y-1][z+1][chem] * diagonal;
  sum += array3D[x-1][y-1][z+1][chem] * corner;
  sum += array3D[x+1][y-1][z+1][chem] * corner;
  sum += array3D[x+1][y+1][z+1][chem] * corner;
  sum += array3D[x-1][y+1][z+1][chem] * corner;

  return sum;
}

void draw() {
  background(51);
  stroke(0);
  strokeWeight(2);
  translate(-cols/2, -rows/2, -zAxis/2);


  //IGNORE EDGE PIXELS - START AT 1, END ON WIDTH-1
  for (int x = 1; x < cols-1; x++) {
    for (int y = 1; y < rows-1; y++) {
      for (int z = 1; z < zAxis-1; z++) {

        float a = array3D[x][y][z][0];
        float b = array3D[x][y][z][1];


        newGen3D[x][y][z][0] = a + (dA * laplace3D(x, y, z, 0)) - (a*b*b) + (feed * (1 - a)) * time;
        newGen3D[x][y][z][1] = b + (dB * laplace3D(x, y, z, 1)) + (a*b*b) - (kill + feed) * b * time;


        newGen3D[x][y][z][0] = constrain(newGen3D[x][y][z][0], 0, 1);
        newGen3D[x][y][z][1] = constrain(newGen3D[x][y][z][1], 0, 1);

        float newA = newGen3D[x][y][z][0];
        float newB = newGen3D[x][y][z][1];
        //int ptColor = floor((newA - newB) * 255);
        //ptColor = constrain(ptColor,0,255);
        float level = newA - newB;



        if (level < isoLevel) {

          if (x < cols - boundary && x > boundary) {
            if (y < rows - boundary && y > boundary) {
              if (z < zAxis - boundary && z > boundary) {
                point(x, y, z);
              }
            }
          }
        }
      }
    }
  }

  swap();


  cam.beginHUD();
  gui();
  cam.endHUD();
}
