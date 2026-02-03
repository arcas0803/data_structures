import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('UnionFind<T>', () {
    late UnionFind<String> uf;

    setUp(() {
      uf = UnionFind<String>();
    });

    group('empty structure operations', () {
      test('should start empty', () {
        expect(uf.setCount, equals(0));
        expect(uf.elementCount, equals(0));
      });

      test('should return empty allSets', () {
        expect(uf.allSets, isEmpty);
      });

      test('should throw on find non-existent element', () {
        expect(() => uf.find('nonexistent'), throwsStateError);
      });

      test('should throw on union with non-existent elements', () {
        uf.makeSet('a');
        expect(() => uf.union('a', 'nonexistent'), throwsStateError);
        expect(() => uf.union('nonexistent', 'a'), throwsStateError);
      });

      test('should throw on connected with non-existent elements', () {
        uf.makeSet('a');
        expect(() => uf.connected('a', 'nonexistent'), throwsStateError);
      });

      test('should throw on getSetSize for non-existent element', () {
        expect(() => uf.getSetSize('nonexistent'), throwsStateError);
      });

      test('should throw on getSet for non-existent element', () {
        expect(() => uf.getSet('nonexistent'), throwsStateError);
      });
    });

    group('makeSet/add', () {
      test('should add single element', () {
        uf.makeSet('a');
        expect(uf.setCount, equals(1));
        expect(uf.elementCount, equals(1));
        expect(uf.contains('a'), isTrue);
      });

      test('should add multiple elements', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        expect(uf.setCount, equals(3));
        expect(uf.elementCount, equals(3));
      });

      test('add should be alias for makeSet', () {
        uf.add('x');
        expect(uf.contains('x'), isTrue);
        expect(uf.setCount, equals(1));
      });

      test('should ignore duplicate makeSet', () {
        uf.makeSet('a');
        uf.makeSet('a');
        expect(uf.setCount, equals(1));
        expect(uf.elementCount, equals(1));
      });

      test('should create from iterable', () {
        final uf2 = UnionFind.from(['a', 'b', 'c', 'd']);
        expect(uf2.setCount, equals(4));
        expect(uf2.elementCount, equals(4));
      });

      test('should handle from with duplicates', () {
        final uf2 = UnionFind.from(['a', 'b', 'a', 'c']);
        expect(uf2.elementCount, equals(3));
      });
    });

    group('find with path compression', () {
      test('should find root of single element', () {
        uf.makeSet('a');
        expect(uf.find('a'), equals('a'));
      });

      test('should find root after union', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.union('a', 'b');
        final rootA = uf.find('a');
        final rootB = uf.find('b');
        expect(rootA, equals(rootB));
      });

      test('should compress path on find', () {
        // Create a chain: a -> b -> c -> d
        final ufInt = UnionFind<int>();
        for (var i = 0; i < 10; i++) {
          ufInt.makeSet(i);
        }
        // Build a long chain by sequential unions
        for (var i = 1; i < 10; i++) {
          ufInt.union(i - 1, i);
        }
        // After find, all should point directly to root
        final root = ufInt.find(0);
        // All elements should now find the same root efficiently
        for (var i = 0; i < 10; i++) {
          expect(ufInt.find(i), equals(root));
        }
      });
    });

    group('union with union by rank', () {
      test('should merge two sets', () {
        uf.makeSet('a');
        uf.makeSet('b');
        expect(uf.union('a', 'b'), isTrue);
        expect(uf.setCount, equals(1));
        expect(uf.connected('a', 'b'), isTrue);
      });

      test('should return false for same set', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.union('a', 'b');
        expect(uf.union('a', 'b'), isFalse);
      });

      test('should merge multiple sets correctly', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        uf.makeSet('d');

        uf.union('a', 'b');
        uf.union('c', 'd');
        expect(uf.setCount, equals(2));

        uf.union('a', 'c');
        expect(uf.setCount, equals(1));
        expect(uf.connected('a', 'd'), isTrue);
      });

      test('should use union by rank for balanced trees', () {
        // Create two equal-sized sets and union them
        final ufInt = UnionFind<int>();
        for (var i = 0; i < 8; i++) {
          ufInt.makeSet(i);
        }
        // Set 1: {0, 1, 2, 3}
        ufInt.union(0, 1);
        ufInt.union(2, 3);
        ufInt.union(0, 2);

        // Set 2: {4, 5, 6, 7}
        ufInt.union(4, 5);
        ufInt.union(6, 7);
        ufInt.union(4, 6);

        expect(ufInt.setCount, equals(2));

        // Union the two sets
        ufInt.union(0, 4);
        expect(ufInt.setCount, equals(1));
        expect(ufInt.getSetSize(0), equals(8));
      });
    });

    group('connected', () {
      test('should return true for same element', () {
        uf.makeSet('a');
        expect(uf.connected('a', 'a'), isTrue);
      });

      test('should return false for different sets', () {
        uf.makeSet('a');
        uf.makeSet('b');
        expect(uf.connected('a', 'b'), isFalse);
      });

      test('should return true after union', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.union('a', 'b');
        expect(uf.connected('a', 'b'), isTrue);
      });

      test('should be transitive', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        uf.union('a', 'b');
        uf.union('b', 'c');
        expect(uf.connected('a', 'c'), isTrue);
      });
    });

    group('contains', () {
      test('should return false for non-existent element', () {
        expect(uf.contains('x'), isFalse);
      });

      test('should return true after makeSet', () {
        uf.makeSet('x');
        expect(uf.contains('x'), isTrue);
      });

      test('should return true for elements after union', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.union('a', 'b');
        expect(uf.contains('a'), isTrue);
        expect(uf.contains('b'), isTrue);
      });
    });

    group('setCount and elementCount', () {
      test('should track set count correctly', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        expect(uf.setCount, equals(3));

        uf.union('a', 'b');
        expect(uf.setCount, equals(2));

        uf.union('b', 'c');
        expect(uf.setCount, equals(1));
      });

      test('should not change setCount for redundant union', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.union('a', 'b');
        uf.union('a', 'b');
        expect(uf.setCount, equals(1));
      });

      test('should track element count correctly', () {
        uf.makeSet('a');
        expect(uf.elementCount, equals(1));
        uf.makeSet('b');
        expect(uf.elementCount, equals(2));
        uf.union('a', 'b');
        expect(
            uf.elementCount, equals(2)); // Union doesn't change element count
      });
    });

    group('getSetSize', () {
      test('should return 1 for single element set', () {
        uf.makeSet('a');
        expect(uf.getSetSize('a'), equals(1));
      });

      test('should return correct size after union', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        uf.union('a', 'b');
        expect(uf.getSetSize('a'), equals(2));
        expect(uf.getSetSize('b'), equals(2));
        expect(uf.getSetSize('c'), equals(1));
      });

      test('should update size on multiple unions', () {
        for (var i = 0; i < 5; i++) {
          uf.makeSet('e$i');
        }
        uf.union('e0', 'e1');
        uf.union('e0', 'e2');
        uf.union('e0', 'e3');
        uf.union('e0', 'e4');
        expect(uf.getSetSize('e0'), equals(5));
        expect(uf.getSetSize('e4'), equals(5));
      });
    });

    group('getSet', () {
      test('should return set with single element', () {
        uf.makeSet('a');
        expect(uf.getSet('a'), equals({'a'}));
      });

      test('should return all elements in set after union', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        uf.union('a', 'b');
        uf.union('b', 'c');

        final set = uf.getSet('a');
        expect(set, equals({'a', 'b', 'c'}));
      });

      test('should return same set for any element in set', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        uf.union('a', 'b');
        uf.union('b', 'c');

        expect(uf.getSet('a'), equals(uf.getSet('b')));
        expect(uf.getSet('b'), equals(uf.getSet('c')));
      });
    });

    group('allSets', () {
      test('should return empty list for empty structure', () {
        expect(uf.allSets, isEmpty);
      });

      test('should return singleton sets', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');

        final sets = uf.allSets;
        expect(sets.length, equals(3));
        expect(sets.any((s) => s.contains('a')), isTrue);
        expect(sets.any((s) => s.contains('b')), isTrue);
        expect(sets.any((s) => s.contains('c')), isTrue);
      });

      test('should return correct sets after unions', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        uf.makeSet('d');
        uf.union('a', 'b');
        uf.union('c', 'd');

        final sets = uf.allSets;
        expect(sets.length, equals(2));

        final setAB = sets.firstWhere((s) => s.contains('a'));
        final setCD = sets.firstWhere((s) => s.contains('c'));
        expect(setAB, equals({'a', 'b'}));
        expect(setCD, equals({'c', 'd'}));
      });
    });

    group('clear', () {
      test('should clear all elements', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.union('a', 'b');

        uf.clear();

        expect(uf.setCount, equals(0));
        expect(uf.elementCount, equals(0));
        expect(uf.allSets, isEmpty);
        expect(uf.contains('a'), isFalse);
      });

      test('should allow reuse after clear', () {
        uf.makeSet('a');
        uf.clear();
        uf.makeSet('x');
        expect(uf.contains('x'), isTrue);
        expect(uf.setCount, equals(1));
      });
    });

    group('edge cases', () {
      test('self-union should return false', () {
        uf.makeSet('a');
        expect(uf.union('a', 'a'), isFalse);
        expect(uf.setCount, equals(1));
      });

      test('union already connected elements', () {
        uf.makeSet('a');
        uf.makeSet('b');
        uf.makeSet('c');
        uf.union('a', 'b');
        uf.union('b', 'c');

        expect(uf.union('a', 'c'), isFalse);
        expect(uf.setCount, equals(1));
      });

      test('long chains should compress paths', () {
        // Create a long chain of 100 elements
        final ufLarge = UnionFind<int>();
        for (var i = 0; i < 100; i++) {
          ufLarge.makeSet(i);
        }
        for (var i = 1; i < 100; i++) {
          ufLarge.union(i - 1, i);
        }

        // After path compression, all finds should be fast
        final root = ufLarge.find(0);
        for (var i = 0; i < 100; i++) {
          expect(ufLarge.find(i), equals(root));
        }
        expect(ufLarge.setCount, equals(1));
        expect(ufLarge.getSetSize(50), equals(100));
      });

      test('many small sets vs few large sets', () {
        // Many small sets (50 pairs)
        final ufSmall = UnionFind<int>();
        for (var i = 0; i < 100; i++) {
          ufSmall.makeSet(i);
        }
        for (var i = 0; i < 100; i += 2) {
          ufSmall.union(i, i + 1);
        }
        expect(ufSmall.setCount, equals(50));

        // Few large sets (2 sets of 50)
        final ufLarge = UnionFind<int>();
        for (var i = 0; i < 100; i++) {
          ufLarge.makeSet(i);
        }
        for (var i = 1; i < 50; i++) {
          ufLarge.union(0, i);
        }
        for (var i = 51; i < 100; i++) {
          ufLarge.union(50, i);
        }
        expect(ufLarge.setCount, equals(2));
        expect(ufLarge.getSetSize(0), equals(50));
        expect(ufLarge.getSetSize(50), equals(50));
      });
    });

    group('toString', () {
      test('should show empty for empty structure', () {
        expect(uf.toString(), equals('UnionFind: {}'));
      });

      test('should show sets', () {
        uf.makeSet('a');
        uf.makeSet('b');
        final str = uf.toString();
        expect(str, startsWith('UnionFind: ['));
        expect(str, contains('a'));
        expect(str, contains('b'));
      });
    });
  });

  group('UnionFindInt', () {
    late UnionFindInt uf;

    setUp(() {
      uf = UnionFindInt(10);
    });

    group('constructor', () {
      test('should create with specified size', () {
        expect(uf.length, equals(10));
        expect(uf.setCount, equals(10));
      });

      test('should create empty with size 0', () {
        final empty = UnionFindInt(0);
        expect(empty.length, equals(0));
        expect(empty.setCount, equals(0));
      });

      test('should throw for negative size', () {
        expect(() => UnionFindInt(-1), throwsArgumentError);
      });

      test('should initialize each element in its own set', () {
        for (var i = 0; i < 10; i++) {
          expect(uf.find(i), equals(i));
        }
      });
    });

    group('find with path compression', () {
      test('should find self for initial elements', () {
        expect(uf.find(0), equals(0));
        expect(uf.find(5), equals(5));
      });

      test('should throw for out of bounds', () {
        expect(() => uf.find(-1), throwsRangeError);
        expect(() => uf.find(10), throwsRangeError);
      });

      test('should find root after union', () {
        uf.union(0, 1);
        expect(uf.find(0), equals(uf.find(1)));
      });

      test('should compress long paths', () {
        // Create chain: 0 <- 1 <- 2 <- 3 <- 4 <- 5
        for (var i = 1; i < 6; i++) {
          uf.union(i - 1, i);
        }
        // All should have same root after compression
        final root = uf.find(0);
        for (var i = 0; i < 6; i++) {
          expect(uf.find(i), equals(root));
        }
      });
    });

    group('union with union by rank', () {
      test('should merge two elements', () {
        expect(uf.union(0, 1), isTrue);
        expect(uf.setCount, equals(9));
        expect(uf.connected(0, 1), isTrue);
      });

      test('should return false for already connected', () {
        uf.union(0, 1);
        expect(uf.union(0, 1), isFalse);
        expect(uf.union(1, 0), isFalse);
      });

      test('should merge multiple sets', () {
        uf.union(0, 1);
        uf.union(2, 3);
        uf.union(0, 2);
        expect(uf.setCount, equals(7));
        expect(uf.connected(0, 3), isTrue);
        expect(uf.connected(1, 2), isTrue);
      });

      test('should balance by rank', () {
        // Create two trees and merge
        uf.union(0, 1);
        uf.union(2, 3);
        uf.union(4, 5);
        uf.union(6, 7);

        uf.union(0, 2);
        uf.union(4, 6);

        uf.union(0, 4);
        expect(uf.setCount, equals(3)); // {0,1,2,3,4,5,6,7}, {8}, {9}
        expect(uf.getSetSize(0), equals(8));
      });
    });

    group('connected', () {
      test('should return true for same element', () {
        expect(uf.connected(5, 5), isTrue);
      });

      test('should return false for different sets', () {
        expect(uf.connected(0, 9), isFalse);
      });

      test('should return true after transitive union', () {
        uf.union(0, 1);
        uf.union(1, 2);
        uf.union(2, 3);
        expect(uf.connected(0, 3), isTrue);
      });
    });

    group('getSetSize', () {
      test('should return 1 for singleton', () {
        expect(uf.getSetSize(5), equals(1));
      });

      test('should return correct size after unions', () {
        uf.union(0, 1);
        uf.union(0, 2);
        uf.union(0, 3);
        expect(uf.getSetSize(0), equals(4));
        expect(uf.getSetSize(1), equals(4));
        expect(uf.getSetSize(2), equals(4));
        expect(uf.getSetSize(3), equals(4));
      });
    });

    group('getSet', () {
      test('should return singleton set', () {
        expect(uf.getSet(5), equals({5}));
      });

      test('should return all elements after union', () {
        uf.union(0, 1);
        uf.union(0, 2);
        expect(uf.getSet(0), equals({0, 1, 2}));
        expect(uf.getSet(1), equals({0, 1, 2}));
      });
    });

    group('allSets', () {
      test('should return all singleton sets initially', () {
        final sets = uf.allSets;
        expect(sets.length, equals(10));
      });

      test('should return correct sets after unions', () {
        uf.union(0, 1);
        uf.union(2, 3);
        uf.union(0, 2);

        final sets = uf.allSets;
        expect(sets.length, equals(7)); // 1 set of 4 + 6 singletons

        final largeSet = sets.firstWhere((s) => s.length == 4);
        expect(largeSet, equals({0, 1, 2, 3}));
      });
    });

    group('clear (reset)', () {
      test('should reset all elements to singletons', () {
        uf.union(0, 1);
        uf.union(2, 3);
        uf.union(0, 2);

        uf.clear();

        expect(uf.setCount, equals(10));
        expect(uf.connected(0, 1), isFalse);
        for (var i = 0; i < 10; i++) {
          expect(uf.find(i), equals(i));
        }
      });
    });

    group('edge cases', () {
      test('self-union should return false', () {
        expect(uf.union(5, 5), isFalse);
        expect(uf.setCount, equals(10));
      });

      test('should handle all elements in one set', () {
        for (var i = 1; i < 10; i++) {
          uf.union(0, i);
        }
        expect(uf.setCount, equals(1));
        expect(uf.getSetSize(0), equals(10));
      });

      test('single element structure', () {
        final single = UnionFindInt(1);
        expect(single.find(0), equals(0));
        expect(single.setCount, equals(1));
        expect(single.union(0, 0), isFalse);
      });
    });

    group('toString', () {
      test('should show empty for size 0', () {
        final empty = UnionFindInt(0);
        expect(empty.toString(), equals('UnionFindInt: {}'));
      });

      test('should show sets', () {
        uf.union(0, 1);
        final str = uf.toString();
        expect(str, startsWith('UnionFindInt: ['));
      });
    });
  });

  group('Use case: Kruskal\'s algorithm simulation', () {
    test('should find MST edges correctly', () {
      // Graph with 6 vertices and weighted edges
      // Vertices: 0, 1, 2, 3, 4, 5
      // Edges sorted by weight:
      final edges = [
        (0, 1, 1), // weight 1
        (1, 2, 2), // weight 2
        (0, 2, 3), // weight 3
        (2, 3, 3), // weight 3
        (3, 4, 4), // weight 4
        (1, 4, 5), // weight 5
        (4, 5, 5), // weight 5
        (3, 5, 6), // weight 6
      ];

      final uf = UnionFindInt(6);
      final mstEdges = <(int, int, int)>[];
      var mstWeight = 0;

      for (final (u, v, w) in edges) {
        if (!uf.connected(u, v)) {
          uf.union(u, v);
          mstEdges.add((u, v, w));
          mstWeight += w;
        }
      }

      // MST should have n-1 = 5 edges
      expect(mstEdges.length, equals(5));
      // MST weight: 1 + 2 + 3 + 4 + 5 = 15
      expect(mstWeight, equals(15));
      // All vertices should be connected
      expect(uf.setCount, equals(1));
      expect(uf.getSetSize(0), equals(6));

      // Verify MST edges
      expect(mstEdges[0], equals((0, 1, 1)));
      expect(mstEdges[1], equals((1, 2, 2)));
      expect(mstEdges[2], equals((2, 3, 3)));
      expect(mstEdges[3], equals((3, 4, 4)));
      expect(mstEdges[4], equals((4, 5, 5)));
    });

    test('should detect when graph becomes connected', () {
      final uf = UnionFindInt(5);

      // Add edges until connected
      uf.union(0, 1);
      expect(uf.setCount, equals(4));

      uf.union(2, 3);
      expect(uf.setCount, equals(3));

      uf.union(1, 2);
      expect(uf.setCount, equals(2));

      uf.union(3, 4);
      expect(uf.setCount, equals(1));

      // Graph is now connected
      for (var i = 0; i < 5; i++) {
        for (var j = i + 1; j < 5; j++) {
          expect(uf.connected(i, j), isTrue);
        }
      }
    });

    test('should work with generic UnionFind for string vertices', () {
      final uf = UnionFind<String>();
      final vertices = ['A', 'B', 'C', 'D', 'E'];
      for (final v in vertices) {
        uf.makeSet(v);
      }

      // Simulate adding MST edges
      final edges = [
        ('A', 'B'),
        ('B', 'C'),
        ('C', 'D'),
        ('D', 'E'),
      ];

      var edgesAdded = 0;
      for (final (u, v) in edges) {
        if (uf.union(u, v)) {
          edgesAdded++;
        }
      }

      expect(edgesAdded, equals(4));
      expect(uf.setCount, equals(1));
      expect(uf.getSet('A'), equals({'A', 'B', 'C', 'D', 'E'}));
    });
  });

  group('Performance comparison', () {
    test('UnionFindInt should handle large inputs', () {
      final n = 10000;
      final uf = UnionFindInt(n);

      // Perform many unions
      for (var i = 0; i < n - 1; i++) {
        uf.union(i, i + 1);
      }

      expect(uf.setCount, equals(1));
      expect(uf.getSetSize(0), equals(n));

      // Verify all connected (should be fast due to path compression)
      expect(uf.connected(0, n - 1), isTrue);
      expect(uf.connected(n ~/ 2, n - 1), isTrue);
    });

    test('UnionFind<int> should also handle large inputs', () {
      final n = 10000;
      final uf = UnionFind<int>.from(List.generate(n, (i) => i));

      for (var i = 0; i < n - 1; i++) {
        uf.union(i, i + 1);
      }

      expect(uf.setCount, equals(1));
      expect(uf.getSetSize(0), equals(n));
      expect(uf.connected(0, n - 1), isTrue);
    });

    test('random unions should work correctly', () {
      final uf = UnionFindInt(100);

      // Random-ish pattern of unions
      for (var i = 0; i < 50; i++) {
        uf.union(i * 2 % 100, (i * 3 + 7) % 100);
      }

      // All sets should be valid
      final sets = uf.allSets;
      var totalElements = 0;
      for (final s in sets) {
        totalElements += s.length;
        // Verify all elements in set are actually connected
        final elements = s.toList();
        for (var i = 1; i < elements.length; i++) {
          expect(uf.connected(elements[0], elements[i]), isTrue);
        }
      }
      expect(totalElements, equals(100));
    });
  });
}
