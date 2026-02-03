/// # Skip List
///
/// A probabilistic data structure that allows O(log n) search, insert,
/// and delete operations by maintaining multiple layers of linked lists.
///
/// The bottom layer contains all elements in sorted order. Each upper layer
/// acts as an "express lane" that skips some elements for faster traversal.
/// Nodes are randomly assigned levels using a probability factor.
///
/// Time Complexity (expected):
/// - Search: O(log n)
/// - Insert: O(log n)
/// - Delete: O(log n)
///
/// Space Complexity: O(n) expected
library;

import 'dart:math';

/// Node for the skip list.
class SkipListNode<T extends Comparable<dynamic>> {
  /// The value stored in this node (nullable for sentinel head node).
  T? value;

  /// Forward pointers for each level (index 0 is the bottom level).
  final List<SkipListNode<T>?> forward;

  /// Creates a new node with the given [value] and [level].
  SkipListNode(this.value, int level) : forward = List.filled(level, null);

  /// Creates a sentinel node with no value.
  SkipListNode.sentinel(int level)
    : value = null,
      forward = List.filled(level, null);

  @override
  String toString() => 'SkipListNode($value, level: ${forward.length})';
}

/// A probabilistic skip list data structure.
///
/// Elements must implement [Comparable] to maintain sorted order.
/// Duplicate values are allowed and stored as separate nodes.
class SkipList<T extends Comparable<dynamic>> {
  /// Maximum number of levels in the skip list.
  final int maxLevel;

  /// Probability factor for level generation (0.0 to 1.0).
  final double probability;

  /// Head sentinel node (does not store a real value).
  late SkipListNode<T> _head;

  /// Current highest level in use (0-indexed).
  int _level = 0;

  /// Number of elements in the skip list.
  int _length = 0;

  /// Random number generator for level assignment.
  final Random _random;

  /// Creates an empty skip list.
  ///
  /// [maxLevel] defines the maximum number of levels (default 16).
  /// [probability] defines the chance of promoting to higher levels (default 0.5).
  SkipList({this.maxLevel = 16, this.probability = 0.5, Random? random})
    : _random = random ?? Random() {
    _validateParameters();
    _initializeHead();
  }

  /// Creates a skip list from an iterable.
  factory SkipList.from(
    Iterable<T> elements, {
    int maxLevel = 16,
    double probability = 0.5,
    Random? random,
  }) {
    final list = SkipList<T>(
      maxLevel: maxLevel,
      probability: probability,
      random: random,
    );
    for (final element in elements) {
      list.insert(element);
    }
    return list;
  }

  void _validateParameters() {
    if (maxLevel < 1) {
      throw ArgumentError.value(maxLevel, 'maxLevel', 'Must be at least 1');
    }
    if (probability <= 0.0 || probability >= 1.0) {
      throw ArgumentError.value(
        probability,
        'probability',
        'Must be between 0.0 and 1.0 (exclusive)',
      );
    }
  }

  void _initializeHead() {
    // Create a sentinel head node without a value.
    _head = SkipListNode<T>.sentinel(maxLevel);
  }

  SkipListNode<T> _createNode(T value, int level) {
    return SkipListNode<T>(value, level);
  }

  /// Generates a random level for a new node.
  int _randomLevel() {
    var level = 1;
    while (_random.nextDouble() < probability && level < maxLevel) {
      level++;
    }
    return level;
  }

  /// Returns the number of elements in the skip list.
  int get length => _length;

  /// Returns true if the skip list is empty.
  bool get isEmpty => _length == 0;

  /// Returns true if the skip list is not empty.
  bool get isNotEmpty => _length > 0;

  /// Returns the current number of levels in use.
  int get currentLevel => _level + 1;

  /// Returns the minimum element in the skip list.
  /// Throws [StateError] if the skip list is empty.
  T get min {
    if (isEmpty) {
      throw StateError('Cannot get min of empty skip list');
    }
    return _head.forward[0]!.value!;
  }

  /// Returns the maximum element in the skip list.
  /// Throws [StateError] if the skip list is empty.
  T get max {
    if (isEmpty) {
      throw StateError('Cannot get max of empty skip list');
    }
    var current = _head;
    for (var i = _level; i >= 0; i--) {
      while (current.forward[i] != null) {
        current = current.forward[i]!;
      }
    }
    return current.value!;
  }

  /// Inserts a value into the skip list. O(log n) expected.
  ///
  /// Duplicate values are allowed and will be inserted as separate nodes.
  void insert(T value) {
    // Track nodes that need their forward pointers updated.
    final update = List<SkipListNode<T>?>.filled(maxLevel, null);
    var current = _head;

    // Find insertion position at each level.
    for (var i = _level; i >= 0; i--) {
      while (current.forward[i] != null &&
          current.forward[i]!.value!.compareTo(value) < 0) {
        current = current.forward[i]!;
      }
      update[i] = current;
    }

    // Generate random level for new node.
    final newLevel = _randomLevel();

    // If new level is higher than current, update tracking.
    if (newLevel > _level + 1) {
      for (var i = _level + 1; i < newLevel; i++) {
        update[i] = _head;
      }
      _level = newLevel - 1;
    }

    // Create and insert the new node.
    final newNode = _createNode(value, newLevel);
    for (var i = 0; i < newLevel; i++) {
      newNode.forward[i] = update[i]!.forward[i];
      update[i]!.forward[i] = newNode;
    }

    _length++;
  }

  /// Removes the first occurrence of [value] from the skip list. O(log n) expected.
  ///
  /// Returns true if the element was found and removed.
  bool remove(T value) {
    final update = List<SkipListNode<T>?>.filled(maxLevel, null);
    var current = _head;

    // Find the node to remove at each level.
    for (var i = _level; i >= 0; i--) {
      while (current.forward[i] != null &&
          current.forward[i]!.value!.compareTo(value) < 0) {
        current = current.forward[i]!;
      }
      update[i] = current;
    }

    current = current.forward[0] ?? _head;

    // Check if the node exists and has the target value.
    if (current != _head && current.value!.compareTo(value) == 0) {
      // Update forward pointers at each level.
      for (var i = 0; i <= _level; i++) {
        if (update[i]!.forward[i] != current) break;
        update[i]!.forward[i] = current.forward[i];
      }

      // Reduce level if necessary.
      while (_level > 0 && _head.forward[_level] == null) {
        _level--;
      }

      _length--;
      return true;
    }

    return false;
  }

  /// Returns true if the skip list contains [value]. O(log n) expected.
  bool contains(T value) {
    return search(value) != null;
  }

  /// Searches for [value] and returns the node if found, null otherwise. O(log n) expected.
  SkipListNode<T>? search(T value) {
    var current = _head;

    // Start from the highest level and work down.
    for (var i = _level; i >= 0; i--) {
      while (current.forward[i] != null &&
          current.forward[i]!.value!.compareTo(value) < 0) {
        current = current.forward[i]!;
      }
    }

    // Move to the candidate node at level 0.
    current = current.forward[0] ?? _head;

    // Check if we found the value.
    if (current != _head && current.value!.compareTo(value) == 0) {
      return current;
    }

    return null;
  }

  /// Removes all elements from the skip list. O(1)
  void clear() {
    _initializeHead();
    _level = 0;
    _length = 0;
  }

  /// Converts the skip list to a sorted Dart List. O(n)
  List<T> toList() {
    final result = <T>[];
    var current = _head.forward[0];
    while (current != null) {
      result.add(current.value!);
      current = current.forward[0];
    }
    return result;
  }

  /// Returns an iterator over the elements in sorted order.
  Iterable<T> get values sync* {
    var current = _head.forward[0];
    while (current != null) {
      yield current.value!;
      current = current.forward[0];
    }
  }

  @override
  String toString() {
    if (isEmpty) return 'SkipList: []';

    final buffer = StringBuffer('SkipList (${_level + 1} levels):\n');

    // Display each level from top to bottom.
    for (var i = _level; i >= 0; i--) {
      buffer.write('  L$i: ');
      var current = _head.forward[i];
      final levelElements = <String>[];
      while (current != null) {
        levelElements.add(current.value.toString());
        current = current.forward[i];
      }
      buffer.write(levelElements.isEmpty ? '(empty)' : levelElements.join(' -> '));
      if (i > 0) buffer.write('\n');
    }

    return buffer.toString();
  }
}
