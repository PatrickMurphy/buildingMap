class Forest {
  ArrayList <Tree> trees;
  int treeCount = 0;
  int attempts;
  Forest(int n) {
    loadStep = "Add Trees";
    trees = new ArrayList<Tree>();
    attempts = n*5;
    while(treeCount < n && attempts>0){
      attempts--;
      loadPCT = treeCount / (float)n;
      int randX = (int)random(0,cols-2);
      int randY = (int)random(0,rows-3);
      CompiledCell testCell = cMap.getCell(randX,randY);
      
      if(testCell.id >= 2 && testCell.id <= 5 && !testCell.isForest() && (!testCell.isCity())){
        this.addTree(new Tree(new Vector3(cellScale/2,cellScale/2,0).add(testCell.v1)));
        testCell.setForest();
      }
    }
  }
  Forest addTree(Tree t){
    trees.add(t);
    treeCount++;
    return this;
  };
  Forest display(){
    for (Tree t : trees) {
      t.display();
      t.update();
    }
    return this;
  }
}