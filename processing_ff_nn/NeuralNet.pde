class NeuralNet {
  
  Matrix input_to_hidden;
  Matrix hidden_to_output;
  Matrix bias_hidden;
  Matrix bias_output;
  
  NeuralNet(int input, int hidden, int output) {
    input_to_hidden = new Matrix(hidden, input);
    hidden_to_output = new Matrix(output, hidden);
    input_to_hidden.randomize();
    hidden_to_output.randomize();
    bias_hidden = new Matrix(hidden, 1);
    bias_output = new Matrix(output, 1);
    bias_hidden.randomize();
    bias_output.randomize();
  }
  
  Matrix feedforward(Matrix input) {
    Matrix h = input_to_hidden.mult(input).add(bias_hidden);
    activate(h);
    
    Matrix out = hidden_to_output.mult(h).add(bias_output);
    activate(out);
    return out;
  }
  
  void activate(Matrix input) {
    for (int i = 0; i < input.rows; i ++) {
      for (int j = 0; j < input.cols; j++) {
        input.table[i][j] = 1/(1+exp(-input.table[i][j]));
      }
    }
  }
}