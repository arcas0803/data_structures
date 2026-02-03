/// # Hash Table
///
/// A hash table (hash map) implementation using separate chaining for
/// collision resolution.
///
/// Time Complexity:
/// - Insert: O(1) average, O(n) worst
/// - Delete: O(1) average, O(n) worst
/// - Search: O(1) average, O(n) worst
/// - Access: O(1) average, O(n) worst
library;

/// Entry for the hash table (key-value pair).
class HashEntry<K, V> {
  final K key;
  V value;
  HashEntry<K, V>? next;

  HashEntry(this.key, this.value, [this.next]);

  @override
  String toString() => '$key: $value';
}

/// A hash table (hash map) data structure.
class HashTable<K, V> {
  static const int _defaultCapacity = 16;
  static const double _loadFactorThreshold = 0.75;

  List<HashEntry<K, V>?> _buckets;
  int _size = 0;

  /// Creates an empty hash table with optional initial [capacity].
  HashTable([int capacity = _defaultCapacity])
      : _buckets = List<HashEntry<K, V>?>.filled(
          capacity < 1 ? _defaultCapacity : capacity,
          null,
        );

  /// Creates a hash table from a map.
  factory HashTable.from(Map<K, V> map) {
    final table = HashTable<K, V>(map.length);
    map.forEach((key, value) {
      table.put(key, value);
    });
    return table;
  }

  /// Returns the number of key-value pairs in the table.
  int get length => _size;

  /// Returns the current capacity (number of buckets).
  int get capacity => _buckets.length;

  /// Returns the current load factor.
  double get loadFactor => _size / _buckets.length;

  /// Returns true if the table is empty.
  bool get isEmpty => _size == 0;

  /// Returns true if the table is not empty.
  bool get isNotEmpty => _size > 0;

  /// Computes the bucket index for a key.
  int _getBucketIndex(K key) {
    return key.hashCode.abs() % _buckets.length;
  }

  /// Inserts or updates a key-value pair. O(1) average
  /// Returns the previous value if the key existed, null otherwise.
  V? put(K key, V value) {
    _resizeIfNeeded();

    final index = _getBucketIndex(key);
    var entry = _buckets[index];

    // Search for existing key in the chain
    while (entry != null) {
      if (entry.key == key) {
        final oldValue = entry.value;
        entry.value = value;
        return oldValue;
      }
      entry = entry.next;
    }

    // Key not found, insert at the beginning of the chain
    _buckets[index] = HashEntry(key, value, _buckets[index]);
    _size++;
    return null;
  }

  /// Alias for [put].
  void operator []=(K key, V value) => put(key, value);

  /// Returns the value associated with [key]. O(1) average
  /// Throws [StateError] if [key] is not found.
  V get(K key) {
    final value = tryGet(key);
    if (value == null && !containsKey(key)) {
      throw StateError('Key not found: $key');
    }
    return value as V;
  }

  /// Alias for [get].
  V operator [](K key) => get(key);

  /// Returns the value associated with [key], or null if not found. O(1) average
  V? tryGet(K key) {
    final index = _getBucketIndex(key);
    var entry = _buckets[index];

    while (entry != null) {
      if (entry.key == key) {
        return entry.value;
      }
      entry = entry.next;
    }
    return null;
  }

  /// Returns the value for [key], or [defaultValue] if not found. O(1) average
  V getOrDefault(K key, V defaultValue) {
    return tryGet(key) ?? defaultValue;
  }

  /// Returns the value for [key], inserting [defaultValue] if not present. O(1) average
  V putIfAbsent(K key, V Function() defaultValue) {
    final existing = tryGet(key);
    if (existing != null || containsKey(key)) {
      return existing as V;
    }
    final value = defaultValue();
    put(key, value);
    return value;
  }

  /// Removes the entry for [key]. O(1) average
  /// Returns the removed value, or null if [key] was not found.
  V? remove(K key) {
    final index = _getBucketIndex(key);
    var entry = _buckets[index];
    HashEntry<K, V>? prev;

    while (entry != null) {
      if (entry.key == key) {
        if (prev == null) {
          _buckets[index] = entry.next;
        } else {
          prev.next = entry.next;
        }
        _size--;
        return entry.value;
      }
      prev = entry;
      entry = entry.next;
    }
    return null;
  }

  /// Returns true if [key] exists in the table. O(1) average
  bool containsKey(K key) {
    final index = _getBucketIndex(key);
    var entry = _buckets[index];

    while (entry != null) {
      if (entry.key == key) return true;
      entry = entry.next;
    }
    return false;
  }

  /// Returns true if [value] exists in the table. O(n)
  bool containsValue(V value) {
    for (final bucket in _buckets) {
      var entry = bucket;
      while (entry != null) {
        if (entry.value == value) return true;
        entry = entry.next;
      }
    }
    return false;
  }

  /// Removes all entries from the table. O(1)
  void clear() {
    _buckets = List<HashEntry<K, V>?>.filled(_defaultCapacity, null);
    _size = 0;
  }

  /// Resizes the table if load factor exceeds threshold.
  void _resizeIfNeeded() {
    if (loadFactor >= _loadFactorThreshold) {
      _resize(_buckets.length * 2);
    }
  }

  /// Resizes the table to [newCapacity].
  void _resize(int newCapacity) {
    final oldBuckets = _buckets;
    _buckets = List<HashEntry<K, V>?>.filled(newCapacity, null);
    _size = 0;

    for (final bucket in oldBuckets) {
      var entry = bucket;
      while (entry != null) {
        put(entry.key, entry.value);
        entry = entry.next;
      }
    }
  }

  /// Returns all keys in the table.
  Iterable<K> get keys sync* {
    for (final bucket in _buckets) {
      var entry = bucket;
      while (entry != null) {
        yield entry.key;
        entry = entry.next;
      }
    }
  }

  /// Returns all values in the table.
  Iterable<V> get values sync* {
    for (final bucket in _buckets) {
      var entry = bucket;
      while (entry != null) {
        yield entry.value;
        entry = entry.next;
      }
    }
  }

  /// Returns all entries as (key, value) pairs.
  Iterable<(K, V)> get entries sync* {
    for (final bucket in _buckets) {
      var entry = bucket;
      while (entry != null) {
        yield (entry.key, entry.value);
        entry = entry.next;
      }
    }
  }

  /// Applies [f] to each key-value pair.
  void forEach(void Function(K key, V value) f) {
    for (final bucket in _buckets) {
      var entry = bucket;
      while (entry != null) {
        f(entry.key, entry.value);
        entry = entry.next;
      }
    }
  }

  /// Updates the value for [key] using [update] function. O(1) average
  /// If [key] doesn't exist, uses [ifAbsent] to create a value.
  void update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final index = _getBucketIndex(key);
    var entry = _buckets[index];

    while (entry != null) {
      if (entry.key == key) {
        entry.value = update(entry.value);
        return;
      }
      entry = entry.next;
    }

    if (ifAbsent != null) {
      put(key, ifAbsent());
    } else {
      throw StateError('Key not found and no ifAbsent provided: $key');
    }
  }

  /// Converts the hash table to a Dart Map. O(n)
  Map<K, V> toMap() {
    final map = <K, V>{};
    forEach((key, value) {
      map[key] = value;
    });
    return map;
  }

  /// Returns statistics about the hash table.
  Map<String, dynamic> get stats {
    var usedBuckets = 0;
    var maxChainLength = 0;
    var totalChainLength = 0;

    for (final bucket in _buckets) {
      if (bucket != null) {
        usedBuckets++;
        var chainLength = 0;
        HashEntry<K, V>? entry = bucket;
        while (entry != null) {
          chainLength++;
          entry = entry.next;
        }
        totalChainLength += chainLength;
        if (chainLength > maxChainLength) {
          maxChainLength = chainLength;
        }
      }
    }

    return {
      'size': _size,
      'capacity': _buckets.length,
      'loadFactor': loadFactor,
      'usedBuckets': usedBuckets,
      'maxChainLength': maxChainLength,
      'avgChainLength': usedBuckets > 0 ? totalChainLength / usedBuckets : 0,
    };
  }

  @override
  String toString() {
    if (_size == 0) return 'HashTable: {}';
    final buffer = StringBuffer('HashTable: {');
    var first = true;
    forEach((key, value) {
      if (!first) buffer.write(', ');
      buffer.write('$key: $value');
      first = false;
    });
    buffer.write('}');
    return buffer.toString();
  }
}

/// A hash set data structure.
class HashSet<T> {
  final HashTable<T, bool> _table = HashTable<T, bool>();

  /// Creates an empty hash set.
  HashSet();

  /// Creates a hash set from an iterable.
  factory HashSet.from(Iterable<T> elements) {
    final set = HashSet<T>();
    for (final element in elements) {
      set.add(element);
    }
    return set;
  }

  /// Returns the number of elements in the set.
  int get length => _table.length;

  /// Returns true if the set is empty.
  bool get isEmpty => _table.isEmpty;

  /// Returns true if the set is not empty.
  bool get isNotEmpty => _table.isNotEmpty;

  /// Adds an element to the set. O(1) average
  /// Returns true if the element was added (not already present).
  bool add(T value) {
    if (_table.containsKey(value)) return false;
    _table.put(value, true);
    return true;
  }

  /// Adds all elements from an iterable. O(n)
  void addAll(Iterable<T> elements) {
    for (final element in elements) {
      add(element);
    }
  }

  /// Removes an element from the set. O(1) average
  /// Returns true if the element was found and removed.
  bool remove(T value) {
    return _table.remove(value) != null;
  }

  /// Returns true if the set contains [value]. O(1) average
  bool contains(T value) => _table.containsKey(value);

  /// Removes all elements from the set. O(1)
  void clear() => _table.clear();

  /// Returns the union of this set and [other]. O(n + m)
  HashSet<T> union(HashSet<T> other) {
    final result = HashSet<T>.from(values);
    result.addAll(other.values);
    return result;
  }

  /// Returns the intersection of this set and [other]. O(n)
  HashSet<T> intersection(HashSet<T> other) {
    final result = HashSet<T>();
    for (final value in values) {
      if (other.contains(value)) {
        result.add(value);
      }
    }
    return result;
  }

  /// Returns the difference of this set and [other]. O(n)
  HashSet<T> difference(HashSet<T> other) {
    final result = HashSet<T>();
    for (final value in values) {
      if (!other.contains(value)) {
        result.add(value);
      }
    }
    return result;
  }

  /// Returns true if this set is a subset of [other]. O(n)
  bool isSubsetOf(HashSet<T> other) {
    for (final value in values) {
      if (!other.contains(value)) return false;
    }
    return true;
  }

  /// Returns all elements in the set.
  Iterable<T> get values => _table.keys;

  /// Converts the hash set to a Dart Set. O(n)
  Set<T> toSet() => values.toSet();

  /// Converts the hash set to a Dart List. O(n)
  List<T> toList() => values.toList();

  @override
  String toString() {
    if (_table.isEmpty) return 'HashSet: {}';
    return 'HashSet: {${values.join(', ')}}';
  }
}
