import 'dart:math';

import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('SkipList', () {
    late SkipList<int> skipList;

    setUp(() {
      skipList = SkipList<int>();
    });

    group('Empty list operations', () {
      test('should start empty', () {
        expect(skipList.isEmpty, isTrue);
        expect(skipList.isNotEmpty, isFalse);
        expect(skipList.length, equals(0));
      });

      test('should return empty list from toList', () {
        expect(skipList.toList(), isEmpty);
      });

      test('should return empty iterator from values', () {
        expect(skipList.values.toList(), isEmpty);
      });

      test('should throw on min of empty list', () {
        expect(() => skipList.min, throwsStateError);
      });

      test('should throw on max of empty list', () {
        expect(() => skipList.max, throwsStateError);
      });

      test('should return false for contains on empty list', () {
        expect(skipList.contains(1), isFalse);
      });

      test('should return null for search on empty list', () {
        expect(skipList.search(1), isNull);
      });

      test('should return false for remove on empty list', () {
        expect(skipList.remove(1), isFalse);
      });
    });

    group('insert', () {
      test('should insert single element', () {
        skipList.insert(5);
        expect(skipList.length, equals(1));
        expect(skipList.contains(5), isTrue);
        expect(skipList.isEmpty, isFalse);
      });

      test('should insert multiple elements', () {
        skipList.insert(3);
        skipList.insert(1);
        skipList.insert(4);
        skipList.insert(1);
        skipList.insert(5);
        expect(skipList.length, equals(5));
        expect(skipList.contains(1), isTrue);
        expect(skipList.contains(3), isTrue);
        expect(skipList.contains(4), isTrue);
        expect(skipList.contains(5), isTrue);
      });

      test('should allow duplicate values', () {
        skipList.insert(5);
        skipList.insert(5);
        skipList.insert(5);
        expect(skipList.length, equals(3));
        expect(skipList.toList(), equals([5, 5, 5]));
      });

      test('should insert in ascending order', () {
        skipList.insert(10);
        skipList.insert(5);
        skipList.insert(15);
        expect(skipList.toList(), equals([5, 10, 15]));
      });

      test('should insert in descending order', () {
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(3);
        expect(skipList.toList(), equals([1, 2, 3]));
      });

      test('should handle negative numbers', () {
        skipList.insert(-5);
        skipList.insert(0);
        skipList.insert(5);
        expect(skipList.toList(), equals([-5, 0, 5]));
      });
    });

    group('remove', () {
      test('should remove existing element', () {
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(3);
        expect(skipList.remove(2), isTrue);
        expect(skipList.length, equals(2));
        expect(skipList.contains(2), isFalse);
        expect(skipList.toList(), equals([1, 3]));
      });

      test('should return false for non-existing element', () {
        skipList.insert(1);
        skipList.insert(3);
        expect(skipList.remove(2), isFalse);
        expect(skipList.length, equals(2));
      });

      test('should remove first element', () {
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(3);
        expect(skipList.remove(1), isTrue);
        expect(skipList.toList(), equals([2, 3]));
      });

      test('should remove last element', () {
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(3);
        expect(skipList.remove(3), isTrue);
        expect(skipList.toList(), equals([1, 2]));
      });

      test('should remove only first occurrence of duplicate', () {
        skipList.insert(5);
        skipList.insert(5);
        skipList.insert(5);
        expect(skipList.remove(5), isTrue);
        expect(skipList.length, equals(2));
        expect(skipList.toList(), equals([5, 5]));
      });

      test('should remove all elements one by one', () {
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(3);
        expect(skipList.remove(1), isTrue);
        expect(skipList.remove(2), isTrue);
        expect(skipList.remove(3), isTrue);
        expect(skipList.isEmpty, isTrue);
        expect(skipList.length, equals(0));
      });

      test('should handle remove after all elements removed', () {
        skipList.insert(1);
        skipList.remove(1);
        expect(skipList.remove(1), isFalse);
        expect(skipList.isEmpty, isTrue);
      });
    });

    group('contains and search', () {
      setUp(() {
        skipList.insert(10);
        skipList.insert(20);
        skipList.insert(30);
        skipList.insert(40);
        skipList.insert(50);
      });

      test('should return true for existing elements', () {
        expect(skipList.contains(10), isTrue);
        expect(skipList.contains(30), isTrue);
        expect(skipList.contains(50), isTrue);
      });

      test('should return false for non-existing elements', () {
        expect(skipList.contains(5), isFalse);
        expect(skipList.contains(25), isFalse);
        expect(skipList.contains(100), isFalse);
      });

      test('should return node for search on existing element', () {
        final node = skipList.search(30);
        expect(node, isNotNull);
        expect(node!.value, equals(30));
      });

      test('should return null for search on non-existing element', () {
        expect(skipList.search(25), isNull);
      });
    });

    group('length and isEmpty', () {
      test('should update length on insert', () {
        expect(skipList.length, equals(0));
        skipList.insert(1);
        expect(skipList.length, equals(1));
        skipList.insert(2);
        expect(skipList.length, equals(2));
      });

      test('should update length on remove', () {
        skipList.insert(1);
        skipList.insert(2);
        expect(skipList.length, equals(2));
        skipList.remove(1);
        expect(skipList.length, equals(1));
      });

      test('should update isEmpty on operations', () {
        expect(skipList.isEmpty, isTrue);
        expect(skipList.isNotEmpty, isFalse);
        skipList.insert(1);
        expect(skipList.isEmpty, isFalse);
        expect(skipList.isNotEmpty, isTrue);
        skipList.remove(1);
        expect(skipList.isEmpty, isTrue);
        expect(skipList.isNotEmpty, isFalse);
      });
    });

    group('clear', () {
      test('should clear all elements', () {
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(3);
        skipList.clear();
        expect(skipList.isEmpty, isTrue);
        expect(skipList.length, equals(0));
        expect(skipList.toList(), isEmpty);
      });

      test('should allow operations after clear', () {
        skipList.insert(1);
        skipList.clear();
        skipList.insert(2);
        expect(skipList.length, equals(1));
        expect(skipList.contains(2), isTrue);
        expect(skipList.contains(1), isFalse);
      });

      test('should be idempotent on empty list', () {
        skipList.clear();
        skipList.clear();
        expect(skipList.isEmpty, isTrue);
      });
    });

    group('toList and values iterator', () {
      test('should return sorted list', () {
        skipList.insert(5);
        skipList.insert(1);
        skipList.insert(3);
        skipList.insert(2);
        skipList.insert(4);
        expect(skipList.toList(), equals([1, 2, 3, 4, 5]));
      });

      test('should iterate in sorted order', () {
        skipList.insert(30);
        skipList.insert(10);
        skipList.insert(20);
        expect(skipList.values.toList(), equals([10, 20, 30]));
      });

      test('should handle duplicates in order', () {
        skipList.insert(2);
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(1);
        final list = skipList.toList();
        expect(list, equals([1, 1, 2, 2]));
      });

      test('should allow multiple iterations', () {
        skipList.insert(1);
        skipList.insert(2);
        final first = skipList.values.toList();
        final second = skipList.values.toList();
        expect(first, equals(second));
      });
    });

    group('min and max', () {
      test('should return min element', () {
        skipList.insert(5);
        skipList.insert(1);
        skipList.insert(10);
        expect(skipList.min, equals(1));
      });

      test('should return max element', () {
        skipList.insert(5);
        skipList.insert(1);
        skipList.insert(10);
        expect(skipList.max, equals(10));
      });

      test('should return same value for min and max with single element', () {
        skipList.insert(42);
        expect(skipList.min, equals(42));
        expect(skipList.max, equals(42));
      });

      test('should update min after removing min element', () {
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(3);
        skipList.remove(1);
        expect(skipList.min, equals(2));
      });

      test('should update max after removing max element', () {
        skipList.insert(1);
        skipList.insert(2);
        skipList.insert(3);
        skipList.remove(3);
        expect(skipList.max, equals(2));
      });

      test('should handle negative numbers for min/max', () {
        skipList.insert(-10);
        skipList.insert(0);
        skipList.insert(10);
        expect(skipList.min, equals(-10));
        expect(skipList.max, equals(10));
      });
    });

    group('Custom maxLevel and probability', () {
      test('should work with maxLevel of 1', () {
        final list = SkipList<int>(maxLevel: 1);
        list.insert(3);
        list.insert(1);
        list.insert(2);
        expect(list.toList(), equals([1, 2, 3]));
        expect(list.currentLevel, equals(1));
      });

      test('should work with small probability', () {
        final list = SkipList<int>(probability: 0.1);
        for (var i = 0; i < 20; i++) {
          list.insert(i);
        }
        expect(list.length, equals(20));
        expect(list.toList(), equals(List.generate(20, (i) => i)));
      });

      test('should work with high probability', () {
        final list = SkipList<int>(probability: 0.9);
        for (var i = 0; i < 20; i++) {
          list.insert(i);
        }
        expect(list.length, equals(20));
        expect(list.toList(), equals(List.generate(20, (i) => i)));
      });

      test('should throw for invalid maxLevel', () {
        expect(() => SkipList<int>(maxLevel: 0), throwsArgumentError);
        expect(() => SkipList<int>(maxLevel: -1), throwsArgumentError);
      });

      test('should throw for invalid probability', () {
        expect(() => SkipList<int>(probability: 0.0), throwsArgumentError);
        expect(() => SkipList<int>(probability: 1.0), throwsArgumentError);
        expect(() => SkipList<int>(probability: -0.5), throwsArgumentError);
        expect(() => SkipList<int>(probability: 1.5), throwsArgumentError);
      });

      test('should accept custom random generator', () {
        final random = Random(42);
        final list = SkipList<int>(random: random);
        list.insert(1);
        list.insert(2);
        expect(list.length, equals(2));
      });
    });

    group('Order preservation (sorted)', () {
      test('should maintain sorted order with random inserts', () {
        final random = Random(123);
        final values = List.generate(50, (_) => random.nextInt(1000));
        for (final value in values) {
          skipList.insert(value);
        }
        final result = skipList.toList();
        for (var i = 1; i < result.length; i++) {
          expect(result[i] >= result[i - 1], isTrue);
        }
      });

      test('should maintain sorted order after removals', () {
        for (var i = 0; i < 20; i++) {
          skipList.insert(i);
        }
        skipList.remove(5);
        skipList.remove(10);
        skipList.remove(15);
        final result = skipList.toList();
        for (var i = 1; i < result.length; i++) {
          expect(result[i] >= result[i - 1], isTrue);
        }
      });

      test('should maintain sorted order with string type', () {
        final stringList = SkipList<String>();
        stringList.insert('banana');
        stringList.insert('apple');
        stringList.insert('cherry');
        stringList.insert('date');
        expect(stringList.toList(), equals(['apple', 'banana', 'cherry', 'date']));
      });
    });

    group('Search efficiency (O(log n) structure)', () {
      test('should build multi-level structure', () {
        final list = SkipList<int>(probability: 0.5, random: Random(42));
        for (var i = 0; i < 100; i++) {
          list.insert(i);
        }
        // With 100 elements and p=0.5, we expect multiple levels
        expect(list.currentLevel, greaterThan(1));
      });

      test('should have reasonable level height', () {
        // Expected max level is O(log n)
        final list = SkipList<int>(maxLevel: 20, probability: 0.5);
        for (var i = 0; i < 1000; i++) {
          list.insert(i);
        }
        // log2(1000) ~ 10, so levels should be reasonable
        expect(list.currentLevel, lessThanOrEqualTo(20));
        expect(list.currentLevel, greaterThan(1));
      });
    });

    group('Edge cases', () {
      test('should handle single element operations', () {
        skipList.insert(42);
        expect(skipList.length, equals(1));
        expect(skipList.min, equals(42));
        expect(skipList.max, equals(42));
        expect(skipList.contains(42), isTrue);
        expect(skipList.remove(42), isTrue);
        expect(skipList.isEmpty, isTrue);
      });

      test('should handle all same values', () {
        for (var i = 0; i < 10; i++) {
          skipList.insert(7);
        }
        expect(skipList.length, equals(10));
        expect(skipList.min, equals(7));
        expect(skipList.max, equals(7));
        expect(skipList.toList(), equals(List.filled(10, 7)));
      });

      test('should handle removing all same values', () {
        for (var i = 0; i < 5; i++) {
          skipList.insert(3);
        }
        for (var i = 0; i < 5; i++) {
          expect(skipList.remove(3), isTrue);
        }
        expect(skipList.remove(3), isFalse);
        expect(skipList.isEmpty, isTrue);
      });

      test('should handle alternating insert and remove', () {
        for (var i = 0; i < 10; i++) {
          skipList.insert(i);
          if (i > 0 && i % 2 == 0) {
            skipList.remove(i - 1);
          }
        }
        expect(skipList.length, equals(6));
      });

      test('should handle extreme values', () {
        const minInt = -9223372036854775808;
        const maxInt = 9223372036854775807;
        skipList.insert(minInt);
        skipList.insert(0);
        skipList.insert(maxInt);
        expect(skipList.min, equals(minInt));
        expect(skipList.max, equals(maxInt));
        expect(skipList.contains(0), isTrue);
      });
    });

    group('Large data sets (100+ elements)', () {
      test('should handle 100 sequential inserts', () {
        for (var i = 0; i < 100; i++) {
          skipList.insert(i);
        }
        expect(skipList.length, equals(100));
        expect(skipList.min, equals(0));
        expect(skipList.max, equals(99));
        expect(skipList.toList(), equals(List.generate(100, (i) => i)));
      });

      test('should handle 100 reverse inserts', () {
        for (var i = 99; i >= 0; i--) {
          skipList.insert(i);
        }
        expect(skipList.length, equals(100));
        expect(skipList.toList(), equals(List.generate(100, (i) => i)));
      });

      test('should handle 1000 random inserts', () {
        final random = Random(999);
        final values = <int>[];
        for (var i = 0; i < 1000; i++) {
          final value = random.nextInt(10000);
          values.add(value);
          skipList.insert(value);
        }
        expect(skipList.length, equals(1000));
        values.sort();
        expect(skipList.toList(), equals(values));
      });

      test('should handle 500 inserts and 500 removes', () {
        final random = Random(888);
        final inserted = <int>[];
        for (var i = 0; i < 500; i++) {
          final value = random.nextInt(10000);
          skipList.insert(value);
          inserted.add(value);
        }
        expect(skipList.length, equals(500));

        var removedCount = 0;
        for (var i = 0; i < 250; i++) {
          if (skipList.remove(inserted[i])) {
            removedCount++;
          }
        }
        expect(skipList.length, equals(500 - removedCount));
      });

      test('should search efficiently in large list', () {
        for (var i = 0; i < 1000; i++) {
          skipList.insert(i * 2); // Even numbers 0-1998
        }
        // Search for existing elements
        expect(skipList.contains(0), isTrue);
        expect(skipList.contains(500), isTrue);
        expect(skipList.contains(1998), isTrue);
        // Search for non-existing elements
        expect(skipList.contains(1), isFalse);
        expect(skipList.contains(501), isFalse);
        expect(skipList.contains(1999), isFalse);
      });
    });

    group('Factory constructor from', () {
      test('should create from empty iterable', () {
        final list = SkipList<int>.from([]);
        expect(list.isEmpty, isTrue);
      });

      test('should create from list', () {
        final list = SkipList<int>.from([3, 1, 4, 1, 5, 9, 2, 6]);
        expect(list.length, equals(8));
        expect(list.toList(), equals([1, 1, 2, 3, 4, 5, 6, 9]));
      });

      test('should create from set', () {
        final list = SkipList<int>.from({5, 2, 8, 1, 9});
        expect(list.length, equals(5));
        final sorted = list.toList();
        expect(sorted.first, equals(1));
        expect(sorted.last, equals(9));
      });

      test('should create with custom parameters', () {
        final list = SkipList<int>.from(
          [1, 2, 3],
          maxLevel: 8,
          probability: 0.25,
        );
        expect(list.length, equals(3));
        expect(list.toList(), equals([1, 2, 3]));
      });
    });

    group('toString', () {
      test('should represent empty list', () {
        expect(skipList.toString(), equals('SkipList: []'));
      });

      test('should represent non-empty list', () {
        skipList.insert(1);
        skipList.insert(2);
        final str = skipList.toString();
        expect(str.contains('SkipList'), isTrue);
        expect(str.contains('1'), isTrue);
        expect(str.contains('2'), isTrue);
      });
    });

    group('SkipListNode', () {
      test('should have correct toString', () {
        final node = SkipListNode<int>(42, 3);
        expect(node.toString(), equals('SkipListNode(42, level: 3)'));
      });

      test('should store value correctly', () {
        final node = SkipListNode<String>('test', 2);
        expect(node.value, equals('test'));
        expect(node.forward.length, equals(2));
      });
    });

    group('Type support', () {
      test('should work with double type', () {
        final doubleList = SkipList<double>();
        doubleList.insert(3.14);
        doubleList.insert(2.71);
        doubleList.insert(1.41);
        expect(doubleList.toList(), equals([1.41, 2.71, 3.14]));
      });

      test('should work with String type', () {
        final stringList = SkipList<String>();
        stringList.insert('zebra');
        stringList.insert('apple');
        stringList.insert('mango');
        expect(stringList.toList(), equals(['apple', 'mango', 'zebra']));
        expect(stringList.min, equals('apple'));
        expect(stringList.max, equals('zebra'));
      });

      test('should work with custom Comparable class', () {
        final personList = SkipList<_Person>();
        personList.insert(_Person('Alice', 30));
        personList.insert(_Person('Bob', 25));
        personList.insert(_Person('Charlie', 35));
        expect(personList.min.name, equals('Bob'));
        expect(personList.max.name, equals('Charlie'));
      });
    });
  });
}

class _Person implements Comparable<_Person> {
  final String name;
  final int age;

  _Person(this.name, this.age);

  @override
  int compareTo(_Person other) => age.compareTo(other.age);

  @override
  String toString() => '$name($age)';
}
