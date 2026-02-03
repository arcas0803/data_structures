/// # Binary Search Tree (BST)
///
/// A binary search tree where each node has at most two children.
/// Left children are smaller, right children are larger.
///
/// Time Complexity (average case):
/// - Search: O(log n)
/// - Insert: O(log n)
/// - Delete: O(log n)
/// - Min/Max: O(log n)
///
/// Worst case (unbalanced): O(n) for all operations
library;

import '../linear/queue.dart';

/// Node for the binary search tree.
class BSTNode<T> {
  /// The value stored in this node.
  T value;

  /// Left child (smaller values).
  BSTNode<T>? left;

  /// Right child (larger values).
  BSTNode<T>? right;

  /// Creates a new node with the given [value].
  BSTNode(this.value, {this.left, this.right});

  /// Returns true if this is a leaf node.
  bool get isLeaf => left == null && right == null;

  /// Returns the number of children.
  int get childCount => (left != null ? 1 : 0) + (right != null ? 1 : 0);

  @override
  String toString() => 'BSTNode($value)';
}

/// A binary search tree data structure.
class BinarySearchTree<T extends Comparable<dynamic>> {
  BSTNode<T>? _root;
  int _size = 0;

  /// Creates an empty binary search tree.
  BinarySearchTree();

  /// Creates a BST from an iterable.
  factory BinarySearchTree.from(Iterable<T> elements) {
    final tree = BinarySearchTree<T>();
    for (final element in elements) {
      tree.insert(element);
    }
    return tree;
  }

  /// Returns the root node.
  BSTNode<T>? get root => _root;

  /// Returns the number of elements in the tree.
  int get length => _size;

  /// Returns true if the tree is empty.
  bool get isEmpty => _root == null;

  /// Returns true if the tree is not empty.
  bool get isNotEmpty => _root != null;

  /// Returns the height of the tree.
  int get height => _height(_root);

  int _height(BSTNode<T>? node) {
    if (node == null) return -1;
    return 1 + _max(_height(node.left), _height(node.right));
  }

  int _max(int a, int b) => a > b ? a : b;

  /// Inserts a value into the tree. O(log n) average
  /// Returns true if the value was inserted (not duplicate).
  bool insert(T value) {
    final result = _insert(_root, value);
    if (result.inserted) {
      _root = result.node;
      _size++;
    }
    return result.inserted;
  }

  ({BSTNode<T> node, bool inserted}) _insert(BSTNode<T>? node, T value) {
    if (node == null) {
      return (node: BSTNode(value), inserted: true);
    }

    final cmp = value.compareTo(node.value);
    if (cmp < 0) {
      final result = _insert(node.left, value);
      node.left = result.node;
      return (node: node, inserted: result.inserted);
    } else if (cmp > 0) {
      final result = _insert(node.right, value);
      node.right = result.node;
      return (node: node, inserted: result.inserted);
    } else {
      // Duplicate value
      return (node: node, inserted: false);
    }
  }

  /// Returns true if the tree contains [value]. O(log n) average
  bool contains(T value) {
    return _search(_root, value) != null;
  }

  /// Searches for a value and returns its node. O(log n) average
  BSTNode<T>? search(T value) => _search(_root, value);

  BSTNode<T>? _search(BSTNode<T>? node, T value) {
    if (node == null) return null;

    final cmp = value.compareTo(node.value);
    if (cmp < 0) {
      return _search(node.left, value);
    } else if (cmp > 0) {
      return _search(node.right, value);
    } else {
      return node;
    }
  }

  /// Returns the minimum value in the tree. O(log n) average
  /// Throws [StateError] if the tree is empty.
  T get min {
    if (_root == null) {
      throw StateError('Cannot get min of empty tree');
    }
    return _minNode(_root!)!.value;
  }

  BSTNode<T>? _minNode(BSTNode<T>? node) {
    if (node == null) return null;
    while (node!.left != null) {
      node = node.left;
    }
    return node;
  }

  /// Returns the maximum value in the tree. O(log n) average
  /// Throws [StateError] if the tree is empty.
  T get max {
    if (_root == null) {
      throw StateError('Cannot get max of empty tree');
    }
    return _maxNode(_root!)!.value;
  }

  BSTNode<T>? _maxNode(BSTNode<T>? node) {
    if (node == null) return null;
    while (node!.right != null) {
      node = node.right;
    }
    return node;
  }

  /// Removes a value from the tree. O(log n) average
  /// Returns true if the value was found and removed.
  bool remove(T value) {
    final sizeBefore = _size;
    _root = _remove(_root, value);
    return _size < sizeBefore;
  }

  BSTNode<T>? _remove(BSTNode<T>? node, T value) {
    if (node == null) return null;

    final cmp = value.compareTo(node.value);
    if (cmp < 0) {
      node.left = _remove(node.left, value);
    } else if (cmp > 0) {
      node.right = _remove(node.right, value);
    } else {
      // Found the node to remove
      _size--;

      if (node.left == null) {
        return node.right;
      } else if (node.right == null) {
        return node.left;
      } else {
        // Node has two children
        // Replace with in-order successor (minimum of right subtree)
        final successor = _minNode(node.right)!;
        node.value = successor.value;
        _size++; // Compensate for the recursive remove
        node.right = _remove(node.right, successor.value);
      }
    }
    return node;
  }

  /// Removes all elements from the tree. O(1)
  void clear() {
    _root = null;
    _size = 0;
  }

  // ============ Traversal Methods ============

  /// In-order traversal (left, root, right) - sorted order.
  Iterable<T> get inOrder sync* {
    yield* _inOrder(_root);
  }

  Iterable<T> _inOrder(BSTNode<T>? node) sync* {
    if (node == null) return;
    yield* _inOrder(node.left);
    yield node.value;
    yield* _inOrder(node.right);
  }

  /// Pre-order traversal (root, left, right).
  Iterable<T> get preOrder sync* {
    yield* _preOrder(_root);
  }

  Iterable<T> _preOrder(BSTNode<T>? node) sync* {
    if (node == null) return;
    yield node.value;
    yield* _preOrder(node.left);
    yield* _preOrder(node.right);
  }

  /// Post-order traversal (left, right, root).
  Iterable<T> get postOrder sync* {
    yield* _postOrder(_root);
  }

  Iterable<T> _postOrder(BSTNode<T>? node) sync* {
    if (node == null) return;
    yield* _postOrder(node.left);
    yield* _postOrder(node.right);
    yield node.value;
  }

  /// Level-order traversal (BFS - Breadth First Search).
  Iterable<T> get levelOrder sync* {
    if (_root == null) return;

    final queue = Queue<BSTNode<T>>();
    queue.enqueue(_root!);

    while (queue.isNotEmpty) {
      final node = queue.dequeue();
      yield node.value;

      if (node.left != null) queue.enqueue(node.left!);
      if (node.right != null) queue.enqueue(node.right!);
    }
  }

  /// Returns the predecessor of [value] (next smaller value).
  T? predecessor(T value) {
    T? result;
    var node = _root;

    while (node != null) {
      final cmp = value.compareTo(node.value);
      if (cmp <= 0) {
        node = node.left;
      } else {
        result = node.value;
        node = node.right;
      }
    }
    return result;
  }

  /// Returns the successor of [value] (next larger value).
  T? successor(T value) {
    T? result;
    var node = _root;

    while (node != null) {
      final cmp = value.compareTo(node.value);
      if (cmp >= 0) {
        node = node.right;
      } else {
        result = node.value;
        node = node.left;
      }
    }
    return result;
  }

  /// Returns values in the range [low, high] inclusive.
  Iterable<T> range(T low, T high) sync* {
    yield* _range(_root, low, high);
  }

  Iterable<T> _range(BSTNode<T>? node, T low, T high) sync* {
    if (node == null) return;

    if (low.compareTo(node.value) < 0) {
      yield* _range(node.left, low, high);
    }
    if (low.compareTo(node.value) <= 0 && node.value.compareTo(high) <= 0) {
      yield node.value;
    }
    if (node.value.compareTo(high) < 0) {
      yield* _range(node.right, low, high);
    }
  }

  /// Converts the tree to a sorted Dart List. O(n)
  List<T> toList() => inOrder.toList();

  /// Returns true if the tree is balanced.
  bool get isBalanced => _isBalanced(_root) != -1;

  int _isBalanced(BSTNode<T>? node) {
    if (node == null) return 0;

    final leftHeight = _isBalanced(node.left);
    if (leftHeight == -1) return -1;

    final rightHeight = _isBalanced(node.right);
    if (rightHeight == -1) return -1;

    if ((leftHeight - rightHeight).abs() > 1) return -1;

    return 1 + _max(leftHeight, rightHeight);
  }

  @override
  String toString() {
    if (_root == null) return 'BinarySearchTree: (empty)';
    return 'BinarySearchTree: [${inOrder.join(', ')}]';
  }

  /// Returns a visual representation of the tree.
  String toTreeString() {
    if (_root == null) return '(empty)';
    final buffer = StringBuffer();
    _buildTreeString(_root, '', true, buffer);
    return buffer.toString();
  }

  void _buildTreeString(
    BSTNode<T>? node,
    String prefix,
    bool isLast,
    StringBuffer buffer,
  ) {
    if (node == null) return;

    buffer.writeln('$prefix${isLast ? '└── ' : '├── '}${node.value}');

    final children = <BSTNode<T>?>[];
    if (node.left != null || node.right != null) {
      children.add(node.left);
      children.add(node.right);
    }

    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      if (child != null) {
        _buildTreeString(
          child,
          '$prefix${isLast ? '    ' : '│   '}',
          i == children.length - 1 || (i == 0 && children[1] == null),
          buffer,
        );
      }
    }
  }
}
