public static class Pathfinder {

  public static PathTile[][] worldTiles = new PathTile[10][20];
  
  private static ArrayList<PathTile> open = new ArrayList<PathTile>(); // collection of tiles we can use to solve the algorithm
  private static ArrayList<PathTile> closed = new ArrayList<PathTile>(); // collection of tiles that we've ruled out as NOT part of the solution

  public static Queue<PVector> findPath(PVector startPos, PVector endPos) {
    open.clear(); // empty array
    closed.clear(); // empty array

    PathTile start = worldTiles[(int)startPos.y][(int)startPos.x];
    PathTile end = worldTiles[(int)endPos.y][(int)endPos.x];
    start.resetParent(); // starting tile's "parent" property should be null

    // STEP 1:
    connectStartToEnd(start, end);

    // STEP 2: BUILD PATH BACK TO BEGINNING
    ArrayList<PathTile> path = new ArrayList<PathTile>();
    PathTile pathNode = end;
    while (pathNode != null) {
      path.add(pathNode);
      pathNode = pathNode.parent;
    }

    // STEP 3: REVERSE THE COLLECTION:
    Queue<PVector> rev = new LinkedList<PVector>();
    int maxIndex = path.size() - 1;
    for (int i = maxIndex; i >= 0; i--) {
      PathTile pt = path.get(i);
      rev.add(new PVector(pt.x, pt.y));
    }
    return rev;
  }

  private static void connectStartToEnd(PathTile start, PathTile end) {

    open.add(start);

    while (open.size () > 0) {
      ////// GET THE NODE IN open WITH LOWEST F VALUE:
      float F = 9999;
      int index = -1;

      for (int i = 0; i < open.size (); i++) {
        PathTile temp = open.get(i);
        if (temp.F < F) {
          F = temp.F;
          index = i;
        }
      }

      PathTile current = open.remove(index);
      closed.add(current);

      if (current == end) {
        // path found!
        break;
      }
      // LOOP THROUGH ALL OF current's NEIGHBORS:
      for (int i = 0; i < current.neighbors.size (); i++) {
        PathTile neighbor = current.neighbors.get(i);
        if (!tileInArray(closed, neighbor)) {
          if (!tileInArray(open, neighbor)) {
            open.add(neighbor);
            neighbor.setParent(current);
            neighbor.doHeuristic(end);
          } else {
            if (neighbor.G > current.G + neighbor.cost) {
              neighbor.setParent(current);
              neighbor.doHeuristic(end);
            } // end if
          } // end else
        } // end if
      } // end for
    } // end while
  } // end method

  private static boolean tileInArray(ArrayList<PathTile> a, PathTile t) {
    for (int i = 0; i < a.size (); i++) {
      if (a.get(i) == t) return true;
    }
    return false;
  }
}


private class PathTile {
  
  public int x;
  public int y;
  
  public float F;
  public float G;
  public float cost;
  
  public PathTile parent;
  public ArrayList<PathTile> neighbors = new ArrayList<PathTile>();
  
  void setNeighbors() {
    if(x-1 >= 0) neighbors.add(Pathfinder.worldTiles[y][x-1]);
    if(x+1 < worldCols) neighbors.add(Pathfinder.worldTiles[y][x+1]);
    if(y-1 >= 0) neighbors.add(Pathfinder.worldTiles[y-1][x]);
    if(y+1 < worldRows) neighbors.add(Pathfinder.worldTiles[y+1][x]);
  }

  void setParent(PathTile n) {
    parent = n;
    G = parent.G + cost;
  }
  
  void resetParent() {
    parent = null;
    G = 0;
    F = 0;
  }
  
    // HEURISTICS CALULATIONS:
  void doHeuristic(PathTile n) {
    F = G + distanceEuclidean(n);
  }
  
    // EUCLIDEAN HEURISTIC CALCULATION:
  float distanceEuclidean(PathTile n) {
    float dx = n.x - x;
    float dy = n.y - y;
    return sqrt(dx * dx + dy * dy);
  }
}
