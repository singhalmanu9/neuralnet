class Matrix {

  float[][] table;
  int rows;
  int cols;

  Matrix(int rows, int cols) {
    table = new float[rows][cols];
    this.rows = rows;
    this.cols = cols;
    for (int i = 0; i < rows; i ++) {
      for (int j = 0; j < cols; j ++) {
        table[i][j] = 0;
      }
    }
  }

  void printMatrix() {
    print("[");
    for (int i = 0; i < rows-1; i ++) {
      for (int j = 0; j < cols-1; j++) {
        print(table[i][j] + ", ");
      }
      println(table[i][cols-1]);
    }
    for (int j = 0; j < cols-1; j++) {
      print(table[rows-1][j] + ", ");
    }
    print(table[rows-1][cols-1]);
    println("]");
  }

  Matrix add(Matrix other) {
    Matrix result = null;
    if (this.rows == other.rows && this.cols == other.cols) {
      result = new Matrix(rows, cols);
      for (int i = 0; i < rows; i ++) {
        for (int j = 0; j < cols; j ++) {
          result.table[i][j] = this.table[i][j] + other.table[i][j];
        }
      }
    }
    return result;
  }

  Matrix sub(Matrix other) {
    Matrix result = null;
    if (this.rows == other.rows && this.cols == other.cols) {
      result = new Matrix(rows, cols);
      for (int i = 0; i < rows; i ++) {
        for (int j = 0; j < cols; j ++) {
          result.table[i][j] = this.table[i][j] - other.table[i][j];
        }
      }
    }
    return result;
  }

  Matrix mult(Matrix other) {
    Matrix result = null;
    if (this.cols == other.rows) {
      result = new Matrix(this.rows, other.cols);
      for (int rx = 0; rx < result.rows; rx ++) {
        for (int ry = 0; ry < result.cols; ry ++) {
          float sum = 0;
          for (int i = 0; i < this.cols; i ++) {
            sum += this.table[rx][i] * other.table[i][ry];
          }
          result.table[rx][ry] = sum;
        }
      }
    }
    return result;
  }

  void randomize() {
    for (int i = 0; i < rows; i ++) {
      for (int j = 0; j < cols; j ++) {
        table[i][j] = random(-1, 1);
      }
    }
  }

  Matrix sclmult(float scl) {
    Matrix result = new Matrix(rows, cols);
    for (int i = 0; i < rows; i ++) {
      for (int j = 0; j < cols; j++) 
        result.table[i][j] = scl * this.table[i][j];
    }
    return result;
  }

  Matrix elemmult(Matrix other) {
    Matrix result = null;
    if (rows == other.rows && cols == other.cols) {
      result = new Matrix(rows, cols);
      for (int i = 0; i < rows; i ++) {
        for (int j = 0; j < cols; j++) 
          result.table[i][j] = this.table[i][j] * other.table[i][j];
      }
    }
    return result;
  }

  Matrix transpose() {
    Matrix t = new Matrix(cols, rows);
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j ++)
        t.table[j][i] = table[i][j];
    }
    return t;
  }

  Matrix clone() {
    Matrix result = new Matrix(rows, cols);
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j ++)
        result.table[i][j] = table[i][j];
    }
    return result;
  }

  void mutate(float mutRate) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j ++)
        if (random(1) < mutRate)
          table[i][j] = table[i][j] + randomGaussian()*.3;
    }
  }

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
}