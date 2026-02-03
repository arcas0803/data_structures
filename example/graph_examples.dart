/// Comprehensive examples for Graph Structures
/// Run with: dart run example/graph_examples.dart
library;

import 'package:data_structures/data_structures.dart';

void main() {
  print('═══════════════════════════════════════════════════════════════');
  print('                    GRAPH STRUCTURES EXAMPLES');
  print('═══════════════════════════════════════════════════════════════\n');

  graphBasicsExamples();
  graphTraversalExamples();
  directedGraphExamples();
  weightedGraphExamples();
  adjacencyMatrixExamples();
  flowNetworkExamples();
  graphAlgorithmsExamples();
}

void graphBasicsExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                    GRAPH BASICS                            │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Undirected graph
  print('--- Undirected Graph ---');
  final graph = Graph<String>();

  // Add vertices
  graph.addVertex('A');
  graph.addVertex('B');
  graph.addVertex('C');
  graph.addVertex('D');
  print('Added vertices: A, B, C, D');

  // Add edges
  graph.addEdge('A', 'B');
  graph.addEdge('A', 'C');
  graph.addEdge('B', 'C');
  graph.addEdge('C', 'D');
  print('Added edges: A-B, A-C, B-C, C-D');

  print('\nGraph structure:');
  print(graph);

  // Graph properties
  print('\n--- Properties ---');
  print('Vertex count: ${graph.vertexCount}');
  print('Edge count: ${graph.edgeCount}');
  print('Is directed: ${graph.isDirected}');
  print('Vertices: ${graph.vertices}');

  // Vertex properties
  print('\n--- Vertex Properties ---');
  print('Neighbors of A: ${graph.neighbors('A')}');
  print('Neighbors of C: ${graph.neighbors('C')}');
  print('Degree of C: ${graph.degree('C')}');

  // Edge operations
  print('\n--- Edge Operations ---');
  print('Has edge A-B: ${graph.hasEdge('A', 'B')}');
  print('Has edge A-D: ${graph.hasEdge('A', 'D')}');

  // Remove operations
  print('\n--- Remove Operations ---');
  graph.removeEdge('B', 'C');
  print('After removing edge B-C:');
  print('  Neighbors of B: ${graph.neighbors('B')}');
  print('  Neighbors of C: ${graph.neighbors('C')}');

  graph.removeVertex('D');
  print('After removing vertex D:');
  print('  Vertices: ${graph.vertices}');

  print('\n');
}

void graphTraversalExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                   GRAPH TRAVERSALS                         │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Build a graph for traversal
  final graph = Graph<int>();
  /*
       1
      /|\
     2 3 4
     |   |
     5   6
      \ /
       7
  */
  graph.addEdge(1, 2);
  graph.addEdge(1, 3);
  graph.addEdge(1, 4);
  graph.addEdge(2, 5);
  graph.addEdge(4, 6);
  graph.addEdge(5, 7);
  graph.addEdge(6, 7);

  print('Graph structure:');
  print('     1');
  print('    /|\\');
  print('   2 3 4');
  print('   |   |');
  print('   5   6');
  print('    \\ /');
  print('     7');

  // BFS
  print('\n--- Breadth-First Search (BFS) ---');
  print('BFS from 1: ${graph.bfs(1).toList()}');
  print('');
  print('BFS explores level by level:');
  print('  Level 0: [1]');
  print('  Level 1: [2, 3, 4]');
  print('  Level 2: [5, 6]');
  print('  Level 3: [7]');

  // DFS
  print('\n--- Depth-First Search (DFS) ---');
  print('DFS from 1: ${graph.dfs(1).toList()}');
  print('');
  print('DFS goes as deep as possible first');

  // BFS with callback
  print('\n--- BFS with Early Termination ---');
  print('Finding node 5:');
  var found = false;
  for (final vertex in graph.bfs(1)) {
    print('  Visiting: $vertex');
    if (vertex == 5) {
      found = true;
      break;
    }
  }
  print('Found: $found');

  // BFS Path (for path reconstruction)
  print('\n--- BFS Path (Path Reconstruction) ---');
  final bfsPath = graph.bfsPath(1, 7);
  print('Path from 1 to 7: $bfsPath');

  print('\n');
}

void directedGraphExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                    DIRECTED GRAPH                          │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final digraph = Graph<String>(type: GraphType.directed);

  // Build a DAG (Directed Acyclic Graph)
  /*
    A → B → D
    ↓   ↓   ↓
    C → E → F
  */
  digraph.addEdge('A', 'B');
  digraph.addEdge('A', 'C');
  digraph.addEdge('B', 'D');
  digraph.addEdge('B', 'E');
  digraph.addEdge('C', 'E');
  digraph.addEdge('D', 'F');
  digraph.addEdge('E', 'F');

  print('Directed Graph (DAG):');
  print('  A → B → D');
  print('  ↓   ↓   ↓');
  print('  C → E → F');
  print('');

  // Directed edge check
  print('--- Directed Edges ---');
  print('Has edge A → B: ${digraph.hasEdge('A', 'B')}');
  print('Has edge B → A: ${digraph.hasEdge('B', 'A')}');  // False!

  // In-degree and out-degree
  print('\n--- In/Out Degree ---');
  print('In-degree of E: ${digraph.inDegree('E')}');   // B, C
  print('Out-degree of B: ${digraph.outDegree('B')}');  // D, E
  print('In-degree of A: ${digraph.inDegree('A')}');   // 0 (source)
  print('Out-degree of F: ${digraph.outDegree('F')}'); // 0 (sink)

  // Topological Sort
  print('\n--- Topological Sort ---');
  final topo = digraph.topologicalSort();
  print('Topological order: $topo');
  print('Every vertex appears after all its dependencies!');

  // Cycle detection
  print('\n--- Cycle Detection ---');
  print('Has cycle: ${digraph.hasCycle}');

  // Add a cycle
  print('\nAdding edge F → A (creates cycle):');
  digraph.addEdge('F', 'A');
  print('Has cycle now: ${digraph.hasCycle}');
  print('Topological sort: ${digraph.topologicalSort()}');  // null

  // Use case: Task scheduler
  print('\n--- Use Case: Build System ---');
  final build = Graph<String>(type: GraphType.directed);
  build.addEdge('compile', 'link');
  build.addEdge('compile', 'test');
  build.addEdge('link', 'package');
  build.addEdge('test', 'package');
  build.addEdge('package', 'deploy');

  print('Build dependencies:');
  print('  compile → link → package → deploy');
  print('          ↘ test ↗');
  print('');
  print('Build order: ${build.topologicalSort()}');

  print('\n');
}

void weightedGraphExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                    WEIGHTED GRAPH                          │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final graph = Graph<String>();

  // Build weighted graph
  graph.addEdge('A', 'B', 4);
  graph.addEdge('A', 'C', 2);
  graph.addEdge('B', 'C', 1);
  graph.addEdge('B', 'D', 5);
  graph.addEdge('C', 'D', 8);
  graph.addEdge('C', 'E', 10);
  graph.addEdge('D', 'E', 2);

  print('Weighted Graph:');
  print('  A --4-- B --5-- D');
  print('  |       |       |');
  print('  2       1       2');
  print('  |       |       |');
  print('  C ------+       E');
  print('      8      10');
  print('');

  // Get edge weights
  print('--- Edge Weights ---');
  print('Weight A-B: ${graph.getEdgeWeight('A', 'B')}');
  print('Weight C-D: ${graph.getEdgeWeight('C', 'D')}');

  // Update weight (by removing and re-adding edge)
  print('\n--- Update Weight ---');
  graph.removeEdge('C', 'D');
  graph.addEdge('C', 'D', 3);
  print('After updating C-D to 3: ${graph.getEdgeWeight('C', 'D')}');

  // All edges with weights
  print('\n--- All Edges ---');
  for (final edge in graph.edges) {
    final (from, to, weight) = edge;
    print('  $from -- $weight -- $to');
  }

  print('\n');
}

void adjacencyMatrixExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                 ADJACENCY MATRIX GRAPH                     │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Undirected
  print('--- Undirected Matrix Graph ---');
  final graph = AdjacencyMatrixGraph<int>();

  for (var i = 0; i < 4; i++) graph.addVertex(i);
  graph.addEdge(0, 1);
  graph.addEdge(0, 2);
  graph.addEdge(1, 2);
  graph.addEdge(2, 3);

  print('Vertices: ${graph.vertices}');
  print('');
  print('Adjacency Matrix:');
  final matrix = graph.getMatrix();
  print('    0  1  2  3');
  for (var i = 0; i < 4; i++) {
    final row = matrix[i].map((w) => w != null ? '1' : '0').join('  ');
    print('$i [ $row ]');
  }

  // Edge lookup is O(1)
  print('\n--- O(1) Edge Lookup ---');
  print('hasEdge(0, 1): ${graph.hasEdge(0, 1)}');
  print('hasEdge(0, 3): ${graph.hasEdge(0, 3)}');
  print('hasEdge(1, 2): ${graph.hasEdge(1, 2)}');

  // Weighted
  print('\n--- Weighted Matrix ---');
  final weighted = AdjacencyMatrixGraph<String>();
  weighted.addEdge('A', 'B', weight: 5);
  weighted.addEdge('B', 'C', weight: 3);
  weighted.addEdge('A', 'C', weight: 10);

  print('getWeight(A, B): ${weighted.getWeight('A', 'B')}');
  print('getWeight(B, C): ${weighted.getWeight('B', 'C')}');

  // Dense vs Sparse
  print('\n--- Dense vs Sparse Comparison ---');
  print('Matrix: O(V²) space, O(1) edge lookup');
  print('List:   O(V+E) space, O(degree) edge lookup');
  print('');
  print('Use matrix when:');
  print('  • Graph is dense (E ≈ V²)');
  print('  • Need O(1) edge lookup');
  print('  • Memory is not a concern');
  print('');
  print('Current graph is dense: ${graph.isDense}');

  // Traversals work the same
  print('\n--- Traversals ---');
  print('BFS from 0: ${graph.bfs(0).toList()}');
  print('DFS from 0: ${graph.dfs(0).toList()}');

  print('\n');
}

void flowNetworkExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                     FLOW NETWORK                           │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Build a flow network
  print('--- Building Flow Network ---');
  final flow = FlowNetwork<String>();

  // Classic max-flow example
  flow.addEdge('S', 'A', 10);
  flow.addEdge('S', 'B', 8);
  flow.addEdge('A', 'B', 5);
  flow.addEdge('A', 'C', 7);
  flow.addEdge('B', 'C', 6);
  flow.addEdge('B', 'D', 3);
  flow.addEdge('C', 'T', 10);
  flow.addEdge('D', 'T', 12);

  print('Network:');
  print('     ┌──10──▶ A ──7──┐');
  print('     │        │      ▼');
  print('  S ─┤        5      C ──10──▶ T');
  print('     │        ▼      ▲         ▲');
  print('     └──8───▶ B ──6──┘         │');
  print('              │                │');
  print('              └────3───▶ D ─12─┘');
  print('');

  // Capacities
  print('--- Capacities ---');
  print('Capacity S→A: ${flow.getCapacity('S', 'A')}');
  print('Capacity A→C: ${flow.getCapacity('A', 'C')}');

  // Maximum flow
  print('\n--- Maximum Flow (Edmonds-Karp) ---');
  final maxFlow = flow.maxFlow('S', 'T');
  print('Maximum flow from S to T: $maxFlow');

  // Flow on edges
  print('\n--- Flow on Each Edge ---');
  final flowNetwork = flow.getFlowNetwork();
  for (final entry in flowNetwork.entries) {
    final from = entry.key.$1;
    final to = entry.key.$2;
    final f = entry.value;
    final c = flow.getCapacity(from, to);
    print('  $from → $to: $f / $c');
  }

  // Residual capacity
  print('\n--- Residual Capacities ---');
  print('Residual S→A: ${flow.getResidualCapacity('S', 'A')}');
  print('Residual A→C: ${flow.getResidualCapacity('A', 'C')}');

  // Min-cut
  print('\n--- Minimum Cut ---');
  final minCut = flow.minCut('S', 'T');
  print('Min-cut edges:');
  for (final edge in minCut) {
    final (from, to, capacity) = edge;
    print('  $from → $to (capacity: $capacity)');
  }
  print('Min-cut capacity = Max-flow = $maxFlow');

  // Reset and recompute
  print('\n--- Reset Flow ---');
  flow.reset();
  print('After reset, flow S→A: ${flow.getFlow('S', 'A')}');

  // Bipartite matching example
  print('\n--- Use Case: Bipartite Matching ---');
  final matching = FlowNetwork<String>();

  // Source to left side
  matching.addEdge('source', 'L1', 1);
  matching.addEdge('source', 'L2', 1);
  matching.addEdge('source', 'L3', 1);

  // Left to right (edges)
  matching.addEdge('L1', 'R1', 1);
  matching.addEdge('L1', 'R2', 1);
  matching.addEdge('L2', 'R2', 1);
  matching.addEdge('L2', 'R3', 1);
  matching.addEdge('L3', 'R1', 1);

  // Right to sink
  matching.addEdge('R1', 'sink', 1);
  matching.addEdge('R2', 'sink', 1);
  matching.addEdge('R3', 'sink', 1);

  print('Bipartite graph:');
  print('  L1 -- R1');
  print('   ╲    ╱');
  print('    ╲  ╱');
  print('  L2 -- R2');
  print('   ╲    ╱');
  print('    ╲  ╱');
  print('  L3 -- R3 (no connection)');
  print('');

  final maxMatching = matching.maxFlow('source', 'sink');
  print('Maximum matching: $maxMatching pairs');

  print('\n');
}

void graphAlgorithmsExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                   GRAPH ALGORITHMS                         │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Connected Components
  print('--- Connected Components ---');
  final graph = Graph<int>();

  // Component 1
  graph.addEdge(1, 2);
  graph.addEdge(2, 3);

  // Component 2
  graph.addEdge(4, 5);
  graph.addEdge(5, 6);

  // Component 3 (isolated)
  graph.addVertex(7);

  print('Graph with 3 components:');
  print('  1-2-3   4-5-6   7');
  print('');
  print('Is connected: ${graph.isConnected}');
  print('Connected components: ${graph.connectedComponents}');

  // Path finding
  print('\n--- Path Finding ---');
  final pathGraph = Graph<String>();
  pathGraph.addEdge('A', 'B');
  pathGraph.addEdge('A', 'C');
  pathGraph.addEdge('B', 'D');
  pathGraph.addEdge('C', 'D');
  pathGraph.addEdge('D', 'E');

  print('Graph: A-B-D-E, A-C-D');
  print('');
  print('BFS Path A → E: ${pathGraph.bfsPath('A', 'E')}');
  print('DFS Path A → E: ${pathGraph.dfsPath('A', 'E')}');
  print('Has path A → E: ${pathGraph.hasPath('A', 'E')}');

  // Shortest path (BFS)
  print('\n--- Shortest Path (Unweighted) ---');
  print('BFS finds shortest path in unweighted graphs');
  print('Shortest path A → E: ${pathGraph.bfsPath('A', 'E')}');

  // Cycle detection
  print('\n--- Cycle Detection ---');
  final cycleGraph = Graph<int>();
  cycleGraph.addEdge(1, 2);
  cycleGraph.addEdge(2, 3);
  print('Graph 1-2-3 (no cycle): ${cycleGraph.hasCycle}');

  cycleGraph.addEdge(3, 1);  // Creates cycle
  print('After adding 3-1 (cycle): ${cycleGraph.hasCycle}');

  // Directed cycle
  print('\n--- Directed Cycle Detection ---');
  final dag = Graph<String>(type: GraphType.directed);
  dag.addEdge('A', 'B');
  dag.addEdge('B', 'C');
  dag.addEdge('A', 'C');
  print('DAG A→B→C, A→C: ${dag.hasCycle}');

  dag.addEdge('C', 'A');
  print('After adding C→A: ${dag.hasCycle}');

  // Use case: Course prerequisites
  print('\n--- Use Case: Course Prerequisites ---');
  final courses = Graph<String>(type: GraphType.directed);
  courses.addEdge('Calculus I', 'Calculus II');
  courses.addEdge('Calculus II', 'Calculus III');
  courses.addEdge('Calculus I', 'Linear Algebra');
  courses.addEdge('Linear Algebra', 'Differential Equations');
  courses.addEdge('Calculus II', 'Differential Equations');

  print('Prerequisites graph:');
  print('  Calculus I → Calculus II → Calculus III');
  print('      ↓              ↓');
  print('  Linear Algebra → Differential Equations');
  print('');

  print('Valid course order: ${courses.topologicalSort()}');

  // Can I take Differential Equations?
  print('\nTo take Differential Equations, you need:');
  final prereqs = <String>[];
  for (final course in courses.dfs('Calculus I')) {
    if (courses.hasPath(course, 'Differential Equations')) {
      prereqs.add(course);
    }
  }
  print('  ${prereqs.join(' → ')} → Differential Equations');

  // Use case: Social network
  print('\n--- Use Case: Social Network ---');
  final network = Graph<String>();
  network.addEdge('Alice', 'Bob');
  network.addEdge('Alice', 'Charlie');
  network.addEdge('Bob', 'Diana');
  network.addEdge('Charlie', 'Diana');
  network.addEdge('Diana', 'Eve');

  print('Social network:');
  print('  Alice -- Bob');
  print('    |       |');
  print('  Charlie--Diana -- Eve');
  print('');

  // Degrees of separation
  int? degreesOfSeparation(String from, String to) {
    final path = network.bfsPath(from, to);
    return path != null ? path.length - 1 : null;
  }

  print('Degrees of separation:');
  print('  Alice → Eve: ${degreesOfSeparation('Alice', 'Eve')}');
  print('  Alice → Bob: ${degreesOfSeparation('Alice', 'Bob')}');
  print('  Bob → Charlie: ${degreesOfSeparation('Bob', 'Charlie')}');

  // Most connected person
  print('\nMost connected person:');
  String mostConnected = network.vertices.first;
  var maxDegree = 0;
  for (final person in network.vertices) {
    if (network.degree(person) > maxDegree) {
      maxDegree = network.degree(person);
      mostConnected = person;
    }
  }
  print('  $mostConnected with $maxDegree connections');

  print('\n');
}
