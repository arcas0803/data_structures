/// # N-ary Tree (General Tree)
///
/// A tree data structure where each node can have any number of children.
/// Unlike binary trees, nodes are not limited to two children.
///
/// Use cases:
/// - File systems (directories with multiple files/subdirectories)
/// - Organization hierarchies (employees with multiple reports)
/// - DOM trees (HTML elements with multiple children)
/// - Category taxonomies (categories with subcategories)
///
/// Time Complexity:
/// - Find: O(n) - must search all nodes
/// - Insert: O(n) - must find parent first
/// - Remove: O(n) - must find node first
/// - Traversals: O(n)
library;

import '../linear/queue.dart';

/// A node in an N-ary tree that can have any number of children.
class NaryTreeNode<T> {
  /// The value stored in this node.
  T value;

  /// List of child nodes.
  final List<NaryTreeNode<T>> children;

  /// Optional reference to the parent node.
  NaryTreeNode<T>? parent;

  /// Creates a new node with the given [value].
  NaryTreeNode(this.value, {this.parent, List<NaryTreeNode<T>>? children})
      : children = children ?? [];

  /// Returns true if this is a leaf node (no children).
  bool get isLeaf => children.isEmpty;

  /// Returns true if this is the root node (no parent).
  bool get isRoot => parent == null;

  /// Returns the number of children.
  int get childCount => children.length;

  /// Adds a child node with the given [value].
  NaryTreeNode<T> addChild(T value) {
    final child = NaryTreeNode<T>(value, parent: this);
    children.add(child);
    return child;
  }

  /// Removes a child node from this node's children list.
  bool removeChild(NaryTreeNode<T> child) {
    return children.remove(child);
  }

  @override
  String toString() => 'NaryTreeNode($value)';
}

/// An N-ary tree (general tree) where nodes can have multiple children.
class NaryTree<T> {
  NaryTreeNode<T>? _root;
  int _size = 0;

  /// Creates an empty N-ary tree.
  NaryTree();

  /// Creates an N-ary tree with a root value.
  NaryTree.withRoot(T rootValue) {
    _root = NaryTreeNode<T>(rootValue);
    _size = 1;
  }

  /// Returns the root node.
  NaryTreeNode<T>? get root => _root;

  /// Returns the number of nodes in the tree.
  int get size => _size;

  /// Returns true if the tree is empty.
  bool get isEmpty => _root == null;

  /// Returns true if the tree is not empty.
  bool get isNotEmpty => _root != null;

  /// Returns the height of the tree.
  /// An empty tree has height -1, a single node has height 0.
  int get height => _height(_root);

  int _height(NaryTreeNode<T>? node) {
    if (node == null) return -1;
    if (node.isLeaf) return 0;

    var maxChildHeight = -1;
    for (final child in node.children) {
      final childHeight = _height(child);
      if (childHeight > maxChildHeight) {
        maxChildHeight = childHeight;
      }
    }
    return 1 + maxChildHeight;
  }

  /// Sets the root of the tree.
  /// Returns the created root node.
  NaryTreeNode<T> setRoot(T value) {
    _root = NaryTreeNode<T>(value);
    _size = 1;
    return _root!;
  }

  /// Adds a child with [childValue] to the node with [parentValue].
  /// Returns the new child node, or null if parent was not found.
  NaryTreeNode<T>? addChild(T parentValue, T childValue) {
    final parent = find(parentValue);
    if (parent == null) return null;

    final child = parent.addChild(childValue);
    _size++;
    return child;
  }

  /// Finds a node by its value using DFS.
  /// Returns null if not found.
  NaryTreeNode<T>? find(T value) {
    return _find(_root, value);
  }

  NaryTreeNode<T>? _find(NaryTreeNode<T>? node, T value) {
    if (node == null) return null;
    if (node.value == value) return node;

    for (final child in node.children) {
      final result = _find(child, value);
      if (result != null) return result;
    }
    return null;
  }

  /// Returns true if the tree contains a node with [value].
  bool contains(T value) => find(value) != null;

  /// Removes the node with [value] and all its subtree.
  /// Returns true if the node was found and removed.
  bool remove(T value) {
    if (_root == null) return false;

    // Special case: removing the root
    if (_root!.value == value) {
      final removedCount = _countNodes(_root);
      _root = null;
      _size -= removedCount;
      return true;
    }

    final node = find(value);
    if (node == null) return false;

    final parent = node.parent;
    if (parent == null) return false;

    final removedCount = _countNodes(node);
    parent.removeChild(node);
    _size -= removedCount;
    return true;
  }

  int _countNodes(NaryTreeNode<T>? node) {
    if (node == null) return 0;
    var count = 1;
    for (final child in node.children) {
      count += _countNodes(child);
    }
    return count;
  }

  /// Removes all nodes from the tree.
  void clear() {
    _root = null;
    _size = 0;
  }

  // ============ Traversal Methods ============

  /// Pre-order traversal: visit node, then children left to right.
  Iterable<T> get preOrder sync* {
    yield* _preOrder(_root);
  }

  Iterable<T> _preOrder(NaryTreeNode<T>? node) sync* {
    if (node == null) return;
    yield node.value;
    for (final child in node.children) {
      yield* _preOrder(child);
    }
  }

  /// Post-order traversal: visit children, then node.
  Iterable<T> get postOrder sync* {
    yield* _postOrder(_root);
  }

  Iterable<T> _postOrder(NaryTreeNode<T>? node) sync* {
    if (node == null) return;
    for (final child in node.children) {
      yield* _postOrder(child);
    }
    yield node.value;
  }

  /// Level-order traversal (BFS - Breadth First Search).
  Iterable<T> get levelOrder sync* {
    if (_root == null) return;

    final queue = Queue<NaryTreeNode<T>>();
    queue.enqueue(_root!);

    while (queue.isNotEmpty) {
      final node = queue.dequeue();
      yield node.value;

      for (final child in node.children) {
        queue.enqueue(child);
      }
    }
  }

  /// Converts the tree to a list using pre-order traversal.
  List<T> toList() => preOrder.toList();

  @override
  String toString() {
    if (_root == null) return 'NaryTree: (empty)';
    return 'NaryTree: [${preOrder.join(', ')}]';
  }

  /// Returns a visual representation of the tree.
  String toTreeString() {
    if (_root == null) return '(empty)';
    final buffer = StringBuffer();
    _buildTreeString(_root, '', true, buffer);
    return buffer.toString();
  }

  void _buildTreeString(
    NaryTreeNode<T>? node,
    String prefix,
    bool isLast,
    StringBuffer buffer,
  ) {
    if (node == null) return;

    buffer.writeln('$prefix${isLast ? '└── ' : '├── '}${node.value}');

    for (var i = 0; i < node.children.length; i++) {
      _buildTreeString(
        node.children[i],
        '$prefix${isLast ? '    ' : '│   '}',
        i == node.children.length - 1,
        buffer,
      );
    }
  }
}
