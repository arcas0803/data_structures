/// # AVL Tree (Self-balancing)
///
/// A self-balancing binary search tree where the heights of the two
/// child subtrees differ by at most one.
///
/// Time Complexity (guaranteed):
/// - Search: O(log n)
/// - Insert: O(log n)
/// - Delete: O(log n)
///
/// Named after inventors Adelson-Velsky and Landis (1962).
library;

import '../linear/queue.dart';

/// Node for the AVL tree with height tracking.
class AVLNode<T> {
  /// The value stored in this node.
  T value;

  /// Left child.
  AVLNode<T>? left;

  /// Right child.
  AVLNode<T>? right;

  /// Height of this subtree.
  int height;

  /// Creates a new node with the given [value].
  AVLNode(this.value, {this.left, this.right, this.height = 1});

  /// Returns the balance factor of this node.
  int get balanceFactor => _getHeight(left) - _getHeight(right);

  static int _getHeight<T>(AVLNode<T>? node) =>
      node?.height ?? 0;

  /// Updates the height based on children.
  void updateHeight() {
    height = 1 + _max(_getHeight(left), _getHeight(right));
  }

  static int _max(int a, int b) => a > b ? a : b;

  @override
  String toString() => 'AVLNode($value, h=$height, bf=$balanceFactor)';
}

/// A self-balancing AVL tree data structure.
class AVLTree<T extends Comparable<dynamic>> {
  AVLNode<T>? _root;
  int _size = 0;

  /// Creates an empty AVL tree.
  AVLTree();

  /// Creates an AVL tree from an iterable.
  factory AVLTree.from(Iterable<T> elements) {
    final tree = AVLTree<T>();
    for (final element in elements) {
      tree.insert(element);
    }
    return tree;
  }

  /// Returns the root node.
  AVLNode<T>? get root => _root;

  /// Returns the number of elements in the tree.
  int get length => _size;

  /// Returns true if the tree is empty.
  bool get isEmpty => _root == null;

  /// Returns true if the tree is not empty.
  bool get isNotEmpty => _root != null;

  /// Returns the height of the tree.
  int get height => _root?.height ?? 0;

  // ============ Rotations ============

  /// Right rotation (for left-left case).
  ///
  ///       y                x
  ///      / \              / \
  ///     x   T3    =>    T1   y
  ///    / \                  / \
  ///   T1  T2               T2  T3
  AVLNode<T> _rotateRight(AVLNode<T> y) {
    final x = y.left!;
    final t2 = x.right;

    x.right = y;
    y.left = t2;

    y.updateHeight();
    x.updateHeight();

    return x;
  }

  /// Left rotation (for right-right case).
  ///
  ///     x                    y
  ///    / \                  / \
  ///   T1  y       =>       x   T3
  ///      / \              / \
  ///     T2  T3           T1  T2
  AVLNode<T> _rotateLeft(AVLNode<T> x) {
    final y = x.right!;
    final t2 = y.left;

    y.left = x;
    x.right = t2;

    x.updateHeight();
    y.updateHeight();

    return y;
  }

  /// Rebalances a node if necessary.
  AVLNode<T> _rebalance(AVLNode<T> node) {
    node.updateHeight();
    final balance = node.balanceFactor;

    // Left-heavy
    if (balance > 1) {
      // Left-Right case: rotate left child left first
      if (node.left!.balanceFactor < 0) {
        node.left = _rotateLeft(node.left!);
      }
      // Left-Left case
      return _rotateRight(node);
    }

    // Right-heavy
    if (balance < -1) {
      // Right-Left case: rotate right child right first
      if (node.right!.balanceFactor > 0) {
        node.right = _rotateRight(node.right!);
      }
      // Right-Right case
      return _rotateLeft(node);
    }

    return node;
  }

  /// Inserts a value into the tree. O(log n)
  /// Returns true if the value was inserted (not duplicate).
  bool insert(T value) {
    final sizeBefore = _size;
    _root = _insert(_root, value);
    return _size > sizeBefore;
  }

  AVLNode<T> _insert(AVLNode<T>? node, T value) {
    if (node == null) {
      _size++;
      return AVLNode(value);
    }

    final cmp = value.compareTo(node.value);
    if (cmp < 0) {
      node.left = _insert(node.left, value);
    } else if (cmp > 0) {
      node.right = _insert(node.right, value);
    } else {
      // Duplicate, don't insert
      return node;
    }

    return _rebalance(node);
  }

  /// Returns true if the tree contains [value]. O(log n)
  bool contains(T value) {
    return _search(_root, value) != null;
  }

  /// Searches for a value and returns its node. O(log n)
  AVLNode<T>? search(T value) => _search(_root, value);

  AVLNode<T>? _search(AVLNode<T>? node, T value) {
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

  /// Returns the minimum value in the tree. O(log n)
  /// Throws [StateError] if the tree is empty.
  T get min {
    if (_root == null) {
      throw StateError('Cannot get min of empty tree');
    }
    return _minNode(_root!)!.value;
  }

  AVLNode<T>? _minNode(AVLNode<T>? node) {
    if (node == null) return null;
    while (node!.left != null) {
      node = node.left;
    }
    return node;
  }

  /// Returns the maximum value in the tree. O(log n)
  /// Throws [StateError] if the tree is empty.
  T get max {
    if (_root == null) {
      throw StateError('Cannot get max of empty tree');
    }
    var node = _root;
    while (node!.right != null) {
      node = node.right;
    }
    return node.value;
  }

  /// Removes a value from the tree. O(log n)
  /// Returns true if the value was found and removed.
  bool remove(T value) {
    final sizeBefore = _size;
    _root = _remove(_root, value);
    return _size < sizeBefore;
  }

  AVLNode<T>? _remove(AVLNode<T>? node, T value) {
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
        final successor = _minNode(node.right)!;
        node.value = successor.value;
        _size++; // Compensate for recursive remove
        node.right = _remove(node.right, successor.value);
      }
    }

    return _rebalance(node);
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

  Iterable<T> _inOrder(AVLNode<T>? node) sync* {
    if (node == null) return;
    yield* _inOrder(node.left);
    yield node.value;
    yield* _inOrder(node.right);
  }

  /// Pre-order traversal (root, left, right).
  Iterable<T> get preOrder sync* {
    yield* _preOrder(_root);
  }

  Iterable<T> _preOrder(AVLNode<T>? node) sync* {
    if (node == null) return;
    yield node.value;
    yield* _preOrder(node.left);
    yield* _preOrder(node.right);
  }

  /// Post-order traversal (left, right, root).
  Iterable<T> get postOrder sync* {
    yield* _postOrder(_root);
  }

  Iterable<T> _postOrder(AVLNode<T>? node) sync* {
    if (node == null) return;
    yield* _postOrder(node.left);
    yield* _postOrder(node.right);
    yield node.value;
  }

  /// Level-order traversal (BFS).
  Iterable<T> get levelOrder sync* {
    if (_root == null) return;

    final queue = Queue<AVLNode<T>>();
    queue.enqueue(_root!);

    while (queue.isNotEmpty) {
      final node = queue.dequeue();
      yield node.value;

      if (node.left != null) queue.enqueue(node.left!);
      if (node.right != null) queue.enqueue(node.right!);
    }
  }

  /// Returns values in the range [low, high] inclusive.
  Iterable<T> range(T low, T high) sync* {
    yield* _range(_root, low, high);
  }

  Iterable<T> _range(AVLNode<T>? node, T low, T high) sync* {
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

  /// Returns true if the tree maintains AVL property.
  bool get isValid => _isValid(_root);

  bool _isValid(AVLNode<T>? node) {
    if (node == null) return true;

    final balance = node.balanceFactor;
    if (balance < -1 || balance > 1) return false;

    return _isValid(node.left) && _isValid(node.right);
  }

  @override
  String toString() {
    if (_root == null) return 'AVLTree: (empty)';
    return 'AVLTree: [${inOrder.join(', ')}] (height: $height)';
  }

  /// Returns a visual representation of the tree.
  String toTreeString() {
    if (_root == null) return '(empty)';
    final buffer = StringBuffer();
    _buildTreeString(_root, '', true, buffer);
    return buffer.toString();
  }

  void _buildTreeString(
    AVLNode<T>? node,
    String prefix,
    bool isLast,
    StringBuffer buffer,
  ) {
    if (node == null) return;

    buffer.writeln(
      '$prefix${isLast ? '└── ' : '├── '}${node.value} (h=${node.height}, bf=${node.balanceFactor})',
    );

    final children = <AVLNode<T>?>[];
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
