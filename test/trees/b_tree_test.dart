import 'dart:math';
import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('BTree', () {
    late BTree<int, String> tree;

    setUp(() {
      tree = BTree<int, String>();
    });

    group('empty tree operations', () {
      test('should start empty', () {
        expect(tree.isEmpty, isTrue);
        expect(tree.isNotEmpty, isFalse);
        expect(tree.length, equals(0));
        expect(tree.root, isNull);
        expect(tree.height, equals(0));
      });

      test('should have default minDegree of 2', () {
        expect(tree.minDegree, equals(2));
      });

      test('search on empty tree returns null', () {
        expect(tree.search(1), isNull);
        expect(tree.get(1), isNull);
        expect(tree[1], isNull);
      });

      test('contains on empty tree returns false', () {
        expect(tree.contains(1), isFalse);
      });

      test('remove on empty tree returns false', () {
        expect(tree.remove(1), isFalse);
      });

      test('inOrder on empty tree returns empty iterable', () {
        expect(tree.inOrder.toList(), isEmpty);
      });

      test('keys and values on empty tree are empty', () {
        expect(tree.keys.toList(), isEmpty);
        expect(tree.values.toList(), isEmpty);
      });

      test('toList on empty tree returns empty list', () {
        expect(tree.toList(), isEmpty);
      });

      test('clear on empty tree does nothing', () {
        tree.clear();
        expect(tree.isEmpty, isTrue);
      });
    });

    group('insert operations', () {
      test('should insert single element', () {
        tree.insert(5, 'five');
        expect(tree.length, equals(1));
        expect(tree.isEmpty, isFalse);
        expect(tree.isNotEmpty, isTrue);
        expect(tree.search(5), equals('five'));
      });

      test('should insert multiple elements', () {
        tree.insert(5, 'five');
        tree.insert(3, 'three');
        tree.insert(7, 'seven');
        expect(tree.length, equals(3));
        expect(tree.search(5), equals('five'));
        expect(tree.search(3), equals('three'));
        expect(tree.search(7), equals('seven'));
      });

      test('should update value on duplicate key insert', () {
        tree.insert(5, 'five');
        tree.insert(5, 'FIVE');
        expect(tree.length, equals(1));
        expect(tree.search(5), equals('FIVE'));
      });

      test('should cause node splits on many inserts', () {
        for (var i = 1; i <= 10; i++) {
          tree.insert(i, 'value$i');
        }
        expect(tree.length, equals(10));
        expect(tree.height, greaterThan(1));
        for (var i = 1; i <= 10; i++) {
          expect(tree.search(i), equals('value$i'));
        }
      });

      test('should handle reverse order inserts', () {
        for (var i = 10; i >= 1; i--) {
          tree.insert(i, 'value$i');
        }
        expect(tree.length, equals(10));
        expect(tree.keys.toList(), equals([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
      });

      test('should handle random inserts', () {
        final random = Random(42);
        final inserted = <int>{};
        for (var i = 0; i < 50; i++) {
          final key = random.nextInt(100);
          if (inserted.add(key)) {
            tree.insert(key, 'value$key');
          }
        }
        expect(tree.length, equals(inserted.length));
        for (final key in inserted) {
          expect(tree.contains(key), isTrue);
        }
      });
    });

    group('search operations', () {
      setUp(() {
        tree.insert(5, 'five');
        tree.insert(3, 'three');
        tree.insert(7, 'seven');
        tree.insert(1, 'one');
        tree.insert(9, 'nine');
      });

      test('search finds existing keys', () {
        expect(tree.search(5), equals('five'));
        expect(tree.search(3), equals('three'));
        expect(tree.search(7), equals('seven'));
      });

      test('search returns null for non-existent keys', () {
        expect(tree.search(2), isNull);
        expect(tree.search(100), isNull);
      });

      test('get works same as search', () {
        expect(tree.get(5), equals('five'));
        expect(tree.get(2), isNull);
      });

      test('operator[] works same as search', () {
        expect(tree[5], equals('five'));
        expect(tree[2], isNull);
      });

      test('contains returns true for existing keys', () {
        expect(tree.contains(5), isTrue);
        expect(tree.contains(1), isTrue);
        expect(tree.contains(9), isTrue);
      });

      test('contains returns false for non-existent keys', () {
        expect(tree.contains(2), isFalse);
        expect(tree.contains(100), isFalse);
      });
    });

    group('remove operations', () {
      setUp(() {
        for (var i = 1; i <= 10; i++) {
          tree.insert(i, 'value$i');
        }
      });

      test('should remove existing key from leaf', () {
        expect(tree.remove(10), isTrue);
        expect(tree.contains(10), isFalse);
        expect(tree.length, equals(9));
      });

      test('should return false when removing non-existent key', () {
        expect(tree.remove(100), isFalse);
        expect(tree.length, equals(10));
      });

      test('should remove all elements', () {
        for (var i = 1; i <= 10; i++) {
          expect(tree.remove(i), isTrue);
        }
        expect(tree.isEmpty, isTrue);
        expect(tree.length, equals(0));
      });

      test('should maintain sorted order after removals', () {
        tree.remove(5);
        tree.remove(2);
        tree.remove(8);
        final keys = tree.keys.toList();
        expect(keys, equals([1, 3, 4, 6, 7, 9, 10]));
      });

      test('should handle removal causing merges', () {
        // Remove enough elements to trigger merges
        for (var i = 1; i <= 8; i++) {
          tree.remove(i);
          // Verify remaining elements are still accessible
          for (var j = i + 1; j <= 10; j++) {
            expect(tree.contains(j), isTrue,
                reason: 'Key $j should exist after removing $i');
          }
        }
      });

      test('should remove internal node keys correctly', () {
        // Create a tree with enough elements to have internal nodes
        final bigTree = BTree<int, String>(3);
        for (var i = 1; i <= 30; i++) {
          bigTree.insert(i, 'value$i');
        }
        // Remove some elements that might be in internal nodes
        bigTree.remove(15);
        bigTree.remove(10);
        bigTree.remove(20);

        expect(bigTree.contains(15), isFalse);
        expect(bigTree.contains(10), isFalse);
        expect(bigTree.contains(20), isFalse);
        expect(bigTree.length, equals(27));
      });
    });

    group('inOrder traversal', () {
      test('should return elements in sorted order', () {
        tree.insert(5, 'five');
        tree.insert(3, 'three');
        tree.insert(7, 'seven');
        tree.insert(1, 'one');
        tree.insert(9, 'nine');

        final entries = tree.inOrder.toList();
        expect(entries.map((e) => e.key).toList(), equals([1, 3, 5, 7, 9]));
      });

      test('should iterate all entries with correct values', () {
        tree.insert(2, 'two');
        tree.insert(1, 'one');
        tree.insert(3, 'three');

        final entries = tree.inOrder.toList();
        expect(entries[0].key, equals(1));
        expect(entries[0].value, equals('one'));
        expect(entries[1].key, equals(2));
        expect(entries[1].value, equals('two'));
        expect(entries[2].key, equals(3));
        expect(entries[2].value, equals('three'));
      });
    });

    group('keys and values properties', () {
      setUp(() {
        tree.insert(3, 'three');
        tree.insert(1, 'one');
        tree.insert(2, 'two');
      });

      test('keys returns all keys in sorted order', () {
        expect(tree.keys.toList(), equals([1, 2, 3]));
      });

      test('values returns all values in key order', () {
        expect(tree.values.toList(), equals(['one', 'two', 'three']));
      });
    });

    group('properties', () {
      test('height increases with more elements', () {
        expect(tree.height, equals(0));
        tree.insert(1, 'one');
        expect(tree.height, equals(1));

        // Add enough elements to increase height
        for (var i = 2; i <= 20; i++) {
          tree.insert(i, 'value$i');
        }
        expect(tree.height, greaterThan(1));
      });

      test('minDegree enforces minimum of 2', () {
        final tree1 = BTree<int, String>(1);
        expect(tree1.minDegree, equals(2));

        final tree0 = BTree<int, String>(0);
        expect(tree0.minDegree, equals(2));

        final treeNeg = BTree<int, String>(-5);
        expect(treeNeg.minDegree, equals(2));
      });
    });

    group('clear', () {
      test('should remove all elements', () {
        for (var i = 1; i <= 10; i++) {
          tree.insert(i, 'value$i');
        }
        tree.clear();
        expect(tree.isEmpty, isTrue);
        expect(tree.length, equals(0));
        expect(tree.root, isNull);
        expect(tree.height, equals(0));
      });
    });

    group('different minimum degrees', () {
      test('should work with minDegree=2', () {
        final t2 = BTree<int, String>(2);
        for (var i = 1; i <= 20; i++) {
          t2.insert(i, 'v$i');
        }
        expect(t2.length, equals(20));
        expect(t2.keys.toList(), equals(List.generate(20, (i) => i + 1)));
      });

      test('should work with minDegree=3', () {
        final t3 = BTree<int, String>(3);
        for (var i = 1; i <= 30; i++) {
          t3.insert(i, 'v$i');
        }
        expect(t3.length, equals(30));
        expect(t3.keys.toList(), equals(List.generate(30, (i) => i + 1)));
      });

      test('should work with minDegree=5', () {
        final t5 = BTree<int, String>(5);
        for (var i = 1; i <= 50; i++) {
          t5.insert(i, 'v$i');
        }
        expect(t5.length, equals(50));
        expect(t5.keys.toList(), equals(List.generate(50, (i) => i + 1)));
      });

      test('higher minDegree should result in lower height', () {
        final t2 = BTree<int, String>(2);
        final t5 = BTree<int, String>(5);

        for (var i = 1; i <= 100; i++) {
          t2.insert(i, 'v$i');
          t5.insert(i, 'v$i');
        }

        expect(t5.height, lessThanOrEqualTo(t2.height));
      });
    });

    group('large data sets', () {
      test('should handle 100+ insertions', () {
        for (var i = 1; i <= 150; i++) {
          tree.insert(i, 'value$i');
        }
        expect(tree.length, equals(150));
        for (var i = 1; i <= 150; i++) {
          expect(tree.contains(i), isTrue);
          expect(tree.search(i), equals('value$i'));
        }
      });

      test('should handle 100+ insertions in reverse', () {
        for (var i = 150; i >= 1; i--) {
          tree.insert(i, 'value$i');
        }
        expect(tree.length, equals(150));
        expect(tree.keys.toList(), equals(List.generate(150, (i) => i + 1)));
      });

      test('should handle 100+ random insertions and deletions', () {
        final random = Random(123);
        final inserted = <int>[];

        // Insert 150 random keys
        for (var i = 0; i < 150; i++) {
          final key = random.nextInt(1000);
          if (!tree.contains(key)) {
            tree.insert(key, 'v$key');
            inserted.add(key);
          }
        }

        // Remove half
        final toRemove = inserted.take(inserted.length ~/ 2).toList();
        for (final key in toRemove) {
          expect(tree.remove(key), isTrue);
          inserted.remove(key);
        }

        // Verify remaining
        for (final key in inserted) {
          expect(tree.contains(key), isTrue);
        }
        expect(tree.length, equals(inserted.length));
      });
    });

    group('edge cases', () {
      test('single element tree', () {
        tree.insert(42, 'answer');
        expect(tree.length, equals(1));
        expect(tree.height, equals(1));
        expect(tree.search(42), equals('answer'));
        expect(tree.remove(42), isTrue);
        expect(tree.isEmpty, isTrue);
      });

      test('sequential inserts', () {
        for (var i = 1; i <= 20; i++) {
          tree.insert(i, 'v$i');
        }
        expect(tree.keys.toList(), equals(List.generate(20, (i) => i + 1)));
      });

      test('reverse inserts', () {
        for (var i = 20; i >= 1; i--) {
          tree.insert(i, 'v$i');
        }
        expect(tree.keys.toList(), equals(List.generate(20, (i) => i + 1)));
      });

      test('alternating inserts', () {
        for (var i = 0; i < 10; i++) {
          tree.insert(i, 'v$i');
          tree.insert(20 - i, 'v${20 - i}');
        }
        final keys = tree.keys.toList();
        final sortedKeys = List<int>.from(keys)..sort();
        expect(keys, equals(sortedKeys));
      });

      test('toString on empty tree', () {
        expect(tree.toString(), contains('empty'));
      });

      test('toString on non-empty tree', () {
        tree.insert(1, 'one');
        tree.insert(2, 'two');
        final str = tree.toString();
        expect(str, contains('BTree'));
        expect(str, contains('1'));
        expect(str, contains('2'));
      });
    });
  });

  group('BPlusTree', () {
    late BPlusTree<int, String> tree;

    setUp(() {
      tree = BPlusTree<int, String>();
    });

    group('empty tree operations', () {
      test('should start empty', () {
        expect(tree.isEmpty, isTrue);
        expect(tree.isNotEmpty, isFalse);
        expect(tree.length, equals(0));
        expect(tree.height, equals(0));
      });

      test('should have default minDegree of 2', () {
        expect(tree.minDegree, equals(2));
      });

      test('search on empty tree returns null', () {
        expect(tree.search(1), isNull);
        expect(tree.get(1), isNull);
        expect(tree[1], isNull);
      });

      test('contains on empty tree returns false', () {
        expect(tree.contains(1), isFalse);
      });

      test('remove on empty tree returns false', () {
        expect(tree.remove(1), isFalse);
      });

      test('inOrder on empty tree returns empty iterable', () {
        expect(tree.inOrder.toList(), isEmpty);
      });

      test('keys and values on empty tree are empty', () {
        expect(tree.keys.toList(), isEmpty);
        expect(tree.values.toList(), isEmpty);
      });

      test('getFirst on empty tree throws StateError', () {
        expect(() => tree.getFirst(), throwsStateError);
      });

      test('getLast on empty tree throws StateError', () {
        expect(() => tree.getLast(), throwsStateError);
      });

      test('range on empty tree returns empty iterable', () {
        expect(tree.range(1, 10).toList(), isEmpty);
      });
    });

    group('insert operations', () {
      test('should insert single element', () {
        tree.insert(5, 'five');
        expect(tree.length, equals(1));
        expect(tree.isEmpty, isFalse);
        expect(tree.search(5), equals('five'));
      });

      test('should insert multiple elements', () {
        tree.insert(5, 'five');
        tree.insert(3, 'three');
        tree.insert(7, 'seven');
        expect(tree.length, equals(3));
        expect(tree.search(5), equals('five'));
        expect(tree.search(3), equals('three'));
        expect(tree.search(7), equals('seven'));
      });

      test('should update value on duplicate key insert', () {
        tree.insert(5, 'five');
        tree.insert(5, 'FIVE');
        expect(tree.length, equals(1));
        expect(tree.search(5), equals('FIVE'));
      });

      test('should cause node splits on many inserts', () {
        for (var i = 1; i <= 10; i++) {
          tree.insert(i, 'value$i');
        }
        expect(tree.length, equals(10));
        expect(tree.height, greaterThan(1));
        for (var i = 1; i <= 10; i++) {
          expect(tree.search(i), equals('value$i'));
        }
      });

      test('should handle reverse order inserts', () {
        for (var i = 10; i >= 1; i--) {
          tree.insert(i, 'value$i');
        }
        expect(tree.length, equals(10));
        expect(tree.keys.toList(), equals([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
      });

      test('should handle random inserts', () {
        final random = Random(42);
        final inserted = <int>{};
        for (var i = 0; i < 50; i++) {
          final key = random.nextInt(100);
          if (inserted.add(key)) {
            tree.insert(key, 'value$key');
          }
        }
        expect(tree.length, equals(inserted.length));
        for (final key in inserted) {
          expect(tree.contains(key), isTrue);
        }
      });
    });

    group('search operations', () {
      setUp(() {
        tree.insert(5, 'five');
        tree.insert(3, 'three');
        tree.insert(7, 'seven');
        tree.insert(1, 'one');
        tree.insert(9, 'nine');
      });

      test('search finds existing keys', () {
        expect(tree.search(5), equals('five'));
        expect(tree.search(3), equals('three'));
        expect(tree.search(7), equals('seven'));
      });

      test('search returns null for non-existent keys', () {
        expect(tree.search(2), isNull);
        expect(tree.search(100), isNull);
      });

      test('get works same as search', () {
        expect(tree.get(5), equals('five'));
        expect(tree.get(2), isNull);
      });

      test('operator[] works same as search', () {
        expect(tree[5], equals('five'));
        expect(tree[2], isNull);
      });

      test('contains returns true for existing keys', () {
        expect(tree.contains(5), isTrue);
        expect(tree.contains(1), isTrue);
        expect(tree.contains(9), isTrue);
      });

      test('contains returns false for non-existent keys', () {
        expect(tree.contains(2), isFalse);
        expect(tree.contains(100), isFalse);
      });
    });

    group('getFirst and getLast', () {
      test('getFirst returns minimum key-value pair', () {
        tree.insert(5, 'five');
        tree.insert(3, 'three');
        tree.insert(7, 'seven');
        tree.insert(1, 'one');

        final first = tree.getFirst();
        expect(first.key, equals(1));
        expect(first.value, equals('one'));
      });

      test('getLast returns maximum key-value pair', () {
        tree.insert(5, 'five');
        tree.insert(3, 'three');
        tree.insert(7, 'seven');
        tree.insert(1, 'one');

        final last = tree.getLast();
        expect(last.key, equals(7));
        expect(last.value, equals('seven'));
      });

      test('getFirst and getLast work on single element', () {
        tree.insert(42, 'answer');

        final first = tree.getFirst();
        final last = tree.getLast();
        expect(first.key, equals(42));
        expect(last.key, equals(42));
      });
    });

    group('range queries', () {
      setUp(() {
        for (var i = 1; i <= 20; i++) {
          tree.insert(i, 'value$i');
        }
      });

      test('range returns elements in range inclusive', () {
        final result = tree.range(5, 10).toList();
        expect(result.length, equals(6));
        expect(result.map((e) => e.key).toList(), equals([5, 6, 7, 8, 9, 10]));
      });

      test('range with same start and end returns single element', () {
        final result = tree.range(5, 5).toList();
        expect(result.length, equals(1));
        expect(result.first.key, equals(5));
      });

      test('range returns empty when no elements in range', () {
        final result = tree.range(25, 30).toList();
        expect(result, isEmpty);
      });

      test('range with start > end returns empty', () {
        final result = tree.range(10, 5).toList();
        expect(result, isEmpty);
      });

      test('range at boundaries', () {
        final result = tree.range(1, 20).toList();
        expect(result.length, equals(20));
      });

      test('range partial overlap at start', () {
        final result = tree.range(-5, 5).toList();
        expect(result.length, equals(5));
        expect(result.first.key, equals(1));
      });

      test('range partial overlap at end', () {
        final result = tree.range(15, 25).toList();
        expect(result.length, equals(6));
        expect(result.last.key, equals(20));
      });
    });

    group('remove operations', () {
      setUp(() {
        for (var i = 1; i <= 10; i++) {
          tree.insert(i, 'value$i');
        }
      });

      test('should remove existing key', () {
        expect(tree.remove(5), isTrue);
        expect(tree.contains(5), isFalse);
        expect(tree.length, equals(9));
      });

      test('should return false when removing non-existent key', () {
        expect(tree.remove(100), isFalse);
        expect(tree.length, equals(10));
      });

      test('should remove all elements', () {
        for (var i = 1; i <= 10; i++) {
          expect(tree.remove(i), isTrue);
        }
        expect(tree.isEmpty, isTrue);
      });

      test('should maintain sorted order after removals', () {
        tree.remove(5);
        tree.remove(2);
        tree.remove(8);
        final keys = tree.keys.toList();
        expect(keys, equals([1, 3, 4, 6, 7, 9, 10]));
      });

      test('should update first/last after removing extremes', () {
        tree.remove(1);
        expect(tree.getFirst().key, equals(2));

        tree.remove(10);
        expect(tree.getLast().key, equals(9));
      });

      test('should handle removal causing underflow', () {
        for (var i = 1; i <= 8; i++) {
          tree.remove(i);
          for (var j = i + 1; j <= 10; j++) {
            expect(tree.contains(j), isTrue,
                reason: 'Key $j should exist after removing $i');
          }
        }
      });
    });

    group('linked leaf traversal', () {
      test('should traverse leaves in order via inOrder', () {
        for (var i = 1; i <= 20; i++) {
          tree.insert(i, 'value$i');
        }

        final keys = tree.inOrder.map((e) => e.key).toList();
        expect(keys, equals(List.generate(20, (i) => i + 1)));
      });

      test('keys returns all keys via leaf links', () {
        for (var i = 10; i >= 1; i--) {
          tree.insert(i, 'value$i');
        }
        expect(tree.keys.toList(), equals(List.generate(10, (i) => i + 1)));
      });

      test('values returns all values in key order via leaf links', () {
        tree.insert(3, 'three');
        tree.insert(1, 'one');
        tree.insert(2, 'two');
        expect(tree.values.toList(), equals(['one', 'two', 'three']));
      });
    });

    group('verify all values are in leaves', () {
      test('all inserted values retrievable after many inserts', () {
        for (var i = 1; i <= 50; i++) {
          tree.insert(i, 'value$i');
        }

        // All values should be in leaves (accessible via inOrder)
        final entries = tree.inOrder.toList();
        expect(entries.length, equals(50));
        for (var i = 0; i < 50; i++) {
          expect(entries[i].key, equals(i + 1));
          expect(entries[i].value, equals('value${i + 1}'));
        }
      });

      test('range query iterates through linked leaves', () {
        for (var i = 1; i <= 30; i++) {
          tree.insert(i, 'v$i');
        }

        // Range should traverse linked leaves
        final rangeResult = tree.range(10, 20).toList();
        expect(rangeResult.length, equals(11));
        for (var i = 0; i < 11; i++) {
          expect(rangeResult[i].key, equals(10 + i));
        }
      });
    });

    group('properties', () {
      test('height increases with more elements', () {
        expect(tree.height, equals(0));
        tree.insert(1, 'one');
        expect(tree.height, equals(1));

        for (var i = 2; i <= 20; i++) {
          tree.insert(i, 'value$i');
        }
        expect(tree.height, greaterThan(1));
      });

      test('minDegree enforces minimum of 2', () {
        final tree1 = BPlusTree<int, String>(1);
        expect(tree1.minDegree, equals(2));

        final tree0 = BPlusTree<int, String>(0);
        expect(tree0.minDegree, equals(2));
      });
    });

    group('clear', () {
      test('should remove all elements', () {
        for (var i = 1; i <= 10; i++) {
          tree.insert(i, 'value$i');
        }
        tree.clear();
        expect(tree.isEmpty, isTrue);
        expect(tree.length, equals(0));
        expect(tree.height, equals(0));
      });

      test('clear resets first and last leaf pointers', () {
        tree.insert(1, 'one');
        tree.insert(2, 'two');
        tree.clear();

        expect(() => tree.getFirst(), throwsStateError);
        expect(() => tree.getLast(), throwsStateError);
      });
    });

    group('different minimum degrees', () {
      test('should work with minDegree=2', () {
        final t2 = BPlusTree<int, String>(2);
        for (var i = 1; i <= 20; i++) {
          t2.insert(i, 'v$i');
        }
        expect(t2.length, equals(20));
        expect(t2.keys.toList(), equals(List.generate(20, (i) => i + 1)));
      });

      test('should work with minDegree=3', () {
        final t3 = BPlusTree<int, String>(3);
        for (var i = 1; i <= 30; i++) {
          t3.insert(i, 'v$i');
        }
        expect(t3.length, equals(30));
        expect(t3.keys.toList(), equals(List.generate(30, (i) => i + 1)));
      });

      test('should work with minDegree=5', () {
        final t5 = BPlusTree<int, String>(5);
        for (var i = 1; i <= 50; i++) {
          t5.insert(i, 'v$i');
        }
        expect(t5.length, equals(50));
        expect(t5.keys.toList(), equals(List.generate(50, (i) => i + 1)));
      });

      test('higher minDegree should result in lower height', () {
        final t2 = BPlusTree<int, String>(2);
        final t5 = BPlusTree<int, String>(5);

        for (var i = 1; i <= 100; i++) {
          t2.insert(i, 'v$i');
          t5.insert(i, 'v$i');
        }

        expect(t5.height, lessThanOrEqualTo(t2.height));
      });
    });

    group('large data sets', () {
      test('should handle 100+ insertions', () {
        for (var i = 1; i <= 150; i++) {
          tree.insert(i, 'value$i');
        }
        expect(tree.length, equals(150));
        for (var i = 1; i <= 150; i++) {
          expect(tree.contains(i), isTrue);
          expect(tree.search(i), equals('value$i'));
        }
      });

      test('should handle 100+ insertions in reverse', () {
        for (var i = 150; i >= 1; i--) {
          tree.insert(i, 'value$i');
        }
        expect(tree.length, equals(150));
        expect(tree.keys.toList(), equals(List.generate(150, (i) => i + 1)));
      });

      test('should handle 100+ random insertions and deletions', () {
        final random = Random(123);
        final inserted = <int>[];

        for (var i = 0; i < 150; i++) {
          final key = random.nextInt(1000);
          if (!tree.contains(key)) {
            tree.insert(key, 'v$key');
            inserted.add(key);
          }
        }

        final toRemove = inserted.take(inserted.length ~/ 2).toList();
        for (final key in toRemove) {
          expect(tree.remove(key), isTrue);
          inserted.remove(key);
        }

        for (final key in inserted) {
          expect(tree.contains(key), isTrue);
        }
        expect(tree.length, equals(inserted.length));
      });

      test('range queries work correctly on large datasets', () {
        for (var i = 1; i <= 200; i++) {
          tree.insert(i, 'v$i');
        }

        final range1 = tree.range(50, 100).toList();
        expect(range1.length, equals(51));

        final range2 = tree.range(1, 200).toList();
        expect(range2.length, equals(200));

        final range3 = tree.range(150, 175).toList();
        expect(range3.length, equals(26));
      });
    });

    group('edge cases', () {
      test('single element tree', () {
        tree.insert(42, 'answer');
        expect(tree.length, equals(1));
        expect(tree.height, equals(1));
        expect(tree.search(42), equals('answer'));
        expect(tree.getFirst().key, equals(42));
        expect(tree.getLast().key, equals(42));
        expect(tree.remove(42), isTrue);
        expect(tree.isEmpty, isTrue);
      });

      test('sequential inserts', () {
        for (var i = 1; i <= 20; i++) {
          tree.insert(i, 'v$i');
        }
        expect(tree.keys.toList(), equals(List.generate(20, (i) => i + 1)));
      });

      test('reverse inserts', () {
        for (var i = 20; i >= 1; i--) {
          tree.insert(i, 'v$i');
        }
        expect(tree.keys.toList(), equals(List.generate(20, (i) => i + 1)));
      });

      test('alternating inserts', () {
        for (var i = 0; i < 10; i++) {
          tree.insert(i, 'v$i');
          tree.insert(20 - i, 'v${20 - i}');
        }
        final keys = tree.keys.toList();
        final sortedKeys = List<int>.from(keys)..sort();
        expect(keys, equals(sortedKeys));
      });

      test('toString on empty tree', () {
        expect(tree.toString(), contains('empty'));
      });

      test('toString on non-empty tree', () {
        tree.insert(1, 'one');
        tree.insert(2, 'two');
        final str = tree.toString();
        expect(str, contains('BPlusTree'));
        expect(str, contains('1'));
        expect(str, contains('2'));
      });

      test('toList returns entries', () {
        tree.insert(2, 'two');
        tree.insert(1, 'one');
        tree.insert(3, 'three');

        final list = tree.toList();
        expect(list.length, equals(3));
        expect(list[0].key, equals(1));
        expect(list[1].key, equals(2));
        expect(list[2].key, equals(3));
      });
    });
  });
}
