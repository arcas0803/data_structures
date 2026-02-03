import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('HashTable', () {
    late HashTable<String, int> table;

    setUp(() {
      table = HashTable<String, int>();
    });

    test('should start empty', () {
      expect(table.isEmpty, isTrue);
      expect(table.length, equals(0));
    });

    test('should put and get values', () {
      table.put('one', 1);
      table.put('two', 2);
      table.put('three', 3);

      expect(table.length, equals(3));
      expect(table.get('one'), equals(1));
      expect(table.get('two'), equals(2));
      expect(table.get('three'), equals(3));
    });

    test('should use operator [] for put and get', () {
      table['one'] = 1;
      table['two'] = 2;

      expect(table['one'], equals(1));
      expect(table['two'], equals(2));
    });

    test('should update existing key', () {
      table.put('key', 1);
      final old = table.put('key', 2);

      expect(old, equals(1));
      expect(table.get('key'), equals(2));
      expect(table.length, equals(1));
    });

    test('should throw on get for missing key', () {
      expect(() => table.get('missing'), throwsStateError);
    });

    test('should tryGet return null for missing key', () {
      expect(table.tryGet('missing'), isNull);
    });

    test('should getOrDefault return default for missing key', () {
      table.put('one', 1);
      expect(table.getOrDefault('one', 0), equals(1));
      expect(table.getOrDefault('missing', 42), equals(42));
    });

    test('should putIfAbsent', () {
      table.put('one', 1);
      expect(table.putIfAbsent('one', () => 100), equals(1));
      expect(table.putIfAbsent('two', () => 2), equals(2));
      expect(table.get('two'), equals(2));
    });

    test('should remove values', () {
      table.put('one', 1);
      table.put('two', 2);

      expect(table.remove('one'), equals(1));
      expect(table.length, equals(1));
      expect(table.containsKey('one'), isFalse);
      expect(table.remove('missing'), isNull);
    });

    test('should check containsKey', () {
      table.put('one', 1);
      expect(table.containsKey('one'), isTrue);
      expect(table.containsKey('two'), isFalse);
    });

    test('should check containsValue', () {
      table.put('one', 1);
      table.put('two', 2);
      expect(table.containsValue(1), isTrue);
      expect(table.containsValue(5), isFalse);
    });

    test('should iterate over keys', () {
      table.put('one', 1);
      table.put('two', 2);
      table.put('three', 3);

      final keys = table.keys.toSet();
      expect(keys, equals({'one', 'two', 'three'}));
    });

    test('should iterate over values', () {
      table.put('one', 1);
      table.put('two', 2);
      table.put('three', 3);

      final values = table.values.toSet();
      expect(values, equals({1, 2, 3}));
    });

    test('should iterate over entries', () {
      table.put('one', 1);
      table.put('two', 2);

      final entries = table.entries.toList();
      expect(entries.length, equals(2));
    });

    test('should clear the table', () {
      table.put('one', 1);
      table.put('two', 2);
      table.clear();

      expect(table.isEmpty, isTrue);
      expect(table.length, equals(0));
    });

    test('should update values', () {
      table.put('counter', 0);
      table.update('counter', (v) => v + 1);
      table.update('counter', (v) => v + 1);

      expect(table.get('counter'), equals(2));
    });

    test('should update with ifAbsent', () {
      table.update('new', (v) => v + 1, ifAbsent: () => 10);
      expect(table.get('new'), equals(10));
    });

    test('should convert to Map', () {
      table.put('one', 1);
      table.put('two', 2);

      final map = table.toMap();
      expect(map, equals({'one': 1, 'two': 2}));
    });

    test('should create from Map', () {
      final newTable = HashTable.from({'a': 1, 'b': 2, 'c': 3});
      expect(newTable.length, equals(3));
      expect(newTable.get('b'), equals(2));
    });

    test('should resize when load factor exceeded', () {
      final smallTable = HashTable<int, int>(4);
      for (var i = 0; i < 20; i++) {
        smallTable.put(i, i * 10);
      }

      expect(smallTable.length, equals(20));
      expect(smallTable.capacity, greaterThan(4));

      for (var i = 0; i < 20; i++) {
        expect(smallTable.get(i), equals(i * 10));
      }
    });

    test('should provide stats', () {
      table.put('one', 1);
      table.put('two', 2);

      final stats = table.stats;
      expect(stats['size'], equals(2));
      expect(stats['capacity'], greaterThan(0));
      expect(stats['loadFactor'], greaterThan(0));
    });
  });

  group('HashSet', () {
    late HashSet<int> set;

    setUp(() {
      set = HashSet<int>();
    });

    test('should start empty', () {
      expect(set.isEmpty, isTrue);
      expect(set.length, equals(0));
    });

    test('should add elements', () {
      expect(set.add(1), isTrue);
      expect(set.add(2), isTrue);
      expect(set.add(1), isFalse); // duplicate
      expect(set.length, equals(2));
    });

    test('should addAll', () {
      set.addAll([1, 2, 3, 2, 1]);
      expect(set.length, equals(3));
    });

    test('should remove elements', () {
      set.addAll([1, 2, 3]);
      expect(set.remove(2), isTrue);
      expect(set.remove(5), isFalse);
      expect(set.length, equals(2));
    });

    test('should check contains', () {
      set.addAll([1, 2, 3]);
      expect(set.contains(2), isTrue);
      expect(set.contains(5), isFalse);
    });

    test('should perform union', () {
      set.addAll([1, 2, 3]);
      final other = HashSet<int>.from([3, 4, 5]);

      final union = set.union(other);
      expect(union.toSet(), equals({1, 2, 3, 4, 5}));
    });

    test('should perform intersection', () {
      set.addAll([1, 2, 3, 4]);
      final other = HashSet<int>.from([3, 4, 5, 6]);

      final intersection = set.intersection(other);
      expect(intersection.toSet(), equals({3, 4}));
    });

    test('should perform difference', () {
      set.addAll([1, 2, 3, 4]);
      final other = HashSet<int>.from([3, 4, 5, 6]);

      final difference = set.difference(other);
      expect(difference.toSet(), equals({1, 2}));
    });

    test('should check isSubsetOf', () {
      set.addAll([1, 2]);
      final superset = HashSet<int>.from([1, 2, 3, 4, 5]);
      final notSuperset = HashSet<int>.from([2, 3, 4]);

      expect(set.isSubsetOf(superset), isTrue);
      expect(set.isSubsetOf(notSuperset), isFalse);
    });

    test('should clear', () {
      set.addAll([1, 2, 3]);
      set.clear();
      expect(set.isEmpty, isTrue);
    });

    test('should convert to Set and List', () {
      set.addAll([1, 2, 3]);
      expect(set.toSet(), equals({1, 2, 3}));
      expect(set.toList().toSet(), equals({1, 2, 3}));
    });

    test('should create from iterable', () {
      final newSet = HashSet.from([1, 2, 3, 2, 1]);
      expect(newSet.length, equals(3));
    });
  });
}
