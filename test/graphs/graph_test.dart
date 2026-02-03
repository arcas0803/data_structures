import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('Graph (Undirected)', () {
    late Graph<String> graph;

    setUp(() {
      graph = Graph.undirected();
    });

    test('should start empty', () {
      expect(graph.isEmpty, isTrue);
      expect(graph.vertexCount, equals(0));
      expect(graph.edgeCount, equals(0));
    });

    test('should add vertices', () {
      expect(graph.addVertex('A'), isTrue);
      expect(graph.addVertex('B'), isTrue);
      expect(graph.addVertex('A'), isFalse); // duplicate
      expect(graph.vertexCount, equals(2));
    });

    test('should add edges', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      expect(graph.vertexCount, equals(3));
      expect(graph.edgeCount, equals(2));
    });

    test('should add weighted edges', () {
      graph.addEdge('A', 'B', 5.0);
      expect(graph.getEdgeWeight('A', 'B'), equals(5.0));
      expect(graph.getEdgeWeight('B', 'A'), equals(5.0));
    });

    test('should check hasVertex', () {
      graph.addVertex('A');
      expect(graph.hasVertex('A'), isTrue);
      expect(graph.hasVertex('B'), isFalse);
    });

    test('should check hasEdge (bidirectional)', () {
      graph.addEdge('A', 'B');
      expect(graph.hasEdge('A', 'B'), isTrue);
      expect(graph.hasEdge('B', 'A'), isTrue);
      expect(graph.hasEdge('A', 'C'), isFalse);
    });

    test('should get neighbors', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('A', 'D');
      expect(graph.neighbors('A').toSet(), equals({'B', 'C', 'D'}));
    });

    test('should get degree', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('A', 'D');
      expect(graph.degree('A'), equals(3));
      expect(graph.degree('B'), equals(1));
    });

    test('should remove vertex', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('B', 'C');
      expect(graph.removeVertex('A'), isTrue);
      expect(graph.hasVertex('A'), isFalse);
      expect(graph.hasEdge('B', 'C'), isTrue);
      expect(graph.removeVertex('X'), isFalse);
    });

    test('should remove edge (bidirectional)', () {
      graph.addEdge('A', 'B');
      expect(graph.removeEdge('A', 'B'), isTrue);
      expect(graph.hasEdge('A', 'B'), isFalse);
      expect(graph.hasEdge('B', 'A'), isFalse);
    });

    test('should BFS traverse', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('B', 'D');
      graph.addEdge('C', 'E');

      final bfs = graph.bfs('A').toList();
      expect(bfs.first, equals('A'));
      expect(bfs.length, equals(5));
      // B and C should come before D and E
      expect(bfs.indexOf('B'), lessThan(bfs.indexOf('D')));
      expect(bfs.indexOf('C'), lessThan(bfs.indexOf('E')));
    });

    test('should BFS find shortest path', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addEdge('A', 'D');
      graph.addEdge('D', 'C');

      final path = graph.bfsPath('A', 'C');
      expect(path, isNotNull);
      expect(path!.first, equals('A'));
      expect(path.last, equals('C'));
      expect(path.length, equals(3)); // A -> B -> C or A -> D -> C
    });

    test('should BFS return null for no path', () {
      graph.addVertex('A');
      graph.addVertex('B');
      expect(graph.bfsPath('A', 'B'), isNull);
    });

    test('should BFS get distances', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addEdge('C', 'D');

      final distances = graph.bfsDistances('A');
      expect(distances['A'], equals(0));
      expect(distances['B'], equals(1));
      expect(distances['C'], equals(2));
      expect(distances['D'], equals(3));
    });

    test('should DFS traverse', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('B', 'D');
      graph.addEdge('C', 'E');

      final dfs = graph.dfs('A').toList();
      expect(dfs.first, equals('A'));
      expect(dfs.length, equals(5));
    });

    test('should DFS recursive traverse', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('B', 'D');

      final dfs = graph.dfsRecursive('A');
      expect(dfs.first, equals('A'));
      expect(dfs.length, equals(4));
    });

    test('should DFS find path', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addEdge('C', 'D');

      final path = graph.dfsPath('A', 'D');
      expect(path, isNotNull);
      expect(path!.first, equals('A'));
      expect(path.last, equals('D'));
    });

    test('should check isConnected', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      expect(graph.isConnected, isTrue);

      graph.addVertex('D'); // isolated vertex
      expect(graph.isConnected, isFalse);
    });

    test('should check hasPath', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addVertex('D');

      expect(graph.hasPath('A', 'C'), isTrue);
      expect(graph.hasPath('A', 'D'), isFalse);
    });

    test('should detect cycle', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      expect(graph.hasCycle, isFalse);

      graph.addEdge('C', 'A');
      expect(graph.hasCycle, isTrue);
    });

    test('should find connected components', () {
      graph.addEdge('A', 'B');
      graph.addEdge('C', 'D');
      graph.addVertex('E');

      final components = graph.connectedComponents;
      expect(components.length, equals(3));
    });

    test('should get reachable vertices', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addVertex('D');

      final reachable = graph.reachableFrom('A');
      expect(reachable, equals({'A', 'B', 'C'}));
    });

    test('should clear', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.clear();
      expect(graph.isEmpty, isTrue);
    });

    test('should copy', () {
      graph.addEdge('A', 'B', 5.0);
      graph.addEdge('B', 'C', 3.0);

      final copy = graph.copy();
      expect(copy.vertexCount, equals(3));
      expect(copy.edgeCount, equals(2));
      expect(copy.getEdgeWeight('A', 'B'), equals(5.0));

      // Modifying copy shouldn't affect original
      copy.addVertex('D');
      expect(graph.hasVertex('D'), isFalse);
    });
  });

  group('Graph (Directed)', () {
    late Graph<String> graph;

    setUp(() {
      graph = Graph.directed();
    });

    test('should be directed', () {
      expect(graph.isDirected, isTrue);
    });

    test('should add edges unidirectionally', () {
      graph.addEdge('A', 'B');
      expect(graph.hasEdge('A', 'B'), isTrue);
      expect(graph.hasEdge('B', 'A'), isFalse);
    });

    test('should calculate in-degree and out-degree', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('B', 'C');
      graph.addEdge('D', 'C');

      expect(graph.outDegree('A'), equals(2));
      expect(graph.inDegree('A'), equals(0));
      expect(graph.inDegree('C'), equals(3));
      expect(graph.outDegree('C'), equals(0));
    });

    test('should remove edge unidirectionally', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'A');
      graph.removeEdge('A', 'B');
      expect(graph.hasEdge('A', 'B'), isFalse);
      expect(graph.hasEdge('B', 'A'), isTrue);
    });

    test('should detect cycle in directed graph', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      expect(graph.hasCycle, isFalse);

      graph.addEdge('C', 'A');
      expect(graph.hasCycle, isTrue);
    });

    test('should topological sort DAG', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('B', 'D');
      graph.addEdge('C', 'D');

      final sorted = graph.topologicalSort();
      expect(sorted, isNotNull);
      expect(sorted!.indexOf('A'), lessThan(sorted.indexOf('B')));
      expect(sorted.indexOf('A'), lessThan(sorted.indexOf('C')));
      expect(sorted.indexOf('B'), lessThan(sorted.indexOf('D')));
      expect(sorted.indexOf('C'), lessThan(sorted.indexOf('D')));
    });

    test('should return null for topological sort with cycle', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addEdge('C', 'A');

      expect(graph.topologicalSort(), isNull);
    });

    test('should throw on topological sort for undirected graph', () {
      final undirected = Graph.undirected();
      undirected.addEdge('A', 'B');
      expect(() => undirected.topologicalSort(), throwsStateError);
    });
  });

  group('Graph Edge', () {
    test('should create edge', () {
      final edge = Edge('B', 5.0);
      expect(edge.destination, equals('B'));
      expect(edge.weight, equals(5.0));
    });

    test('should have default weight of 1.0', () {
      final edge = Edge('B');
      expect(edge.weight, equals(1.0));
    });

    test('should compare edges', () {
      final edge1 = Edge('B', 5.0);
      final edge2 = Edge('B', 5.0);
      final edge3 = Edge('C', 5.0);

      expect(edge1, equals(edge2));
      expect(edge1, isNot(equals(edge3)));
    });
  });
}
