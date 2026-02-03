import 'dart:math';
import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('SegmentTree', () {
    group('empty tree', () {
      test('should handle empty data', () {
        final tree = SegmentTree<int>(
          [],
          combine: (a, b) => a + b,
          identity: 0,
        );
        expect(tree.length, equals(0));
      });

      test('query on empty tree returns identity', () {
        final tree = SegmentTree<int>(
          [],
          combine: (a, b) => a + b,
          identity: 0,
        );
        expect(tree.query(0, 0), equals(0));
      });
    });

    group('single element tree', () {
      late SegmentTree<num> tree;

      setUp(() {
        tree = SegmentTree.sum([42]);
      });

      test('should have length 1', () {
        expect(tree.length, equals(1));
      });

      test('should query single element', () {
        expect(tree.query(0, 0), equals(42));
      });

      test('should access element with operator[]', () {
        expect(tree[0], equals(42));
      });

      test('should update single element', () {
        tree.update(0, 100);
        expect(tree.query(0, 0), equals(100));
        expect(tree[0], equals(100));
      });
    });

    group('factory constructors', () {
      group('SegmentTree.sum()', () {
        late SegmentTree<num> tree;

        setUp(() {
          tree = SegmentTree.sum([1, 2, 3, 4, 5]);
        });

        test('should compute range sums correctly', () {
          expect(tree.query(0, 4), equals(15));
          expect(tree.query(0, 0), equals(1));
          expect(tree.query(1, 3), equals(9));
          expect(tree.query(2, 4), equals(12));
        });

        test('should handle updates', () {
          tree.update(2, 10);
          expect(tree.query(0, 4), equals(22));
          expect(tree.query(1, 3), equals(16));
        });
      });

      group('SegmentTree.min()', () {
        late SegmentTree<num> tree;

        setUp(() {
          tree = SegmentTree.min([5, 2, 8, 1, 9, 3]);
        });

        test('should compute range minimum correctly', () {
          expect(tree.query(0, 5), equals(1));
          expect(tree.query(0, 2), equals(2));
          expect(tree.query(3, 5), equals(1));
          expect(tree.query(4, 5), equals(3));
        });

        test('should handle updates', () {
          tree.update(3, 10);
          expect(tree.query(0, 5), equals(2));
          expect(tree.query(3, 5), equals(3));
        });
      });

      group('SegmentTree.max()', () {
        late SegmentTree<num> tree;

        setUp(() {
          tree = SegmentTree.max([5, 2, 8, 1, 9, 3]);
        });

        test('should compute range maximum correctly', () {
          expect(tree.query(0, 5), equals(9));
          expect(tree.query(0, 2), equals(8));
          expect(tree.query(0, 1), equals(5));
          expect(tree.query(3, 5), equals(9));
        });

        test('should handle updates', () {
          tree.update(4, 0);
          expect(tree.query(0, 5), equals(8));
          expect(tree.query(3, 5), equals(3));
        });
      });
    });

    group('query(left, right)', () {
      late SegmentTree<num> tree;
      final data = [1, 3, 5, 7, 9, 11];

      setUp(() {
        tree = SegmentTree.sum(data);
      });

      test('should query full range', () {
        expect(tree.query(0, 5), equals(36));
      });

      test('should query single elements', () {
        for (var i = 0; i < data.length; i++) {
          expect(tree.query(i, i), equals(data[i]));
        }
      });

      test('should query adjacent pairs', () {
        expect(tree.query(0, 1), equals(4));
        expect(tree.query(1, 2), equals(8));
        expect(tree.query(2, 3), equals(12));
        expect(tree.query(3, 4), equals(16));
        expect(tree.query(4, 5), equals(20));
      });

      test('should query left half', () {
        expect(tree.query(0, 2), equals(9));
      });

      test('should query right half', () {
        expect(tree.query(3, 5), equals(27));
      });

      test('should query middle section', () {
        expect(tree.query(2, 4), equals(21));
      });

      test('should throw on invalid range', () {
        expect(() => tree.query(-1, 2), throwsRangeError);
        expect(() => tree.query(0, 10), throwsRangeError);
        expect(() => tree.query(3, 2), throwsRangeError);
      });
    });

    group('update(index, value)', () {
      late SegmentTree<num> tree;

      setUp(() {
        tree = SegmentTree.sum([1, 2, 3, 4, 5]);
      });

      test('should update first element', () {
        tree.update(0, 10);
        expect(tree[0], equals(10));
        expect(tree.query(0, 4), equals(24));
      });

      test('should update last element', () {
        tree.update(4, 50);
        expect(tree[4], equals(50));
        expect(tree.query(0, 4), equals(60));
      });

      test('should update middle element', () {
        tree.update(2, 30);
        expect(tree[2], equals(30));
        expect(tree.query(0, 4), equals(42));
      });

      test('should handle multiple updates', () {
        tree.update(0, 10);
        tree.update(2, 30);
        tree.update(4, 50);
        expect(tree.query(0, 4), equals(96));
      });

      test('should throw on invalid index', () {
        expect(() => tree.update(-1, 10), throwsRangeError);
        expect(() => tree.update(5, 10), throwsRangeError);
      });
    });

    group('updateRange (lazy propagation)', () {
      test('should throw when lazy not enabled', () {
        final tree = SegmentTree.sum([1, 2, 3, 4, 5]);
        expect(() => tree.updateRange(0, 2, 10), throwsStateError);
      });

      test('should update range with lazy propagation', () {
        final tree = SegmentTree.sum([1, 2, 3, 4, 5], useLazy: true);
        tree.updateRange(1, 3, 10);
        // Each element in range [1,3] increased by 10
        expect(tree.query(0, 4), equals(15 + 30));
      });

      test('should handle multiple range updates', () {
        final tree = SegmentTree.sum([0, 0, 0, 0, 0], useLazy: true);
        tree.updateRange(0, 2, 5);
        tree.updateRange(2, 4, 3);
        // [5, 5, 8, 3, 3]
        expect(tree.query(0, 4), equals(24));
        expect(tree.query(0, 1), equals(10));
        expect(tree.query(2, 2), equals(8));
      });

      test('should update full range', () {
        final tree = SegmentTree.sum([1, 1, 1, 1, 1], useLazy: true);
        tree.updateRange(0, 4, 1);
        expect(tree.query(0, 4), equals(10));
      });

      test('should throw on invalid range', () {
        final tree = SegmentTree.sum([1, 2, 3], useLazy: true);
        expect(() => tree.updateRange(-1, 1, 5), throwsRangeError);
        expect(() => tree.updateRange(0, 5, 5), throwsRangeError);
        expect(() => tree.updateRange(2, 1, 5), throwsRangeError);
      });
    });

    group('length and operator[]', () {
      test('should return correct length', () {
        expect(SegmentTree.sum([1, 2, 3]).length, equals(3));
        expect(SegmentTree.sum([1]).length, equals(1));
        expect(SegmentTree.sum(<num>[]).length, equals(0));
      });

      test('should access elements with operator[]', () {
        final tree = SegmentTree.sum([10, 20, 30, 40, 50]);
        expect(tree[0], equals(10));
        expect(tree[2], equals(30));
        expect(tree[4], equals(50));
      });

      test('should throw on out of bounds access', () {
        final tree = SegmentTree.sum([1, 2, 3]);
        expect(() => tree[-1], throwsRangeError);
        expect(() => tree[3], throwsRangeError);
      });
    });

    group('build with new data', () {
      test('should rebuild tree with new data', () {
        final tree = SegmentTree.sum([1, 2, 3]);
        expect(tree.query(0, 2), equals(6));

        tree.build(<num>[10, 20, 30, 40]);
        expect(tree.length, equals(4));
        expect(tree.query(0, 3), equals(100));
      });

      test('should rebuild with smaller data', () {
        final tree = SegmentTree.sum([1, 2, 3, 4, 5]);
        tree.build(<num>[100, 200]);
        expect(tree.length, equals(2));
        expect(tree.query(0, 1), equals(300));
      });

      test('should rebuild with empty data', () {
        final tree = SegmentTree.sum([1, 2, 3]);
        tree.build(<num>[]);
        expect(tree.length, equals(0));
      });
    });

    group('edge cases', () {
      test('full range query equals sum of all single queries', () {
        final data = [3, 1, 4, 1, 5, 9, 2, 6];
        final tree = SegmentTree.sum(data);

        num singleSum = 0;
        for (var i = 0; i < data.length; i++) {
          singleSum += tree.query(i, i);
        }
        expect(tree.query(0, data.length - 1), equals(singleSum));
      });

      test('adjacent ranges combine correctly', () {
        final tree = SegmentTree.sum([1, 2, 3, 4, 5, 6]);
        final left = tree.query(0, 2);
        final right = tree.query(3, 5);
        expect(left + right, equals(tree.query(0, 5)));
      });

      test('should handle negative numbers', () {
        final tree = SegmentTree.sum([-5, 3, -2, 7, -1]);
        expect(tree.query(0, 4), equals(2));
        expect(tree.query(0, 1), equals(-2));
      });

      test('should handle floating point numbers', () {
        final tree = SegmentTree.sum([1.5, 2.5, 3.5]);
        expect(tree.query(0, 2), closeTo(7.5, 0.001));
      });

      test('values getter returns copy of data', () {
        final tree = SegmentTree.sum([1, 2, 3]);
        final values = tree.values;
        expect(values, equals([1, 2, 3]));
        values[0] = 999;
        expect(tree[0], equals(1));
      });

      test('toString returns readable format', () {
        final tree = SegmentTree.sum([1, 2, 3]);
        expect(tree.toString(), contains('SegmentTree'));
        expect(tree.toString(), contains('[1, 2, 3]'));
      });
    });

    group('verify correctness against naive computation', () {
      test('sum queries match naive O(n) computation', () {
        final data = [5, 8, 6, 3, 2, 7, 2, 6];
        final tree = SegmentTree.sum(data);

        for (var i = 0; i < data.length; i++) {
          for (var j = i; j < data.length; j++) {
            num naiveSum = 0;
            for (var k = i; k <= j; k++) {
              naiveSum += data[k];
            }
            expect(tree.query(i, j), equals(naiveSum),
                reason: 'Query [$i, $j] failed');
          }
        }
      });

      test('min queries match naive O(n) computation', () {
        final data = [5, 8, 6, 3, 2, 7, 2, 6];
        final tree = SegmentTree.min(data);

        for (var i = 0; i < data.length; i++) {
          for (var j = i; j < data.length; j++) {
            num naiveMin = data[i];
            for (var k = i; k <= j; k++) {
              if (data[k] < naiveMin) naiveMin = data[k];
            }
            expect(tree.query(i, j), equals(naiveMin),
                reason: 'Query [$i, $j] failed');
          }
        }
      });

      test('max queries match naive O(n) computation', () {
        final data = [5, 8, 6, 3, 2, 7, 2, 6];
        final tree = SegmentTree.max(data);

        for (var i = 0; i < data.length; i++) {
          for (var j = i; j < data.length; j++) {
            num naiveMax = data[i];
            for (var k = i; k <= j; k++) {
              if (data[k] > naiveMax) naiveMax = data[k];
            }
            expect(tree.query(i, j), equals(naiveMax),
                reason: 'Query [$i, $j] failed');
          }
        }
      });
    });

    group('large data sets', () {
      test('should handle 1000 elements', () {
        final data = List.generate(1000, (i) => i + 1);
        final tree = SegmentTree.sum(data);

        expect(tree.length, equals(1000));
        expect(tree.query(0, 999), equals(500500));
        expect(tree.query(0, 499), equals(125250));
        expect(tree.query(500, 999), equals(375250));
      });

      test('should handle random updates on large data', () {
        final random = Random(42);
        final data = List.generate(1000, (i) => random.nextInt(100));
        final tree = SegmentTree.sum(data);

        // Perform random updates
        for (var i = 0; i < 100; i++) {
          final index = random.nextInt(1000);
          final value = random.nextInt(100);
          data[index] = value;
          tree.update(index, value);
        }

        // Verify all range queries
        for (var i = 0; i < 50; i++) {
          final left = random.nextInt(500);
          final right = left + random.nextInt(500);
          num naiveSum = 0;
          for (var k = left; k <= right; k++) {
            naiveSum += data[k];
          }
          expect(tree.query(left, right), equals(naiveSum));
        }
      });

      test('should handle 5000 elements with min queries', () {
        final random = Random(123);
        final data = List.generate(5000, (i) => random.nextInt(10000));
        final tree = SegmentTree.min(data);

        for (var i = 0; i < 100; i++) {
          final left = random.nextInt(2500);
          final right = left + random.nextInt(2500);
          num naiveMin = data[left];
          for (var k = left; k <= right; k++) {
            if (data[k] < naiveMin) naiveMin = data[k];
          }
          expect(tree.query(left, right), equals(naiveMin));
        }
      });
    });

    group('random update and query patterns', () {
      test('interleaved updates and queries', () {
        final random = Random(999);
        final data = List.generate(100, (i) => random.nextInt(50));
        final tree = SegmentTree.sum(data);

        for (var round = 0; round < 200; round++) {
          if (random.nextBool()) {
            // Update
            final index = random.nextInt(100);
            final value = random.nextInt(50);
            data[index] = value;
            tree.update(index, value);
          } else {
            // Query
            final left = random.nextInt(50);
            final right = left + random.nextInt(50);
            num naiveSum = 0;
            for (var k = left; k <= right; k++) {
              naiveSum += data[k];
            }
            expect(tree.query(left, right), equals(naiveSum));
          }
        }
      });
    });

    group('custom combine function', () {
      test('should work with GCD', () {
        int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);

        final tree = SegmentTree<int>(
          [12, 18, 24, 6, 30],
          combine: gcd,
          identity: 0,
        );

        expect(tree.query(0, 4), equals(6));
        expect(tree.query(0, 2), equals(6));
        expect(tree.query(0, 1), equals(6));
      });

      test('should work with XOR', () {
        final tree = SegmentTree<int>(
          [1, 2, 3, 4, 5],
          combine: (a, b) => a ^ b,
          identity: 0,
        );

        expect(tree.query(0, 4), equals(1 ^ 2 ^ 3 ^ 4 ^ 5));
        expect(tree.query(1, 3), equals(2 ^ 3 ^ 4));
      });
    });
  });

  group('FenwickTree', () {
    group('empty tree', () {
      test('should handle empty data', () {
        final tree = FenwickTree([]);
        expect(tree.length, equals(0));
      });
    });

    group('single element tree', () {
      late FenwickTree tree;

      setUp(() {
        tree = FenwickTree([42]);
      });

      test('should have length 1', () {
        expect(tree.length, equals(1));
      });

      test('should compute prefix sum', () {
        expect(tree.prefixSum(0), equals(42));
      });

      test('should compute range sum', () {
        expect(tree.rangeSum(0, 0), equals(42));
      });

      test('should access element with operator[]', () {
        expect(tree[0], equals(42));
      });

      test('should update single element', () {
        tree.update(0, 8);
        expect(tree.prefixSum(0), equals(50));
        expect(tree[0], equals(50));
      });

      test('should set single element', () {
        tree.set(0, 100);
        expect(tree.prefixSum(0), equals(100));
        expect(tree[0], equals(100));
      });
    });

    group('prefixSum(index)', () {
      late FenwickTree tree;
      final data = [1, 2, 3, 4, 5];

      setUp(() {
        tree = FenwickTree(data);
      });

      test('should compute prefix sums correctly', () {
        expect(tree.prefixSum(0), equals(1));
        expect(tree.prefixSum(1), equals(3));
        expect(tree.prefixSum(2), equals(6));
        expect(tree.prefixSum(3), equals(10));
        expect(tree.prefixSum(4), equals(15));
      });

      test('should throw on invalid index', () {
        expect(() => tree.prefixSum(-1), throwsRangeError);
        expect(() => tree.prefixSum(5), throwsRangeError);
      });
    });

    group('rangeSum(left, right)', () {
      late FenwickTree tree;
      final data = [1, 3, 5, 7, 9, 11];

      setUp(() {
        tree = FenwickTree(data);
      });

      test('should compute range sums correctly', () {
        expect(tree.rangeSum(0, 5), equals(36));
        expect(tree.rangeSum(0, 0), equals(1));
        expect(tree.rangeSum(1, 3), equals(15));
        expect(tree.rangeSum(2, 4), equals(21));
        expect(tree.rangeSum(5, 5), equals(11));
      });

      test('should compute full range sum', () {
        expect(tree.rangeSum(0, 5), equals(36));
      });

      test('should compute single element range', () {
        for (var i = 0; i < data.length; i++) {
          expect(tree.rangeSum(i, i), equals(data[i]));
        }
      });

      test('should throw on invalid range', () {
        expect(() => tree.rangeSum(-1, 2), throwsRangeError);
        expect(() => tree.rangeSum(0, 10), throwsRangeError);
        expect(() => tree.rangeSum(3, 2), throwsRangeError);
      });
    });

    group('update(index, delta)', () {
      late FenwickTree tree;

      setUp(() {
        tree = FenwickTree([1, 2, 3, 4, 5]);
      });

      test('should add delta to element', () {
        tree.update(2, 10);
        expect(tree[2], equals(13));
        expect(tree.prefixSum(4), equals(25));
      });

      test('should handle negative delta', () {
        tree.update(2, -2);
        expect(tree[2], equals(1));
        expect(tree.prefixSum(4), equals(13));
      });

      test('should update first element', () {
        tree.update(0, 9);
        expect(tree[0], equals(10));
        expect(tree.prefixSum(0), equals(10));
      });

      test('should update last element', () {
        tree.update(4, 5);
        expect(tree[4], equals(10));
        expect(tree.prefixSum(4), equals(20));
      });

      test('should throw on invalid index', () {
        expect(() => tree.update(-1, 5), throwsRangeError);
        expect(() => tree.update(5, 5), throwsRangeError);
      });
    });

    group('set(index, value)', () {
      late FenwickTree tree;

      setUp(() {
        tree = FenwickTree([1, 2, 3, 4, 5]);
      });

      test('should set element to new value', () {
        tree.set(2, 100);
        expect(tree[2], equals(100));
        expect(tree.prefixSum(4), equals(112));
      });

      test('should set first element', () {
        tree.set(0, 50);
        expect(tree[0], equals(50));
        expect(tree.prefixSum(0), equals(50));
      });

      test('should set last element', () {
        tree.set(4, 0);
        expect(tree[4], equals(0));
        expect(tree.prefixSum(4), equals(10));
      });

      test('should throw on invalid index', () {
        expect(() => tree.set(-1, 10), throwsRangeError);
        expect(() => tree.set(5, 10), throwsRangeError);
      });
    });

    group('length and operator[]', () {
      test('should return correct length', () {
        expect(FenwickTree([1, 2, 3]).length, equals(3));
        expect(FenwickTree([1]).length, equals(1));
        expect(FenwickTree([]).length, equals(0));
      });

      test('should access elements with operator[]', () {
        final tree = FenwickTree([10, 20, 30, 40, 50]);
        expect(tree[0], equals(10));
        expect(tree[2], equals(30));
        expect(tree[4], equals(50));
      });

      test('should throw on out of bounds access', () {
        final tree = FenwickTree([1, 2, 3]);
        expect(() => tree[-1], throwsRangeError);
        expect(() => tree[3], throwsRangeError);
      });
    });

    group('edge cases', () {
      test('should handle negative numbers', () {
        final tree = FenwickTree([-5, 3, -2, 7, -1]);
        expect(tree.prefixSum(4), equals(2));
        expect(tree.rangeSum(0, 1), equals(-2));
        expect(tree.rangeSum(2, 4), equals(4));
      });

      test('should handle floating point numbers', () {
        final tree = FenwickTree([1.5, 2.5, 3.5]);
        expect(tree.prefixSum(2), closeTo(7.5, 0.001));
        expect(tree.rangeSum(1, 2), closeTo(6.0, 0.001));
      });

      test('should handle all zeros', () {
        final tree = FenwickTree([0, 0, 0, 0, 0]);
        expect(tree.prefixSum(4), equals(0));
        tree.update(2, 5);
        expect(tree.prefixSum(4), equals(5));
      });

      test('values getter returns copy of data', () {
        final tree = FenwickTree([1, 2, 3]);
        final values = tree.values;
        expect(values, equals([1, 2, 3]));
        values[0] = 999;
        expect(tree[0], equals(1));
      });

      test('toString returns readable format', () {
        final tree = FenwickTree([1, 2, 3]);
        expect(tree.toString(), contains('FenwickTree'));
        expect(tree.toString(), contains('[1, 2, 3]'));
      });
    });

    group('verify correctness against naive computation', () {
      test('prefix sums match naive O(n) computation', () {
        final data = [5, 8, 6, 3, 2, 7, 2, 6];
        final tree = FenwickTree(data);

        for (var i = 0; i < data.length; i++) {
          num naiveSum = 0;
          for (var k = 0; k <= i; k++) {
            naiveSum += data[k];
          }
          expect(tree.prefixSum(i), equals(naiveSum),
              reason: 'Prefix sum at $i failed');
        }
      });

      test('range sums match naive O(n) computation', () {
        final data = [5, 8, 6, 3, 2, 7, 2, 6];
        final tree = FenwickTree(data);

        for (var i = 0; i < data.length; i++) {
          for (var j = i; j < data.length; j++) {
            num naiveSum = 0;
            for (var k = i; k <= j; k++) {
              naiveSum += data[k];
            }
            expect(tree.rangeSum(i, j), equals(naiveSum),
                reason: 'Range sum [$i, $j] failed');
          }
        }
      });
    });

    group('large data sets', () {
      test('should handle 1000 elements', () {
        final data = List.generate(1000, (i) => i + 1);
        final tree = FenwickTree(data);

        expect(tree.length, equals(1000));
        expect(tree.prefixSum(999), equals(500500));
        expect(tree.prefixSum(499), equals(125250));
        expect(tree.rangeSum(500, 999), equals(375250));
      });

      test('should handle random updates on large data', () {
        final random = Random(42);
        final data = List<num>.generate(1000, (i) => random.nextInt(100));
        final tree = FenwickTree(data);

        // Perform random updates
        for (var i = 0; i < 100; i++) {
          final index = random.nextInt(1000);
          final delta = random.nextInt(100) - 50;
          data[index] += delta;
          tree.update(index, delta);
        }

        // Verify all prefix sums
        for (var i = 0; i < 50; i++) {
          final index = random.nextInt(1000);
          num naiveSum = 0;
          for (var k = 0; k <= index; k++) {
            naiveSum += data[k];
          }
          expect(tree.prefixSum(index), equals(naiveSum));
        }
      });

      test('should handle 5000 elements with range queries', () {
        final random = Random(123);
        final data = List<num>.generate(5000, (i) => random.nextInt(1000));
        final tree = FenwickTree(data);

        for (var i = 0; i < 100; i++) {
          final left = random.nextInt(2500);
          final right = left + random.nextInt(2500);
          num naiveSum = 0;
          for (var k = left; k <= right; k++) {
            naiveSum += data[k];
          }
          expect(tree.rangeSum(left, right), equals(naiveSum));
        }
      });

      test('should handle set operations on large data', () {
        final random = Random(456);
        final data = List<num>.generate(1000, (i) => random.nextInt(100));
        final tree = FenwickTree(data);

        // Perform random set operations
        for (var i = 0; i < 100; i++) {
          final index = random.nextInt(1000);
          final value = random.nextInt(100);
          data[index] = value;
          tree.set(index, value);
        }

        // Verify correctness
        for (var i = 0; i < 50; i++) {
          final left = random.nextInt(500);
          final right = left + random.nextInt(500);
          num naiveSum = 0;
          for (var k = left; k <= right; k++) {
            naiveSum += data[k];
          }
          expect(tree.rangeSum(left, right), equals(naiveSum));
        }
      });
    });

    group('random update and query patterns', () {
      test('interleaved updates, sets, and queries', () {
        final random = Random(999);
        final data = List<num>.generate(100, (i) => random.nextInt(50));
        final tree = FenwickTree(data);

        for (var round = 0; round < 300; round++) {
          final op = random.nextInt(3);
          if (op == 0) {
            // Update
            final index = random.nextInt(100);
            final delta = random.nextInt(20) - 10;
            data[index] += delta;
            tree.update(index, delta);
          } else if (op == 1) {
            // Set
            final index = random.nextInt(100);
            final value = random.nextInt(50);
            data[index] = value;
            tree.set(index, value);
          } else {
            // Range query
            final left = random.nextInt(50);
            final right = left + random.nextInt(50);
            num naiveSum = 0;
            for (var k = left; k <= right; k++) {
              naiveSum += data[k];
            }
            expect(tree.rangeSum(left, right), equals(naiveSum));
          }
        }
      });
    });
  });

  group('SegmentTree vs FenwickTree comparison', () {
    test('both produce same sum results', () {
      final data = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3];
      final segTree = SegmentTree.sum(data);
      final fenTree = FenwickTree(data);

      for (var i = 0; i < data.length; i++) {
        for (var j = i; j < data.length; j++) {
          expect(segTree.query(i, j), equals(fenTree.rangeSum(i, j)),
              reason: 'Mismatch at range [$i, $j]');
        }
      }
    });

    test('both produce same results after updates', () {
      final data = List<num>.generate(50, (i) => i);
      final segTree = SegmentTree.sum(data);
      final fenTree = FenwickTree(data);

      final random = Random(777);
      for (var i = 0; i < 20; i++) {
        final index = random.nextInt(50);
        final value = random.nextInt(100);
        segTree.update(index, value);
        fenTree.set(index, value);
      }

      for (var i = 0; i < 30; i++) {
        final left = random.nextInt(25);
        final right = left + random.nextInt(25);
        expect(
            segTree.query(left, right), equals(fenTree.rangeSum(left, right)),
            reason: 'Mismatch at range [$left, $right]');
      }
    });
  });
}
