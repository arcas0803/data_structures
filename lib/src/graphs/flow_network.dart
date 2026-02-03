/// # Flow Network
///
/// A directed graph for max-flow/min-cut problems using adjacency list representation.
/// Implements the Ford-Fulkerson algorithm with BFS (Edmonds-Karp) for finding maximum flow.
///
/// Time Complexity:
/// - Add vertex: O(1)
/// - Add edge: O(1)
/// - Remove vertex: O(V + E)
/// - Remove edge: O(E)
/// - Max flow (Edmonds-Karp): O(V * E²)
/// - Min cut: O(V * E²)
///
/// Where V = number of vertices, E = number of edges
///
/// Key concepts:
/// - Capacity constraints: flow <= capacity
/// - Flow conservation: flow in = flow out (except source/sink)
/// - Residual graph: remaining capacities after flow
///
/// Use cases: Network flow, bipartite matching, transportation problems.
library;

import '../linear/queue.dart';

/// Represents a flow edge in the network.
class FlowEdge<T> {
  /// The destination vertex.
  final T destination;

  /// The capacity of the edge.
  final num capacity;

  /// Creates a flow edge to [destination] with [capacity].
  const FlowEdge(this.destination, this.capacity);

  @override
  bool operator ==(Object other) =>
      other is FlowEdge<T> &&
      destination == other.destination &&
      capacity == other.capacity;

  @override
  int get hashCode => destination.hashCode ^ capacity.hashCode;

  @override
  String toString() => '-($capacity)->$destination';
}

/// A flow network for max-flow/min-cut problems.
class FlowNetwork<T> {
  /// Adjacency list storing edges with capacities.
  final Map<T, List<FlowEdge<T>>> _adjacencyList = {};

  /// Current flow on each edge: (source, destination) -> flow.
  final Map<(T, T), num> _flow = {};

  /// Creates an empty flow network.
  FlowNetwork();

  /// Returns the number of vertices.
  int get vertexCount => _adjacencyList.length;

  /// Returns the number of edges.
  int get edgeCount {
    var count = 0;
    for (final edges in _adjacencyList.values) {
      count += edges.length;
    }
    return count;
  }

  /// Returns all vertices.
  Iterable<T> get vertices => _adjacencyList.keys;

  /// Returns true if the network is empty.
  bool get isEmpty => _adjacencyList.isEmpty;

  /// Returns true if the network is not empty.
  bool get isNotEmpty => _adjacencyList.isNotEmpty;

  /// Adds a vertex to the network. O(1)
  /// Returns true if the vertex was added (not already present).
  bool addVertex(T vertex) {
    if (_adjacencyList.containsKey(vertex)) return false;
    _adjacencyList[vertex] = [];
    return true;
  }

  /// Adds an edge with [capacity] from [from] to [to]. O(1)
  /// Creates vertices if they don't exist.
  /// If the edge already exists, updates the capacity.
  void addEdge(T from, T to, num capacity) {
    if (capacity < 0) {
      throw ArgumentError('Capacity must be non-negative');
    }

    addVertex(from);
    addVertex(to);

    // Remove existing edge if present
    _adjacencyList[from]!.removeWhere((e) => e.destination == to);

    _adjacencyList[from]!.add(FlowEdge(to, capacity));

    // Initialize flow to 0
    _flow[(from, to)] = 0;
  }

  /// Removes a vertex and all its edges. O(V + E)
  /// Returns true if the vertex was found and removed.
  bool removeVertex(T vertex) {
    if (!_adjacencyList.containsKey(vertex)) return false;

    // Remove all edges pointing to this vertex
    for (final source in _adjacencyList.keys) {
      final edges = _adjacencyList[source]!;
      final hasEdgeToVertex = edges.any((e) => e.destination == vertex);
      if (hasEdgeToVertex) {
        _flow.remove((source, vertex));
      }
      edges.removeWhere((e) => e.destination == vertex);
    }

    // Remove flows from this vertex
    final edgesFromVertex = _adjacencyList[vertex]!;
    for (final edge in edgesFromVertex) {
      _flow.remove((vertex, edge.destination));
    }

    _adjacencyList.remove(vertex);
    return true;
  }

  /// Removes an edge from [from] to [to]. O(E)
  /// Returns true if the edge was found and removed.
  bool removeEdge(T from, T to) {
    if (!_adjacencyList.containsKey(from)) return false;

    final lengthBefore = _adjacencyList[from]!.length;
    _adjacencyList[from]!.removeWhere((e) => e.destination == to);
    final removed = _adjacencyList[from]!.length < lengthBefore;

    if (removed) {
      _flow.remove((from, to));
    }

    return removed;
  }

  /// Returns true if [vertex] exists in the network. O(1)
  bool hasVertex(T vertex) => _adjacencyList.containsKey(vertex);

  /// Returns true if an edge exists from [from] to [to]. O(degree)
  bool hasEdge(T from, T to) {
    final edges = _adjacencyList[from];
    if (edges == null) return false;
    return edges.any((e) => e.destination == to);
  }

  /// Returns the capacity of the edge from [from] to [to].
  /// Returns 0 if no edge exists.
  num getCapacity(T from, T to) {
    final edges = _adjacencyList[from];
    if (edges == null) return 0;
    for (final edge in edges) {
      if (edge.destination == to) return edge.capacity;
    }
    return 0;
  }

  /// Returns the current flow on the edge from [from] to [to].
  /// Returns 0 if no edge exists.
  num getFlow(T from, T to) => _flow[(from, to)] ?? 0;

  /// Returns the residual capacity (capacity - flow) from [from] to [to].
  /// Includes reverse edges in the residual graph.
  num getResidualCapacity(T from, T to) {
    // Forward edge: capacity - flow
    if (hasEdge(from, to)) {
      return getCapacity(from, to) - getFlow(from, to);
    }
    // Reverse edge in residual graph: flow on reverse direction
    if (hasEdge(to, from)) {
      return getFlow(to, from);
    }
    return 0;
  }

  /// Sets the flow on the edge from [from] to [to].
  /// Throws if flow exceeds capacity or is negative.
  void setFlow(T from, T to, num flow) {
    if (flow < 0) {
      throw ArgumentError('Flow must be non-negative');
    }
    final capacity = getCapacity(from, to);
    if (flow > capacity) {
      throw ArgumentError('Flow ($flow) exceeds capacity ($capacity)');
    }
    _flow[(from, to)] = flow;
  }

  /// Returns neighbors of [vertex] in the residual graph.
  List<T> _residualNeighbors(T vertex) {
    final neighbors = <T>[];

    // Forward edges with remaining capacity
    final edges = _adjacencyList[vertex];
    if (edges != null) {
      for (final edge in edges) {
        if (getResidualCapacity(vertex, edge.destination) > 0) {
          neighbors.add(edge.destination);
        }
      }
    }

    // Reverse edges with positive flow
    for (final source in _adjacencyList.keys) {
      if (source == vertex) continue;
      if (hasEdge(source, vertex) && getFlow(source, vertex) > 0) {
        if (!neighbors.contains(source)) {
          neighbors.add(source);
        }
      }
    }

    return neighbors;
  }

  /// Finds an augmenting path from [source] to [sink] using BFS.
  /// Returns the path as a list of vertices, or null if no path exists.
  List<T>? getFlowPath(T source, T sink) {
    if (!hasVertex(source) || !hasVertex(sink)) return null;
    if (source == sink) return [source];

    final visited = <T>{};
    final queue = Queue<T>();
    final parent = <T, T>{};

    visited.add(source);
    queue.enqueue(source);

    while (queue.isNotEmpty) {
      final vertex = queue.dequeue();

      if (vertex == sink) {
        // Reconstruct path
        final path = <T>[sink];
        var current = sink;
        while (parent.containsKey(current)) {
          current = parent[current] as T;
          path.insert(0, current);
        }
        return path;
      }

      for (final neighbor in _residualNeighbors(vertex)) {
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          parent[neighbor] = vertex;
          queue.enqueue(neighbor);
        }
      }
    }

    return null;
  }

  /// Returns true if an augmenting path exists from [source] to [sink].
  bool hasAugmentingPath(T source, T sink) => getFlowPath(source, sink) != null;

  /// Computes the maximum flow from [source] to [sink] using Edmonds-Karp algorithm.
  /// Returns the maximum flow value.
  num maxFlow(T source, T sink) {
    if (!hasVertex(source) || !hasVertex(sink)) return 0;
    if (source == sink) return 0;

    // Reset all flows
    reset();

    num totalFlow = 0;

    // Find augmenting paths until none exist
    var path = getFlowPath(source, sink);
    while (path != null) {
      // Find minimum residual capacity along the path
      num pathFlow = double.infinity;
      for (var i = 0; i < path.length - 1; i++) {
        final residual = getResidualCapacity(path[i], path[i + 1]);
        if (residual < pathFlow) {
          pathFlow = residual;
        }
      }

      // Augment flow along the path
      for (var i = 0; i < path.length - 1; i++) {
        final from = path[i];
        final to = path[i + 1];

        if (hasEdge(from, to)) {
          // Forward edge: increase flow
          _flow[(from, to)] = getFlow(from, to) + pathFlow;
        } else {
          // Reverse edge: decrease flow on original edge
          _flow[(to, from)] = getFlow(to, from) - pathFlow;
        }
      }

      totalFlow += pathFlow;
      path = getFlowPath(source, sink);
    }

    return totalFlow;
  }

  /// Returns the edges in the minimum cut after computing max flow.
  /// Each edge is represented as a tuple (from, to, capacity).
  List<(T, T, num)> minCut(T source, T sink) {
    // Compute max flow first
    maxFlow(source, sink);

    // Find all vertices reachable from source in residual graph
    final reachable = <T>{};
    final queue = Queue<T>();

    reachable.add(source);
    queue.enqueue(source);

    while (queue.isNotEmpty) {
      final vertex = queue.dequeue();
      for (final neighbor in _residualNeighbors(vertex)) {
        if (!reachable.contains(neighbor)) {
          reachable.add(neighbor);
          queue.enqueue(neighbor);
        }
      }
    }

    // Find edges from reachable to non-reachable vertices
    final cutEdges = <(T, T, num)>[];
    for (final from in reachable) {
      final edges = _adjacencyList[from];
      if (edges == null) continue;
      for (final edge in edges) {
        if (!reachable.contains(edge.destination)) {
          cutEdges.add((from, edge.destination, edge.capacity));
        }
      }
    }

    return cutEdges;
  }

  /// Returns a map of all edges with their current flows.
  /// Format: {(from, to): flow}
  Map<(T, T), num> getFlowNetwork() {
    final result = <(T, T), num>{};
    for (final from in _adjacencyList.keys) {
      for (final edge in _adjacencyList[from]!) {
        result[(from, edge.destination)] = getFlow(from, edge.destination);
      }
    }
    return result;
  }

  /// Returns the total flow out of [source].
  num totalFlow(T source) {
    final edges = _adjacencyList[source];
    if (edges == null) return 0;

    num total = 0;
    for (final edge in edges) {
      total += getFlow(source, edge.destination);
    }
    return total;
  }

  /// Resets all flows to 0.
  void reset() {
    for (final key in _flow.keys) {
      _flow[key] = 0;
    }
  }

  /// Removes all vertices and edges from the network.
  void clear() {
    _adjacencyList.clear();
    _flow.clear();
  }

  @override
  String toString() {
    if (_adjacencyList.isEmpty) return 'FlowNetwork: (empty)';

    final buffer = StringBuffer();
    buffer.writeln('FlowNetwork:');
    for (final vertex in _adjacencyList.keys) {
      final edges = _adjacencyList[vertex]!;
      if (edges.isEmpty) {
        buffer.writeln('  $vertex: []');
      } else {
        final edgeStrs = edges.map((e) {
          final flow = getFlow(vertex, e.destination);
          return '${e.destination}($flow/${e.capacity})';
        }).join(', ');
        buffer.writeln('  $vertex: [$edgeStrs]');
      }
    }
    return buffer.toString().trimRight();
  }
}
