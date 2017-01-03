// A collection of trees for displaying easier

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
      int randX = (int)random(0,GRID_COLUMNS-1);
      int randY = (int)random(0,GRID_ROWS-1);
      CompiledCell testCell = cMap.getCell(randX,randY);
      
      if(testCell.id >= 2 && testCell.id <= 5 && !testCell.isForest() && (!testCell.isCity())){
        Vector3 tree_pos = new Vector3(CELL_SCALE/2,CELL_SCALE/2,0).add(testCell.v1);
        tree_pos.z = testCell.getHeightAt(CELL_SCALE/2,CELL_SCALE/2);
        this.addTree(new Tree(tree_pos));
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