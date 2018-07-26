
int innCounter = 1;
Genome gen;

void setup() {
  gen = new Genome(10, 4);
}

void draw() {  
  ArrayList<Float> inputs = new ArrayList();
  for (int i = 0; i < 10; i ++) {
    inputs.add(random(-1, 1));
  }
  println(gen.feedforward(inputs));
  
  noLoop();
}

float sigmoid(float x) {
  return 1/(1+exp(-x));
}