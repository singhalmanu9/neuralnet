#############################################
# Matrix class for a neural network library #
#                                           #
# @author - Abhimanyu Singhal               #
#############################################

import random;
import math;

class Matrix:

	def __init__(self, rows, cols):
		self.table = [];
		self.rows = rows;
		self.cols = cols;
		for i in range(0, rows):
			a = [];
			for j in range(0, cols):
				a.append(0);
			self.table.append(a);

	def __str__(self):
		ret = "[";
		for i in range(0, len(self.table)):
			for j in range(0, len(self.table[i])):
				ret += str(self.table[i][j]);
				if (j < len(self.table[i]) - 1):
					ret += ", ";
			if (i < len(self.table) - 1):
				ret += '\n ';
		ret += "]";
		return ret;

	def print(self):
		print(str(self));

	def randomize(self):
		for i in range(0, len(self.table)):
			for j in range(0, len(self.table[i])):
				self.table[i][j] = math.floor(random.random()*5);

	@staticmethod
	def mult(a, b):
		if(isinstance(a, Matrix) and isinstance(b, Matrix)):
			if a.cols != b.rows:
				print('Matrix dimensions are not compatible');
			else:
				res = Matrix(a.rows, b.cols);
				for i in range(0, len(res.table)):
					for j in range(0, len(res.table[i])):
						for k in range(0, a.cols):
							res.table[i][j] += a.table[i][k]*b.table[k][j];
				return res;
		else:
			res = 0;
			if (not isinstance(a, Matrix)):
				res = Matrix(b.rows, b.cols);
				for i in range(0, len(b.table)):
					for j in range(0, len(b.table[i])):
						res.table[i][j] = b.table[i][j] * a;
			else:
				res = Matrix(a.rows, a.cols);
				for i in range(0, len(a.table)):
					for j in range(0, len(a.table[i])):
						res.table[i][j] = a.table[i][j] * b;
			return res;