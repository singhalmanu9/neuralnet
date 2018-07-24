float[][] inputs;
float[][] targets;
NeuralNet nn = new NeuralNet(2, 2, 1);

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

void prepareXORSet() {
  inputs = new float[100000][2];
  targets = new float[inputs.length][1];
  for (int i = 0; i < inputs.length; i ++) {
    float x = round(random(1));
    float y = round(random(1));
    inputs[i][0] = x; inputs[i][1] = y;
    float output = (x+y) % 2;
    targets[i][0] = output;
  }
}

void setup() {
  prepareXORSet();
  
}

void draw() {
  println("before train");
  float[][] test1 = {{0}, {0}};
  float[][] test2 = {{0}, {1}};
  float[][] test3 = {{1}, {0}};
  float[][] test4 = {{1}, {1}};
  nn.feedforward(fromArray(test1)).printMatrix();
  nn.feedforward(fromArray(test2)).printMatrix();
  nn.feedforward(fromArray(test3)).printMatrix();
  nn.feedforward(fromArray(test4)).printMatrix();
  for (int i = 0; i < inputs.length; i ++) {
    float[][] in = {{inputs[i][0]}, {inputs[i][1]}};
    float[][] out = {{targets[i][0]}};
    Matrix matIn = fromArray(in);
    Matrix targ = fromArray(out);
    nn.train(matIn, targ);
  }
  println("after train");
  nn.feedforward(fromArray(test1)).printMatrix();
  nn.feedforward(fromArray(test2)).printMatrix();
  nn.feedforward(fromArray(test3)).printMatrix();
  nn.feedforward(fromArray(test4)).printMatrix();
  noLoop();
}