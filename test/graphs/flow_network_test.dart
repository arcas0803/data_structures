import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('FlowNetwork', () {
    late FlowNetwork<String> network;

    setUp(() {
      network = FlowNetwork<String>();
    });

    group('Empty network operations', () {
      test('should start empty', () {
        expect(network.isEmpty, isTrue);
        expect(network.isNotEmpty, isFalse);
        expect(network.vertexCount, equals(0));
        expect(network.edgeCount, equals(0));
        expect(network.vertices, isEmpty);
      });

      test('should return 0 for max flow on empty network', () {
        expect(network.maxFlow('A', 'B'), equals(0));
      });

      test('should return empty list for min cut on empty network', () {
        expect(network.minCut('A', 'B'), isEmpty);
      });

      test('should return null for getFlowPath on non-existent vertices', () {
        expect(network.getFlowPath('A', 'B'), isNull);
      });

      test('should return false for hasAugmentingPath on empty network', () {
        expect(network.hasAugmentingPath('A', 'B'), isFalse);
      });

      test('should return empty map for getFlowNetwork on empty network', () {
        expect(network.getFlowNetwork(), isEmpty);
      });
    });

    group('addVertex', () {
      test('should add vertices', () {
        expect(network.addVertex('A'), isTrue);
        expect(network.addVertex('B'), isTrue);
        expect(network.vertexCount, equals(2));
        expect(network.hasVertex('A'), isTrue);
        expect(network.hasVertex('B'), isTrue);
      });

      test('should return false for duplicate vertex', () {
        expect(network.addVertex('A'), isTrue);
        expect(network.addVertex('A'), isFalse);
        expect(network.vertexCount, equals(1));
      });
    });

    group('removeVertex', () {
      test('should remove existing vertex', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 10);
        expect(network.removeVertex('B'), isTrue);
        expect(network.hasVertex('B'), isFalse);
        expect(network.hasEdge('A', 'B'), isFalse);
        expect(network.vertexCount, equals(2));
      });

      test('should return false for non-existent vertex', () {
        expect(network.removeVertex('X'), isFalse);
      });

      test('should remove all edges to and from vertex', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 10);
        network.addEdge('C', 'B', 5);
        network.removeVertex('B');
        expect(network.edgeCount, equals(0));
      });
    });

    group('addEdge with capacity', () {
      test('should add edge with capacity', () {
        network.addEdge('A', 'B', 10);
        expect(network.hasEdge('A', 'B'), isTrue);
        expect(network.getCapacity('A', 'B'), equals(10));
        expect(network.edgeCount, equals(1));
      });

      test('should auto-create vertices when adding edge', () {
        network.addEdge('A', 'B', 10);
        expect(network.hasVertex('A'), isTrue);
        expect(network.hasVertex('B'), isTrue);
        expect(network.vertexCount, equals(2));
      });

      test('should update capacity if edge exists', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('A', 'B', 20);
        expect(network.getCapacity('A', 'B'), equals(20));
        expect(network.edgeCount, equals(1));
      });

      test('should throw on negative capacity', () {
        expect(() => network.addEdge('A', 'B', -5), throwsArgumentError);
      });

      test('should initialize flow to 0', () {
        network.addEdge('A', 'B', 10);
        expect(network.getFlow('A', 'B'), equals(0));
      });
    });

    group('removeEdge', () {
      test('should remove existing edge', () {
        network.addEdge('A', 'B', 10);
        expect(network.removeEdge('A', 'B'), isTrue);
        expect(network.hasEdge('A', 'B'), isFalse);
      });

      test('should return false for non-existent edge', () {
        network.addVertex('A');
        expect(network.removeEdge('A', 'B'), isFalse);
      });

      test('should return false for non-existent source vertex', () {
        expect(network.removeEdge('X', 'Y'), isFalse);
      });

      test('should keep vertices after removing edge', () {
        network.addEdge('A', 'B', 10);
        network.removeEdge('A', 'B');
        expect(network.hasVertex('A'), isTrue);
        expect(network.hasVertex('B'), isTrue);
      });
    });

    group('getCapacity, getFlow, getResidualCapacity', () {
      test('should return 0 for capacity of non-existent edge', () {
        expect(network.getCapacity('A', 'B'), equals(0));
      });

      test('should return 0 for flow on non-existent edge', () {
        expect(network.getFlow('A', 'B'), equals(0));
      });

      test('should return residual capacity correctly', () {
        network.addEdge('A', 'B', 10);
        network.setFlow('A', 'B', 3);
        expect(network.getResidualCapacity('A', 'B'), equals(7));
      });

      test('should return reverse flow as residual capacity', () {
        network.addEdge('A', 'B', 10);
        network.setFlow('A', 'B', 5);
        expect(network.getResidualCapacity('B', 'A'), equals(5));
      });

      test('should return 0 residual for non-existent edge pair', () {
        expect(network.getResidualCapacity('X', 'Y'), equals(0));
      });
    });

    group('setFlow', () {
      test('should set flow within capacity', () {
        network.addEdge('A', 'B', 10);
        network.setFlow('A', 'B', 5);
        expect(network.getFlow('A', 'B'), equals(5));
      });

      test('should allow setting flow to capacity', () {
        network.addEdge('A', 'B', 10);
        network.setFlow('A', 'B', 10);
        expect(network.getFlow('A', 'B'), equals(10));
      });

      test('should throw on negative flow', () {
        network.addEdge('A', 'B', 10);
        expect(() => network.setFlow('A', 'B', -1), throwsArgumentError);
      });

      test('should throw when flow exceeds capacity', () {
        network.addEdge('A', 'B', 10);
        expect(() => network.setFlow('A', 'B', 15), throwsArgumentError);
      });
    });

    group('maxFlow (Edmonds-Karp)', () {
      test('simple linear path', () {
        // A --10--> B --5--> C
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 5);
        expect(network.maxFlow('A', 'C'), equals(5));
      });

      test('multiple parallel paths', () {
        // A --10--> B --10--> D
        // A --10--> C --10--> D
        network.addEdge('A', 'B', 10);
        network.addEdge('A', 'C', 10);
        network.addEdge('B', 'D', 10);
        network.addEdge('C', 'D', 10);
        expect(network.maxFlow('A', 'D'), equals(20));
      });

      test('bottleneck scenario', () {
        // A --100--> B --1--> C --100--> D
        network.addEdge('A', 'B', 100);
        network.addEdge('B', 'C', 1);
        network.addEdge('C', 'D', 100);
        expect(network.maxFlow('A', 'D'), equals(1));
      });

      test('complete bipartite graph', () {
        // Source S connects to A, B
        // A, B connect to X, Y
        // X, Y connect to Sink T
        network.addEdge('S', 'A', 10);
        network.addEdge('S', 'B', 10);
        network.addEdge('A', 'X', 5);
        network.addEdge('A', 'Y', 5);
        network.addEdge('B', 'X', 5);
        network.addEdge('B', 'Y', 5);
        network.addEdge('X', 'T', 10);
        network.addEdge('Y', 'T', 10);
        expect(network.maxFlow('S', 'T'), equals(20));
      });

      test('diamond/rhombus graph', () {
        //       B
        //     /   \
        // A -+     +-> D
        //     \   /
        //       C
        network.addEdge('A', 'B', 10);
        network.addEdge('A', 'C', 10);
        network.addEdge('B', 'D', 10);
        network.addEdge('C', 'D', 10);
        expect(network.maxFlow('A', 'D'), equals(20));
      });

      test('complex network with multiple paths', () {
        // Classic Ford-Fulkerson example
        network.addEdge('S', 'A', 10);
        network.addEdge('S', 'B', 10);
        network.addEdge('A', 'B', 2);
        network.addEdge('A', 'C', 4);
        network.addEdge('A', 'D', 8);
        network.addEdge('B', 'D', 9);
        network.addEdge('C', 'T', 10);
        network.addEdge('D', 'C', 6);
        network.addEdge('D', 'T', 10);
        expect(network.maxFlow('S', 'T'), equals(19));
      });

      test('no path from source to sink returns 0', () {
        network.addVertex('A');
        network.addVertex('B');
        expect(network.maxFlow('A', 'B'), equals(0));
      });

      test('single edge', () {
        network.addEdge('A', 'B', 42);
        expect(network.maxFlow('A', 'B'), equals(42));
      });

      test('source equals sink returns 0', () {
        network.addVertex('A');
        expect(network.maxFlow('A', 'A'), equals(0));
      });

      test('non-existent source returns 0', () {
        network.addVertex('B');
        expect(network.maxFlow('X', 'B'), equals(0));
      });

      test('non-existent sink returns 0', () {
        network.addVertex('A');
        expect(network.maxFlow('A', 'X'), equals(0));
      });
    });

    group('minCut', () {
      test('should separate source from sink', () {
        network.addEdge('S', 'A', 10);
        network.addEdge('A', 'T', 5);
        final cut = network.minCut('S', 'T');
        expect(cut, isNotEmpty);

        // Verify cut edges go from reachable to non-reachable
        final cutCapacity = cut.fold<num>(0, (sum, e) => sum + e.$3);
        expect(cutCapacity, equals(5)); // Min cut = max flow
      });

      test('min cut capacity equals max flow', () {
        network.addEdge('S', 'A', 10);
        network.addEdge('S', 'B', 10);
        network.addEdge('A', 'T', 5);
        network.addEdge('B', 'T', 15);

        final maxFlowValue = network.maxFlow('S', 'T');
        network.reset();
        final cut = network.minCut('S', 'T');
        final cutCapacity = cut.fold<num>(0, (sum, e) => sum + e.$3);

        expect(cutCapacity, equals(maxFlowValue));
      });

      test('complex network min cut', () {
        network.addEdge('S', 'A', 16);
        network.addEdge('S', 'C', 13);
        network.addEdge('A', 'B', 12);
        network.addEdge('A', 'C', 10);
        network.addEdge('B', 'C', 9);
        network.addEdge('B', 'T', 20);
        network.addEdge('C', 'D', 14);
        network.addEdge('D', 'B', 7);
        network.addEdge('D', 'T', 4);

        final cut = network.minCut('S', 'T');
        final cutCapacity = cut.fold<num>(0, (sum, e) => sum + e.$3);

        // Max flow for this network is 23
        expect(cutCapacity, equals(23));
      });
    });

    group('getFlowPath (augmenting path)', () {
      test('should find path in simple network', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 10);
        final path = network.getFlowPath('A', 'C');
        expect(path, equals(['A', 'B', 'C']));
      });

      test('should return single vertex path when source equals sink', () {
        network.addVertex('A');
        final path = network.getFlowPath('A', 'A');
        expect(path, equals(['A']));
      });

      test('should return null when no path exists', () {
        network.addVertex('A');
        network.addVertex('B');
        expect(network.getFlowPath('A', 'B'), isNull);
      });

      test('should find path through residual edges', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 10);
        network.setFlow('A', 'B', 10);
        network.setFlow('B', 'C', 5);

        // Path A->B is saturated, but B->C still has capacity
        // Since A->B is saturated, no forward path
        final path = network.getFlowPath('A', 'C');
        expect(path, isNull);
      });
    });

    group('hasAugmentingPath', () {
      test('should return true when path exists', () {
        network.addEdge('A', 'B', 10);
        expect(network.hasAugmentingPath('A', 'B'), isTrue);
      });

      test('should return false when no path exists', () {
        network.addVertex('A');
        network.addVertex('B');
        expect(network.hasAugmentingPath('A', 'B'), isFalse);
      });

      test('should return false when all paths saturated', () {
        network.addEdge('A', 'B', 10);
        network.setFlow('A', 'B', 10);
        expect(network.hasAugmentingPath('A', 'B'), isFalse);
      });
    });

    group('Properties', () {
      test('vertices returns all vertices', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 10);
        network.addVertex('D');
        expect(network.vertices.toSet(), equals({'A', 'B', 'C', 'D'}));
      });

      test('vertexCount is correct', () {
        network.addVertex('A');
        network.addVertex('B');
        network.addEdge('C', 'D', 10);
        expect(network.vertexCount, equals(4));
      });

      test('edgeCount is correct', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 10);
        network.addEdge('A', 'C', 5);
        expect(network.edgeCount, equals(3));
      });
    });

    group('totalFlow', () {
      test('should return total flow from source', () {
        network.addEdge('S', 'A', 10);
        network.addEdge('S', 'B', 10);
        network.addEdge('A', 'T', 10);
        network.addEdge('B', 'T', 10);
        network.maxFlow('S', 'T');
        expect(network.totalFlow('S'), equals(20));
      });

      test('should return 0 for non-existent vertex', () {
        expect(network.totalFlow('X'), equals(0));
      });

      test('should return 0 before computing max flow', () {
        network.addEdge('S', 'T', 10);
        expect(network.totalFlow('S'), equals(0));
      });
    });

    group('getFlowNetwork', () {
      test('should return all edge flows', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 5);
        network.setFlow('A', 'B', 3);
        network.setFlow('B', 'C', 2);

        final flows = network.getFlowNetwork();
        expect(flows[('A', 'B')], equals(3));
        expect(flows[('B', 'C')], equals(2));
        expect(flows.length, equals(2));
      });
    });

    group('reset', () {
      test('should clear all flows', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 10);
        network.setFlow('A', 'B', 5);
        network.setFlow('B', 'C', 3);

        network.reset();

        expect(network.getFlow('A', 'B'), equals(0));
        expect(network.getFlow('B', 'C'), equals(0));
      });

      test('should preserve capacities after reset', () {
        network.addEdge('A', 'B', 10);
        network.setFlow('A', 'B', 5);
        network.reset();
        expect(network.getCapacity('A', 'B'), equals(10));
      });

      test('should preserve vertices and edges after reset', () {
        network.addEdge('A', 'B', 10);
        network.reset();
        expect(network.hasVertex('A'), isTrue);
        expect(network.hasEdge('A', 'B'), isTrue);
      });
    });

    group('Flow conservation', () {
      test('flow in equals flow out at intermediate vertices', () {
        network.addEdge('S', 'A', 10);
        network.addEdge('S', 'B', 10);
        network.addEdge('A', 'C', 10);
        network.addEdge('B', 'C', 10);
        network.addEdge('C', 'T', 15);

        network.maxFlow('S', 'T');

        // For vertex A: flow in from S should equal flow out to C
        final flowIntoA = network.getFlow('S', 'A');
        final flowOutOfA = network.getFlow('A', 'C');
        expect(flowIntoA, equals(flowOutOfA));

        // For vertex B: flow in from S should equal flow out to C
        final flowIntoB = network.getFlow('S', 'B');
        final flowOutOfB = network.getFlow('B', 'C');
        expect(flowIntoB, equals(flowOutOfB));

        // For vertex C: flow in should equal flow out
        final flowIntoC = network.getFlow('A', 'C') + network.getFlow('B', 'C');
        final flowOutOfC = network.getFlow('C', 'T');
        expect(flowIntoC, equals(flowOutOfC));
      });
    });

    group('Capacity constraints', () {
      test('flow never exceeds capacity', () {
        network.addEdge('S', 'A', 10);
        network.addEdge('S', 'B', 15);
        network.addEdge('A', 'T', 5);
        network.addEdge('B', 'T', 20);

        network.maxFlow('S', 'T');

        final flows = network.getFlowNetwork();
        for (final entry in flows.entries) {
          final from = entry.key.$1;
          final to = entry.key.$2;
          final flow = entry.value;
          final capacity = network.getCapacity(from, to);
          expect(flow, lessThanOrEqualTo(capacity),
              reason: 'Flow $flow exceeds capacity $capacity on edge $from->$to');
        }
      });
    });

    group('clear', () {
      test('should remove all vertices and edges', () {
        network.addEdge('A', 'B', 10);
        network.addEdge('B', 'C', 10);
        network.setFlow('A', 'B', 5);

        network.clear();

        expect(network.isEmpty, isTrue);
        expect(network.vertexCount, equals(0));
        expect(network.edgeCount, equals(0));
        expect(network.getFlowNetwork(), isEmpty);
      });
    });

    group('FlowEdge', () {
      test('should create edge with destination and capacity', () {
        final edge = FlowEdge('B', 10);
        expect(edge.destination, equals('B'));
        expect(edge.capacity, equals(10));
      });

      test('should compare edges correctly', () {
        final edge1 = FlowEdge('B', 10);
        final edge2 = FlowEdge('B', 10);
        final edge3 = FlowEdge('C', 10);
        final edge4 = FlowEdge('B', 20);

        expect(edge1, equals(edge2));
        expect(edge1, isNot(equals(edge3)));
        expect(edge1, isNot(equals(edge4)));
      });

      test('should have correct toString', () {
        final edge = FlowEdge('B', 10);
        expect(edge.toString(), equals('-(10)->B'));
      });
    });

    group('Integer vertices', () {
      test('should work with integer vertices', () {
        final intNetwork = FlowNetwork<int>();
        intNetwork.addEdge(0, 1, 10);
        intNetwork.addEdge(1, 2, 5);
        expect(intNetwork.maxFlow(0, 2), equals(5));
      });
    });
  });
}
