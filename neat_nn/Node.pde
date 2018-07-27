class Node {

  int id;
  boolean ready;
  float curr = 0;
  float bias = random(-1, 1);

  Node(int id) {
    this.id = id;
    ready = false;
  }

  void getReady(HashMap<Integer, ArrayList<Gene>> genes) {
    if (!ready) {
      ArrayList<Gene> leadIns = genes.get(id);

      boolean allReady = true;
      for (Gene g : leadIns)
        allReady = allReady && (g.inNode.ready || !g.active);

      if (allReady) {
        ready = true;
        for (Gene g : leadIns)
          curr += g.active ? g.inNode.curr*g.weight : 0;
        curr += bias;
        curr = sigmoid(curr);
      } else {
      }
    }
  }
  
  void reset() {
    ready = false;
    curr = 0;
  }
}

// input and output extensions of Node
class InputNode extends Node {

  InputNode(int id) {
    super(id);
    bias = 0;
  }

  void getReady(float input) {
    curr = input;
    ready = true;
  }
}

class OutputNode extends Node {

  OutputNode(int id) {
    super(id);
  }
}