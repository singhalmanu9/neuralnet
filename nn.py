##############################################
# Neural network class                       #
#                                            #
#                                            #
# @author - Abhimanyu Singhal                #
#                                            #
##############################################

from matrix import Matrix
import math

class NeuralNet:

	def __init__(self, inputs, hidden, output): 
		self.inputs = inputs;
		self.hidden = hidden;
		self.output = output;

		# create and randomize weights
		self.ih = Matrix(hidden, inputs);
		self.ho = Matrix(output, hidden);
		self.bi = Matrix(hidden, 1);
		self.bh = Matrix(output, 1);
		self.ih.randomize();
		self.ho.randomize();
		self.bi.randomize();
		self.bh.randomize();

	def feedforward(self, input_arr):
		inputs = Matrix.fromArray(input_arr);

		h = Matrix.add(Matrix.mult(self.ih, inputs), self.bi);
		NeuralNet.activate(h);

		out = Matrix.add(Matrix.mult(self.ho, h), self.bh);
		NeuralNet.activate(out);
		return out.table

	@staticmethod
	def activate(vec):
		for i in range(0, len(vec.table)):
			vec.table[i][0] = 1/(1+math.exp(-vec.table[i][0]));

	def train(self, trainset):
		return None




