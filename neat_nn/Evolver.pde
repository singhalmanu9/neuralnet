class Evolver {

  float c1 = 1;
  float c2 = 1;
  float c3 = .4;
  float threshhold = 3;

  ArrayList<ArrayList<Genome>> allSpecies = new ArrayList();

  Evolver(float c1, float c2, float c3, float threshhold) {
    this.c1 = c1;
    this.c2 = c2;
    this.c3 = c3;
    this.threshhold = threshhold;
  }

  ArrayList<Genome> newGeneration(ArrayList<Genome> prevGen) {

    // add all previous bests
    ArrayList<Genome> nextGen = new ArrayList(); //<>//
    for (ArrayList<Genome> species : allSpecies) {
      Genome best = species.get(0);
      for (Genome g : species) {
        if (best.fitness < g.fitness) {
          best = g;
        }
      }
      nextGen.add(best.clone());
    }

    // add rest of genomes
    float[] fitnessValues = new float[allSpecies.size()]; //<>//
    float totalFit = 0;
    for (ArrayList<Genome> species : allSpecies) {
      for (Genome g : species) {
        fitnessValues[g.species] += g.fitness;
        totalFit += g.fitness;
      }
    }
    for (int i = 0; i < fitnessValues.length; i ++) { //<>//
      fitnessValues[i] *= (prevGen.size() - nextGen.size()) / totalFit;
    }

    for (int i = 0; i < fitnessValues.length; i ++) {
      for (int j = 0; j < round(fitnessValues[i]); j ++) {
        Genome rand = allSpecies.get(i).get((int) random(allSpecies.get(i).size())).clone();
        rand.mutate();
        nextGen.add(rand);
      }
    }
    
    for (int i = nextGen.size(); i < prevGen.size(); i ++) { //<>//
      Genome rand = prevGen.get((int) random(prevGen.size()));
      rand.mutate();
      nextGen.add(rand);
    }
    allSpecies = new ArrayList();

    return nextGen;
  }

  void assignSpecies(Genome g) {
    ArrayList<Genome> reps = getSpeciesReps();
    boolean placed = false;
    for (Genome r : reps) {
      if (compareGenomes(g, r) < threshhold && !placed) {
        allSpecies.get(r.species).add(g);
        g.species = r.species;
        placed = true;
      }
    }
    if (!placed) {
      ArrayList<Genome> newSpecies = new ArrayList();
      newSpecies.add(g);
      g.species = allSpecies.size();
      allSpecies.add(newSpecies);
    }
  }

  void resolveMutations(ArrayList<Genome> genomes, ArrayList<Gene> mutations) {
    for (Gene g : mutations) {
      for (Gene h : mutations) {
        if (g != h && (g.inNode.id == h.inNode.id && g.outNode.id == h.outNode.id)) {
          g.innNumber = min(g.innNumber, h.innNumber);
          h.innNumber = g.innNumber;
        }
      }
    }
    innCounter = 0;
    for (Gene g : mutations) {
      innCounter = max(innCounter, g.innNumber);
    }

    for (Genome genome : genomes) {
      ArrayList<Gene> copy = new ArrayList();
      for (Gene gene : genome.genesInn) {
        if (gene != null) {
          while (copy.size() < gene.innNumber) {
            copy.add(null);
          }
          copy.add(gene);
        }
      }
      genome.genesInn = copy;
    }
  }

  void normFitness(ArrayList<Genome> genomes) {
    for (Genome g : genomes) {
      g.fitness /= allSpecies.get(g.species).size();
    }
  }

  float compareGenomes(Genome g1, Genome g2) {
    int disjoint = 0;
    int xcs = 0;
    int matching = 0;
    float weightDiff = 0;

    if (g1.genesInn.size() < g2.genesInn.size()) {
      Genome temp = g2;
      g1 = g2;
      g1 = temp;
    } else {
    }

    for (int i = 0; i < g1.genesInn.size(); i ++) {
      if (i < g2.genesInn.size()) {
        if ((g1.genesInn.get(i) == null && g2.genesInn.get(i) != null) || (g2.genesInn.get(i) == null && g1.genesInn.get(i) != null)) {
          disjoint ++;
        } else if (g1.genesInn.get(i) != null && g1.genesInn.get(i).innNumber == g2.genesInn.get(i).innNumber) {
          matching ++;
          weightDiff += abs(g1.genesInn.get(i).weight - g2.genesInn.get(i).weight);
        }
      } else if (g1.genesInn.get(i) != null) {
        xcs ++;
      }
    }
    weightDiff /= matching;

    return disjoint*c1 + xcs*c2 + weightDiff*c3;
  }

  ArrayList<Genome> getSpeciesReps() {
    ArrayList<Genome> reps = new ArrayList();
    for (ArrayList<Genome> al : allSpecies) {
      reps.add(al.get((int) random(al.size())));
    }
    return reps;
  }
}