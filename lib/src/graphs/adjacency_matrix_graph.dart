/// # Adjacency Matrix Graph
///
/// A graph data structure using adjacency matrix representation.
/// Supports both directed and undirected graphs with weighted edges.
///
/// Time Complexity:
/// - Add vertex: O(V) - requires matrix resizing
/// - Remove vertex: O(V^2) - requires matrix resizing
/// - Add edge: O(1)
/// - Remove edge: O(1)
/// - Has edge: O(1)
/// - Get weight: O(1)
/// - BFS/DFS: O(V^2)
///
/// Space Complexity: O(V^2)
///
/// Comparison with adjacency list:
/// - Better for dense graphs where E approaches V^2
/// - O(1) edge lookup vs O(degree) for adjacency list
/// - O(V^2) space vs O(V+E) for adjacency list
///
/// Use cases: Dense graphs, Floyd-Warshall, matrix operations.
library;

import '../linear/queue.dart';
import '../linear/stack.dart';

/// A graph data structure using adjacency matrix representation.
class AdjacencyMatrixGraph<T> {
  /// The adjacency matrix storing edge weights.
  /// null indicates no edge, a value indicates the edge weight.
  final List<List<double?>> _matrix = [];

  /// Maps vertices to their indices in the matrix.
  final Map<T, int> _vertexToIndex = {};

  /// Maps indices back to vertices.
  final List<T> _indexToVertex = [];

  /// Whether this is a directed graph.
  final bool _directed;

  /// Creates an empty graph.
  ///
  /// If [directed] is true, edges have direction (A->B != B->A).
  /// If [directed] is false (default), edges are bidirectional.
  AdjacencyMatrixGraph({bool directed = false}) : _directed = directed;

  /// Creates a directed graph.
  factory AdjacencyMatrixGraph.directed() =>
      AdjacencyMatrixGraph(directed: true);

  /// Creates an undirected graph.
  factory AdjacencyMatrixGraph.undirected() =>
      AdjacencyMatrixGraph(directed: false);

  // ============ Properties ============

  /// Returns true if this is a directed graph.
  bool get isDirected => _directed;

  /// Returns the number of vertices.
  int get vertexCount => _indexToVertex.length;

  /// Returns the number of edges.
  int get edgeCount {
    var count = 0;
    for (var i = 0; i < _matrix.length; i++) {
      for (var j = 0; j < _matrix.length; j++) {
        if (_matrix[i][j] != null) count++;
      }
    }
    // For undirected graphs, each edge is counted twice (except self-loops)
    if (!_directed) {
      // Count self-loops separately
      var selfLoops = 0;
      for (var i = 0; i < _matrix.length; i++) {
        if (_matrix[i][i] != null) selfLoops++;
      }
      count = (count - selfLoops) ~/ 2 + selfLoops;
    }
    return count;
  }

  /// Returns all vertices.
  Iterable<T> get vertices => List.unmodifiable(_indexToVertex);

  /// Returns true if the graph is empty.
  bool get isEmpty => _indexToVertex.isEmpty;

  /// Returns true if the graph is not empty.
  bool get isNotEmpty => _indexToVertex.isNotEmpty;

  /// Returns true if edge count > vertexCount^2 / 2.
  /// Dense graphs benefit more from matrix representation.
  bool get isDense {
    final v = vertexCount;
    if (v == 0) return false;
    final maxEdges = _directed ? v * v : (v * (v - 1)) ~/ 2 + v;
    return edgeCount > maxEdges / 2;
  }

  // ============ Vertex Operations ============

  /// Adds a vertex to the graph. O(V)
  /// Returns true if the vertex was added (not already present).
  bool addVertex(T vertex) {
    if (_vertexToIndex.containsKey(vertex)) return false;

    final index = _indexToVertex.length;
    _vertexToIndex[vertex] = index;
    _indexToVertex.add(vertex);

    // Expand existing rows
    for (final row in _matrix) {
      row.add(null);
    }

    // Add new row
    _matrix
        .add(List<double?>.filled(_indexToVertex.length, null, growable: true));

    return true;
  }

  /// Removes a vertex and all its edges. O(V^2)
  /// Returns true if the vertex was found and removed.
  bool removeVertex(T vertex) {
    final index = _vertexToIndex[vertex];
    if (index == null) return false;

    // Remove row
    _matrix.removeAt(index);

    // Remove column from each row
    for (final row in _matrix) {
      row.removeAt(index);
    }

    // Update mappings
    _indexToVertex.removeAt(index);
    _vertexToIndex.remove(vertex);

    // Update indices for vertices after the removed one
    for (var i = index; i < _indexToVertex.length; i++) {
      _vertexToIndex[_indexToVertex[i]] = i;
    }

    return true;
  }

  /// Returns true if [vertex] exists in the graph. O(1)
  bool hasVertex(T vertex) => _vertexToIndex.containsKey(vertex);

  // ============ Edge Operations ============

  /// Adds an edge between [from] and [to] with optional [weight]. O(1)
  /// Creates vertices if they don't exist.
  void addEdge(T from, T to, {double weight = 1.0}) {
    addVertex(from);
    addVertex(to);

    final fromIndex = _vertexToIndex[from]!;
    final toIndex = _vertexToIndex[to]!;

    _matrix[fromIndex][toIndex] = weight;

    if (!_directed && from != to) {
      _matrix[toIndex][fromIndex] = weight;
    }
  }

  /// Removes an edge between [from] and [to]. O(1)
  /// Returns true if the edge was found and removed.
  bool removeEdge(T from, T to) {
    final fromIndex = _vertexToIndex[from];
    final toIndex = _vertexToIndex[to];

    if (fromIndex == null || toIndex == null) return false;
    if (_matrix[fromIndex][toIndex] == null) return false;

    _matrix[fromIndex][toIndex] = null;

    if (!_directed && from != to) {
      _matrix[toIndex][fromIndex] = null;
    }

    return true;
  }

  /// Returns true if an edge exists between [from] and [to]. O(1)
  bool hasEdge(T from, T to) {
    final fromIndex = _vertexToIndex[from];
    final toIndex = _vertexToIndex[to];

    if (fromIndex == null || toIndex == null) return false;
    return _matrix[fromIndex][toIndex] != null;
  }

  /// Returns the weight of the edge between [from] and [to].
  /// Returns null if no edge exists.
  double? getWeight(T from, T to) {
    final fromIndex = _vertexToIndex[from];
    final toIndex = _vertexToIndex[to];

    if (fromIndex == null || toIndex == null) return null;
    return _matrix[fromIndex][toIndex];
  }

  /// Sets the weight of an existing edge between [from] and [to].
  /// Returns true if the edge exists and weight was updated.
  bool setWeight(T from, T to, double weight) {
    final fromIndex = _vertexToIndex[from];
    final toIndex = _vertexToIndex[to];

    if (fromIndex == null || toIndex == null) return false;
    if (_matrix[fromIndex][toIndex] == null) return false;

    _matrix[fromIndex][toIndex] = weight;

    if (!_directed && from != to) {
      _matrix[toIndex][fromIndex] = weight;
    }

    return true;
  }

  /// Returns the neighbors of [vertex] (adjacent vertices).
  List<T> neighbors(T vertex) {
    final index = _vertexToIndex[vertex];
    if (index == null) return [];

    final result = <T>[];
    for (var i = 0; i < _matrix.length; i++) {
      if (_matrix[index][i] != null) {
        result.add(_indexToVertex[i]);
      }
    }
    return result;
  }

  // ============ Matrix Access ============

  /// Returns a copy of the adjacency matrix.
  /// null values indicate no edge, numbers indicate edge weights.
  List<List<double?>> getMatrix() {
    return _matrix.map((row) => List<double?>.from(row)).toList();
  }

  /// Direct access to edge weight using call syntax.
  /// Usage: graph(vertexA, vertexB)
  /// Returns null if no edge exists.
  double? call(T from, T to) => getWeight(from, to);

  // ============ BFS - Breadth First Search ============

  /// Performs BFS starting from [start]. O(V^2)
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

  // ============ DFS - Depth First Search ============

  /// Performs DFS starting from [start] (iterative). O(V^2)
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

  // ============ Utilities ============

  /// Removes all vertices and edges from the graph. O(1)
  void clear() {
    _matrix.clear();
    _vertexToIndex.clear();
    _indexToVertex.clear();
  }

  @override
  String toString() {
    if (_indexToVertex.isEmpty) return 'AdjacencyMatrixGraph: (empty)';

    final buffer = StringBuffer();
    buffer.writeln(
        'AdjacencyMatrixGraph (${_directed ? "directed" : "undirected"}):');
    buffer.writeln('Vertices: $_indexToVertex');
    buffer.writeln('Matrix:');

    // Header row
    buffer.write('     ');
    for (var i = 0; i < _indexToVertex.length; i++) {
      buffer.write('${_indexToVertex[i].toString().padLeft(5)} ');
    }
    buffer.writeln();

    // Matrix rows
    for (var i = 0; i < _matrix.length; i++) {
      buffer.write('${_indexToVertex[i].toString().padLeft(4)} ');
      for (var j = 0; j < _matrix[i].length; j++) {
        final value = _matrix[i][j];
        if (value == null) {
          buffer.write('    - ');
        } else {
          buffer.write('${value.toStringAsFixed(1).padLeft(5)} ');
        }
      }
      buffer.writeln();
    }

    return buffer.toString().trimRight();
  }

  /// Returns a copy of this graph.
  AdjacencyMatrixGraph<T> copy() {
    final newGraph = AdjacencyMatrixGraph<T>(directed: _directed);

    // Add all vertices
    for (final vertex in _indexToVertex) {
      newGraph.addVertex(vertex);
    }

    // Copy the matrix
    for (var i = 0; i < _matrix.length; i++) {
      for (var j = 0; j < _matrix[i].length; j++) {
        if (_matrix[i][j] != null) {
          newGraph._matrix[i][j] = _matrix[i][j];
        }
      }
    }

    return newGraph;
  }
}
