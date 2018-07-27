class Genome { //<>// //<>//

  // list of all genes, indexed by outnumber (node data flows to)
  HashMap<Integer, ArrayList<Gene>> genes = new HashMap();

  ArrayList<Gene> genesInn = new ArrayList();

  // list of all nodes (increasing id number)
  ArrayList<Node> nodes = new ArrayList();

  Genome(int input_nodes, int output_nodes) {

    // load all input and output nodes
    for (int i = 0; i < input_nodes; i ++) {
      Node newNode = new InputNode(nodes.size());
      nodes.add(newNode);
      genes.put(newNode.id, new ArrayList<Gene>());
    }
    for (int i = 0; i < output_nodes; i ++) {
      Node newNode = new OutputNode(nodes.size());
      nodes.add(newNode);
      genes.put(newNode.id, new ArrayList<Gene>());
    }

    // connect all input and output nodes
    for (int i = 0; i < input_nodes; i ++) {
      for (int j = 0; j < output_nodes; j ++) {
        Gene g = new Gene(nodes.get(i), nodes.get(input_nodes + j), innCounter++);
        genes.get(input_nodes + j).add(g);
        genesInn.add(g);
      }
    }
  }

  boolean canReach(Node n1, Node n2) {
    if (n1.id == n2.id)
      return true;

    boolean found = false;
    for (Gene g : genes.get(n1.id)) {
      if (g.inNode.id == n2.id) {
        return true;
      } else {
        if (!(g.inNode instanceof InputNode))
          found = found || canReach(g.inNode, n2);
      }
    }
    return found;
  }

  Gene[] addGene() {
    Node node1 = nodes.get((int) random(nodes.size())); //<>//
    Node node2 = nodes.get((int) random(nodes.size()));

    int counter = 0;
    while (counter < nodes.size()*nodes.size() && (node2 instanceof InputNode || node1 instanceof OutputNode || canReach(node1, node2) || canReach(node2, node1))) {
      node1 = nodes.get((int) random(nodes.size()));
      node2 = nodes.get((int) random(nodes.size()));
      counter ++;
    }

    if (counter < nodes.size()*nodes.size()) {
      Gene g = new Gene(node1, node2, innCounter ++);
      genes.get(node2.id).add(g);
      genesInn.add(g);
      println("added gene between " + node1.id + ", " + node2.id);
      Gene[] retGenes = {g};
      return retGenes;
    } else {
      println("adding gene failed!");
      return null;
    }
  }

  Gene[] addNode() {
    Gene g = null;
    while (g == null) {
      Node node1 = nodes.get((int) random(nodes.size()));
      Node node2 = nodes.get((int) random(nodes.size()));

      for (Gene gene : genes.get(node2.id)) {
        if (gene.inNode.id == node1.id)
          g = gene;
      }
    }

    g.active = false;
    Node n = new Node(nodes.size());
    nodes.add(n);
    genes.put(n.id, new ArrayList<Gene>());
    Gene g1 = new Gene(g.inNode, n, innCounter ++);
    Gene g2 = new Gene(n, g.outNode, innCounter ++);
    genes.get(g1.outNode.id).add(g1);
    genesInn.add(g1);
    genes.get(g2.outNode.id).add(g2);
    genesInn.add(g2);
    
    Gene[] retGenes = {g1, g2};
    return retGenes;
  }

  Gene[] mutate() {
    float rand = random(1);
    // mutate weights?
    if (rand < .8) {
      for (Gene g : genesInn) {
        // mutate indiviual genes
        if (random(1) < .9) {
          g.weight += randomGaussian()*.5;
        } else {
          g.weight = random(-1, 1);
        }
      }
      return null;
    } else if (rand <.85) {
      return addGene();
    } else if (rand < .88) {
      return addNode();
    } else {
      return null;
    }
  }

  int numGenes() {
    int total = 0;
    for (int i : genes.keySet())
      total += genes.get(i).size();
    return total;
  }

  ArrayList<Float> feedforward(ArrayList<Float> inputs) {

    // get a list of all output nodes
    ArrayList<OutputNode> outputNodes = new ArrayList();
    for (Node n : nodes) {
      if (n instanceof OutputNode)
        outputNodes.add((OutputNode) n);
    }

    // get all inputs ready
    int inputCounter = 0;
    for (Node n : nodes) {
      if (n instanceof InputNode && !n.ready) {
        ((InputNode) n).getReady(inputs.get(inputCounter ++));
      }
    }

    // while all outputs aren't ready
    while (!allOutputsReady()) {
      // get every not ready node ready
      for (Node n : nodes) {
        if (!n.ready) {
          n.getReady(genes);
        }
      }
    }

    // get output values from output nodes
    ArrayList<Float> out = new ArrayList();
    for (OutputNode o : outputNodes) 
      out.add(o.curr);

    resetReadiness();

    return out;
  }

  void resetReadiness() {
    for (Node n : nodes)
      n.reset();
  }

  boolean allOutputsReady() {
    for (Node n : nodes) {
      if (n instanceof OutputNode && !n.ready)
        return false;
    }
    return true;
  }

  void show() {
    ArrayList<Integer> inputs = new ArrayList();
    ArrayList<Integer> outputs = new ArrayList();
    ArrayList<Integer> hidden = new ArrayList();
    for (Node n : nodes) {
      if (n instanceof InputNode) {
        inputs.add(n.id);
      } else if (n instanceof OutputNode) {
        outputs.add(n.id);
      } else {
        hidden.add(n.id);
      }
    }
    fill(0);
    stroke(0);
    textSize(10);
    text("Inputs: " + inputs.toString(), 25, 25);
    text("Outputs: " + outputs.toString(), 25, 50);
    text("Hidden: " + hidden.toString(), 25, 75);

    int counter = 0;
    int topOffset = 100;
    int sideOffset = 25;
    for (Gene g : genesInn) {
      stroke(0);
      if (g.active) {
        fill(255);
      } else {
        fill(200);
      }

      rect(100*(counter % 7) + sideOffset - 5, 150*(counter / 7) + topOffset, 100, 150);
      fill(0);
      textSize(10);
      text("Inn. #: " + g.innNumber, 100*(counter % 7) + sideOffset, 150*(counter / 7) + topOffset + 25);
      text(g.inNode.id + "->" + g.outNode.id, 100*(counter % 7) + sideOffset, 150*(counter / 7) + topOffset + 50);
      text("Weight: " + g.weight, 100*(counter % 7) + sideOffset, 150*(counter / 7) + topOffset + 75);
      counter ++;
    }
  }
}