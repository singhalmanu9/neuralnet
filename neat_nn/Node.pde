class Node {

  int id;
  boolean ready;
  float curr;

  Node(int id) {
    this.id = id;
    ready = false;
    curr = random(-1, 1);
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
        curr = sigmoid(curr);
      } else {
      }
    }
  }

  float getValue() {
    return (ready) ? curr : 0;
  }
}

// input and output extensions of Node
class InputNode extends Node {

  InputNode(int id) {
    super(id);
    curr = 0;
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