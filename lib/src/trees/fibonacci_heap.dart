/// # Fibonacci Heap
///
/// A heap data structure with excellent amortized time complexity,
/// particularly suited for algorithms with frequent decrease-key operations.
///
/// Time Complexity (amortized):
/// - Insert: O(1)
/// - Extract min/max: O(log n)
/// - Peek: O(1)
/// - Decrease key: O(1)
/// - Delete: O(log n)
/// - Merge: O(1)
///
/// Use cases: Dijkstra's algorithm, Prim's algorithm, where decrease-key is frequent.
library;

import 'heap.dart' show HeapType;

/// A node in the Fibonacci heap.
///
/// Nodes are exposed to allow O(1) decrease-key operations.
class FibonacciHeapNode<T extends Comparable<dynamic>> {
  /// The value stored in this node.
  T value;

  /// Parent node, or null if this is a root.
  FibonacciHeapNode<T>? parent;

  /// One of the children (arbitrary).
  FibonacciHeapNode<T>? child;

  /// Left sibling in the circular doubly linked list.
  FibonacciHeapNode<T>? left;

  /// Right sibling in the circular doubly linked list.
  FibonacciHeapNode<T>? right;

  /// Number of children.
  int degree = 0;

  /// Whether this node has lost a child since becoming a child of its current parent.
  /// Used for cascading cut optimization.
  bool marked = false;

  /// Creates a new node with the given [value].
  FibonacciHeapNode(this.value) {
    left = this;
    right = this;
  }

  @override
  String toString() => 'FibonacciHeapNode($value)';
}

/// A Fibonacci heap data structure (can be min-heap or max-heap).
///
/// Provides O(1) amortized insert, decrease-key, and merge operations,
/// making it ideal for graph algorithms like Dijkstra's and Prim's.
class FibonacciHeap<T extends Comparable<dynamic>> {
  /// The type of heap (min or max).
  final HeapType type;

  /// Pointer to the minimum/maximum node.
  FibonacciHeapNode<T>? _extremeNode;

  /// Number of nodes in the heap.
  int _count = 0;

  /// Creates an empty Fibonacci heap of the specified [type].
  FibonacciHeap({this.type = HeapType.min});

  /// Creates a min-heap (smallest element at root).
  factory FibonacciHeap.minHeap() => FibonacciHeap(type: HeapType.min);

  /// Creates a max-heap (largest element at root).
  factory FibonacciHeap.maxHeap() => FibonacciHeap(type: HeapType.max);

  /// Returns the number of elements in the heap.
  int get length => _count;

  /// Returns true if the heap is empty.
  bool get isEmpty => _count == 0;

  /// Returns true if the heap is not empty.
  bool get isNotEmpty => _count > 0;

  /// Returns the minimum value without removing it. O(1)
  /// Throws [StateError] if the heap is empty.
  T get min {
    if (type != HeapType.min) {
      throw StateError('Cannot get min from max-heap, use max instead');
    }
    return peek;
  }

  /// Returns the maximum value without removing it. O(1)
  /// Throws [StateError] if the heap is empty.
  T get max {
    if (type != HeapType.max) {
      throw StateError('Cannot get max from min-heap, use min instead');
    }
    return peek;
  }

  /// Returns the extreme (min or max) value without removing it. O(1)
  /// Throws [StateError] if the heap is empty.
  T get peek {
    if (_extremeNode == null) {
      throw StateError('Cannot peek empty heap');
    }
    return _extremeNode!.value;
  }

  /// Returns the minimum value, or null if empty. O(1)
  T? get peekMin {
    if (type != HeapType.min) return null;
    return _extremeNode?.value;
  }

  /// Returns the maximum value, or null if empty. O(1)
  T? get peekMax {
    if (type != HeapType.max) return null;
    return _extremeNode?.value;
  }

  /// Compares two values according to heap type.
  /// Returns true if [a] should be closer to the root than [b].
  bool _isBetter(T a, T b) {
    final cmp = a.compareTo(b);
    return type == HeapType.min ? cmp < 0 : cmp > 0;
  }

  /// Inserts a value into the heap. O(1) amortized
  ///
  /// Returns the node for use with [decreaseKey] or [delete].
  FibonacciHeapNode<T> insert(T value) {
    final node = FibonacciHeapNode<T>(value);
    _insertNode(node);
    return node;
  }

  /// Inserts a node into the root list.
  void _insertNode(FibonacciHeapNode<T> node) {
    node.parent = null;
    node.marked = false;

    if (_extremeNode == null) {
      // Empty heap, node becomes the only root
      node.left = node;
      node.right = node;
      _extremeNode = node;
    } else {
      // Add to root list (insert to left of extreme node)
      _addToRootList(node);

      // Update extreme if necessary
      if (_isBetter(node.value, _extremeNode!.value)) {
        _extremeNode = node;
      }
    }
    _count++;
  }

  /// Adds a node to the root list (circular doubly linked list).
  void _addToRootList(FibonacciHeapNode<T> node) {
    if (_extremeNode == null) {
      node.left = node;
      node.right = node;
      _extremeNode = node;
      return;
    }

    node.left = _extremeNode!.left;
    node.right = _extremeNode;
    _extremeNode!.left!.right = node;
    _extremeNode!.left = node;
  }

  /// Removes a node from its current list.
  void _removeFromList(FibonacciHeapNode<T> node) {
    node.left!.right = node.right;
    node.right!.left = node.left;
  }

  /// Extracts the minimum value from the heap. O(log n) amortized
  /// Throws [StateError] if the heap is empty.
  T extractMin() {
    if (type != HeapType.min) {
      throw StateError('Cannot extractMin from max-heap, use extractMax');
    }
    return _extractExtreme();
  }

  /// Extracts the maximum value from the heap. O(log n) amortized
  /// Throws [StateError] if the heap is empty.
  T extractMax() {
    if (type != HeapType.max) {
      throw StateError('Cannot extractMax from min-heap, use extractMin');
    }
    return _extractExtreme();
  }

  /// Extracts the extreme (min or max) value. O(log n) amortized
  T _extractExtreme() {
    if (_extremeNode == null) {
      throw StateError('Cannot extract from empty heap');
    }

    final extreme = _extremeNode!;

    // Add all children to root list
    if (extreme.child != null) {
      var child = extreme.child!;
      final firstChild = child;

      do {
        final next = child.right!;
        child.parent = null;
        _addToRootList(child);
        child = next;
      } while (child != firstChild);
    }

    // Remove extreme from root list
    _removeFromList(extreme);

    if (extreme == extreme.right) {
      // Was the only node
      _extremeNode = null;
    } else {
      _extremeNode = extreme.right;
      _consolidate();
    }

    _count--;
    return extreme.value;
  }

  /// Consolidates trees of the same degree. O(log n) amortized
  void _consolidate() {
    if (_extremeNode == null) return;

    // Maximum possible degree is O(log n)
    final maxDegree = _maxDegree();
    final degreeTable = List<FibonacciHeapNode<T>?>.filled(maxDegree + 1, null);

    // Collect all roots first to avoid issues while iterating
    final roots = <FibonacciHeapNode<T>>[];
    var current = _extremeNode!;
    do {
      roots.add(current);
      current = current.right!;
    } while (current != _extremeNode);

    for (var node in roots) {
      var x = node;
      var d = x.degree;

      while (d < degreeTable.length && degreeTable[d] != null) {
        var y = degreeTable[d]!;

        // Ensure x has the better value
        if (_isBetter(y.value, x.value)) {
          final temp = x;
          x = y;
          y = temp;
        }

        // Link y under x
        _link(y, x);

        degreeTable[d] = null;
        d++;
      }

      if (d < degreeTable.length) {
        degreeTable[d] = x;
      }
    }

    // Reconstruct root list and find new extreme
    _extremeNode = null;
    for (var node in degreeTable) {
      if (node != null) {
        if (_extremeNode == null) {
          node.left = node;
          node.right = node;
          _extremeNode = node;
        } else {
          _addToRootList(node);
          if (_isBetter(node.value, _extremeNode!.value)) {
            _extremeNode = node;
          }
        }
      }
    }
  }

  /// Calculates the maximum possible degree based on count.
  int _maxDegree() {
    if (_count <= 1) return 1;
    // Upper bound: log_phi(n) where phi is the golden ratio
    return (2.08 * _log2(_count)).ceil() + 1;
  }

  /// Helper to compute log base 2.
  double _log2(int n) {
    if (n <= 0) return 0;
    var count = 0.0;
    var val = n;
    while (val > 1) {
      val ~/= 2;
      count++;
    }
    return count;
  }

  /// Links node [y] as a child of node [x].
  void _link(FibonacciHeapNode<T> y, FibonacciHeapNode<T> x) {
    // Remove y from root list
    _removeFromList(y);

    // Make y a child of x
    y.parent = x;
    y.marked = false;

    if (x.child == null) {
      x.child = y;
      y.left = y;
      y.right = y;
    } else {
      // Add y to x's child list
      y.left = x.child!.left;
      y.right = x.child;
      x.child!.left!.right = y;
      x.child!.left = y;
    }

    x.degree++;
  }

  /// Decreases the key of a node. O(1) amortized
  ///
  /// This operation is critical for Dijkstra's algorithm efficiency.
  /// Throws [ArgumentError] if [newValue] is not smaller (for min-heap)
  /// or larger (for max-heap) than the current value.
  void decreaseKey(FibonacciHeapNode<T> node, T newValue) {
    if (!_isBetter(newValue, node.value) &&
        newValue.compareTo(node.value) != 0) {
      final operation = type == HeapType.min ? 'decrease' : 'increase';
      throw ArgumentError('New value must $operation the key');
    }

    node.value = newValue;

    final parent = node.parent;
    if (parent != null && _isBetter(node.value, parent.value)) {
      _cut(node, parent);
      _cascadingCut(parent);
    }

    if (_isBetter(node.value, _extremeNode!.value)) {
      _extremeNode = node;
    }
  }

  /// Cuts a node from its parent and adds it to the root list.
  void _cut(FibonacciHeapNode<T> node, FibonacciHeapNode<T> parent) {
    // Remove node from parent's child list
    if (node == node.right) {
      // Only child
      parent.child = null;
    } else {
      if (parent.child == node) {
        parent.child = node.right;
      }
      _removeFromList(node);
    }

    parent.degree--;

    // Add node to root list
    _addToRootList(node);
    node.parent = null;
    node.marked = false;
  }

  /// Performs cascading cut on parent nodes.
  void _cascadingCut(FibonacciHeapNode<T> node) {
    final parent = node.parent;
    if (parent != null) {
      if (!node.marked) {
        node.marked = true;
      } else {
        _cut(node, parent);
        _cascadingCut(parent);
      }
    }
  }

  /// Deletes a node from the heap. O(log n) amortized
  void delete(FibonacciHeapNode<T> node) {
    // Decrease key to extreme value (conceptually -infinity or +infinity)
    // Then extract
    _decreaseToExtreme(node);
    _extractExtreme();
  }

  /// Moves a node to become the new extreme (for deletion).
  void _decreaseToExtreme(FibonacciHeapNode<T> node) {
    final parent = node.parent;
    if (parent != null) {
      _cut(node, parent);
      _cascadingCut(parent);
    }
    _extremeNode = node;
  }

  /// Merges another Fibonacci heap into this one. O(1)
  ///
  /// Note: The [other] heap should not be used after merging.
  void merge(FibonacciHeap<T> other) {
    if (other.type != type) {
      throw ArgumentError('Cannot merge heaps of different types');
    }

    if (other._extremeNode == null) return;

    if (_extremeNode == null) {
      _extremeNode = other._extremeNode;
    } else {
      // Concatenate root lists
      final thisLeft = _extremeNode!.left!;
      final otherLeft = other._extremeNode!.left!;

      _extremeNode!.left = otherLeft;
      otherLeft.right = _extremeNode;

      other._extremeNode!.left = thisLeft;
      thisLeft.right = other._extremeNode;

      // Update extreme if necessary
      if (_isBetter(other._extremeNode!.value, _extremeNode!.value)) {
        _extremeNode = other._extremeNode;
      }
    }

    _count += other._count;

    // Clear the other heap
    other._extremeNode = null;
    other._count = 0;
  }

  /// Removes all elements from the heap. O(1)
  void clear() {
    _extremeNode = null;
    _count = 0;
  }

  /// Returns all values in the heap (unordered).
  List<T> get values {
    final result = <T>[];
    if (_extremeNode == null) return result;

    _collectValues(_extremeNode!, result);
    return result;
  }

  /// Recursively collects values from a circular list and its children.
  void _collectValues(FibonacciHeapNode<T> start, List<T> result) {
    var node = start;
    do {
      result.add(node.value);
      if (node.child != null) {
        _collectValues(node.child!, result);
      }
      node = node.right!;
    } while (node != start);
  }

  /// Returns elements in sorted order (extracts all). O(n log n)
  /// Note: This empties the heap!
  List<T> extractAll() {
    final result = <T>[];
    while (isNotEmpty) {
      result.add(_extractExtreme());
    }
    return result;
  }

  @override
  String toString() {
    final typeName =
        type == HeapType.min ? 'FibonacciMinHeap' : 'FibonacciMaxHeap';
    if (isEmpty) return '$typeName: []';
    return '$typeName: $values (extreme: ${_extremeNode?.value})';
  }

  /// Returns a visual tree representation.
  String toTreeString() {
    if (_extremeNode == null) return '(empty)';

    final buffer = StringBuffer();
    buffer.writeln('Roots:');

    var node = _extremeNode!;
    var isFirst = true;
    do {
      final marker = node == _extremeNode ? ' <- extreme' : '';
      _buildTreeString(node, '', isFirst, buffer, marker);
      node = node.right!;
      isFirst = false;
    } while (node != _extremeNode);

    return buffer.toString();
  }

  void _buildTreeString(
    FibonacciHeapNode<T> node,
    String prefix,
    bool isLast,
    StringBuffer buffer,
    String suffix,
  ) {
    final marker = node.marked ? '*' : '';
    buffer.writeln(
        '$prefix${isLast ? '└── ' : '├── '}${node.value}$marker$suffix');

    if (node.child != null) {
      final children = <FibonacciHeapNode<T>>[];
      var child = node.child!;
      do {
        children.add(child);
        child = child.right!;
      } while (child != node.child);

      for (var i = 0; i < children.length; i++) {
        _buildTreeString(
          children[i],
          '$prefix${isLast ? '    ' : '│   '}',
          i == children.length - 1,
          buffer,
          '',
        );
      }
    }
  }
}
