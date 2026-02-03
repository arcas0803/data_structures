/// # B-Tree and B+ Tree
///
/// Self-balancing tree data structures optimized for disk-based storage
/// and databases where nodes can have multiple keys.
///
/// Time Complexity:
/// - Search: O(log n)
/// - Insert: O(log n)
/// - Delete: O(log n)
///
/// Use cases: databases, file systems, indexing.
library;

// ============================================================================
// B-Tree Implementation
// ============================================================================

/// A key-value pair for B-Tree entries.
class BTreeEntry<K extends Comparable<dynamic>, V> {
  /// The key.
  final K key;

  /// The value.
  V value;

  /// Creates a new entry.
  BTreeEntry(this.key, this.value);

  @override
  String toString() => '($key: $value)';
}

/// A node in the B-Tree.
class BTreeNode<K extends Comparable<dynamic>, V> {
  /// Keys and values stored in this node.
  final List<BTreeEntry<K, V>> entries;

  /// Child pointers.
  final List<BTreeNode<K, V>?> children;

  /// Whether this is a leaf node.
  bool isLeaf;

  /// Creates a new B-Tree node.
  BTreeNode({required this.isLeaf})
      : entries = [],
        children = [];

  /// Number of keys in this node.
  int get keyCount => entries.length;

  @override
  String toString() =>
      'BTreeNode(keys: ${entries.map((e) => e.key).toList()}, leaf: $isLeaf)';
}

/// A self-balancing B-Tree optimized for disk access.
///
/// Each node (except root) has between t-1 and 2t-1 keys,
/// where t is the minimum degree.
class BTree<K extends Comparable<dynamic>, V> {
  BTreeNode<K, V>? _root;
  int _size = 0;
  final int _minDegree;

  /// Creates an empty B-Tree with the specified minimum degree.
  ///
  /// The minimum degree t determines:
  /// - Each node has at most 2t-1 keys
  /// - Each non-root node has at least t-1 keys
  /// - Each non-leaf node has at most 2t children
  BTree([int minDegree = 2])
      : _minDegree = minDegree < 2 ? 2 : minDegree;

  /// Returns the minimum degree of this B-Tree.
  int get minDegree => _minDegree;

  /// Returns true if the tree is empty.
  bool get isEmpty => _root == null;

  /// Returns true if the tree is not empty.
  bool get isNotEmpty => _root != null;

  /// Returns the number of key-value pairs in the tree.
  int get length => _size;

  /// Returns the height of the tree.
  int get height {
    if (_root == null) return 0;
    var h = 1;
    var node = _root;
    while (!node!.isLeaf) {
      h++;
      node = node.children[0];
    }
    return h;
  }

  /// Returns the root node.
  BTreeNode<K, V>? get root => _root;

  /// Maximum keys per node.
  int get _maxKeys => 2 * _minDegree - 1;

  /// Minimum keys per node (except root).
  int get _minKeys => _minDegree - 1;

  // ============ Search Operations ============

  /// Searches for the value associated with [key].
  /// Returns null if not found.
  V? search(K key) {
    if (_root == null) return null;
    return _search(_root!, key);
  }

  V? _search(BTreeNode<K, V> node, K key) {
    var i = 0;

    // Find the first key >= search key
    while (i < node.keyCount && key.compareTo(node.entries[i].key) > 0) {
      i++;
    }

    // Check if we found the key
    if (i < node.keyCount && key.compareTo(node.entries[i].key) == 0) {
      return node.entries[i].value;
    }

    // If leaf, key not found
    if (node.isLeaf) {
      return null;
    }

    // Recurse to appropriate child
    return _search(node.children[i]!, key);
  }

  /// Returns true if the tree contains [key].
  bool contains(K key) => search(key) != null;

  /// Gets the value for [key], or null if not found.
  V? get(K key) => search(key);

  /// Operator for accessing values by key.
  V? operator [](K key) => search(key);

  // ============ Insert Operations ============

  /// Inserts a key-value pair into the tree.
  void insert(K key, V value) {
    if (_root == null) {
      _root = BTreeNode(isLeaf: true);
      _root!.entries.add(BTreeEntry(key, value));
      _size++;
      return;
    }

    // If root is full, split it
    if (_root!.keyCount == _maxKeys) {
      final newRoot = BTreeNode<K, V>(isLeaf: false);
      newRoot.children.add(_root);
      _splitChild(newRoot, 0);
      _root = newRoot;
    }

    _insertNonFull(_root!, key, value);
  }

  void _insertNonFull(BTreeNode<K, V> node, K key, V value) {
    var i = node.keyCount - 1;

    if (node.isLeaf) {
      // Find position and check for duplicate
      while (i >= 0 && key.compareTo(node.entries[i].key) < 0) {
        i--;
      }

      // Check for duplicate key
      if (i >= 0 && key.compareTo(node.entries[i].key) == 0) {
        // Update existing value
        node.entries[i].value = value;
        return;
      }

      // Insert new entry
      node.entries.insert(i + 1, BTreeEntry(key, value));
      _size++;
    } else {
      // Find child to recurse into
      while (i >= 0 && key.compareTo(node.entries[i].key) < 0) {
        i--;
      }

      // Check for duplicate at current node
      if (i >= 0 && key.compareTo(node.entries[i].key) == 0) {
        node.entries[i].value = value;
        return;
      }

      i++;

      // Split child if full
      if (node.children[i]!.keyCount == _maxKeys) {
        _splitChild(node, i);
        if (key.compareTo(node.entries[i].key) > 0) {
          i++;
        } else if (key.compareTo(node.entries[i].key) == 0) {
          node.entries[i].value = value;
          return;
        }
      }

      _insertNonFull(node.children[i]!, key, value);
    }
  }

  /// Splits a full child node.
  void _splitChild(BTreeNode<K, V> parent, int childIndex) {
    final fullChild = parent.children[childIndex]!;
    final newChild = BTreeNode<K, V>(isLeaf: fullChild.isLeaf);

    final midIndex = _minDegree - 1;

    // Move the upper half of keys to new child
    for (var j = midIndex + 1; j < fullChild.keyCount; j++) {
      newChild.entries.add(fullChild.entries[j]);
    }

    // If not leaf, move the upper half of children
    if (!fullChild.isLeaf) {
      for (var j = _minDegree; j < fullChild.children.length; j++) {
        newChild.children.add(fullChild.children[j]);
      }
      // Remove moved children from full child
      fullChild.children.removeRange(_minDegree, fullChild.children.length);
    }

    // Get median entry before removing entries
    final medianEntry = fullChild.entries[midIndex];

    // Remove moved entries and median from full child
    fullChild.entries.removeRange(midIndex, fullChild.entries.length);

    // Insert new child into parent
    parent.children.insert(childIndex + 1, newChild);

    // Move median key up to parent
    parent.entries.insert(childIndex, medianEntry);
  }

  // ============ Delete Operations ============

  /// Removes the entry with the given [key].
  /// Returns true if the key was found and removed.
  bool remove(K key) {
    if (_root == null) return false;

    final removed = _remove(_root!, key);

    // If root becomes empty, make first child the new root
    if (_root!.keyCount == 0) {
      _root = _root!.isLeaf ? null : _root!.children[0];
    }

    return removed;
  }

  bool _remove(BTreeNode<K, V> node, K key) {
    var i = 0;
    while (i < node.keyCount && key.compareTo(node.entries[i].key) > 0) {
      i++;
    }

    // Case 1: Key found in this node
    if (i < node.keyCount && key.compareTo(node.entries[i].key) == 0) {
      if (node.isLeaf) {
        // Case 1a: Key is in a leaf node
        node.entries.removeAt(i);
        _size--;
        return true;
      } else {
        // Case 1b: Key is in an internal node
        return _removeFromInternal(node, i);
      }
    }

    // Case 2: Key is not in this node
    if (node.isLeaf) {
      return false; // Key not found
    }

    // Ensure child has enough keys before recursing
    final isLastChild = i == node.keyCount;
    if (node.children[i]!.keyCount <= _minKeys) {
      _fill(node, i);
    }

    // If last child was merged, recurse to previous child
    if (isLastChild && i > node.keyCount) {
      return _remove(node.children[i - 1]!, key);
    }
    return _remove(node.children[i]!, key);
  }

  bool _removeFromInternal(BTreeNode<K, V> node, int idx) {
    final key = node.entries[idx].key;

    // Case 2a: Left child has enough keys
    if (node.children[idx]!.keyCount > _minKeys) {
      final pred = _getPredecessor(node, idx);
      node.entries[idx] = pred;
      return _remove(node.children[idx]!, pred.key);
    }

    // Case 2b: Right child has enough keys
    if (node.children[idx + 1]!.keyCount > _minKeys) {
      final succ = _getSuccessor(node, idx);
      node.entries[idx] = succ;
      return _remove(node.children[idx + 1]!, succ.key);
    }

    // Case 2c: Both children have minimum keys, merge them
    _merge(node, idx);
    return _remove(node.children[idx]!, key);
  }

  BTreeEntry<K, V> _getPredecessor(BTreeNode<K, V> node, int idx) {
    var current = node.children[idx]!;
    while (!current.isLeaf) {
      current = current.children[current.keyCount]!;
    }
    return current.entries[current.keyCount - 1];
  }

  BTreeEntry<K, V> _getSuccessor(BTreeNode<K, V> node, int idx) {
    var current = node.children[idx + 1]!;
    while (!current.isLeaf) {
      current = current.children[0]!;
    }
    return current.entries[0];
  }

  /// Ensures child at [idx] has at least t keys.
  void _fill(BTreeNode<K, V> node, int idx) {
    // Try to borrow from left sibling
    if (idx > 0 && node.children[idx - 1]!.keyCount > _minKeys) {
      _borrowFromPrev(node, idx);
    }
    // Try to borrow from right sibling
    else if (idx < node.keyCount && node.children[idx + 1]!.keyCount > _minKeys) {
      _borrowFromNext(node, idx);
    }
    // Merge with a sibling
    else {
      if (idx < node.keyCount) {
        _merge(node, idx);
      } else {
        _merge(node, idx - 1);
      }
    }
  }

  void _borrowFromPrev(BTreeNode<K, V> node, int idx) {
    final child = node.children[idx]!;
    final sibling = node.children[idx - 1]!;

    // Move key from parent to child
    child.entries.insert(0, node.entries[idx - 1]);

    // Move last key from sibling to parent
    node.entries[idx - 1] = sibling.entries.removeLast();

    // Move child pointer if not leaf
    if (!sibling.isLeaf) {
      child.children.insert(0, sibling.children.removeLast());
    }
  }

  void _borrowFromNext(BTreeNode<K, V> node, int idx) {
    final child = node.children[idx]!;
    final sibling = node.children[idx + 1]!;

    // Move key from parent to child
    child.entries.add(node.entries[idx]);

    // Move first key from sibling to parent
    node.entries[idx] = sibling.entries.removeAt(0);

    // Move child pointer if not leaf
    if (!sibling.isLeaf) {
      child.children.add(sibling.children.removeAt(0));
    }
  }

  void _merge(BTreeNode<K, V> node, int idx) {
    final left = node.children[idx]!;
    final right = node.children[idx + 1]!;

    // Move key from parent to left child
    left.entries.add(node.entries[idx]);

    // Move all keys from right to left
    left.entries.addAll(right.entries);

    // Move all children from right to left
    if (!left.isLeaf) {
      left.children.addAll(right.children);
    }

    // Remove key and child pointer from parent
    node.entries.removeAt(idx);
    node.children.removeAt(idx + 1);
  }

  // ============ Traversal ============

  /// Returns all key-value pairs in sorted order.
  Iterable<BTreeEntry<K, V>> get inOrder sync* {
    if (_root != null) {
      yield* _inOrder(_root!);
    }
  }

  Iterable<BTreeEntry<K, V>> _inOrder(BTreeNode<K, V> node) sync* {
    for (var i = 0; i < node.keyCount; i++) {
      if (!node.isLeaf) {
        yield* _inOrder(node.children[i]!);
      }
      yield node.entries[i];
    }
    if (!node.isLeaf) {
      yield* _inOrder(node.children[node.keyCount]!);
    }
  }

  /// Returns all keys in sorted order.
  Iterable<K> get keys sync* {
    for (final entry in inOrder) {
      yield entry.key;
    }
  }

  /// Returns all values in key order.
  Iterable<V> get values sync* {
    for (final entry in inOrder) {
      yield entry.value;
    }
  }

  // ============ Utility ============

  /// Removes all entries from the tree.
  void clear() {
    _root = null;
    _size = 0;
  }

  /// Converts the tree to a list of entries.
  List<BTreeEntry<K, V>> toList() => inOrder.toList();

  @override
  String toString() {
    if (_root == null) return 'BTree: (empty)';
    return 'BTree(t=$_minDegree): [${inOrder.map((e) => '${e.key}: ${e.value}').join(', ')}]';
  }
}

// ============================================================================
// B+ Tree Implementation
// ============================================================================

/// A node in the B+ Tree.
abstract class BPlusTreeNode<K extends Comparable<dynamic>, V> {
  /// Whether this is a leaf node.
  bool get isLeaf;

  /// Number of keys in this node.
  int get keyCount;
}

/// Internal node in the B+ Tree.
class BPlusInternalNode<K extends Comparable<dynamic>, V>
    implements BPlusTreeNode<K, V> {
  /// Keys for routing (separators).
  final List<K> keys;

  /// Child pointers.
  final List<BPlusTreeNode<K, V>> children;

  /// Creates a new internal node.
  BPlusInternalNode()
      : keys = [],
        children = [];

  @override
  bool get isLeaf => false;

  @override
  int get keyCount => keys.length;

  @override
  String toString() => 'Internal(keys: $keys)';
}

/// Leaf node in the B+ Tree (stores actual values).
class BPlusLeafNode<K extends Comparable<dynamic>, V>
    implements BPlusTreeNode<K, V> {
  /// Keys stored in this leaf.
  final List<K> keys;

  /// Values corresponding to keys.
  final List<V> values;

  /// Pointer to next leaf for range queries.
  BPlusLeafNode<K, V>? next;

  /// Pointer to previous leaf.
  BPlusLeafNode<K, V>? prev;

  /// Creates a new leaf node.
  BPlusLeafNode()
      : keys = [],
        values = [];

  @override
  bool get isLeaf => true;

  @override
  int get keyCount => keys.length;

  @override
  String toString() => 'Leaf(keys: $keys)';
}

/// A B+ Tree where all values are stored in leaf nodes.
///
/// Leaf nodes are linked together for efficient range queries.
class BPlusTree<K extends Comparable<dynamic>, V> {
  BPlusTreeNode<K, V>? _root;
  BPlusLeafNode<K, V>? _firstLeaf;
  BPlusLeafNode<K, V>? _lastLeaf;
  int _size = 0;
  final int _minDegree;

  /// Creates an empty B+ Tree with the specified minimum degree.
  BPlusTree([int minDegree = 2])
      : _minDegree = minDegree < 2 ? 2 : minDegree;

  /// Returns the minimum degree of this B+ Tree.
  int get minDegree => _minDegree;

  /// Returns true if the tree is empty.
  bool get isEmpty => _root == null;

  /// Returns true if the tree is not empty.
  bool get isNotEmpty => _root != null;

  /// Returns the number of key-value pairs in the tree.
  int get length => _size;

  /// Returns the height of the tree.
  int get height {
    if (_root == null) return 0;
    var h = 1;
    var node = _root;
    while (!node!.isLeaf) {
      h++;
      node = (node as BPlusInternalNode<K, V>).children[0];
    }
    return h;
  }

  /// Maximum keys per node.
  int get _maxKeys => 2 * _minDegree - 1;

  /// Minimum keys per node (except root).
  int get _minKeys => _minDegree - 1;

  // ============ Search Operations ============

  /// Searches for the value associated with [key].
  /// Returns null if not found.
  V? search(K key) {
    if (_root == null) return null;

    final leaf = _findLeaf(key);
    final idx = _findKeyInLeaf(leaf, key);
    if (idx >= 0) {
      return leaf.values[idx];
    }
    return null;
  }

  BPlusLeafNode<K, V> _findLeaf(K key) {
    var node = _root!;
    while (!node.isLeaf) {
      final internal = node as BPlusInternalNode<K, V>;
      var i = 0;
      while (i < internal.keyCount && key.compareTo(internal.keys[i]) >= 0) {
        i++;
      }
      node = internal.children[i];
    }
    return node as BPlusLeafNode<K, V>;
  }

  int _findKeyInLeaf(BPlusLeafNode<K, V> leaf, K key) {
    for (var i = 0; i < leaf.keyCount; i++) {
      final cmp = key.compareTo(leaf.keys[i]);
      if (cmp == 0) return i;
      if (cmp < 0) return -1;
    }
    return -1;
  }

  /// Returns true if the tree contains [key].
  bool contains(K key) => search(key) != null;

  /// Gets the value for [key], or null if not found.
  V? get(K key) => search(key);

  /// Operator for accessing values by key.
  V? operator [](K key) => search(key);

  /// Returns the first (minimum) key-value pair.
  /// Throws [StateError] if the tree is empty.
  MapEntry<K, V> getFirst() {
    if (_firstLeaf == null) {
      throw StateError('Cannot get first from empty tree');
    }
    return MapEntry(_firstLeaf!.keys.first, _firstLeaf!.values.first);
  }

  /// Returns the last (maximum) key-value pair.
  /// Throws [StateError] if the tree is empty.
  MapEntry<K, V> getLast() {
    if (_lastLeaf == null) {
      throw StateError('Cannot get last from empty tree');
    }
    return MapEntry(_lastLeaf!.keys.last, _lastLeaf!.values.last);
  }

  // ============ Range Query ============

  /// Returns all entries with keys in the range [start, end] inclusive.
  Iterable<MapEntry<K, V>> range(K start, K end) sync* {
    if (_root == null) return;

    BPlusLeafNode<K, V>? leaf = _findLeaf(start);

    while (leaf != null) {
      for (var i = 0; i < leaf.keyCount; i++) {
        final key = leaf.keys[i];
        if (key.compareTo(start) >= 0 && key.compareTo(end) <= 0) {
          yield MapEntry(key, leaf.values[i]);
        } else if (key.compareTo(end) > 0) {
          return;
        }
      }
      leaf = leaf.next;
    }
  }

  // ============ Insert Operations ============

  /// Inserts a key-value pair into the tree.
  void insert(K key, V value) {
    if (_root == null) {
      final leaf = BPlusLeafNode<K, V>();
      leaf.keys.add(key);
      leaf.values.add(value);
      _root = leaf;
      _firstLeaf = leaf;
      _lastLeaf = leaf;
      _size++;
      return;
    }

    // Find leaf and insert
    final path = <BPlusInternalNode<K, V>>[];
    final pathIndices = <int>[];
    var node = _root!;

    while (!node.isLeaf) {
      final internal = node as BPlusInternalNode<K, V>;
      var i = 0;
      while (i < internal.keyCount && key.compareTo(internal.keys[i]) >= 0) {
        i++;
      }
      path.add(internal);
      pathIndices.add(i);
      node = internal.children[i];
    }

    final leaf = node as BPlusLeafNode<K, V>;
    final inserted = _insertIntoLeaf(leaf, key, value);
    if (!inserted) return; // Key already exists, value updated

    // Check if leaf needs to split
    if (leaf.keyCount > _maxKeys) {
      _splitLeaf(leaf, path, pathIndices);
    }
  }

  bool _insertIntoLeaf(BPlusLeafNode<K, V> leaf, K key, V value) {
    var i = 0;
    while (i < leaf.keyCount && key.compareTo(leaf.keys[i]) > 0) {
      i++;
    }

    // Check for duplicate
    if (i < leaf.keyCount && key.compareTo(leaf.keys[i]) == 0) {
      leaf.values[i] = value;
      return false;
    }

    leaf.keys.insert(i, key);
    leaf.values.insert(i, value);
    _size++;
    return true;
  }

  void _splitLeaf(
    BPlusLeafNode<K, V> leaf,
    List<BPlusInternalNode<K, V>> path,
    List<int> pathIndices,
  ) {
    final newLeaf = BPlusLeafNode<K, V>();
    final midIndex = (leaf.keyCount + 1) ~/ 2;

    // Move upper half to new leaf
    for (var i = midIndex; i < leaf.keyCount; i++) {
      newLeaf.keys.add(leaf.keys[i]);
      newLeaf.values.add(leaf.values[i]);
    }
    leaf.keys.removeRange(midIndex, leaf.keyCount);
    leaf.values.removeRange(midIndex, leaf.values.length);

    // Update leaf links
    newLeaf.next = leaf.next;
    newLeaf.prev = leaf;
    if (leaf.next != null) {
      leaf.next!.prev = newLeaf;
    }
    leaf.next = newLeaf;

    if (_lastLeaf == leaf) {
      _lastLeaf = newLeaf;
    }

    // Promote first key of new leaf to parent
    final promotedKey = newLeaf.keys.first;
    _insertIntoParent(leaf, promotedKey, newLeaf, path, pathIndices);
  }

  void _insertIntoParent(
    BPlusTreeNode<K, V> left,
    K key,
    BPlusTreeNode<K, V> right,
    List<BPlusInternalNode<K, V>> path,
    List<int> pathIndices,
  ) {
    if (path.isEmpty) {
      // Create new root
      final newRoot = BPlusInternalNode<K, V>();
      newRoot.keys.add(key);
      newRoot.children.add(left);
      newRoot.children.add(right);
      _root = newRoot;
      return;
    }

    final parent = path.removeLast();
    final idx = pathIndices.removeLast();

    parent.keys.insert(idx, key);
    parent.children.insert(idx + 1, right);

    // Check if parent needs to split
    if (parent.keyCount > _maxKeys) {
      _splitInternal(parent, path, pathIndices);
    }
  }

  void _splitInternal(
    BPlusInternalNode<K, V> node,
    List<BPlusInternalNode<K, V>> path,
    List<int> pathIndices,
  ) {
    final newNode = BPlusInternalNode<K, V>();
    final midIndex = node.keyCount ~/ 2;

    // Move upper half to new node (excluding median)
    for (var i = midIndex + 1; i < node.keyCount; i++) {
      newNode.keys.add(node.keys[i]);
    }
    for (var i = midIndex + 1; i <= node.keyCount; i++) {
      newNode.children.add(node.children[i]);
    }

    // Get median before removing
    final medianKey = node.keys[midIndex];

    // Remove moved keys and children
    node.keys.removeRange(midIndex, node.keyCount);
    node.children.removeRange(midIndex + 1, node.children.length);

    // Insert into parent
    _insertIntoParent(node, medianKey, newNode, path, pathIndices);
  }

  // ============ Delete Operations ============

  /// Removes the entry with the given [key].
  /// Returns true if the key was found and removed.
  bool remove(K key) {
    if (_root == null) return false;

    // Find leaf containing the key
    final path = <BPlusInternalNode<K, V>>[];
    final pathIndices = <int>[];
    var node = _root!;

    while (!node.isLeaf) {
      final internal = node as BPlusInternalNode<K, V>;
      var i = 0;
      while (i < internal.keyCount && key.compareTo(internal.keys[i]) >= 0) {
        i++;
      }
      path.add(internal);
      pathIndices.add(i);
      node = internal.children[i];
    }

    final leaf = node as BPlusLeafNode<K, V>;
    final idx = _findKeyInLeaf(leaf, key);
    if (idx < 0) return false;

    // Remove from leaf
    leaf.keys.removeAt(idx);
    leaf.values.removeAt(idx);
    _size--;

    // Handle underflow
    if (path.isNotEmpty && leaf.keyCount < _minKeys) {
      _handleLeafUnderflow(leaf, path, pathIndices);
    }

    // Handle empty root
    if (_root!.keyCount == 0) {
      if (_root!.isLeaf) {
        _root = null;
        _firstLeaf = null;
        _lastLeaf = null;
      } else {
        _root = (_root as BPlusInternalNode<K, V>).children[0];
      }
    }

    return true;
  }

  void _handleLeafUnderflow(
    BPlusLeafNode<K, V> leaf,
    List<BPlusInternalNode<K, V>> path,
    List<int> pathIndices,
  ) {
    final parent = path.last;
    final idx = pathIndices.last;

    // Try to borrow from left sibling
    if (idx > 0) {
      final leftSibling = parent.children[idx - 1] as BPlusLeafNode<K, V>;
      if (leftSibling.keyCount > _minKeys) {
        _borrowFromLeftLeaf(leaf, leftSibling, parent, idx);
        return;
      }
    }

    // Try to borrow from right sibling
    if (idx < parent.keyCount) {
      final rightSibling = parent.children[idx + 1] as BPlusLeafNode<K, V>;
      if (rightSibling.keyCount > _minKeys) {
        _borrowFromRightLeaf(leaf, rightSibling, parent, idx);
        return;
      }
    }

    // Merge with a sibling
    if (idx > 0) {
      final leftSibling = parent.children[idx - 1] as BPlusLeafNode<K, V>;
      _mergeLeaves(leftSibling, leaf, parent, idx - 1);
      pathIndices[pathIndices.length - 1] = idx - 1;
    } else {
      final rightSibling = parent.children[idx + 1] as BPlusLeafNode<K, V>;
      _mergeLeaves(leaf, rightSibling, parent, idx);
    }

    // Check parent for underflow
    path.removeLast();
    pathIndices.removeLast();
    if (path.isNotEmpty && parent.keyCount < _minKeys) {
      _handleInternalUnderflow(parent, path, pathIndices);
    }
  }

  void _borrowFromLeftLeaf(
    BPlusLeafNode<K, V> leaf,
    BPlusLeafNode<K, V> sibling,
    BPlusInternalNode<K, V> parent,
    int idx,
  ) {
    // Move last key from sibling to leaf
    leaf.keys.insert(0, sibling.keys.removeLast());
    leaf.values.insert(0, sibling.values.removeLast());

    // Update parent key
    parent.keys[idx - 1] = leaf.keys.first;
  }

  void _borrowFromRightLeaf(
    BPlusLeafNode<K, V> leaf,
    BPlusLeafNode<K, V> sibling,
    BPlusInternalNode<K, V> parent,
    int idx,
  ) {
    // Move first key from sibling to leaf
    leaf.keys.add(sibling.keys.removeAt(0));
    leaf.values.add(sibling.values.removeAt(0));

    // Update parent key
    parent.keys[idx] = sibling.keys.first;
  }

  void _mergeLeaves(
    BPlusLeafNode<K, V> left,
    BPlusLeafNode<K, V> right,
    BPlusInternalNode<K, V> parent,
    int idx,
  ) {
    // Move all from right to left
    left.keys.addAll(right.keys);
    left.values.addAll(right.values);

    // Update links
    left.next = right.next;
    if (right.next != null) {
      right.next!.prev = left;
    }

    if (_lastLeaf == right) {
      _lastLeaf = left;
    }

    // Remove separator from parent
    parent.keys.removeAt(idx);
    parent.children.removeAt(idx + 1);
  }

  void _handleInternalUnderflow(
    BPlusInternalNode<K, V> node,
    List<BPlusInternalNode<K, V>> path,
    List<int> pathIndices,
  ) {
    final parent = path.last;
    final idx = pathIndices.last;

    // Try to borrow from left sibling
    if (idx > 0) {
      final leftSibling = parent.children[idx - 1] as BPlusInternalNode<K, V>;
      if (leftSibling.keyCount > _minKeys) {
        _borrowFromLeftInternal(node, leftSibling, parent, idx);
        return;
      }
    }

    // Try to borrow from right sibling
    if (idx < parent.keyCount) {
      final rightSibling = parent.children[idx + 1] as BPlusInternalNode<K, V>;
      if (rightSibling.keyCount > _minKeys) {
        _borrowFromRightInternal(node, rightSibling, parent, idx);
        return;
      }
    }

    // Merge with a sibling
    if (idx > 0) {
      final leftSibling = parent.children[idx - 1] as BPlusInternalNode<K, V>;
      _mergeInternals(leftSibling, node, parent, idx - 1);
      pathIndices[pathIndices.length - 1] = idx - 1;
    } else {
      final rightSibling = parent.children[idx + 1] as BPlusInternalNode<K, V>;
      _mergeInternals(node, rightSibling, parent, idx);
    }

    // Check parent for underflow
    path.removeLast();
    pathIndices.removeLast();
    if (path.isNotEmpty && parent.keyCount < _minKeys) {
      _handleInternalUnderflow(parent, path, pathIndices);
    }
  }

  void _borrowFromLeftInternal(
    BPlusInternalNode<K, V> node,
    BPlusInternalNode<K, V> sibling,
    BPlusInternalNode<K, V> parent,
    int idx,
  ) {
    // Move parent key down
    node.keys.insert(0, parent.keys[idx - 1]);

    // Move sibling's last key up
    parent.keys[idx - 1] = sibling.keys.removeLast();

    // Move sibling's last child
    node.children.insert(0, sibling.children.removeLast());
  }

  void _borrowFromRightInternal(
    BPlusInternalNode<K, V> node,
    BPlusInternalNode<K, V> sibling,
    BPlusInternalNode<K, V> parent,
    int idx,
  ) {
    // Move parent key down
    node.keys.add(parent.keys[idx]);

    // Move sibling's first key up
    parent.keys[idx] = sibling.keys.removeAt(0);

    // Move sibling's first child
    node.children.add(sibling.children.removeAt(0));
  }

  void _mergeInternals(
    BPlusInternalNode<K, V> left,
    BPlusInternalNode<K, V> right,
    BPlusInternalNode<K, V> parent,
    int idx,
  ) {
    // Move parent key down
    left.keys.add(parent.keys[idx]);

    // Move all from right to left
    left.keys.addAll(right.keys);
    left.children.addAll(right.children);

    // Remove from parent
    parent.keys.removeAt(idx);
    parent.children.removeAt(idx + 1);
  }

  // ============ Traversal ============

  /// Returns all key-value pairs in sorted order.
  Iterable<MapEntry<K, V>> get inOrder sync* {
    var leaf = _firstLeaf;
    while (leaf != null) {
      for (var i = 0; i < leaf.keyCount; i++) {
        yield MapEntry(leaf.keys[i], leaf.values[i]);
      }
      leaf = leaf.next;
    }
  }

  /// Returns all keys in sorted order.
  Iterable<K> get keys sync* {
    for (final entry in inOrder) {
      yield entry.key;
    }
  }

  /// Returns all values in key order.
  Iterable<V> get values sync* {
    for (final entry in inOrder) {
      yield entry.value;
    }
  }

  // ============ Utility ============

  /// Removes all entries from the tree.
  void clear() {
    _root = null;
    _firstLeaf = null;
    _lastLeaf = null;
    _size = 0;
  }

  /// Converts the tree to a list of entries.
  List<MapEntry<K, V>> toList() => inOrder.toList();

  @override
  String toString() {
    if (_root == null) return 'BPlusTree: (empty)';
    return 'BPlusTree(t=$_minDegree): [${inOrder.map((e) => '${e.key}: ${e.value}').join(', ')}]';
  }
}
