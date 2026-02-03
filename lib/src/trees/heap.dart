/// # Heap (Binary Heap)
///
/// A complete binary tree that satisfies the heap property:
/// - Min-Heap: parent is smaller than or equal to children
/// - Max-Heap: parent is larger than or equal to children
///
/// Time Complexity:
/// - Insert: O(log n)
/// - Extract min/max: O(log n)
/// - Peek: O(1)
/// - Build heap: O(n)
///
/// Commonly used for priority queues.
library;

/// Heap type enumeration.
enum HeapType {
  /// Min-heap: smallest element at root.
  min,

  /// Max-heap: largest element at root.
  max,
}

/// A binary heap data structure (can be min-heap or max-heap).
class Heap<T extends Comparable<dynamic>> {
  final List<T> _data = [];
  final HeapType type;

  /// Creates an empty heap of the specified [type].
  Heap({this.type = HeapType.min});

  /// Creates a min-heap.
  factory Heap.minHeap() => Heap(type: HeapType.min);

  /// Creates a max-heap.
  factory Heap.maxHeap() => Heap(type: HeapType.max);

  /// Creates a heap from an iterable using heapify (O(n)).
  factory Heap.from(Iterable<T> elements, {HeapType type = HeapType.min}) {
    final heap = Heap<T>(type: type);
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

  /// Returns the root element without removing it. O(1)
  /// Throws [StateError] if the heap is empty.
  T get peek {
    if (_data.isEmpty) {
      throw StateError('Cannot peek empty heap');
    }
    return _data[0];
  }

  /// Returns the root element without removing it, or null if empty. O(1)
  T? tryPeek() => _data.isEmpty ? null : _data[0];

  /// Compares two values according to heap type.
  /// Returns true if a should be higher in the heap than b.
  bool _compare(T a, T b) {
    final cmp = a.compareTo(b);
    return type == HeapType.min ? cmp < 0 : cmp > 0;
  }

  /// Returns the parent index of the node at [index].
  int _parent(int index) => (index - 1) ~/ 2;

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

  /// Moves an element up to restore heap property. O(log n)
  void _siftUp(int index) {
    while (index > 0) {
      final parentIndex = _parent(index);
      if (_compare(_data[index], _data[parentIndex])) {
        _swap(index, parentIndex);
        index = parentIndex;
      } else {
        break;
      }
    }
  }

  /// Moves an element down to restore heap property. O(log n)
  void _siftDown(int index) {
    while (true) {
      var best = index;
      final left = _leftChild(index);
      final right = _rightChild(index);

      if (left < _data.length && _compare(_data[left], _data[best])) {
        best = left;
      }
      if (right < _data.length && _compare(_data[right], _data[best])) {
        best = right;
      }

      if (best == index) break;

      _swap(index, best);
      index = best;
    }
  }

  /// Builds a heap from existing data (O(n)).
  void _heapify() {
    // Start from the last non-leaf node and sift down
    for (var i = (_data.length ~/ 2) - 1; i >= 0; i--) {
      _siftDown(i);
    }
  }

  /// Inserts a value into the heap. O(log n)
  void insert(T value) {
    _data.add(value);
    _siftUp(_data.length - 1);
  }

  /// Alias for [insert].
  void add(T value) => insert(value);

  /// Inserts multiple values into the heap.
  void addAll(Iterable<T> values) {
    for (final value in values) {
      insert(value);
    }
  }

  /// Removes and returns the root element. O(log n)
  /// Throws [StateError] if the heap is empty.
  T extract() {
    if (_data.isEmpty) {
      throw StateError('Cannot extract from empty heap');
    }

    final root = _data[0];
    final last = _data.removeLast();

    if (_data.isNotEmpty) {
      _data[0] = last;
      _siftDown(0);
    }

    return root;
  }

  /// Removes and returns the root element, or null if empty. O(log n)
  T? tryExtract() {
    if (_data.isEmpty) return null;
    return extract();
  }

  /// Replaces the root with [value] and rebalances. O(log n)
  /// More efficient than extract + insert.
  T replace(T value) {
    if (_data.isEmpty) {
      throw StateError('Cannot replace on empty heap');
    }
    final root = _data[0];
    _data[0] = value;
    _siftDown(0);
    return root;
  }

  /// Returns true if the heap contains [value]. O(n)
  bool contains(T value) => _data.contains(value);

  /// Removes all elements from the heap. O(1)
  void clear() => _data.clear();

  /// Returns the elements as a list (not necessarily in heap order).
  List<T> get values => List.from(_data);

  /// Returns elements in sorted order (extracts all). O(n log n)
  /// Note: This empties the heap!
  List<T> extractAll() {
    final result = <T>[];
    while (isNotEmpty) {
      result.add(extract());
    }
    return result;
  }

  /// Returns a copy with elements in sorted order. O(n log n)
  List<T> toSortedList() {
    final copy = Heap<T>.from(_data, type: type);
    return copy.extractAll();
  }

  /// Validates that the heap property is maintained. O(n)
  bool get isValid {
    for (var i = 0; i < _data.length; i++) {
      final left = _leftChild(i);
      final right = _rightChild(i);

      if (left < _data.length && _compare(_data[left], _data[i])) {
        return false;
      }
      if (right < _data.length && _compare(_data[right], _data[i])) {
        return false;
      }
    }
    return true;
  }

  /// Merges another heap into this one. O(n + m)
  void merge(Heap<T> other) {
    _data.addAll(other._data);
    _heapify();
  }

  @override
  String toString() {
    final typeName = type == HeapType.min ? 'MinHeap' : 'MaxHeap';
    if (_data.isEmpty) return '$typeName: []';
    return '$typeName: $_data (root: ${_data[0]})';
  }

  /// Returns a visual tree representation.
  String toTreeString() {
    if (_data.isEmpty) return '(empty)';
    final buffer = StringBuffer();
    _buildTreeString(0, '', true, buffer);
    return buffer.toString();
  }

  void _buildTreeString(int index, String prefix, bool isLast, StringBuffer buffer) {
    if (index >= _data.length) return;

    buffer.writeln('$prefix${isLast ? '└── ' : '├── '}${_data[index]}');

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

/// A priority queue implemented using a heap.
class PriorityQueue<T extends Comparable<dynamic>> {
  final Heap<T> _heap;

  /// Creates a min-priority queue (smallest first).
  PriorityQueue() : _heap = Heap.minHeap();

  /// Creates a max-priority queue (largest first).
  PriorityQueue.maxPriority() : _heap = Heap.maxHeap();

  /// Creates a priority queue from an iterable.
  factory PriorityQueue.from(Iterable<T> elements, {bool maxPriority = false}) {
    final queue = maxPriority ? PriorityQueue<T>.maxPriority() : PriorityQueue<T>();
    queue._heap._data.addAll(elements);
    queue._heap._heapify();
    return queue;
  }

  /// Returns the number of elements in the queue.
  int get length => _heap.length;

  /// Returns true if the queue is empty.
  bool get isEmpty => _heap.isEmpty;

  /// Returns true if the queue is not empty.
  bool get isNotEmpty => _heap.isNotEmpty;

  /// Adds an element with its natural priority. O(log n)
  void enqueue(T value) => _heap.insert(value);

  /// Alias for [enqueue].
  void add(T value) => enqueue(value);

  /// Removes and returns the highest priority element. O(log n)
  T dequeue() => _heap.extract();

  /// Returns the highest priority element without removing it. O(1)
  T peek() => _heap.peek;

  /// Returns the highest priority element, or null if empty. O(1)
  T? tryPeek() => _heap.tryPeek();

  /// Removes and returns the highest priority element, or null if empty. O(log n)
  T? tryDequeue() => _heap.tryExtract();

  /// Returns true if the queue contains [value]. O(n)
  bool contains(T value) => _heap.contains(value);

  /// Removes all elements from the queue. O(1)
  void clear() => _heap.clear();

  /// Returns all elements in priority order (empties the queue). O(n log n)
  List<T> toSortedList() => _heap.toSortedList();

  @override
  String toString() => 'PriorityQueue: ${_heap._data}';
}
