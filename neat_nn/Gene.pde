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
    weight = random(-1, 1);
  }
}