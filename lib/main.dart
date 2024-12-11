import 'dart:convert';
import 'dart:io';

import 'package:search_in_p2p/graph.dart';
import 'package:search_in_p2p/p2p_simulator.dart';

Future<void> main() async {
  try {
    String path = 'lib/json.json';

    var file = File(path);
    String content = await file.readAsString();
    var data = jsonDecode(content);

    int minNeighbors = data['min_neighbors'];
    int maxNeighbors = data['max_neighbors'];

    Graph graph = Graph(minNeighbors, maxNeighbors);

    for (var node in data['resources'].keys) {
      int nodeId = int.parse(node);
      List<int> nodeResources = List<int>.from(data['resources'][node]);
      graph.addNode(nodeId, nodeResources);
    }

    for (var edge in data['edges']) {
      int node1 = edge[0];
      int node2 = edge[1];
      graph.addEdge(node1, node2);
    }

    if (!graph.isValidGraph()) {
      print('Invalid graph: Node neighbors out of bounds.');
      return;
    }

    print('Graph created successfully:');
    print(graph);

    PeerToPeerSimulator simulator = PeerToPeerSimulator(graph);
    int startNode = data['start_node'];
    int targetResource = data['resource_id'];
    int ttl = data['ttl'];
    String algorithm = data['algorithm'];

    final Map<String, Function(int startNode, int targetResource, int ttl)> algorithms = {
      'flooding': simulator.flooding,
      'informed_flooding': simulator.informedFlooding,
      'random_walk': simulator.randomWalk,
      'informed_random_walk': simulator.informedRandomWalk,
    };

    final selectedAlgorithm = algorithms[algorithm];

    if (selectedAlgorithm != null) {
      print('\n--- Executando o algoritmo: $algorithm ---\n');
      selectedAlgorithm(startNode, targetResource, ttl);
    } else {
      print('Erro: Algoritmo "$algorithm" nao encontrado.');
    }
  } catch (e) {
    print('Erro: $e');
  }
}
