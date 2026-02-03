/// # Graph
///
/// A graph data structure using adjacency list representation.
/// Supports both directed and undirected graphs, weighted and unweighted edges.
///
/// Time Complexity:
/// - Add vertex: O(1)
/// - Add edge: O(1)
/// - Remove vertex: O(V + E)
/// - Remove edge: O(E)
/// - BFS/DFS: O(V + E)
/// - Has edge: O(degree)
///
/// Where V = number of vertices, E = number of edges
library;

import '../linear/queue.dart';
import '../linear/stack.dart';

/// Represents an edge in the graph.
class Edge<T> {
  /// The destination vertex.
  final T destination;

  /// The weight of the edge (default 1.0).
  final double weight;

  /// Creates an edge to [destination] with optional [weight].
  const Edge(this.destination, [this.weight = 1.0]);

  @override
  bool operator ==(Object other) =>
      other is Edge<T> &&
      destination == other.destination &&
      weight == other.weight;

  @override
  int get hashCode => destination.hashCode ^ weight.hashCode;

  @override
  String toString() => weight == 1.0 ? '->$destination' : '-($weight)->$destination';
}

/// Graph type enumeration.
enum GraphType {
  /// Directed graph: edges have direction.
  directed,

  /// Undirected graph: edges are bidirectional.
  undirected,
}

/// A graph data structure using adjacency list representation.
class Graph<T> {
  final Map<T, List<Edge<T>>> _adjacencyList = {};
  final GraphType type;

  /// Creates an empty graph of the specified [type].
  Graph({this.type = GraphType.undirected});

  /// Creates a directed graph.
  factory Graph.directed() => Graph(type: GraphType.directed);

  /// Creates an undirected graph.
  factory Graph.undirected() => Graph(type: GraphType.undirected);

  /// Returns true if the graph is directed.
  bool get isDirected => type == GraphType.directed;

  /// Returns the number of vertices.
  int get vertexCount => _adjacencyList.length;

  /// Returns the number of edges.
  int get edgeCount {
    var count = 0;
    for (final edges in _adjacencyList.values) {
      count += edges.length;
    }
    // For undirected graphs, each edge is counted twice
    return isDirected ? count : count ~/ 2;
  }

  /// Returns all vertices.
  Iterable<T> get vertices => _adjacencyList.keys;

  /// Returns all edges as (source, destination, weight) tuples.
  Iterable<(T, T, double)> get edges sync* {
    final seen = <String>{};
    for (final vertex in _adjacencyList.keys) {
      for (final edge in _adjacencyList[vertex]!) {
        final key = isDirected
            ? '$vertex-${edge.destination}'
            : _edgeKey(vertex, edge.destination);
        if (!seen.contains(key)) {
          seen.add(key);
          yield (vertex, edge.destination, edge.weight);
        }
      }
    }
  }

  String _edgeKey(T a, T b) {
    final hash1 = a.hashCode;
    final hash2 = b.hashCode;
    return hash1 <= hash2 ? '$a-$b' : '$b-$a';
  }

  /// Returns true if the graph is empty.
  bool get isEmpty => _adjacencyList.isEmpty;

  /// Returns true if the graph is not empty.
  bool get isNotEmpty => _adjacencyList.isNotEmpty;

  /// Adds a vertex to the graph. O(1)
  /// Returns true if the vertex was added (not already present).
  bool addVertex(T vertex) {
    if (_adjacencyList.containsKey(vertex)) return false;
    _adjacencyList[vertex] = [];
    return true;
  }

  /// Adds multiple vertices to the graph.
  void addVertices(Iterable<T> vertices) {
    for (final vertex in vertices) {
      addVertex(vertex);
    }
  }

  /// Adds an edge between [source] and [destination]. O(1)
  /// Creates vertices if they don't exist.
  void addEdge(T source, T destination, [double weight = 1.0]) {
    addVertex(source);
    addVertex(destination);

    _adjacencyList[source]!.add(Edge(destination, weight));

    if (!isDirected && source != destination) {
      _adjacencyList[destination]!.add(Edge(source, weight));
    }
  }

  /// Removes a vertex and all its edges. O(V + E)
  /// Returns true if the vertex was found and removed.
  bool removeVertex(T vertex) {
    if (!_adjacencyList.containsKey(vertex)) return false;

    // Remove all edges pointing to this vertex
    for (final edges in _adjacencyList.values) {
      edges.removeWhere((edge) => edge.destination == vertex);
    }

    // Remove the vertex itself
    _adjacencyList.remove(vertex);
    return true;
  }

  /// Removes an edge between [source] and [destination]. O(E)
  /// Returns true if the edge was found and removed.
  bool removeEdge(T source, T destination) {
    if (!_adjacencyList.containsKey(source)) return false;

    final lengthBefore = _adjacencyList[source]!.length;
    _adjacencyList[source]!
        .removeWhere((edge) => edge.destination == destination);
    final removed = _adjacencyList[source]!.length < lengthBefore;

    if (!isDirected && source != destination) {
      _adjacencyList[destination]?.removeWhere((edge) => edge.destination == source);
    }

    return removed;
  }

  /// Returns true if [vertex] exists in the graph. O(1)
  bool hasVertex(T vertex) => _adjacencyList.containsKey(vertex);

  /// Returns true if an edge exists between [source] and [destination]. O(degree)
  bool hasEdge(T source, T destination) {
    final edges = _adjacencyList[source];
    if (edges == null) return false;
    return edges.any((edge) => edge.destination == destination);
  }

  /// Returns the weight of the edge between [source] and [destination].
  /// Returns null if no edge exists.
  double? getEdgeWeight(T source, T destination) {
    final edges = _adjacencyList[source];
    if (edges == null) return null;
    for (final edge in edges) {
      if (edge.destination == destination) return edge.weight;
    }
    return null;
  }

  /// Returns the neighbors of [vertex].
  List<T> neighbors(T vertex) {
    final edges = _adjacencyList[vertex];
    if (edges == null) return [];
    return edges.map((e) => e.destination).toList();
  }

  /// Returns the edges from [vertex].
  List<Edge<T>> edgesFrom(T vertex) {
    return _adjacencyList[vertex] ?? [];
  }

  /// Returns the degree of [vertex] (number of edges).
  int degree(T vertex) => _adjacencyList[vertex]?.length ?? 0;

  /// Returns the in-degree of [vertex] (for directed graphs).
  int inDegree(T vertex) {
    var count = 0;
    for (final edges in _adjacencyList.values) {
      for (final edge in edges) {
        if (edge.destination == vertex) count++;
      }
    }
    return count;
  }

  /// Returns the out-degree of [vertex] (for directed graphs).
  int outDegree(T vertex) => degree(vertex);

  /// Removes all vertices and edges from the graph. O(1)
  void clear() => _adjacencyList.clear();

  // ============ BFS - Breadth First Search ============

  /// Performs BFS starting from [start]. O(V + E)
  /// Returns vertices in BFS order.
  Iterable<T> bfs(T start) sync* {
    if (!hasVertex(start)) return;

    final visited = <T>{};
    final queue = Queue<T>();

    visited.add(start);
    queue.enqueue(start);

    while (queue.isNotEmpty) {
      final vertex = queue.dequeue();
      yield vertex;

      for (final neighbor in neighbors(vertex)) {
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.enqueue(neighbor);
        }
      }
    }
  }

  /// Performs BFS and returns the path from [start] to [end]. O(V + E)
  /// Returns null if no path exists.
  List<T>? bfsPath(T start, T end) {
    if (!hasVertex(start) || !hasVertex(end)) return null;
    if (start == end) return [start];

    final visited = <T>{};
    final queue = Queue<T>();
    final parent = <T, T>{};

    visited.add(start);
    queue.enqueue(start);

    while (queue.isNotEmpty) {
      final vertex = queue.dequeue();

      if (vertex == end) {
        // Reconstruct path
        final path = <T>[end];
        var current = end;
        while (parent.containsKey(current)) {
          current = parent[current] as T;
          path.insert(0, current);
        }
        return path;
      }

      for (final neighbor in neighbors(vertex)) {
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          parent[neighbor] = vertex;
          queue.enqueue(neighbor);
        }
      }
    }

    return null; // No path found
  }

  /// Returns the shortest distance (number of edges) from [start] to all reachable vertices.
  Map<T, int> bfsDistances(T start) {
    if (!hasVertex(start)) return {};

    final distances = <T, int>{start: 0};
    final queue = Queue<T>();
    queue.enqueue(start);

    while (queue.isNotEmpty) {
      final vertex = queue.dequeue();
      final currentDistance = distances[vertex]!;

      for (final neighbor in neighbors(vertex)) {
        if (!distances.containsKey(neighbor)) {
          distances[neighbor] = currentDistance + 1;
          queue.enqueue(neighbor);
        }
      }
    }

    return distances;
  }

  // ============ DFS - Depth First Search ============

  /// Performs DFS starting from [start] (iterative). O(V + E)
  /// Returns vertices in DFS order.
  Iterable<T> dfs(T start) sync* {
    if (!hasVertex(start)) return;

    final visited = <T>{};
    final stack = Stack<T>();

    stack.push(start);

    while (stack.isNotEmpty) {
      final vertex = stack.pop();

      if (visited.contains(vertex)) continue;

      visited.add(vertex);
      yield vertex;

      // Add neighbors in reverse order so they are processed in order
      final neighborList = neighbors(vertex);
      for (var i = neighborList.length - 1; i >= 0; i--) {
        if (!visited.contains(neighborList[i])) {
          stack.push(neighborList[i]);
        }
      }
    }
  }

  /// Performs DFS starting from [start] (recursive). O(V + E)
  /// Returns vertices in DFS order.
  List<T> dfsRecursive(T start) {
    final result = <T>[];
    final visited = <T>{};
    _dfsHelper(start, visited, result);
    return result;
  }

  void _dfsHelper(T vertex, Set<T> visited, List<T> result) {
    if (visited.contains(vertex) || !hasVertex(vertex)) return;

    visited.add(vertex);
    result.add(vertex);

    for (final neighbor in neighbors(vertex)) {
      _dfsHelper(neighbor, visited, result);
    }
  }

  /// Performs DFS and returns the path from [start] to [end]. O(V + E)
  /// Returns null if no path exists.
  List<T>? dfsPath(T start, T end) {
    if (!hasVertex(start) || !hasVertex(end)) return null;
    if (start == end) return [start];

    final visited = <T>{};
    final path = <T>[];

    if (_dfsPathHelper(start, end, visited, path)) {
      return path;
    }
    return null;
  }

  bool _dfsPathHelper(T current, T end, Set<T> visited, List<T> path) {
    visited.add(current);
    path.add(current);

    if (current == end) return true;

    for (final neighbor in neighbors(current)) {
      if (!visited.contains(neighbor)) {
        if (_dfsPathHelper(neighbor, end, visited, path)) {
          return true;
        }
      }
    }

    path.removeLast();
    return false;
  }

  // ============ Graph Algorithms ============

  /// Returns all vertices reachable from [start].
  Set<T> reachableFrom(T start) => bfs(start).toSet();

  /// Returns true if the graph is connected (for undirected graphs).
  bool get isConnected {
    if (_adjacencyList.isEmpty) return true;
    final start = _adjacencyList.keys.first;
    return reachableFrom(start).length == vertexCount;
  }

  /// Returns true if there is a path from [start] to [end].
  bool hasPath(T start, T end) {
    return reachableFrom(start).contains(end);
  }

  /// Returns true if the graph contains a cycle.
  bool get hasCycle {
    final visited = <T>{};
    final inStack = <T>{};

    bool dfs(T vertex, T? parent) {
      visited.add(vertex);
      inStack.add(vertex);

      for (final neighbor in neighbors(vertex)) {
        if (!visited.contains(neighbor)) {
          if (dfs(neighbor, vertex)) return true;
        } else if (inStack.contains(neighbor)) {
          // For undirected graphs, skip the parent
          if (isDirected || neighbor != parent) return true;
        }
      }

      inStack.remove(vertex);
      return false;
    }

    for (final vertex in vertices) {
      if (!visited.contains(vertex)) {
        if (dfs(vertex, null)) return true;
      }
    }

    return false;
  }

  /// Returns connected components of the graph.
  List<Set<T>> get connectedComponents {
    final visited = <T>{};
    final components = <Set<T>>[];

    for (final vertex in vertices) {
      if (!visited.contains(vertex)) {
        final component = bfs(vertex).toSet();
        visited.addAll(component);
        components.add(component);
      }
    }

    return components;
  }

  /// Topological sort (for DAG - Directed Acyclic Graph). O(V + E)
  /// Returns null if the graph has a cycle.
  List<T>? topologicalSort() {
    if (!isDirected) {
      throw StateError('Topological sort is only for directed graphs');
    }

    final inDegrees = <T, int>{};
    for (final vertex in vertices) {
      inDegrees[vertex] = 0;
    }
    for (final vertex in vertices) {
      for (final neighbor in neighbors(vertex)) {
        inDegrees[neighbor] = (inDegrees[neighbor] ?? 0) + 1;
      }
    }

    final queue = Queue<T>();
    for (final vertex in vertices) {
      if (inDegrees[vertex] == 0) {
        queue.enqueue(vertex);
      }
    }

    final result = <T>[];
    while (queue.isNotEmpty) {
      final vertex = queue.dequeue();
      result.add(vertex);

      for (final neighbor in neighbors(vertex)) {
        inDegrees[neighbor] = inDegrees[neighbor]! - 1;
        if (inDegrees[neighbor] == 0) {
          queue.enqueue(neighbor);
        }
      }
    }

    if (result.length != vertexCount) {
      return null; // Graph has a cycle
    }

    return result;
  }

  @override
  String toString() {
    if (_adjacencyList.isEmpty) return 'Graph: (empty)';

    final buffer = StringBuffer();
    buffer.writeln('Graph (${isDirected ? "directed" : "undirected"}):');
    for (final vertex in _adjacencyList.keys) {
      final edges = _adjacencyList[vertex]!;
      if (edges.isEmpty) {
        buffer.writeln('  $vertex: []');
      } else {
        buffer.writeln('  $vertex: [${edges.join(', ')}]');
      }
    }
    return buffer.toString().trimRight();
  }

  /// Returns a copy of this graph.
  Graph<T> copy() {
    final newGraph = Graph<T>(type: type);
    for (final vertex in vertices) {
      newGraph.addVertex(vertex);
    }
    for (final (source, dest, weight) in edges) {
      if (isDirected) {
        newGraph.addEdge(source, dest, weight);
      } else if (!newGraph.hasEdge(source, dest)) {
        newGraph.addEdge(source, dest, weight);
      }
    }
    return newGraph;
  }
}
