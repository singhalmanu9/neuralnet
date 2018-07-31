class Gene {
  
  Node inNode;
  Node outNode;
  float weight;
  boolean active;
  int innNumber;
  
  Gene(Node inNode, Node outNode, int innNumber) {
    this.inNode = inNode;
    this.outNode = outNode;
    this.innNumber = innNumber;
    active = true;
    weight = random(-5, 5);
    mutations.add(this);
  }
  
  Gene clone() {
    Gene g =  new Gene(inNode.clone(), outNode.clone(), innNumber);
    g.active = active;
    g.weight = weight;
    return g;
  }
}