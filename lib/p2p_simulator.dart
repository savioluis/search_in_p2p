import 'graph.dart';

class PeerToPeerSimulator {
  final Graph graph;
  int totalMessages = 0;
  Set<int> visitedNodes = {};

  PeerToPeerSimulator(this.graph);

  void flooding(int startNode, int targetResource, int ttl) {
    totalMessages = 0;
    visitedNodes.clear();

    print('\n--- Executing Flooding Algorithm ---\n');
    _floodingRecursive(startNode, targetResource, ttl);
    print(
        '\nFlooding Complete: Messages: $totalMessages, Nodes Visited: ${visitedNodes.length}');
  }

  bool _floodingRecursive(int currentNode, int targetResource, int ttl) {
    if (ttl < 0) return false;

    visitedNodes.add(currentNode);
    totalMessages++;
    print('Current Node: $currentNode, Current TTL: $ttl');

    if (graph.resources[currentNode]?.contains(targetResource) ?? false) {
      print('Resource found at Node $currentNode!');
      return true;
    }

    for (var neighbor in graph.adjacencyList[currentNode]!) {
      if (!visitedNodes.contains(neighbor)) {
        if (_floodingRecursive(neighbor, targetResource, ttl - 1)) {
          return true;
        }
      }
    }
    return false;
  }

  void randomWalk(int startNode, int targetResource, int ttl) {
    totalMessages = 0;
    visitedNodes.clear();

    print('\n--- Executing Random Walk Algorithm ---\n');
    int currentNode = startNode;
    List<int> history = [];

    while (ttl >= 0) {
      visitedNodes.add(currentNode);
      history.add(currentNode);
      totalMessages++;
      print('Current Node: $currentNode, Current TTL: $ttl');

      if (graph.resources[currentNode]?.contains(targetResource) ?? false) {
        print('Resource found at Node $currentNode!');
        return;
      }

      var neighbors = graph.adjacencyList[currentNode];
      if (neighbors == null || neighbors.isEmpty) {
        print('No neighbors available. Terminating.');
        break;
      }

      // filtra por vizinhos nao visitados
      var unvisitedNeighbors = neighbors
          .where((neighbor) => !visitedNodes.contains(neighbor))
          .toList();

      if (unvisitedNeighbors.isNotEmpty) {
        // ordena os vizinhos em ordem decrescente
        unvisitedNeighbors.sort((a, b) => b.compareTo(a));

        currentNode = unvisitedNeighbors.first;
      } else {
        neighbors.sort((a, b) => b.compareTo(a));

        currentNode = neighbors.first;
      }

      ttl--;
    }

    if (ttl < 0) {
      print('\nTTL expired. Resource not found.');
    }

    print(
        '\nRandom Walk Complete: Messages: $totalMessages, Nodes Visited: ${visitedNodes.length}');
  }

  void informedFlooding(int startNode, int targetResource, int ttl) {
    totalMessages = 0;
    visitedNodes.clear();

    print('\n--- Executando o Algoritmo de Informed Flooding ---\n');
    _informedFloodingRecursive(startNode, targetResource, ttl);
    print(
        '\nInformed Flooding Finalizado: Mensagens: $totalMessages, Nos Visitados: ${visitedNodes.length}');
  }

  bool _informedFloodingRecursive(
      int currentNode, int targetResource, int ttl) {
    if (ttl < 0) return false;

    visitedNodes.add(currentNode);
    totalMessages++;
    print('No Atual: $currentNode, TTL Atual: $ttl');

    // verifica se o recurso foi encontrado no no atual
    if (graph.resources[currentNode]?.contains(targetResource) ?? false) {
      print('Recurso encontrado no No $currentNode!');
      return true;
    }

    // obtem os vizinhos nao visitados do no atual
    var neighbors = graph.adjacencyList[currentNode]!
        .where((neighbor) => !visitedNodes.contains(neighbor))
        .toList();

    // ordena os vizinhos pelo numero de conexoes em ordem decrescente
    // isso prioriza vizinhos mais conectados, que tem maior probabilidade de estar mais proximos do recurso
    neighbors.sort((a, b) => graph.adjacencyList[b]!.length
        .compareTo(graph.adjacencyList[a]!.length));

    // propaga a mensagem para cada vizinho ordenado
    for (var neighbor in neighbors) {
      if (_informedFloodingRecursive(neighbor, targetResource, ttl - 1)) {
        return true;
      }
    }

    return false;
  }

  void informedRandomWalk(int startNode, int targetResource, int ttl) {
    totalMessages = 0;
    visitedNodes.clear();

    print('\n--- Executing Informed Random Walk Algorithm ---\n');
    int currentNode = startNode;
    List<int> history = [];

    while (ttl >= 0) {
      visitedNodes.add(currentNode);
      history.add(currentNode);
      totalMessages++; 
      print('Nó Atual: $currentNode, TTL Atual: $ttl');

      if (graph.resources[currentNode]?.contains(targetResource) ?? false) {
        print('Recurso encontrado no Nó $currentNode!');
        return;
      }

      var neighbors = graph.adjacencyList[currentNode];
      if (neighbors == null || neighbors.isEmpty) {
        print('Nenhum vizinho disponível. Terminando.');
        break;
      }

      var unvisitedNeighbors = neighbors
          .where((neighbor) => !visitedNodes.contains(neighbor))
          .toList();

      if (unvisitedNeighbors.isNotEmpty) {
        // ordena os vizinhos nao visitados em ordem decrescente pelo número de conexoes
        unvisitedNeighbors.sort((a, b) => graph.adjacencyList[b]!.length
            .compareTo(graph.adjacencyList[a]!.length));

        // seleciona o vizinho mais conectado
        currentNode = unvisitedNeighbors.first;
      } else {
        // ordena todos os vizinhos em ordem decrescente pelo numero de conexoes
        neighbors.sort((a, b) => graph.adjacencyList[b]!.length
            .compareTo(graph.adjacencyList[a]!.length));

        currentNode = neighbors.first;
      }

      ttl--;
    }

    if (ttl < 0) {
      print('\nTTL expirado. Recurso não encontrado.');
    }

    print(
        '\nInformed Random Walk Complete: Mensagens: $totalMessages, Nós Visitados: ${visitedNodes.length}');
  }
}
