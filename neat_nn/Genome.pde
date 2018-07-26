class Genome {

  // list of all genes, indexed by outnumber (node data flows to)
  HashMap<Integer, ArrayList<Gene>> genes = new HashMap();

  // list of all nodes (increasing id number)
  ArrayList<Node> nodes = new ArrayList();

  Genome(int input_nodes, int output_nodes) {

    // load all input and output nodes
    for (int i = 0; i < input_nodes; i ++) {
      nodes.add(new InputNode(nodes.size()));
    }
    for (int i = 0; i < output_nodes; i ++) {
      nodes.add(new OutputNode(nodes.size()));
    }

    // connect all input and output nodes
    for (int i = 0; i < input_nodes; i ++) { //<>// //<>//
      for (int j = 0; j < output_nodes; j ++) {
        if (genes.get(input_nodes + j) == null) {
          ArrayList<Gene> geneList = new ArrayList();
          genes.put(input_nodes + j, geneList);
        }
          
        genes.get(input_nodes + j).add(new Gene(nodes.get(i), nodes.get(input_nodes + j), innCounter++));
      }
    }
  }

  void restart() {
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

    return out;
  }

  boolean allOutputsReady() {
    for (Node n : nodes) {
      if (n instanceof OutputNode && !n.ready)
        return false;
    }
    return true;
  }
}