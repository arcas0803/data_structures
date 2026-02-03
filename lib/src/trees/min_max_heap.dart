/// # Min-Max Heap
///
/// A complete binary tree that supports both O(1) min AND max access.
/// Even levels (0, 2, 4...) are min levels where nodes are smaller than descendants.
/// Odd levels (1, 3, 5...) are max levels where nodes are larger than descendants.
///
/// Time Complexity:
/// - Insert: O(log n)
/// - Extract min/max: O(log n)
/// - Peek min/max: O(1)
/// - Build heap: O(n)
///
/// Use cases: Double-ended priority queue, finding both extremes efficiently.
library;

/// A min-max heap data structure supporting efficient access to both extremes.
class MinMaxHeap<T extends Comparable<dynamic>> {
  final List<T> _data = [];

  /// Creates an empty min-max heap.
  MinMaxHeap();

  /// Creates a min-max heap from an iterable using heapify (O(n)).
  factory MinMaxHeap.from(Iterable<T> elements) {
    final heap = MinMaxHeap<T>();
    heap._data.addAll(elements);
    heap._heapify();
    return heap;
  }

  /// Returns the number of elements in the heap.
  int get length => _data.length;

  /// Returns true if the heap is empty.
  bool get isEmpty => _data.isEmpty;

  /// Returns true if the heap is not empty.
  bool get isNotEmpty => _data.isNotEmpty;

  /// Returns the minimum element without removing it. O(1)
  /// Throws [StateError] if the heap is empty.
  T get min {
    if (_data.isEmpty) {
      throw StateError('Cannot get min from empty heap');
    }
    return _data[0];
  }

  /// Returns the maximum element without removing it. O(1)
  /// Throws [StateError] if the heap is empty.
  T get max {
    if (_data.isEmpty) {
      throw StateError('Cannot get max from empty heap');
    }
    if (_data.length == 1) {
      return _data[0];
    }
    if (_data.length == 2) {
      return _data[1];
    }
    // Max is at index 1 or 2 (children of root)
    return _data[1].compareTo(_data[2]) >= 0 ? _data[1] : _data[2];
  }

  /// Returns the minimum element without removing it. O(1)
  /// Throws [StateError] if the heap is empty.
  T peekMin() => min;

  /// Returns the maximum element without removing it. O(1)
  /// Throws [StateError] if the heap is empty.
  T peekMax() => max;

  /// Returns the minimum element without removing it, or null if empty. O(1)
  T? tryPeekMin() => _data.isEmpty ? null : min;

  /// Returns the maximum element without removing it, or null if empty. O(1)
  T? tryPeekMax() => _data.isEmpty ? null : max;

  /// Returns the level of a node at [index] (0-indexed).
  int _level(int index) {
    // Level = floor(log2(index + 1))
    var level = 0;
    var i = index + 1;
    while (i > 1) {
      i ~/= 2;
      level++;
    }
    return level;
  }

  /// Returns true if the node at [index] is on a min level.
  bool _isMinLevel(int index) => _level(index) % 2 == 0;

  /// Returns the parent index of the node at [index].
  int _parent(int index) => (index - 1) ~/ 2;

  /// Returns the grandparent index of the node at [index].
  int _grandparent(int index) => _parent(_parent(index));

  /// Returns the left child index of the node at [index].
  int _leftChild(int index) => 2 * index + 1;

  /// Returns the right child index of the node at [index].
  int _rightChild(int index) => 2 * index + 2;

  /// Swaps elements at indices [i] and [j].
  void _swap(int i, int j) {
    final temp = _data[i];
    _data[i] = _data[j];
    _data[j] = temp;
  }

  /// Returns true if a < b.
  bool _less(T a, T b) => a.compareTo(b) < 0;

  /// Returns true if a > b.
  bool _greater(T a, T b) => a.compareTo(b) > 0;

  /// Inserts a value into the heap. O(log n)
  void insert(T value) {
    _data.add(value);
    _pushUp(_data.length - 1);
  }

  /// Alias for [insert].
  void add(T value) => insert(value);

  /// Inserts multiple values into the heap.
  void addAll(Iterable<T> values) {
    for (final value in values) {
      insert(value);
    }
  }

  /// Push-up operation for maintaining heap property after insertion.
  void _pushUp(int index) {
    if (index == 0) return;

    final parentIndex = _parent(index);

    if (_isMinLevel(index)) {
      // On min level
      if (_greater(_data[index], _data[parentIndex])) {
        // Should be on max level instead
        _swap(index, parentIndex);
        _pushUpMax(parentIndex);
      } else {
        _pushUpMin(index);
      }
    } else {
      // On max level
      if (_less(_data[index], _data[parentIndex])) {
        // Should be on min level instead
        _swap(index, parentIndex);
        _pushUpMin(parentIndex);
      } else {
        _pushUpMax(index);
      }
    }
  }

  /// Push-up on min levels (toward smaller values).
  void _pushUpMin(int index) {
    while (index > 2) {
      final gpIndex = _grandparent(index);
      if (_less(_data[index], _data[gpIndex])) {
        _swap(index, gpIndex);
        index = gpIndex;
      } else {
        break;
      }
    }
  }

  /// Push-up on max levels (toward larger values).
  void _pushUpMax(int index) {
    while (index > 2) {
      final gpIndex = _grandparent(index);
      if (_greater(_data[index], _data[gpIndex])) {
        _swap(index, gpIndex);
        index = gpIndex;
      } else {
        break;
      }
    }
  }

  /// Removes and returns the minimum element. O(log n)
  /// Throws [StateError] if the heap is empty.
  T extractMin() {
    if (_data.isEmpty) {
      throw StateError('Cannot extract from empty heap');
    }

    final minVal = _data[0];
    final last = _data.removeLast();

    if (_data.isNotEmpty) {
      _data[0] = last;
      _pushDown(0);
    }

    return minVal;
  }

  /// Removes and returns the maximum element. O(log n)
  /// Throws [StateError] if the heap is empty.
  T extractMax() {
    if (_data.isEmpty) {
      throw StateError('Cannot extract from empty heap');
    }

    if (_data.length == 1) {
      return _data.removeLast();
    }

    if (_data.length == 2) {
      return _data.removeLast();
    }

    // Find max index (either 1 or 2)
    final maxIndex = _data[1].compareTo(_data[2]) >= 0 ? 1 : 2;
    final maxVal = _data[maxIndex];
    final last = _data.removeLast();

    if (maxIndex < _data.length) {
      _data[maxIndex] = last;
      _pushDown(maxIndex);
    }

    return maxVal;
  }

  /// Alias for [extractMin].
  T removeMin() => extractMin();

  /// Alias for [extractMax].
  T removeMax() => extractMax();

  /// Push-down operation for maintaining heap property.
  void _pushDown(int index) {
    if (_isMinLevel(index)) {
      _pushDownMin(index);
    } else {
      _pushDownMax(index);
    }
  }

  /// Returns indices of children and grandchildren of node at [index].
  List<int> _childrenAndGrandchildren(int index) {
    final result = <int>[];
    final left = _leftChild(index);
    final right = _rightChild(index);

    if (left < _data.length) result.add(left);
    if (right < _data.length) result.add(right);

    // Grandchildren
    if (left < _data.length) {
      final ll = _leftChild(left);
      final lr = _rightChild(left);
      if (ll < _data.length) result.add(ll);
      if (lr < _data.length) result.add(lr);
    }
    if (right < _data.length) {
      final rl = _leftChild(right);
      final rr = _rightChild(right);
      if (rl < _data.length) result.add(rl);
      if (rr < _data.length) result.add(rr);
    }

    return result;
  }

  /// Returns true if [index] is a grandchild of [potentialGrandparent].
  bool _isGrandchild(int index, int potentialGrandparent) {
    if (index <= 2) return false;
    return _grandparent(index) == potentialGrandparent;
  }

  /// Push-down on min level.
  void _pushDownMin(int index) {
    while (true) {
      final descendants = _childrenAndGrandchildren(index);
      if (descendants.isEmpty) break;

      // Find the smallest among children and grandchildren
      var smallestIndex = descendants[0];
      for (final d in descendants) {
        if (_less(_data[d], _data[smallestIndex])) {
          smallestIndex = d;
        }
      }

      if (_isGrandchild(smallestIndex, index)) {
        // Smallest is a grandchild
        if (_less(_data[smallestIndex], _data[index])) {
          _swap(smallestIndex, index);
          final parentOfSmallest = _parent(smallestIndex);
          if (_greater(_data[smallestIndex], _data[parentOfSmallest])) {
            _swap(smallestIndex, parentOfSmallest);
          }
          index = smallestIndex;
        } else {
          break;
        }
      } else {
        // Smallest is a child
        if (_less(_data[smallestIndex], _data[index])) {
          _swap(smallestIndex, index);
        }
        break;
      }
    }
  }

  /// Push-down on max level.
  void _pushDownMax(int index) {
    while (true) {
      final descendants = _childrenAndGrandchildren(index);
      if (descendants.isEmpty) break;

      // Find the largest among children and grandchildren
      var largestIndex = descendants[0];
      for (final d in descendants) {
        if (_greater(_data[d], _data[largestIndex])) {
          largestIndex = d;
        }
      }

      if (_isGrandchild(largestIndex, index)) {
        // Largest is a grandchild
        if (_greater(_data[largestIndex], _data[index])) {
          _swap(largestIndex, index);
          final parentOfLargest = _parent(largestIndex);
          if (_less(_data[largestIndex], _data[parentOfLargest])) {
            _swap(largestIndex, parentOfLargest);
          }
          index = largestIndex;
        } else {
          break;
        }
      } else {
        // Largest is a child
        if (_greater(_data[largestIndex], _data[index])) {
          _swap(largestIndex, index);
        }
        break;
      }
    }
  }

  /// Builds a min-max heap from existing data (O(n)).
  void _heapify() {
    // Start from the last non-leaf node and push down
    for (var i = (_data.length ~/ 2) - 1; i >= 0; i--) {
      _pushDown(i);
    }
  }

  /// Removes all elements from the heap. O(1)
  void clear() => _data.clear();

  /// Returns true if the heap contains [value]. O(n)
  bool contains(T value) => _data.contains(value);

  /// Returns the elements as a list (not necessarily in heap order).
  List<T> toList() => List.from(_data);

  /// Returns a sorted list from smallest to largest. O(n log n)
  /// Does not modify the heap.
  List<T> toSortedList() {
    final copy = MinMaxHeap<T>.from(_data);
    final result = <T>[];
    while (copy.isNotEmpty) {
      result.add(copy.extractMin());
    }
    return result;
  }

  /// Validates that the min-max heap property is maintained. O(n)
  bool get isValid {
    for (var i = 0; i < _data.length; i++) {
      final left = _leftChild(i);
      final right = _rightChild(i);

      if (_isMinLevel(i)) {
        // Min level: node should be <= all descendants
        if (left < _data.length && _greater(_data[i], _data[left])) {
          return false;
        }
        if (right < _data.length && _greater(_data[i], _data[right])) {
          return false;
        }
        // Check grandchildren
        if (left < _data.length) {
          final ll = _leftChild(left);
          final lr = _rightChild(left);
          if (ll < _data.length && _greater(_data[i], _data[ll])) return false;
          if (lr < _data.length && _greater(_data[i], _data[lr])) return false;
        }
        if (right < _data.length) {
          final rl = _leftChild(right);
          final rr = _rightChild(right);
          if (rl < _data.length && _greater(_data[i], _data[rl])) return false;
          if (rr < _data.length && _greater(_data[i], _data[rr])) return false;
        }
      } else {
        // Max level: node should be >= all descendants
        if (left < _data.length && _less(_data[i], _data[left])) {
          return false;
        }
        if (right < _data.length && _less(_data[i], _data[right])) {
          return false;
        }
        // Check grandchildren
        if (left < _data.length) {
          final ll = _leftChild(left);
          final lr = _rightChild(left);
          if (ll < _data.length && _less(_data[i], _data[ll])) return false;
          if (lr < _data.length && _less(_data[i], _data[lr])) return false;
        }
        if (right < _data.length) {
          final rl = _leftChild(right);
          final rr = _rightChild(right);
          if (rl < _data.length && _less(_data[i], _data[rl])) return false;
          if (rr < _data.length && _less(_data[i], _data[rr])) return false;
        }
      }
    }
    return true;
  }

  @override
  String toString() {
    if (_data.isEmpty) return 'MinMaxHeap: []';
    return 'MinMaxHeap: $_data (min: $min, max: $max)';
  }

  /// Returns a visual tree representation.
  String toTreeString() {
    if (_data.isEmpty) return '(empty)';
    final buffer = StringBuffer();
    _buildTreeString(0, '', true, buffer);
    return buffer.toString();
  }

  void _buildTreeString(
    int index,
    String prefix,
    bool isLast,
    StringBuffer buffer,
  ) {
    if (index >= _data.length) return;

    final levelType = _isMinLevel(index) ? 'min' : 'max';
    buffer.writeln('$prefix${isLast ? '└── ' : '├── '}${_data[index]} ($levelType)');

    final left = _leftChild(index);
    final right = _rightChild(index);

    final children = <int>[];
    if (left < _data.length) children.add(left);
    if (right < _data.length) children.add(right);

    for (var i = 0; i < children.length; i++) {
      _buildTreeString(
        children[i],
        '$prefix${isLast ? '    ' : '│   '}',
        i == children.length - 1,
        buffer,
      );
    }
  }
}
