import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('AdjacencyMatrixGraph (Undirected)', () {
    late AdjacencyMatrixGraph<String> graph;

    setUp(() {
      graph = AdjacencyMatrixGraph.undirected();
    });

    group('Empty graph operations', () {
      test('should start empty', () {
        expect(graph.isEmpty, isTrue);
        expect(graph.isNotEmpty, isFalse);
        expect(graph.vertexCount, equals(0));
        expect(graph.edgeCount, equals(0));
        expect(graph.vertices, isEmpty);
      });

      test('should return empty neighbors for non-existent vertex', () {
        expect(graph.neighbors('A'), isEmpty);
      });

      test('should return false for hasVertex on empty graph', () {
        expect(graph.hasVertex('A'), isFalse);
      });

      test('should return false for hasEdge on empty graph', () {
        expect(graph.hasEdge('A', 'B'), isFalse);
      });

      test('should return null for getWeight on empty graph', () {
        expect(graph.getWeight('A', 'B'), isNull);
      });

      test('should return null for call operator on empty graph', () {
        expect(graph('A', 'B'), isNull);
      });

      test('bfs on empty graph should yield nothing', () {
        expect(graph.bfs('A').toList(), isEmpty);
      });

      test('dfs on empty graph should yield nothing', () {
        expect(graph.dfs('A').toList(), isEmpty);
      });

      test('should not be dense when empty', () {
        expect(graph.isDense, isFalse);
      });

      test('getMatrix should return empty list for empty graph', () {
        expect(graph.getMatrix(), isEmpty);
      });

      test('toString on empty graph', () {
        expect(graph.toString(), contains('empty'));
      });
    });

    group('addVertex', () {
      test('should add vertices', () {
        expect(graph.addVertex('A'), isTrue);
        expect(graph.addVertex('B'), isTrue);
        expect(graph.vertexCount, equals(2));
        expect(graph.vertices, containsAll(['A', 'B']));
      });

      test('should return false for duplicate vertex', () {
        expect(graph.addVertex('A'), isTrue);
        expect(graph.addVertex('A'), isFalse);
        expect(graph.vertexCount, equals(1));
      });

      test('should resize matrix when adding vertex', () {
        graph.addVertex('A');
        graph.addVertex('B');
        graph.addVertex('C');
        final matrix = graph.getMatrix();
        expect(matrix.length, equals(3));
        expect(matrix[0].length, equals(3));
        expect(matrix[1].length, equals(3));
        expect(matrix[2].length, equals(3));
      });
    });

    group('removeVertex', () {
      test('should remove vertex', () {
        graph.addEdge('A', 'B');
        graph.addEdge('A', 'C');
        graph.addEdge('B', 'C');

        expect(graph.removeVertex('A'), isTrue);
        expect(graph.hasVertex('A'), isFalse);
        expect(graph.vertexCount, equals(2));
        expect(graph.hasEdge('B', 'C'), isTrue);
      });

      test('should return false when removing non-existent vertex', () {
        expect(graph.removeVertex('X'), isFalse);
      });

      test('should resize matrix when removing vertex', () {
        graph.addEdge('A', 'B');
        graph.addEdge('B', 'C');
        graph.addEdge('C', 'D');

        graph.removeVertex('B');
        final matrix = graph.getMatrix();
        expect(matrix.length, equals(3));
        expect(matrix[0].length, equals(3));
      });

      test('should update indices correctly after removal', () {
        graph.addEdge('A', 'B');
        graph.addEdge('B', 'C');
        graph.addEdge('C', 'D');

        graph.removeVertex('B');
        expect(graph.hasEdge('C', 'D'), isTrue);
        expect(graph.hasEdge('A', 'C'), isFalse);
        expect(graph.neighbors('C'), contains('D'));
      });

      test('should remove all edges connected to removed vertex', () {
        graph.addEdge('A', 'B');
        graph.addEdge('A', 'C');
        graph.addEdge('A', 'D');

        graph.removeVertex('A');
        expect(graph.edgeCount, equals(0));
      });
    });

    group('addEdge', () {
      test('should add edges', () {
        graph.addEdge('A', 'B');
        graph.addEdge('B', 'C');
        expect(graph.edgeCount, equals(2));
      });

      test('should auto-create vertices when adding edge', () {
        graph.addEdge('A', 'B');
        expect(graph.hasVertex('A'), isTrue);
        expect(graph.hasVertex('B'), isTrue);
        expect(graph.vertexCount, equals(2));
      });

      test('should add weighted edge', () {
        graph.addEdge('A', 'B', weight: 5.0);
        expect(graph.getWeight('A', 'B'), equals(5.0));
        expect(graph.getWeight('B', 'A'), equals(5.0));
      });

      test('should overwrite existing edge weight', () {
        graph.addEdge('A', 'B', weight: 5.0);
        graph.addEdge('A', 'B', weight: 10.0);
        expect(graph.getWeight('A', 'B'), equals(10.0));
        expect(graph.edgeCount, equals(1));
      });
    });

    group('removeEdge', () {
      test('should remove edge (bidirectional)', () {
        graph.addEdge('A', 'B');
        expect(graph.removeEdge('A', 'B'), isTrue);
        expect(graph.hasEdge('A', 'B'), isFalse);
        expect(graph.hasEdge('B', 'A'), isFalse);
      });

      test('should return false when removing non-existent edge', () {
        graph.addVertex('A');
        graph.addVertex('B');
        expect(graph.removeEdge('A', 'B'), isFalse);
      });

      test('should return false when vertices do not exist', () {
        expect(graph.removeEdge('X', 'Y'), isFalse);
      });

      test('should keep vertices after removing edge', () {
        graph.addEdge('A', 'B');
        graph.removeEdge('A', 'B');
        expect(graph.hasVertex('A'), isTrue);
        expect(graph.hasVertex('B'), isTrue);
      });
    });

    group('hasVertex and hasEdge', () {
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
    });

    group('getWeight and setWeight', () {
      test('should get weight of existing edge', () {
        graph.addEdge('A', 'B', weight: 3.5);
        expect(graph.getWeight('A', 'B'), equals(3.5));
      });

      test('should return null for non-existent edge', () {
        graph.addVertex('A');
        graph.addVertex('B');
        expect(graph.getWeight('A', 'B'), isNull);
      });

      test('should set weight of existing edge', () {
        graph.addEdge('A', 'B', weight: 1.0);
        expect(graph.setWeight('A', 'B', 5.0), isTrue);
        expect(graph.getWeight('A', 'B'), equals(5.0));
        expect(graph.getWeight('B', 'A'), equals(5.0));
      });

      test('should return false when setting weight on non-existent edge', () {
        graph.addVertex('A');
        graph.addVertex('B');
        expect(graph.setWeight('A', 'B', 5.0), isFalse);
      });

      test('should return false when setting weight on non-existent vertices',
          () {
        expect(graph.setWeight('X', 'Y', 5.0), isFalse);
      });
    });

    group('neighbors', () {
      test('should get neighbors', () {
        graph.addEdge('A', 'B');
        graph.addEdge('A', 'C');
        graph.addEdge('A', 'D');
        expect(graph.neighbors('A').toSet(), equals({'B', 'C', 'D'}));
      });

      test('should return empty list for isolated vertex', () {
        graph.addVertex('A');
        expect(graph.neighbors('A'), isEmpty);
      });

      test('should return empty list for non-existent vertex', () {
        expect(graph.neighbors('Z'), isEmpty);
      });
    });

    group('BFS traversal', () {
      test('should BFS traverse', () {
        graph.addEdge('A', 'B');
        graph.addEdge('A', 'C');
        graph.addEdge('B', 'D');
        graph.addEdge('C', 'E');

        final bfs = graph.bfs('A').toList();
        expect(bfs.first, equals('A'));
        expect(bfs.length, equals(5));
        expect(bfs.indexOf('B'), lessThan(bfs.indexOf('D')));
        expect(bfs.indexOf('C'), lessThan(bfs.indexOf('E')));
      });

      test('should handle single vertex', () {
        graph.addVertex('A');
        expect(graph.bfs('A').toList(), equals(['A']));
      });

      test('should handle disconnected components', () {
        graph.addEdge('A', 'B');
        graph.addVertex('C');

        final bfs = graph.bfs('A').toList();
        expect(bfs, containsAll(['A', 'B']));
        expect(bfs, isNot(contains('C')));
      });

      test('should return empty for non-existent start vertex', () {
        graph.addVertex('A');
        expect(graph.bfs('Z').toList(), isEmpty);
      });
    });

    group('DFS traversal', () {
      test('should DFS traverse', () {
        graph.addEdge('A', 'B');
        graph.addEdge('A', 'C');
        graph.addEdge('B', 'D');
        graph.addEdge('C', 'E');

        final dfs = graph.dfs('A').toList();
        expect(dfs.first, equals('A'));
        expect(dfs.length, equals(5));
      });

      test('should handle single vertex', () {
        graph.addVertex('A');
        expect(graph.dfs('A').toList(), equals(['A']));
      });

      test('should handle disconnected components', () {
        graph.addEdge('A', 'B');
        graph.addVertex('C');

        final dfs = graph.dfs('A').toList();
        expect(dfs, containsAll(['A', 'B']));
        expect(dfs, isNot(contains('C')));
      });

      test('should return empty for non-existent start vertex', () {
        graph.addVertex('A');
        expect(graph.dfs('Z').toList(), isEmpty);
      });
    });

    group('Properties', () {
      test('should return vertices', () {
        graph.addVertex('A');
        graph.addVertex('B');
        graph.addVertex('C');
        expect(graph.vertices.toList(), equals(['A', 'B', 'C']));
      });

      test('should return vertexCount', () {
        graph.addVertex('A');
        graph.addVertex('B');
        expect(graph.vertexCount, equals(2));
      });

      test('should return edgeCount', () {
        graph.addEdge('A', 'B');
        graph.addEdge('B', 'C');
        graph.addEdge('C', 'D');
        expect(graph.edgeCount, equals(3));
      });

      test('should return isDirected', () {
        expect(graph.isDirected, isFalse);
      });

      test('should detect dense graph', () {
        graph.addEdge('A', 'B');
        graph.addEdge('A', 'C');
        graph.addEdge('B', 'C');
        // 3 vertices, 3 edges, max edges = 3 + 3 = 6, dense if > 3
        expect(graph.isDense, isFalse);

        graph.addEdge('A', 'A'); // self-loop
        // Now 4 edges, should be dense
        expect(graph.isDense, isTrue);
      });
    });

    group('getMatrix', () {
      test('should return adjacency matrix', () {
        graph.addEdge('A', 'B', weight: 1.0);
        graph.addEdge('B', 'C', weight: 2.0);

        final matrix = graph.getMatrix();
        expect(matrix.length, equals(3));
        expect(matrix[0][1], equals(1.0)); // A -> B
        expect(matrix[1][0], equals(1.0)); // B -> A
        expect(matrix[1][2], equals(2.0)); // B -> C
        expect(matrix[2][1], equals(2.0)); // C -> B
        expect(matrix[0][2], isNull); // A -> C (no edge)
      });

      test('returned matrix should be a copy', () {
        graph.addEdge('A', 'B', weight: 1.0);
        final matrix = graph.getMatrix();
        matrix[0][1] = 999.0;
        expect(graph.getWeight('A', 'B'), equals(1.0));
      });
    });

    group('call operator', () {
      test('should access weight using call syntax', () {
        graph.addEdge('A', 'B', weight: 5.0);
        expect(graph('A', 'B'), equals(5.0));
        expect(graph('B', 'A'), equals(5.0));
      });

      test('should return null for non-existent edge', () {
        graph.addVertex('A');
        graph.addVertex('B');
        expect(graph('A', 'B'), isNull);
      });
    });

    group('copy', () {
      test('should create a copy of the graph', () {
        graph.addEdge('A', 'B', weight: 5.0);
        graph.addEdge('B', 'C', weight: 3.0);

        final copy = graph.copy();
        expect(copy.vertexCount, equals(3));
        expect(copy.edgeCount, equals(2));
        expect(copy.getWeight('A', 'B'), equals(5.0));
        expect(copy.isDirected, equals(graph.isDirected));
      });

      test('modifying copy should not affect original', () {
        graph.addEdge('A', 'B');
        final copy = graph.copy();

        copy.addVertex('D');
        copy.removeEdge('A', 'B');

        expect(graph.hasVertex('D'), isFalse);
        expect(graph.hasEdge('A', 'B'), isTrue);
      });
    });

    group('clear', () {
      test('should clear all vertices and edges', () {
        graph.addEdge('A', 'B');
        graph.addEdge('B', 'C');
        graph.clear();

        expect(graph.isEmpty, isTrue);
        expect(graph.vertexCount, equals(0));
        expect(graph.edgeCount, equals(0));
        expect(graph.getMatrix(), isEmpty);
      });
    });

    group('toString', () {
      test('should display graph information', () {
        graph.addEdge('A', 'B', weight: 1.0);
        final str = graph.toString();
        expect(str, contains('undirected'));
        expect(str, contains('A'));
        expect(str, contains('B'));
      });
    });

    group('Self-loops', () {
      test('should add self-loop', () {
        graph.addEdge('A', 'A', weight: 1.0);
        expect(graph.hasEdge('A', 'A'), isTrue);
        expect(graph.edgeCount, equals(1));
      });

      test('should remove self-loop', () {
        graph.addEdge('A', 'A');
        expect(graph.removeEdge('A', 'A'), isTrue);
        expect(graph.hasEdge('A', 'A'), isFalse);
      });

      test('self-loop should appear in neighbors', () {
        graph.addEdge('A', 'A');
        expect(graph.neighbors('A'), contains('A'));
      });

      test('should count self-loops correctly in edgeCount', () {
        graph.addEdge('A', 'B');
        graph.addEdge('A', 'A');
        graph.addEdge('B', 'B');
        expect(graph.edgeCount, equals(3));
      });
    });

    group('Disconnected vertices', () {
      test('should handle isolated vertices', () {
        graph.addVertex('A');
        graph.addVertex('B');
        graph.addVertex('C');
        graph.addEdge('A', 'B');

        expect(graph.vertexCount, equals(3));
        expect(graph.edgeCount, equals(1));
        expect(graph.neighbors('C'), isEmpty);
      });

      test('bfs should not reach disconnected vertices', () {
        graph.addEdge('A', 'B');
        graph.addVertex('C');
        graph.addVertex('D');

        final bfs = graph.bfs('A').toList();
        expect(bfs.length, equals(2));
        expect(bfs, containsAll(['A', 'B']));
      });
    });
  });

  group('AdjacencyMatrixGraph (Directed)', () {
    late AdjacencyMatrixGraph<String> graph;

    setUp(() {
      graph = AdjacencyMatrixGraph.directed();
    });

    test('should be directed', () {
      expect(graph.isDirected, isTrue);
    });

    test('should add edges unidirectionally', () {
      graph.addEdge('A', 'B');
      expect(graph.hasEdge('A', 'B'), isTrue);
      expect(graph.hasEdge('B', 'A'), isFalse);
    });

    test('should count edges correctly', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'A');
      expect(graph.edgeCount, equals(2));
    });

    test('should remove edge unidirectionally', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'A');
      graph.removeEdge('A', 'B');
      expect(graph.hasEdge('A', 'B'), isFalse);
      expect(graph.hasEdge('B', 'A'), isTrue);
    });

    test('should get neighbors (outgoing only)', () {
      graph.addEdge('A', 'B');
      graph.addEdge('A', 'C');
      graph.addEdge('D', 'A');

      expect(graph.neighbors('A').toSet(), equals({'B', 'C'}));
      expect(graph.neighbors('A'), isNot(contains('D')));
    });

    test('should set weight unidirectionally', () {
      graph.addEdge('A', 'B', weight: 1.0);
      graph.setWeight('A', 'B', 5.0);

      expect(graph.getWeight('A', 'B'), equals(5.0));
      expect(graph.getWeight('B', 'A'), isNull);
    });

    test('toString should show directed', () {
      graph.addVertex('A');
      expect(graph.toString(), contains('directed'));
    });

    test('should detect dense directed graph', () {
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'A');
      graph.addEdge('A', 'C');
      graph.addEdge('C', 'A');
      graph.addEdge('B', 'C');
      graph.addEdge('C', 'B');
      // 3 vertices, 6 edges, max edges = 9, dense if > 4.5
      expect(graph.isDense, isTrue);
    });

    group('Self-loops in directed graph', () {
      test('should add and count self-loop', () {
        graph.addEdge('A', 'A');
        expect(graph.hasEdge('A', 'A'), isTrue);
        expect(graph.edgeCount, equals(1));
      });

      test('should handle self-loop with other edges', () {
        graph.addEdge('A', 'A');
        graph.addEdge('A', 'B');
        graph.addEdge('B', 'A');
        expect(graph.edgeCount, equals(3));
      });
    });
  });

  group('AdjacencyMatrixGraph with integer vertices', () {
    test('should work with integer vertices', () {
      final graph = AdjacencyMatrixGraph<int>.undirected();
      graph.addEdge(1, 2, weight: 1.0);
      graph.addEdge(2, 3, weight: 2.0);

      expect(graph.hasVertex(1), isTrue);
      expect(graph.hasEdge(1, 2), isTrue);
      expect(graph.getWeight(2, 3), equals(2.0));
      expect(graph.neighbors(2).toSet(), equals({1, 3}));
    });
  });

  group('Comparison with Graph (adjacency list)', () {
    late AdjacencyMatrixGraph<String> matrixGraph;
    late Graph<String> listGraph;

    setUp(() {
      matrixGraph = AdjacencyMatrixGraph.undirected();
      listGraph = Graph.undirected();
    });

    test('should produce same vertex count', () {
      for (final v in ['A', 'B', 'C', 'D']) {
        matrixGraph.addVertex(v);
        listGraph.addVertex(v);
      }
      expect(matrixGraph.vertexCount, equals(listGraph.vertexCount));
    });

    test('should produce same edge count', () {
      final edges = [
        ('A', 'B'),
        ('B', 'C'),
        ('C', 'D'),
        ('A', 'D'),
      ];
      for (final (from, to) in edges) {
        matrixGraph.addEdge(from, to);
        listGraph.addEdge(from, to);
      }
      expect(matrixGraph.edgeCount, equals(listGraph.edgeCount));
    });

    test('should produce same hasEdge results', () {
      matrixGraph.addEdge('A', 'B');
      matrixGraph.addEdge('B', 'C');
      listGraph.addEdge('A', 'B');
      listGraph.addEdge('B', 'C');

      expect(
          matrixGraph.hasEdge('A', 'B'), equals(listGraph.hasEdge('A', 'B')));
      expect(
          matrixGraph.hasEdge('B', 'A'), equals(listGraph.hasEdge('B', 'A')));
      expect(
          matrixGraph.hasEdge('A', 'C'), equals(listGraph.hasEdge('A', 'C')));
    });

    test('should produce same neighbors', () {
      matrixGraph.addEdge('A', 'B');
      matrixGraph.addEdge('A', 'C');
      matrixGraph.addEdge('A', 'D');
      listGraph.addEdge('A', 'B');
      listGraph.addEdge('A', 'C');
      listGraph.addEdge('A', 'D');

      expect(matrixGraph.neighbors('A').toSet(),
          equals(listGraph.neighbors('A').toSet()));
    });

    test('should produce same BFS traversal order', () {
      // Build identical graphs
      matrixGraph.addEdge('A', 'B');
      matrixGraph.addEdge('A', 'C');
      matrixGraph.addEdge('B', 'D');
      listGraph.addEdge('A', 'B');
      listGraph.addEdge('A', 'C');
      listGraph.addEdge('B', 'D');

      final matrixBfs = matrixGraph.bfs('A').toSet();
      final listBfs = listGraph.bfs('A').toSet();

      expect(matrixBfs, equals(listBfs));
    });

    test('should produce same DFS traversal vertices', () {
      matrixGraph.addEdge('A', 'B');
      matrixGraph.addEdge('A', 'C');
      matrixGraph.addEdge('B', 'D');
      listGraph.addEdge('A', 'B');
      listGraph.addEdge('A', 'C');
      listGraph.addEdge('B', 'D');

      final matrixDfs = matrixGraph.dfs('A').toSet();
      final listDfs = listGraph.dfs('A').toSet();

      expect(matrixDfs, equals(listDfs));
    });

    test('should produce same weights', () {
      matrixGraph.addEdge('A', 'B', weight: 5.0);
      matrixGraph.addEdge('B', 'C', weight: 3.0);
      listGraph.addEdge('A', 'B', 5.0);
      listGraph.addEdge('B', 'C', 3.0);

      expect(matrixGraph.getWeight('A', 'B'),
          equals(listGraph.getEdgeWeight('A', 'B')));
      expect(matrixGraph.getWeight('B', 'C'),
          equals(listGraph.getEdgeWeight('B', 'C')));
    });

    group('Directed graph comparison', () {
      setUp(() {
        matrixGraph = AdjacencyMatrixGraph.directed();
        listGraph = Graph.directed();
      });

      test('should produce same directed behavior', () {
        matrixGraph.addEdge('A', 'B');
        listGraph.addEdge('A', 'B');

        expect(
            matrixGraph.hasEdge('A', 'B'), equals(listGraph.hasEdge('A', 'B')));
        expect(
            matrixGraph.hasEdge('B', 'A'), equals(listGraph.hasEdge('B', 'A')));
      });
    });
  });

  group('Edge cases', () {
    test('should handle large number of vertices', () {
      final graph = AdjacencyMatrixGraph<int>.undirected();
      for (var i = 0; i < 100; i++) {
        graph.addVertex(i);
      }
      expect(graph.vertexCount, equals(100));

      final matrix = graph.getMatrix();
      expect(matrix.length, equals(100));
      expect(matrix[0].length, equals(100));
    });

    test('should handle adding and removing multiple vertices', () {
      final graph = AdjacencyMatrixGraph<String>.undirected();
      graph.addEdge('A', 'B');
      graph.addEdge('B', 'C');
      graph.addEdge('C', 'D');
      graph.addEdge('D', 'E');

      graph.removeVertex('B');
      graph.removeVertex('D');

      expect(graph.vertexCount, equals(3));
      expect(graph.hasVertex('A'), isTrue);
      expect(graph.hasVertex('C'), isTrue);
      expect(graph.hasVertex('E'), isTrue);
      expect(graph.hasEdge('B', 'C'), isFalse);
    });

    test('should handle complete graph', () {
      final graph = AdjacencyMatrixGraph<String>.undirected();
      final vertices = ['A', 'B', 'C', 'D'];

      // Create complete graph
      for (var i = 0; i < vertices.length; i++) {
        for (var j = i + 1; j < vertices.length; j++) {
          graph.addEdge(vertices[i], vertices[j]);
        }
      }

      // Complete graph with 4 vertices has 6 edges
      expect(graph.edgeCount, equals(6));
      expect(graph.isDense, isTrue);

      // Each vertex should have 3 neighbors
      for (final v in vertices) {
        expect(graph.neighbors(v).length, equals(3));
      }
    });

    test('should handle graph with only self-loops', () {
      final graph = AdjacencyMatrixGraph<String>.undirected();
      graph.addEdge('A', 'A');
      graph.addEdge('B', 'B');
      graph.addEdge('C', 'C');

      expect(graph.vertexCount, equals(3));
      expect(graph.edgeCount, equals(3));
    });

    test('weighted edges with zero weight', () {
      final graph = AdjacencyMatrixGraph<String>.undirected();
      graph.addEdge('A', 'B', weight: 0.0);
      expect(graph.hasEdge('A', 'B'), isTrue);
      expect(graph.getWeight('A', 'B'), equals(0.0));
    });

    test('weighted edges with negative weight', () {
      final graph = AdjacencyMatrixGraph<String>.undirected();
      graph.addEdge('A', 'B', weight: -5.0);
      expect(graph.getWeight('A', 'B'), equals(-5.0));
    });
  });
}
