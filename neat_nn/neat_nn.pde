
int innCounter = 1;
Genome gen;

void setup() {
  size(800, 800);
  gen = new Genome(2, 1);
}

void draw() {  
  background(255);
  ArrayList<Float> inputs = new ArrayList();
  for (int i = 0; i < 2; i ++) {
    inputs.add(random(-1, 1));
  }
  gen.show();
  
  //noLoop();
}

void mousePressed() {
  gen.mutate();
}

float sigmoid(float x) {
  return 1/(1+exp(-x));
}