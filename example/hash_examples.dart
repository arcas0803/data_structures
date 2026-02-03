/// Comprehensive examples for Hash/Direct Access Structures
/// Run with: dart run example/hash_examples.dart
library;

import 'package:data_structures/data_structures.dart';

void main() {
  print('═══════════════════════════════════════════════════════════════');
  print('                 DIRECT ACCESS STRUCTURES EXAMPLES');
  print('═══════════════════════════════════════════════════════════════\n');

  dynamicArrayExamples();
  hashTableExamples();
  hashSetExamples();
  unionFindExamples();
  bloomFilterExamples();
}

void dynamicArrayExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                    DYNAMIC ARRAY                           │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Creation with initial capacity
  print('--- Creation ---');
  final arr = DynamicArray<int>(4);
  print('Created with initial capacity: 4');
  print('Length: ${arr.length}, Capacity: ${arr.capacity}');

  // Add elements
  print('\n--- Adding Elements ---');
  for (var i = 1; i <= 6; i++) {
    arr.add(i * 10);
    print('Added ${i * 10}: length=${arr.length}, capacity=${arr.capacity}');
  }

  // Access by index
  print('\n--- Index Access ---');
  print('arr[0] = ${arr[0]}');
  print('arr[3] = ${arr[3]}');
  print('arr[5] = ${arr[5]}');

  // Modify by index
  print('\n--- Modify by Index ---');
  arr[2] = 999;
  print('After arr[2] = 999: $arr');

  // Insert at position
  print('\n--- Insert at Position ---');
  arr.insert(0, 5);
  print('After insert(0, 5): $arr');
  arr.insert(3, 555);
  print('After insert(3, 555): $arr');

  // Remove operations
  print('\n--- Remove Operations ---');
  arr.removeAt(3);
  print('After removeAt(3): $arr');
  arr.remove(999);
  print('After remove(999): $arr');

  // Search
  print('\n--- Search ---');
  print('Contains 40? ${arr.contains(40)}');
  print('Contains 100? ${arr.contains(100)}');
  print('Index of 50: ${arr.indexOf(50)}');

  // Transformations
  print('\n--- Transformations ---');
  arr.reverse();
  print('After reverse(): $arr');

  // Resize
  print('\n--- Manual Resize ---');
  arr.setCapacity(100);
  print('After setCapacity(100): capacity=${arr.capacity}');
  arr.trimToSize();
  print('After trimToSize(): capacity=${arr.capacity}');

  // Factory
  print('\n--- Factory Constructor ---');
  final fromList = DynamicArray.from([1, 2, 3, 4, 5]);
  print('DynamicArray.from([1,2,3,4,5]): $fromList');

  // Use case: Growing buffer
  print('\n--- Use Case: Growing Buffer ---');
  final buffer = DynamicArray<String>(2);
  final messages = ['msg1', 'msg2', 'msg3', 'msg4', 'msg5'];
  print('Initial capacity: ${buffer.capacity}');
  for (final msg in messages) {
    buffer.add(msg);
  }
  print('After adding ${messages.length} messages:');
  print('  Length: ${buffer.length}, Capacity: ${buffer.capacity}');
  print('  Growth is amortized O(1)!');

  print('\n');
}

void hashTableExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                      HASH TABLE                            │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final map = HashTable<String, int>();

  // Basic operations
  print('--- Basic Operations ---');
  map['apple'] = 5;
  map['banana'] = 3;
  map['cherry'] = 8;
  map['date'] = 2;
  print('Added: apple=5, banana=3, cherry=8, date=2');
  print('Map: $map');

  // Access
  print('\n--- Access ---');
  print('map["apple"] = ${map['apple']}');
  print('map["banana"] = ${map['banana']}');
  print('containsKey("unknown") = ${map.containsKey('unknown')}');

  // Check existence
  print('\n--- Existence Check ---');
  print('containsKey("cherry"): ${map.containsKey('cherry')}');
  print('containsKey("elderberry"): ${map.containsKey('elderberry')}');
  print('containsValue(8): ${map.containsValue(8)}');
  print('containsValue(100): ${map.containsValue(100)}');

  // Update
  print('\n--- Update ---');
  print('Before: map["apple"] = ${map['apple']}');
  map['apple'] = 10;
  print('After map["apple"] = 10: ${map['apple']}');

  // Remove
  print('\n--- Remove ---');
  final removed = map.remove('banana');
  print('Removed "banana": $removed');
  print('Map after removal: $map');

  // Keys, values, entries
  print('\n--- Keys, Values, Entries ---');
  map['elderberry'] = 7;
  map['fig'] = 4;
  print('Keys: ${map.keys.toList()}');
  print('Values: ${map.values.toList()}');
  print('Entries:');
  for (final entry in map.entries) {
    final (key, value) = entry;
    print('  $key -> $value');
  }

  // Get or default
  print('\n--- Get with Default ---');
  print('getOrDefault("apple", 0) = ${map.getOrDefault('apple', 0)}');
  print('getOrDefault("unknown", 99) = ${map.getOrDefault('unknown', 99)}');

  // Put if absent
  print('\n--- Put If Absent ---');
  map.putIfAbsent('grape', () => 6);
  print('After putIfAbsent("grape", 6): ${map.tryGet('grape')}');
  map.putIfAbsent('apple', () => 100); // Won't update
  print('After putIfAbsent("apple", 100): ${map.tryGet('apple')} (unchanged)');

  // Statistics
  print('\n--- Hash Table Statistics ---');
  print('Length: ${map.length}');
  final stats = map.stats;
  print('Bucket count: ${stats['bucketCount']}');
  print('Load factor: ${(stats['loadFactor'] as double).toStringAsFixed(2)}');
  print('Empty buckets: ${stats['emptyBuckets']}');
  print('Max chain length: ${stats['maxChainLength']}');

  // Use case: Word frequency
  print('\n--- Use Case: Word Frequency Counter ---');
  final text = 'the quick brown fox jumps over the lazy dog the fox';
  final frequency = HashTable<String, int>();

  for (final word in text.split(' ')) {
    final current = frequency.tryGet(word) ?? 0;
    frequency[word] = current + 1;
  }

  print('Text: "$text"');
  print('Word frequencies:');
  for (final entry in frequency.entries) {
    final (key, value) = entry;
    print('  "$key": $value');
  }

  // Use case: Two Sum
  print('\n--- Use Case: Two Sum Problem ---');
  List<int>? twoSum(List<int> nums, int target) {
    final seen = HashTable<int, int>();
    for (var i = 0; i < nums.length; i++) {
      final complement = target - nums[i];
      if (seen.containsKey(complement)) {
        return [seen[complement], i];
      }
      seen[nums[i]] = i;
    }
    return null;
  }

  final nums = [2, 7, 11, 15];
  final target = 9;
  print('nums = $nums, target = $target');
  print('Indices: ${twoSum(nums, target)}');

  print('\n');
}

void hashSetExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                       HASH SET                             │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Creation
  print('--- Creation ---');
  final setA = HashSet<int>();
  setA.add(1);
  setA.add(2);
  setA.add(3);
  setA.add(2); // Duplicate
  print('After adding 1, 2, 3, 2: $setA');
  print('Length: ${setA.length} (no duplicates!)');

  // From iterable
  print('\n--- From Iterable ---');
  final setB = HashSet<int>.from([3, 4, 5, 6]);
  print('HashSet.from([3,4,5,6]): $setB');

  // Contains
  print('\n--- Contains ---');
  print('setA.contains(2): ${setA.contains(2)}');
  print('setA.contains(5): ${setA.contains(5)}');

  // Remove
  print('\n--- Remove ---');
  setA.remove(2);
  print('After remove(2): $setA');

  // Set operations
  print('\n--- Set Operations ---');
  final set1 = HashSet<int>.from([1, 2, 3, 4, 5]);
  final set2 = HashSet<int>.from([4, 5, 6, 7, 8]);
  print('Set1: $set1');
  print('Set2: $set2');

  print('\nUnion (A ∪ B):');
  print('  ${set1.union(set2)}');

  print('\nIntersection (A ∩ B):');
  print('  ${set1.intersection(set2)}');

  print('\nDifference (A - B):');
  print('  ${set1.difference(set2)}');

  // Subset/superset
  print('\n--- Subset/Superset ---');
  final small = HashSet<int>.from([2, 3]);
  final big = HashSet<int>.from([1, 2, 3, 4, 5]);
  print('Small: $small');
  print('Big: $big');
  print('small.isSubsetOf(big): ${small.isSubsetOf(big)}');
  print('big contains all of small? ${small.isSubsetOf(big)}');

  // Use case: Remove duplicates
  print('\n--- Use Case: Remove Duplicates ---');
  final listWithDups = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4];
  final unique = HashSet<int>.from(listWithDups);
  print('Original: $listWithDups');
  print('Unique: ${unique.toList()}');

  // Use case: Find common elements
  print('\n--- Use Case: Find Common Elements ---');
  final list1 = [1, 2, 3, 4, 5];
  final list2 = [4, 5, 6, 7, 8];
  final list3 = [5, 6, 7, 8, 9];

  var common = HashSet<int>.from(list1);
  common = common.intersection(HashSet<int>.from(list2));
  common = common.intersection(HashSet<int>.from(list3));

  print('List1: $list1');
  print('List2: $list2');
  print('List3: $list3');
  print('Common to all: $common');

  // Use case: Check if anagram
  print('\n--- Use Case: Anagram Check ---');
  bool areAnagrams(String s1, String s2) {
    if (s1.length != s2.length) return false;
    final freq = HashTable<String, int>();

    for (final c in s1.split('')) {
      final current = freq.tryGet(c) ?? 0;
      freq[c] = current + 1;
    }
    for (final c in s2.split('')) {
      if (!freq.containsKey(c)) return false;
      final current = freq.tryGet(c) ?? 0;
      freq[c] = current - 1;
      if (freq.tryGet(c) == 0) freq.remove(c);
    }
    return freq.isEmpty;
  }

  print('"listen" and "silent": ${areAnagrams("listen", "silent")}');
  print('"hello" and "world": ${areAnagrams("hello", "world")}');

  print('\n');
}

void unionFindExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                      UNION FIND                            │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Generic Union-Find
  print('--- Generic UnionFind<String> ---');
  final uf = UnionFind<String>();

  // Make sets
  uf.makeSet('A');
  uf.makeSet('B');
  uf.makeSet('C');
  uf.makeSet('D');
  uf.makeSet('E');
  print('Created sets: A, B, C, D, E');
  print('Set count: ${uf.setCount}');

  // Union
  print('\n--- Union Operations ---');
  uf.union('A', 'B');
  print('After union(A, B): ${uf.setCount} sets');
  uf.union('C', 'D');
  print('After union(C, D): ${uf.setCount} sets');
  uf.union('A', 'C');
  print('After union(A, C): ${uf.setCount} sets');

  // Find
  print('\n--- Find and Connected ---');
  print('find(A) = ${uf.find('A')}');
  print('find(D) = ${uf.find('D')}');
  print('connected(A, D): ${uf.connected('A', 'D')}');
  print('connected(A, E): ${uf.connected('A', 'E')}');

  // Set info
  print('\n--- Set Information ---');
  print('Set containing A: ${uf.getSet('A')}');
  print('Size of A\'s set: ${uf.getSetSize('A')}');
  print('All sets: ${uf.allSets}');

  // Integer Union-Find (optimized)
  print('\n--- UnionFindInt (Optimized) ---');
  final ufInt = UnionFindInt(10); // 0 to 9
  print('Created with 10 elements (0-9)');

  ufInt.union(0, 1);
  ufInt.union(2, 3);
  ufInt.union(0, 2);
  ufInt.union(5, 6);
  ufInt.union(7, 8);
  ufInt.union(5, 7);

  print('After unions:');
  print('  Set count: ${ufInt.setCount}');
  print('  Set of 0: ${ufInt.getSet(0)}');
  print('  Set of 5: ${ufInt.getSet(5)}');
  print('  Set of 4: ${ufInt.getSet(4)} (isolated)');

  // Use case: Kruskal's MST
  print('\n--- Use Case: Kruskal\'s MST ---');
  // Edges: (u, v, weight)
  final edges = [
    (0, 1, 4),
    (0, 2, 3),
    (1, 2, 1),
    (1, 3, 2),
    (2, 3, 4),
    (3, 4, 2),
    (4, 5, 6),
  ];

  // Sort by weight
  final sortedEdges = List.of(edges)..sort((a, b) => a.$3.compareTo(b.$3));

  final mstUF = UnionFindInt(6);
  final mst = <(int, int, int)>[];
  var totalWeight = 0;

  print(
      'Edges sorted by weight: ${sortedEdges.map((e) => '(${e.$1}-${e.$2}:${e.$3})').join(', ')}');
  print('');

  for (final edge in sortedEdges) {
    final (u, v, w) = edge;
    if (!mstUF.connected(u, v)) {
      mstUF.union(u, v);
      mst.add(edge);
      totalWeight += w;
      print('Add edge ($u, $v) with weight $w');
    } else {
      print('Skip edge ($u, $v) - would create cycle');
    }
  }

  print('');
  print('MST edges: ${mst.map((e) => '(${e.$1}-${e.$2})').join(', ')}');
  print('Total weight: $totalWeight');

  // Use case: Connected components
  print('\n--- Use Case: Social Network Groups ---');
  final network = UnionFind<String>();
  final people = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve', 'Frank'];
  for (final p in people) {
    network.makeSet(p);
  }

  // Friendships
  network.union('Alice', 'Bob');
  network.union('Bob', 'Charlie');
  network.union('Diana', 'Eve');

  print('Friendships: Alice-Bob, Bob-Charlie, Diana-Eve');
  print('Groups: ${network.allSets}');
  print(
      'Are Alice and Charlie connected? ${network.connected('Alice', 'Charlie')}');
  print(
      'Are Alice and Diana connected? ${network.connected('Alice', 'Diana')}');

  print('\n');
}

void bloomFilterExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                     BLOOM FILTER                           │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Creation
  print('--- Creation ---');
  final bloom =
      BloomFilter<String>(1000, 0.01); // 1000 elements, 1% false positive rate
  print('Created for 1000 elements with 1% false positive rate');
  print('Bit array size: ${bloom.bitCount}');
  print('Hash functions: ${bloom.hashCount}');

  // Add elements
  print('\n--- Adding Elements ---');
  final words = ['apple', 'banana', 'cherry', 'date', 'elderberry'];
  for (final word in words) {
    bloom.add(word);
  }
  print('Added: ${words.join(', ')}');
  print('Approximate element count: ${bloom.approximateElementCount.round()}');
  print('Fill ratio: ${(bloom.fillRatio * 100).toStringAsFixed(2)}%');

  // Check membership
  print('\n--- Membership Check ---');
  print('contains("apple"): ${bloom.contains('apple')} (definitely in set)');
  print('contains("banana"): ${bloom.contains('banana')} (definitely in set)');
  print('contains("fig"): ${bloom.contains('fig')} (probably not)');
  print('contains("grape"): ${bloom.contains('grape')} (probably not)');

  // False positive demonstration
  print('\n--- False Positive Demonstration ---');
  print(
      'Important: If contains() returns false, element is DEFINITELY not in set');
  print('           If contains() returns true, element is PROBABLY in set');

  final testBloom = BloomFilter<int>(100, 0.1); // Higher FP rate for demo
  for (var i = 0; i < 100; i += 2) {
    testBloom.add(i); // Add only even numbers
  }

  var falsePositives = 0;
  var trueNegatives = 0;
  for (var i = 1; i < 100; i += 2) {
    if (testBloom.contains(i)) {
      falsePositives++;
    } else {
      trueNegatives++;
    }
  }
  print('Added even numbers 0-98, tested odd numbers 1-99:');
  print('  False positives: $falsePositives');
  print('  True negatives: $trueNegatives');
  print('  Actual FP rate: ${(falsePositives / 50 * 100).toStringAsFixed(1)}%');

  // Optimal parameters
  print('\n--- Optimal Parameters ---');
  print('For 10,000 elements with 1% FP rate:');
  print('  Optimal bits: ${BloomFilter.optimalSize(10000, 0.01)}');
  print(
      '  Optimal hashes: ${BloomFilter.optimalHashCount(BloomFilter.optimalSize(10000, 0.01), 10000)}');

  print('\nFor 10,000 elements with 0.1% FP rate:');
  print('  Optimal bits: ${BloomFilter.optimalSize(10000, 0.001)}');
  print(
      '  Optimal hashes: ${BloomFilter.optimalHashCount(BloomFilter.optimalSize(10000, 0.001), 10000)}');

  // Union and Intersection
  print('\n--- Set Operations ---');
  final bloom1 = BloomFilter<String>(100, 0.01);
  bloom1.addAll(['a', 'b', 'c']);

  final bloom2 = BloomFilter<String>(100, 0.01);
  bloom2.addAll(['b', 'c', 'd']);

  final unionBloom = bloom1.union(bloom2);
  print('Bloom1: a, b, c');
  print('Bloom2: b, c, d');
  print('Union contains "a": ${unionBloom.contains('a')}');
  print('Union contains "d": ${unionBloom.contains('d')}');

  // Use case: Cache lookup
  print('\n--- Use Case: Cache Lookup Optimization ---');
  print('Scenario: Check if item is in cache before expensive lookup');

  final cacheFilter = BloomFilter<String>(10000, 0.01);
  final cachedItems = ['user_123', 'user_456', 'product_789'];
  cacheFilter.addAll(cachedItems);

  void lookup(String key) {
    if (!cacheFilter.contains(key)) {
      print('  "$key": NOT in cache (skip DB lookup)');
    } else {
      print('  "$key": MIGHT be in cache (check actual cache)');
    }
  }

  print('Looking up items:');
  lookup('user_123'); // In cache
  lookup('user_999'); // Not in cache
  lookup('product_789'); // In cache

  // Use case: Spell checker
  print('\n--- Use Case: Fast Spell Checker ---');
  final dictionary = BloomFilter<String>(100000, 0.001);
  final words2 = [
    'the',
    'quick',
    'brown',
    'fox',
    'jumps',
    'over',
    'lazy',
    'dog'
  ];
  dictionary.addAll(words2);

  final sentence = ['the', 'quik', 'brown', 'foxes'];
  print('Checking: ${sentence.join(' ')}');
  for (final word in sentence) {
    if (!dictionary.contains(word)) {
      print('  "$word" - MISSPELLED');
    } else {
      print('  "$word" - OK');
    }
  }

  print('\n');
}
