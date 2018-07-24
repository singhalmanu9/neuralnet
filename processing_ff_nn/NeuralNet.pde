class NeuralNet {

  Matrix input_to_hidden;
  Matrix hidden_to_output;
  Matrix bias_hidden;
  Matrix bias_output;
  float lr = .1;

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

  void train(Matrix inputs, Matrix answers) {
    // feedforward
    Matrix h = input_to_hidden.mult(inputs).add(bias_hidden);
    activate(h);

    Matrix output = hidden_to_output.mult(h).add(bias_output);
    activate(output);

    // calc error o
    Matrix err_o = answers.sub(output);

    // calc gradient h->o
    Matrix grad_ob = output.sub(output.elemmult(output)).elemmult(err_o).sclmult(lr);
    Matrix gradient_ho = grad_ob.mult(h.transpose());
    bias_output = bias_output.add(grad_ob);
    hidden_to_output = hidden_to_output.add(gradient_ho);

    // calc error h
    Matrix err_h = hidden_to_output.transpose().mult(err_o);

    // calc gradient i->h
    Matrix grad_hb = h.sub(h.elemmult(h)).elemmult(err_h).sclmult(lr);
    Matrix gradient_ih = grad_hb.mult(inputs.transpose());
    bias_hidden = bias_hidden.add(grad_hb);
    input_to_hidden = input_to_hidden.add(gradient_ih);
  }

  void activate(Matrix input) {
    for (int i = 0; i < input.rows; i ++) {
      for (int j = 0; j < input.cols; j++) {
        input.table[i][j] = 1/(1+exp(-input.table[i][j]));
      }
    }
  }
}