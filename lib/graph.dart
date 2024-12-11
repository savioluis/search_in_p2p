class Graph {
  Map<int, List<int>> adjacencyList = {};
  Map<int, List<int>> resources = {};
  int minNeighbors;
  int maxNeighbors;

  Graph(this.minNeighbors, this.maxNeighbors);

  void addNode(int nodeId, List<int> nodeResources) {
    adjacencyList[nodeId] ??= [];
    resources[nodeId] = nodeResources;
  }

  void addEdge(int node1, int node2) {
    if (!adjacencyList[node1]!.contains(node2)) {
      adjacencyList[node1]?.add(node2);
      adjacencyList[node2]?.add(node1);
    }
  }

  bool isValidGraph() {
    for (var neighbors in adjacencyList.values) {
      if (neighbors.length < minNeighbors || neighbors.length > maxNeighbors) {
        return false;
      }
    }
    return adjacencyList.isNotEmpty;
  }

  @override
  String toString() {
    return 'Graph:\nAdjacency List: $adjacencyList\nResources: $resources';
  }
}
