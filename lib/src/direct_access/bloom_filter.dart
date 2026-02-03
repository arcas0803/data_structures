/// # Bloom Filter
///
/// A probabilistic data structure for efficient set membership testing.
/// May return false positives but never false negatives.
///
/// Time Complexity:
/// - Add: O(k) where k is the number of hash functions
/// - Contains: O(k)
///
/// Space Complexity: O(m) where m is the bit array size
///
/// Use cases: Database lookups, cache filtering, duplicate detection.
library;

import 'dart:math' as math;

/// A Bloom filter for probabilistic set membership testing.
class BloomFilter<T> {
  final List<bool> _bits;
  final int _hashCount;
  int _insertedCount = 0;

  /// Creates a Bloom filter with the given bit array size and hash count.
  BloomFilter.withSize(int bitArraySize, int hashCount)
      : _bits = List<bool>.filled(bitArraySize < 1 ? 1 : bitArraySize, false),
        _hashCount = hashCount < 1 ? 1 : hashCount;

  /// Creates a Bloom filter optimized for [expectedElements] with
  /// the desired [falsePositiveRate].
  factory BloomFilter(int expectedElements, double falsePositiveRate) {
    if (expectedElements <= 0) {
      throw ArgumentError('expectedElements must be positive');
    }
    if (falsePositiveRate <= 0 || falsePositiveRate >= 1) {
      throw ArgumentError('falsePositiveRate must be between 0 and 1');
    }

    final bitCount = optimalSize(expectedElements, falsePositiveRate);
    final hashCount = optimalHashCount(bitCount, expectedElements);
    return BloomFilter.withSize(bitCount, hashCount);
  }

  /// Calculates the optimal bit array size for [n] elements
  /// with false positive probability [p].
  /// Formula: m = -n * ln(p) / (ln(2)^2)
  static int optimalSize(int n, double p) {
    if (n <= 0) return 1;
    if (p <= 0 || p >= 1) return n * 10;
    return (-(n * math.log(p)) / (math.ln2 * math.ln2)).ceil();
  }

  /// Calculates the optimal number of hash functions for bit array
  /// size [m] and [n] expected elements.
  /// Formula: k = (m / n) * ln(2)
  static int optimalHashCount(int m, int n) {
    if (n <= 0) return 1;
    final k = ((m / n) * math.ln2).round();
    return k < 1 ? 1 : k;
  }

  /// Returns the size of the bit array.
  int get bitCount => _bits.length;

  /// Returns the number of hash functions used.
  int get hashCount => _hashCount;

  /// Returns true if no elements have been added.
  bool get isEmpty => _insertedCount == 0;

  /// Returns the approximate number of elements added.
  int get approximateElementCount => _insertedCount;

  /// Returns the ratio of bits set to 1.
  double get fillRatio {
    var setBits = 0;
    for (final bit in _bits) {
      if (bit) setBits++;
    }
    return setBits / _bits.length;
  }

  /// Returns the expected false positive rate based on current fill.
  /// Formula: (1 - e^(-k*n/m))^k
  double get expectedFalsePositiveRate {
    if (_insertedCount == 0) return 0.0;
    final exponent = -_hashCount * _insertedCount / _bits.length;
    return math.pow(1 - math.exp(exponent), _hashCount).toDouble();
  }

  /// Computes hash positions for an element using double hashing.
  /// h(i) = (h1 + i * h2) mod m
  List<int> _getHashPositions(T element) {
    final h1 = element.hashCode;
    final h2 = _secondaryHash(h1);
    final positions = <int>[];

    for (var i = 0; i < _hashCount; i++) {
      final hash = (h1 + i * h2).abs() % _bits.length;
      positions.add(hash);
    }
    return positions;
  }

  /// Generates a secondary hash from the primary hash.
  int _secondaryHash(int primaryHash) {
    var hash = primaryHash;
    hash = ((hash >> 16) ^ hash) * 0x45d9f3b;
    hash = ((hash >> 16) ^ hash) * 0x45d9f3b;
    hash = (hash >> 16) ^ hash;
    return hash == 0 ? 1 : hash;
  }

  /// Adds an element to the filter. O(k)
  void add(T element) {
    for (final position in _getHashPositions(element)) {
      _bits[position] = true;
    }
    _insertedCount++;
  }

  /// Adds all elements from an iterable. O(n*k)
  void addAll(Iterable<T> elements) {
    for (final element in elements) {
      add(element);
    }
  }

  /// Returns true if the element might be in the set. O(k)
  /// False positives are possible, but false negatives are not.
  bool mightContain(T element) {
    for (final position in _getHashPositions(element)) {
      if (!_bits[position]) return false;
    }
    return true;
  }

  /// Alias for [mightContain].
  bool contains(T element) => mightContain(element);

  /// Returns true if all elements might be contained in the filter. O(n*k)
  bool containsAll(Iterable<T> elements) {
    for (final element in elements) {
      if (!mightContain(element)) return false;
    }
    return true;
  }

  /// Resets all bits to 0. O(m)
  void clear() {
    for (var i = 0; i < _bits.length; i++) {
      _bits[i] = false;
    }
    _insertedCount = 0;
  }

  /// Creates a new filter that is the union of this and [other]. O(m)
  /// Both filters must have the same size and hash count.
  BloomFilter<T> union(BloomFilter<T> other) {
    if (_bits.length != other._bits.length) {
      throw ArgumentError('Bloom filters must have the same bit array size');
    }
    if (_hashCount != other._hashCount) {
      throw ArgumentError('Bloom filters must have the same hash count');
    }

    final result = BloomFilter<T>.withSize(_bits.length, _hashCount);
    for (var i = 0; i < _bits.length; i++) {
      result._bits[i] = _bits[i] || other._bits[i];
    }
    result._insertedCount = _insertedCount + other._insertedCount;
    return result;
  }

  /// Creates a new filter that is the intersection of this and [other]. O(m)
  /// Both filters must have the same size and hash count.
  BloomFilter<T> intersection(BloomFilter<T> other) {
    if (_bits.length != other._bits.length) {
      throw ArgumentError('Bloom filters must have the same bit array size');
    }
    if (_hashCount != other._hashCount) {
      throw ArgumentError('Bloom filters must have the same hash count');
    }

    final result = BloomFilter<T>.withSize(_bits.length, _hashCount);
    for (var i = 0; i < _bits.length; i++) {
      result._bits[i] = _bits[i] && other._bits[i];
    }
    // Intersection count is approximate (take minimum as estimate)
    result._insertedCount = math.min(_insertedCount, other._insertedCount);
    return result;
  }

  @override
  String toString() {
    return 'BloomFilter(bits: ${_bits.length}, hashes: $_hashCount, '
        'elements: ~$_insertedCount, fillRatio: ${(fillRatio * 100).toStringAsFixed(1)}%)';
  }
}
