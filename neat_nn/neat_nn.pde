
int innCounter = 0;
ArrayList<Genome> genomes = new ArrayList<Genome>();

ArrayList<Gene> mutations = new ArrayList();

Evolver ev = new Evolver(1, 1, .4, 1);

void setup() {
  size(800, 800);
  for (int i = 0; i < 50; i ++) {
    genomes.add(new Genome(2, 1));
  }
  frameRate(1);
}

void draw() {  
  background(255);
  ArrayList<Float> inputs = new ArrayList();
  ArrayList<Float> targets = new ArrayList();
  for (int i = 0; i < 1; i ++) {
    float rand1 = round(random(1));
    float rand2 = round(random(1));
    inputs.add(rand1);
    inputs.add(rand2);
    targets.add((rand1 + rand2) % 2);
  }

  ev.resolveMutations(genomes, mutations);

  float avgErr = 0;
  for (Genome g : genomes) {
    ev.assignSpecies(g);
    g.calculateFitness(inputs, targets);
    avgErr += 1/g.fitness;
  }
  ev.normFitness(genomes);
  genomes = ev.newGeneration(genomes);
  println(avgErr / genomes.size());

  //noLoop();
  mutations = new ArrayList();
}

float sigmoid(float x) {
  return 1/(1+exp(-x));
}