float[][] inputs = {{1.0}, {1.0}, {1.0}, {1.0}};
NeuralNet nn = new NeuralNet(4, 2, 1);

Matrix fromArray(float[][] array) {
  int rows = array.length;
  int cols = array[rows-1].length;
  Matrix result = new Matrix(rows, cols);
  result.table = copyArray(array);
  return result;
}

float[][] copyArray(float[][] array) {
  float[][] result = new float[array.length][array[0].length];
  for (int i = 0; i < result.length; i ++ ) {
    for (int j = 0; j < result[0].length; j++) {
      result[i][j] = array[i][j];
    }
  }
  return result;
}

void setup() {
  size(800,800);
}

void draw() {
  background(255);
  Matrix matIn = fromArray(inputs);
  matIn.printMatrix();
  nn.feedforward(matIn).printMatrix();
  
}