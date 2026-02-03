/// # Segment Tree and Fenwick Tree
///
/// Efficient data structures for range queries and point/range updates.
///
/// ## Segment Tree
/// A binary tree where each node represents a segment of the array.
/// Supports any associative combine operation (sum, min, max, gcd, etc.).
///
/// Time Complexity:
/// - Build: O(n)
/// - Query: O(log n)
/// - Point Update: O(log n)
/// - Range Update (lazy): O(log n)
///
/// ## Fenwick Tree (Binary Indexed Tree)
/// Space-efficient structure for prefix sums and point updates.
///
/// Time Complexity:
/// - Build: O(n log n)
/// - Prefix Sum: O(log n)
/// - Range Sum: O(log n)
/// - Update: O(log n)
///
/// Use cases: competitive programming, range sum/min/max queries, frequency counting.
library;

import 'dart:math' as math;

/// A segment tree for efficient range queries and updates.
///
/// Supports any associative combine operation (sum, min, max, gcd, etc.).
class SegmentTree<T> {
  late List<T?> _tree;
  late List<T?> _lazy;
  late List<T> _data;
  final T Function(T a, T b) _combine;
  final T _identity;
  bool _useLazy;

  /// Creates a segment tree from [data] with a custom [combine] function.
  ///
  /// The [identity] element must satisfy: combine(x, identity) = x for all x.
  /// Set [useLazy] to true to enable lazy propagation for range updates.
  SegmentTree(
    List<T> data, {
    required T Function(T a, T b) combine,
    required T identity,
    bool useLazy = false,
  })  : _combine = combine,
        _identity = identity,
        _useLazy = useLazy {
    _data = List<T>.from(data);
    _buildTree();
  }

  /// Creates a segment tree for sum queries.
  factory SegmentTree.sum(List<num> data, {bool useLazy = false}) {
    return SegmentTree<num>(
      data,
      combine: (a, b) => a + b,
      identity: 0,
      useLazy: useLazy,
    ) as SegmentTree<T>;
  }

  /// Creates a segment tree for minimum queries.
  factory SegmentTree.min(List<num> data, {bool useLazy = false}) {
    return SegmentTree<num>(
      data,
      combine: (a, b) => math.min(a, b),
      identity: double.infinity,
      useLazy: useLazy,
    ) as SegmentTree<T>;
  }

  /// Creates a segment tree for maximum queries.
  factory SegmentTree.max(List<num> data, {bool useLazy = false}) {
    return SegmentTree<num>(
      data,
      combine: (a, b) => math.max(a, b),
      identity: double.negativeInfinity,
      useLazy: useLazy,
    ) as SegmentTree<T>;
  }

  /// Returns the number of elements in the original array.
  int get length => _data.length;

  /// Returns the value at [index] in the original array.
  T operator [](int index) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, this, 'index', null, _data.length);
    }
    return _data[index];
  }

  /// Builds the segment tree from the data array.
  void _buildTree() {
    if (_data.isEmpty) {
      _tree = [];
      _lazy = [];
      return;
    }
    // Tree size: 4 * n is safe upper bound
    final size = 4 * _data.length;
    _tree = List<T?>.filled(size, null);
    _lazy = List<T?>.filled(size, null);
    _build(0, 0, _data.length - 1);
  }

  void _build(int node, int start, int end) {
    if (start == end) {
      _tree[node] = _data[start];
    } else {
      final mid = (start + end) ~/ 2;
      final leftChild = 2 * node + 1;
      final rightChild = 2 * node + 2;
      _build(leftChild, start, mid);
      _build(rightChild, mid + 1, end);
      _tree[node] = _combine(_tree[leftChild] as T, _tree[rightChild] as T);
    }
  }

  /// Pushes lazy updates down to children.
  void _pushDown(int node, int start, int end) {
    if (!_useLazy || _lazy[node] == null) return;

    final mid = (start + end) ~/ 2;
    final leftChild = 2 * node + 1;
    final rightChild = 2 * node + 2;
    final lazyVal = _lazy[node] as T;

    // Apply lazy value to children
    // For sum: multiply by segment length
    // For min/max: just set the value
    final leftLen = mid - start + 1;
    final rightLen = end - mid;

    if (_tree[leftChild] != null) {
      _tree[leftChild] = _applyLazy(_tree[leftChild] as T, lazyVal, leftLen);
      if (_lazy[leftChild] == null) {
        _lazy[leftChild] = lazyVal;
      } else {
        _lazy[leftChild] = _combine(_lazy[leftChild] as T, lazyVal);
      }
    }

    if (_tree[rightChild] != null) {
      _tree[rightChild] = _applyLazy(_tree[rightChild] as T, lazyVal, rightLen);
      if (_lazy[rightChild] == null) {
        _lazy[rightChild] = lazyVal;
      } else {
        _lazy[rightChild] = _combine(_lazy[rightChild] as T, lazyVal);
      }
    }

    _lazy[node] = null;
  }

  /// Applies lazy value based on segment length (for sum operations).
  T _applyLazy(T current, T lazyVal, int segmentLength) {
    // For additive operations like sum, multiply delta by segment length
    if (lazyVal is num && current is num) {
      return (current + lazyVal * segmentLength) as T;
    }
    // For min/max, just combine
    return _combine(current, lazyVal);
  }

  /// Queries the range [left, right] inclusive.
  ///
  /// Returns the result of combining all elements in the range.
  T query(int left, int right) {
    if (_data.isEmpty) {
      return _identity;
    }
    if (left < 0 || right >= _data.length || left > right) {
      throw RangeError(
          'Invalid range: [$left, $right] for length ${_data.length}');
    }
    return _query(0, 0, _data.length - 1, left, right);
  }

  T _query(int node, int start, int end, int left, int right) {
    if (_useLazy) {
      _pushDown(node, start, end);
    }

    if (right < start || left > end) {
      // Out of range
      return _identity;
    }

    if (left <= start && end <= right) {
      // Completely inside range
      return _tree[node] as T;
    }

    // Partial overlap
    final mid = (start + end) ~/ 2;
    final leftChild = 2 * node + 1;
    final rightChild = 2 * node + 2;
    final leftResult = _query(leftChild, start, mid, left, right);
    final rightResult = _query(rightChild, mid + 1, end, left, right);
    return _combine(leftResult, rightResult);
  }

  /// Updates the value at [index] to [value].
  void update(int index, T value) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, this, 'index', null, _data.length);
    }
    _data[index] = value;
    _update(0, 0, _data.length - 1, index, value);
  }

  void _update(int node, int start, int end, int index, T value) {
    if (start == end) {
      _tree[node] = value;
    } else {
      final mid = (start + end) ~/ 2;
      final leftChild = 2 * node + 1;
      final rightChild = 2 * node + 2;

      if (_useLazy) {
        _pushDown(node, start, end);
      }

      if (index <= mid) {
        _update(leftChild, start, mid, index, value);
      } else {
        _update(rightChild, mid + 1, end, index, value);
      }
      _tree[node] = _combine(_tree[leftChild] as T, _tree[rightChild] as T);
    }
  }

  /// Updates all values in range [left, right] by adding [delta].
  ///
  /// Only works when lazy propagation is enabled and for additive operations.
  /// Throws [StateError] if lazy propagation is not enabled.
  void updateRange(int left, int right, T delta) {
    if (!_useLazy) {
      throw StateError('Range updates require lazy propagation. '
          'Create the tree with useLazy: true');
    }
    if (_data.isEmpty) return;
    if (left < 0 || right >= _data.length || left > right) {
      throw RangeError(
          'Invalid range: [$left, $right] for length ${_data.length}');
    }
    _updateRange(0, 0, _data.length - 1, left, right, delta);
  }

  void _updateRange(
      int node, int start, int end, int left, int right, T delta) {
    if (right < start || left > end) {
      // Out of range
      return;
    }

    if (left <= start && end <= right) {
      // Completely inside range
      final segmentLength = end - start + 1;
      _tree[node] = _applyLazy(_tree[node] as T, delta, segmentLength);
      if (_lazy[node] == null) {
        _lazy[node] = delta;
      } else {
        _lazy[node] = _combine(_lazy[node] as T, delta);
      }
      return;
    }

    // Partial overlap
    _pushDown(node, start, end);
    final mid = (start + end) ~/ 2;
    final leftChild = 2 * node + 1;
    final rightChild = 2 * node + 2;
    _updateRange(leftChild, start, mid, left, right, delta);
    _updateRange(rightChild, mid + 1, end, left, right, delta);
    _tree[node] = _combine(_tree[leftChild] as T, _tree[rightChild] as T);
  }

  /// Rebuilds the segment tree from new data.
  void build(List<T> data) {
    _data = List<T>.from(data);
    _buildTree();
  }

  /// Returns the original data as a list.
  List<T> get values => List<T>.from(_data);

  @override
  String toString() {
    if (_data.isEmpty) return 'SegmentTree: []';
    return 'SegmentTree: $_data';
  }
}

/// A Fenwick Tree (Binary Indexed Tree) for efficient prefix sums.
///
/// Space-efficient alternative to segment tree when only prefix/range sums
/// and point updates are needed.
class FenwickTree {
  late List<num> _tree;
  late List<num> _data;

  /// Creates a Fenwick tree from a list of numbers.
  FenwickTree(List<num> data) {
    _data = List<num>.from(data);
    _buildTree();
  }

  /// Returns the number of elements.
  int get length => _data.length;

  /// Returns the value at [index].
  num operator [](int index) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, this, 'index', null, _data.length);
    }
    return _data[index];
  }

  /// Builds the Fenwick tree from data. O(n)
  void _buildTree() {
    // 1-indexed internally for easier bit manipulation
    _tree = List<num>.filled(_data.length + 1, 0);

    // Build in O(n) using the property that each index is responsible
    // for a range of elements
    for (var i = 0; i < _data.length; i++) {
      _addToTree(i + 1, _data[i]);
    }
  }

  /// Adds [delta] to tree at 1-indexed position.
  void _addToTree(int index, num delta) {
    while (index < _tree.length) {
      _tree[index] += delta;
      index += index & (-index); // Add lowest set bit
    }
  }

  /// Returns the prefix sum from index 0 to [index] inclusive. O(log n)
  num prefixSum(int index) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, this, 'index', null, _data.length);
    }
    return _prefixSum(index + 1);
  }

  num _prefixSum(int index) {
    num sum = 0;
    while (index > 0) {
      sum += _tree[index];
      index -= index & (-index); // Remove lowest set bit
    }
    return sum;
  }

  /// Returns the sum of elements from [left] to [right] inclusive. O(log n)
  num rangeSum(int left, int right) {
    if (left < 0 || right >= _data.length || left > right) {
      throw RangeError(
          'Invalid range: [$left, $right] for length ${_data.length}');
    }
    if (left == 0) {
      return prefixSum(right);
    }
    return prefixSum(right) - prefixSum(left - 1);
  }

  /// Adds [delta] to the element at [index]. O(log n)
  void update(int index, num delta) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, this, 'index', null, _data.length);
    }
    _data[index] += delta;
    _addToTree(index + 1, delta);
  }

  /// Sets the element at [index] to [value]. O(log n)
  void set(int index, num value) {
    if (index < 0 || index >= _data.length) {
      throw RangeError.index(index, this, 'index', null, _data.length);
    }
    final delta = value - _data[index];
    update(index, delta);
  }

  /// Returns the original data as a list.
  List<num> get values => List<num>.from(_data);

  @override
  String toString() {
    if (_data.isEmpty) return 'FenwickTree: []';
    return 'FenwickTree: $_data';
  }
}
