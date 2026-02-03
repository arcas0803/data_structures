/// # Union-Find (Disjoint Set Union)
///
/// A data structure for tracking element groupings and efficiently
/// determining connectivity between elements.
///
/// Time Complexity (with path compression and union by rank):
/// - makeSet: O(1)
/// - find: O(α(n)) amortized, nearly O(1)
/// - union: O(α(n)) amortized, nearly O(1)
/// - connected: O(α(n)) amortized, nearly O(1)
///
/// Where α(n) is the inverse Ackermann function, which grows extremely slowly.
///
/// Use cases: Kruskal's MST, connected components, equivalence relations.
library;

/// Union-Find data structure for tracking disjoint sets of elements.
class UnionFind<T> {
  final Map<T, T> _parent = {};
  final Map<T, int> _rank = {};
  final Map<T, int> _size = {};
  int _setCount = 0;

  /// Creates an empty Union-Find structure.
  UnionFind();

  /// Creates a Union-Find structure with initial elements, each in its own set.
  factory UnionFind.from(Iterable<T> elements) {
    final uf = UnionFind<T>();
    for (final element in elements) {
      uf.makeSet(element);
    }
    return uf;
  }

  /// Returns the number of disjoint sets.
  int get setCount => _setCount;

  /// Returns the total number of elements.
  int get elementCount => _parent.length;

  /// Returns true if [element] exists in the structure.
  bool contains(T element) => _parent.containsKey(element);

  /// Creates a new set containing only [element]. O(1)
  /// Does nothing if [element] already exists.
  void makeSet(T element) {
    if (_parent.containsKey(element)) return;
    _parent[element] = element;
    _rank[element] = 0;
    _size[element] = 1;
    _setCount++;
  }

  /// Alias for [makeSet].
  void add(T element) => makeSet(element);

  /// Finds the representative (root) of [element]'s set. O(α(n)) amortized
  /// Uses path compression for optimization.
  /// Throws [StateError] if [element] doesn't exist.
  T find(T element) {
    if (!_parent.containsKey(element)) {
      throw StateError('Element not found: $element');
    }
    return _findWithCompression(element);
  }

  /// Internal find with path compression.
  T _findWithCompression(T element) {
    if (_parent[element] != element) {
      _parent[element] = _findWithCompression(_parent[element] as T);
    }
    return _parent[element] as T;
  }

  /// Merges the sets containing [a] and [b]. O(α(n)) amortized
  /// Uses union by rank for optimization.
  /// Returns true if the sets were different and merged, false if already same set.
  /// Throws [StateError] if either element doesn't exist.
  bool union(T a, T b) {
    final rootA = find(a);
    final rootB = find(b);

    if (rootA == rootB) return false;

    // Union by rank: attach smaller tree under larger
    final rankA = _rank[rootA]!;
    final rankB = _rank[rootB]!;

    if (rankA < rankB) {
      _parent[rootA] = rootB;
      _size[rootB] = _size[rootB]! + _size[rootA]!;
    } else if (rankA > rankB) {
      _parent[rootB] = rootA;
      _size[rootA] = _size[rootA]! + _size[rootB]!;
    } else {
      _parent[rootB] = rootA;
      _size[rootA] = _size[rootA]! + _size[rootB]!;
      _rank[rootA] = rankA + 1;
    }

    _setCount--;
    return true;
  }

  /// Returns true if [a] and [b] are in the same set. O(α(n)) amortized
  /// Throws [StateError] if either element doesn't exist.
  bool connected(T a, T b) {
    return find(a) == find(b);
  }

  /// Returns the size of the set containing [element]. O(α(n)) amortized
  /// Throws [StateError] if [element] doesn't exist.
  int getSetSize(T element) {
    final root = find(element);
    return _size[root]!;
  }

  /// Returns all elements in the set containing [element]. O(n)
  /// Throws [StateError] if [element] doesn't exist.
  Set<T> getSet(T element) {
    final root = find(element);
    final result = <T>{};
    for (final e in _parent.keys) {
      if (_findWithCompression(e) == root) {
        result.add(e);
      }
    }
    return result;
  }

  /// Returns a list of all disjoint sets. O(n)
  List<Set<T>> get allSets {
    final setsMap = <T, Set<T>>{};
    for (final element in _parent.keys) {
      final root = _findWithCompression(element);
      setsMap.putIfAbsent(root, () => <T>{});
      setsMap[root]!.add(element);
    }
    return setsMap.values.toList();
  }

  /// Removes all elements from the structure. O(1)
  void clear() {
    _parent.clear();
    _rank.clear();
    _size.clear();
    _setCount = 0;
  }

  @override
  String toString() {
    if (_parent.isEmpty) return 'UnionFind: {}';
    final sets = allSets.map((s) => '{${s.join(', ')}}').join(', ');
    return 'UnionFind: [$sets]';
  }
}

/// Optimized Union-Find for integer indices `0..n-1`.
///
/// More memory efficient than generic `UnionFind<int>` as it uses
/// fixed-size lists instead of maps.
class UnionFindInt {
  late List<int> _parent;
  late List<int> _rank;
  late List<int> _size;
  int _setCount;

  /// Creates a Union-Find structure with [n] elements (0 to n-1),
  /// each initially in its own set.
  UnionFindInt(int n) : _setCount = n {
    if (n < 0) throw ArgumentError('Size must be non-negative: $n');
    _parent = List<int>.generate(n, (i) => i);
    _rank = List<int>.filled(n, 0);
    _size = List<int>.filled(n, 1);
  }

  /// Returns the number of elements.
  int get length => _parent.length;

  /// Returns the number of disjoint sets.
  int get setCount => _setCount;

  /// Finds the representative (root) of [element]'s set. O(α(n)) amortized
  /// Uses path compression for optimization.
  int find(int element) {
    _checkBounds(element);
    return _findWithCompression(element);
  }

  /// Internal find with path compression.
  int _findWithCompression(int element) {
    if (_parent[element] != element) {
      _parent[element] = _findWithCompression(_parent[element]);
    }
    return _parent[element];
  }

  /// Merges the sets containing [a] and [b]. O(α(n)) amortized
  /// Uses union by rank for optimization.
  /// Returns true if the sets were different and merged.
  bool union(int a, int b) {
    final rootA = find(a);
    final rootB = find(b);

    if (rootA == rootB) return false;

    // Union by rank: attach smaller tree under larger
    if (_rank[rootA] < _rank[rootB]) {
      _parent[rootA] = rootB;
      _size[rootB] += _size[rootA];
    } else if (_rank[rootA] > _rank[rootB]) {
      _parent[rootB] = rootA;
      _size[rootA] += _size[rootB];
    } else {
      _parent[rootB] = rootA;
      _size[rootA] += _size[rootB];
      _rank[rootA]++;
    }

    _setCount--;
    return true;
  }

  /// Returns true if [a] and [b] are in the same set. O(α(n)) amortized
  bool connected(int a, int b) {
    return find(a) == find(b);
  }

  /// Returns the size of the set containing [element]. O(α(n)) amortized
  int getSetSize(int element) {
    final root = find(element);
    return _size[root];
  }

  /// Returns all elements in the set containing [element]. O(n)
  Set<int> getSet(int element) {
    final root = find(element);
    final result = <int>{};
    for (var i = 0; i < _parent.length; i++) {
      if (_findWithCompression(i) == root) {
        result.add(i);
      }
    }
    return result;
  }

  /// Returns a list of all disjoint sets. O(n)
  List<Set<int>> get allSets {
    final setsMap = <int, Set<int>>{};
    for (var i = 0; i < _parent.length; i++) {
      final root = _findWithCompression(i);
      setsMap.putIfAbsent(root, () => <int>{});
      setsMap[root]!.add(i);
    }
    return setsMap.values.toList();
  }

  /// Resets all elements to be in their own sets. O(n)
  void clear() {
    for (var i = 0; i < _parent.length; i++) {
      _parent[i] = i;
      _rank[i] = 0;
      _size[i] = 1;
    }
    _setCount = _parent.length;
  }

  void _checkBounds(int element) {
    if (element < 0 || element >= _parent.length) {
      throw RangeError('Element out of bounds: $element');
    }
  }

  @override
  String toString() {
    if (_parent.isEmpty) return 'UnionFindInt: {}';
    final sets = allSets.map((s) => '{${s.join(', ')}}').join(', ');
    return 'UnionFindInt: [$sets]';
  }
}
