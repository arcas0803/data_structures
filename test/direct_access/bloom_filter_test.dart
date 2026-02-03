import 'dart:math';

import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('BloomFilter', () {
    group('constructor', () {
      test('should create filter with expected elements and false positive rate',
          () {
        final filter = BloomFilter<String>(100, 0.01);
        expect(filter.bitCount, greaterThan(0));
        expect(filter.hashCount, greaterThan(0));
        expect(filter.isEmpty, isTrue);
      });

      test('should throw for non-positive expectedElements', () {
        expect(() => BloomFilter<String>(0, 0.01), throwsArgumentError);
        expect(() => BloomFilter<String>(-1, 0.01), throwsArgumentError);
      });

      test('should throw for invalid falsePositiveRate', () {
        expect(() => BloomFilter<String>(100, 0.0), throwsArgumentError);
        expect(() => BloomFilter<String>(100, 1.0), throwsArgumentError);
        expect(() => BloomFilter<String>(100, -0.1), throwsArgumentError);
        expect(() => BloomFilter<String>(100, 1.5), throwsArgumentError);
      });

      test('should create larger filter for smaller false positive rate', () {
        final filter1 = BloomFilter<String>(100, 0.1);
        final filter2 = BloomFilter<String>(100, 0.01);
        final filter3 = BloomFilter<String>(100, 0.001);

        expect(filter2.bitCount, greaterThan(filter1.bitCount));
        expect(filter3.bitCount, greaterThan(filter2.bitCount));
      });

      test('should create larger filter for more expected elements', () {
        final filter1 = BloomFilter<String>(100, 0.01);
        final filter2 = BloomFilter<String>(1000, 0.01);

        expect(filter2.bitCount, greaterThan(filter1.bitCount));
      });
    });

    group('BloomFilter.withSize constructor', () {
      test('should create filter with specified size and hash count', () {
        final filter = BloomFilter<String>.withSize(1000, 7);
        expect(filter.bitCount, equals(1000));
        expect(filter.hashCount, equals(7));
        expect(filter.isEmpty, isTrue);
      });

      test('should enforce minimum bit array size of 1', () {
        final filter1 = BloomFilter<String>.withSize(0, 5);
        final filter2 = BloomFilter<String>.withSize(-10, 5);

        expect(filter1.bitCount, equals(1));
        expect(filter2.bitCount, equals(1));
      });

      test('should enforce minimum hash count of 1', () {
        final filter1 = BloomFilter<String>.withSize(100, 0);
        final filter2 = BloomFilter<String>.withSize(100, -5);

        expect(filter1.hashCount, equals(1));
        expect(filter2.hashCount, equals(1));
      });
    });

    group('add', () {
      late BloomFilter<String> filter;

      setUp(() {
        filter = BloomFilter<String>(100, 0.01);
      });

      test('should add single element', () {
        filter.add('hello');
        expect(filter.isEmpty, isFalse);
        expect(filter.approximateElementCount, equals(1));
        expect(filter.contains('hello'), isTrue);
      });

      test('should add multiple elements', () {
        filter.add('one');
        filter.add('two');
        filter.add('three');

        expect(filter.approximateElementCount, equals(3));
        expect(filter.contains('one'), isTrue);
        expect(filter.contains('two'), isTrue);
        expect(filter.contains('three'), isTrue);
      });

      test('should handle duplicate additions', () {
        filter.add('duplicate');
        filter.add('duplicate');
        filter.add('duplicate');

        // Count increases even for duplicates (bloom filter doesn't know)
        expect(filter.approximateElementCount, equals(3));
        expect(filter.contains('duplicate'), isTrue);
      });

      test('should add different types', () {
        final intFilter = BloomFilter<int>(100, 0.01);
        intFilter.add(42);
        intFilter.add(100);
        intFilter.add(-5);

        expect(intFilter.contains(42), isTrue);
        expect(intFilter.contains(100), isTrue);
        expect(intFilter.contains(-5), isTrue);
      });
    });

    group('contains/mightContain', () {
      late BloomFilter<String> filter;

      setUp(() {
        filter = BloomFilter<String>(100, 0.01);
      });

      test('should return false for empty filter', () {
        expect(filter.contains('anything'), isFalse);
        expect(filter.mightContain('something'), isFalse);
      });

      test('should return true for added elements (true positives)', () {
        filter.add('apple');
        filter.add('banana');
        filter.add('cherry');

        expect(filter.contains('apple'), isTrue);
        expect(filter.contains('banana'), isTrue);
        expect(filter.contains('cherry'), isTrue);
      });

      test('should likely return false for non-added elements (true negatives)',
          () {
        filter.add('cat');
        filter.add('dog');

        // These should very likely be false (not guaranteed due to false positives)
        expect(filter.contains('elephant'), isFalse);
        expect(filter.contains('giraffe'), isFalse);
      });

      test('mightContain is alias for contains', () {
        filter.add('test');
        expect(filter.mightContain('test'), equals(filter.contains('test')));
        expect(filter.mightContain('other'), equals(filter.contains('other')));
      });
    });

    group('addAll', () {
      test('should add all elements from iterable', () {
        final filter = BloomFilter<String>(100, 0.01);
        filter.addAll(['a', 'b', 'c', 'd', 'e']);

        expect(filter.approximateElementCount, equals(5));
        expect(filter.contains('a'), isTrue);
        expect(filter.contains('b'), isTrue);
        expect(filter.contains('c'), isTrue);
        expect(filter.contains('d'), isTrue);
        expect(filter.contains('e'), isTrue);
      });

      test('should add from empty iterable', () {
        final filter = BloomFilter<String>(100, 0.01);
        filter.addAll([]);

        expect(filter.isEmpty, isTrue);
        expect(filter.approximateElementCount, equals(0));
      });

      test('should add from list with duplicates', () {
        final filter = BloomFilter<int>(100, 0.01);
        filter.addAll([1, 2, 1, 3, 2, 1]);

        expect(filter.approximateElementCount, equals(6));
        expect(filter.contains(1), isTrue);
        expect(filter.contains(2), isTrue);
        expect(filter.contains(3), isTrue);
      });
    });

    group('containsAll', () {
      late BloomFilter<String> filter;

      setUp(() {
        filter = BloomFilter<String>(100, 0.01);
        filter.addAll(['x', 'y', 'z']);
      });

      test('should return true when all elements present', () {
        expect(filter.containsAll(['x', 'y']), isTrue);
        expect(filter.containsAll(['x', 'y', 'z']), isTrue);
        expect(filter.containsAll(['z']), isTrue);
      });

      test('should return true for empty iterable', () {
        expect(filter.containsAll([]), isTrue);
      });

      test('should return false when any element not present', () {
        expect(filter.containsAll(['x', 'y', 'w']), isFalse);
        expect(filter.containsAll(['a', 'b']), isFalse);
      });
    });

    group('properties', () {
      test('bitCount should return bit array size', () {
        final filter = BloomFilter<String>.withSize(500, 5);
        expect(filter.bitCount, equals(500));
      });

      test('hashCount should return number of hash functions', () {
        final filter = BloomFilter<String>.withSize(500, 7);
        expect(filter.hashCount, equals(7));
      });

      test('isEmpty should reflect filter state', () {
        final filter = BloomFilter<String>(100, 0.01);
        expect(filter.isEmpty, isTrue);

        filter.add('element');
        expect(filter.isEmpty, isFalse);
      });

      test('approximateElementCount should track insertions', () {
        final filter = BloomFilter<String>(100, 0.01);
        expect(filter.approximateElementCount, equals(0));

        filter.add('one');
        expect(filter.approximateElementCount, equals(1));

        filter.add('two');
        filter.add('three');
        expect(filter.approximateElementCount, equals(3));
      });

      test('fillRatio should increase as elements are added', () {
        final filter = BloomFilter<String>(100, 0.01);
        expect(filter.fillRatio, equals(0.0));

        filter.add('a');
        final ratio1 = filter.fillRatio;
        expect(ratio1, greaterThan(0.0));

        filter.add('b');
        filter.add('c');
        final ratio2 = filter.fillRatio;
        expect(ratio2, greaterThanOrEqualTo(ratio1));
      });

      test('fillRatio should be between 0 and 1', () {
        final filter = BloomFilter<String>(100, 0.01);
        for (var i = 0; i < 200; i++) {
          filter.add('element_$i');
        }

        expect(filter.fillRatio, greaterThanOrEqualTo(0.0));
        expect(filter.fillRatio, lessThanOrEqualTo(1.0));
      });
    });

    group('expectedFalsePositiveRate', () {
      test('should be 0 for empty filter', () {
        final filter = BloomFilter<String>(100, 0.01);
        expect(filter.expectedFalsePositiveRate, equals(0.0));
      });

      test('should increase as elements are added', () {
        final filter = BloomFilter<String>(100, 0.01);
        filter.add('a');
        final rate1 = filter.expectedFalsePositiveRate;

        for (var i = 0; i < 50; i++) {
          filter.add('element_$i');
        }
        final rate2 = filter.expectedFalsePositiveRate;

        expect(rate2, greaterThan(rate1));
      });

      test('should be below configured rate when under capacity', () {
        final targetRate = 0.01;
        final filter = BloomFilter<String>(100, targetRate);

        // Add up to expected capacity
        for (var i = 0; i < 100; i++) {
          filter.add('element_$i');
        }

        // Should be close to target rate (with some tolerance)
        expect(filter.expectedFalsePositiveRate, lessThan(targetRate * 2));
      });

      test('should approach 1.0 when severely overfilled', () {
        final filter = BloomFilter<String>.withSize(10, 3);

        // Overfill massively
        for (var i = 0; i < 1000; i++) {
          filter.add('element_$i');
        }

        expect(filter.expectedFalsePositiveRate, greaterThan(0.9));
      });
    });

    group('clear', () {
      test('should reset filter to empty state', () {
        final filter = BloomFilter<String>(100, 0.01);
        filter.addAll(['a', 'b', 'c', 'd', 'e']);

        expect(filter.isEmpty, isFalse);
        expect(filter.contains('a'), isTrue);

        filter.clear();

        expect(filter.isEmpty, isTrue);
        expect(filter.approximateElementCount, equals(0));
        expect(filter.fillRatio, equals(0.0));
        expect(filter.expectedFalsePositiveRate, equals(0.0));
        expect(filter.contains('a'), isFalse);
      });

      test('should allow reuse after clear', () {
        final filter = BloomFilter<String>(100, 0.01);
        filter.add('first');
        filter.clear();
        filter.add('second');

        expect(filter.contains('first'), isFalse);
        expect(filter.contains('second'), isTrue);
        expect(filter.approximateElementCount, equals(1));
      });

      test('should preserve size and hash count after clear', () {
        final filter = BloomFilter<String>.withSize(500, 7);
        filter.add('test');
        filter.clear();

        expect(filter.bitCount, equals(500));
        expect(filter.hashCount, equals(7));
      });
    });

    group('union', () {
      test('should combine two filters', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 5);

        filter1.addAll(['a', 'b', 'c']);
        filter2.addAll(['d', 'e', 'f']);

        final union = filter1.union(filter2);

        expect(union.contains('a'), isTrue);
        expect(union.contains('b'), isTrue);
        expect(union.contains('c'), isTrue);
        expect(union.contains('d'), isTrue);
        expect(union.contains('e'), isTrue);
        expect(union.contains('f'), isTrue);
      });

      test('should return filter containing overlapping elements', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 5);

        filter1.addAll(['a', 'b', 'c']);
        filter2.addAll(['b', 'c', 'd']);

        final union = filter1.union(filter2);

        expect(union.contains('a'), isTrue);
        expect(union.contains('b'), isTrue);
        expect(union.contains('c'), isTrue);
        expect(union.contains('d'), isTrue);
      });

      test('should sum approximate element counts', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 5);

        filter1.addAll(['a', 'b']);
        filter2.addAll(['c', 'd', 'e']);

        final union = filter1.union(filter2);
        expect(union.approximateElementCount, equals(5));
      });

      test('should throw for different bit array sizes', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(200, 5);

        expect(() => filter1.union(filter2), throwsArgumentError);
      });

      test('should throw for different hash counts', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 7);

        expect(() => filter1.union(filter2), throwsArgumentError);
      });

      test('should not modify original filters', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 5);

        filter1.add('a');
        filter2.add('b');

        filter1.union(filter2);

        expect(filter1.approximateElementCount, equals(1));
        expect(filter2.approximateElementCount, equals(1));
        expect(filter1.contains('b'), isFalse);
        expect(filter2.contains('a'), isFalse);
      });
    });

    group('intersection', () {
      test('should return filter with common bits', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 5);

        filter1.addAll(['a', 'b', 'c']);
        filter2.addAll(['b', 'c', 'd']);

        final intersection = filter1.intersection(filter2);

        // Common elements should be present
        expect(intersection.contains('b'), isTrue);
        expect(intersection.contains('c'), isTrue);
      });

      test('should use minimum element count', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 5);

        filter1.addAll(['a', 'b']);
        filter2.addAll(['c', 'd', 'e']);

        final intersection = filter1.intersection(filter2);
        expect(intersection.approximateElementCount, equals(2));
      });

      test('should throw for different bit array sizes', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(200, 5);

        expect(() => filter1.intersection(filter2), throwsArgumentError);
      });

      test('should throw for different hash counts', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 7);

        expect(() => filter1.intersection(filter2), throwsArgumentError);
      });

      test('should not modify original filters', () {
        final filter1 = BloomFilter<String>.withSize(100, 5);
        final filter2 = BloomFilter<String>.withSize(100, 5);

        filter1.add('a');
        filter2.add('b');

        filter1.intersection(filter2);

        expect(filter1.approximateElementCount, equals(1));
        expect(filter2.approximateElementCount, equals(1));
        expect(filter1.contains('a'), isTrue);
        expect(filter2.contains('b'), isTrue);
      });
    });

    group('static helpers', () {
      group('optimalSize', () {
        test('should return positive size for valid inputs', () {
          expect(BloomFilter.optimalSize(100, 0.01), greaterThan(0));
          expect(BloomFilter.optimalSize(1000, 0.001), greaterThan(0));
        });

        test('should return 1 for non-positive n', () {
          expect(BloomFilter.optimalSize(0, 0.01), equals(1));
          expect(BloomFilter.optimalSize(-10, 0.01), equals(1));
        });

        test('should return fallback for invalid p', () {
          expect(BloomFilter.optimalSize(100, 0.0), equals(1000)); // n * 10
          expect(BloomFilter.optimalSize(100, 1.0), equals(1000));
          expect(BloomFilter.optimalSize(100, -0.5), equals(1000));
        });

        test('should increase size for smaller false positive rate', () {
          final size1 = BloomFilter.optimalSize(100, 0.1);
          final size2 = BloomFilter.optimalSize(100, 0.01);
          final size3 = BloomFilter.optimalSize(100, 0.001);

          expect(size2, greaterThan(size1));
          expect(size3, greaterThan(size2));
        });

        test('should increase size for more elements', () {
          final size1 = BloomFilter.optimalSize(100, 0.01);
          final size2 = BloomFilter.optimalSize(1000, 0.01);

          expect(size2, greaterThan(size1));
        });
      });

      group('optimalHashCount', () {
        test('should return positive count for valid inputs', () {
          expect(BloomFilter.optimalHashCount(1000, 100), greaterThan(0));
        });

        test('should return 1 for non-positive n', () {
          expect(BloomFilter.optimalHashCount(100, 0), equals(1));
          expect(BloomFilter.optimalHashCount(100, -10), equals(1));
        });

        test('should calculate based on m/n ratio', () {
          // k = (m/n) * ln(2) ≈ 0.693 * (m/n)
          // For m=1000, n=100: k ≈ 6.93 ≈ 7
          final k = BloomFilter.optimalHashCount(1000, 100);
          expect(k, greaterThanOrEqualTo(6));
          expect(k, lessThanOrEqualTo(8));
        });
      });
    });

    group('edge cases', () {
      test('empty filter behavior', () {
        final filter = BloomFilter<String>(100, 0.01);

        expect(filter.isEmpty, isTrue);
        expect(filter.approximateElementCount, equals(0));
        expect(filter.fillRatio, equals(0.0));
        expect(filter.expectedFalsePositiveRate, equals(0.0));
        expect(filter.contains('anything'), isFalse);
        expect(filter.containsAll([]), isTrue);
        expect(filter.containsAll(['a', 'b']), isFalse);
      });

      test('single element filter', () {
        final filter = BloomFilter<String>(100, 0.01);
        filter.add('only');

        expect(filter.isEmpty, isFalse);
        expect(filter.approximateElementCount, equals(1));
        expect(filter.contains('only'), isTrue);
        expect(filter.fillRatio, greaterThan(0.0));
      });

      test('filter with minimum size', () {
        final filter = BloomFilter<String>.withSize(1, 1);
        filter.add('test');

        expect(filter.bitCount, equals(1));
        expect(filter.hashCount, equals(1));
        expect(filter.contains('test'), isTrue);
        // With only 1 bit, everything will be a false positive after adding
        expect(filter.contains('other'), isTrue);
      });

      test('different types - String', () {
        final filter = BloomFilter<String>(100, 0.01);
        filter.addAll(['hello', 'world', '']);

        expect(filter.contains('hello'), isTrue);
        expect(filter.contains('world'), isTrue);
        expect(filter.contains(''), isTrue);
        expect(filter.contains('missing'), isFalse);
      });

      test('different types - int', () {
        final filter = BloomFilter<int>(100, 0.01);
        filter.addAll([0, 1, -1, 42, 1000000]);

        expect(filter.contains(0), isTrue);
        expect(filter.contains(1), isTrue);
        expect(filter.contains(-1), isTrue);
        expect(filter.contains(42), isTrue);
        expect(filter.contains(1000000), isTrue);
        expect(filter.contains(999), isFalse);
      });

      test('different types - custom objects', () {
        final filter = BloomFilter<_TestObject>(100, 0.01);
        final obj1 = _TestObject(1, 'a');
        final obj2 = _TestObject(2, 'b');
        final obj3 = _TestObject(1, 'a'); // Same as obj1

        filter.add(obj1);
        filter.add(obj2);

        expect(filter.contains(obj1), isTrue);
        expect(filter.contains(obj2), isTrue);
        expect(filter.contains(obj3), isTrue); // Same hashCode as obj1
      });
    });

    group('probabilistic testing', () {
      test('should never have false negatives (added elements always found)',
          () {
        final filter = BloomFilter<int>(1000, 0.01);
        final addedElements = <int>[];

        // Add 1000 elements
        for (var i = 0; i < 1000; i++) {
          filter.add(i);
          addedElements.add(i);
        }

        // Every added element MUST be found (no false negatives)
        for (final element in addedElements) {
          expect(filter.contains(element), isTrue,
              reason: 'Element $element was added but not found');
        }
      });

      test('false positive rate should be within expected bounds', () {
        final targetRate = 0.01; // 1%
        final numElements = 1000;
        final filter = BloomFilter<int>(numElements, targetRate);

        // Add elements 0 to numElements-1
        for (var i = 0; i < numElements; i++) {
          filter.add(i);
        }

        // Test with elements that were NOT added
        var falsePositives = 0;
        final testCount = 10000;

        for (var i = numElements; i < numElements + testCount; i++) {
          if (filter.contains(i)) {
            falsePositives++;
          }
        }

        final actualRate = falsePositives / testCount;

        // Allow up to 3x the target rate due to statistical variance
        expect(actualRate, lessThan(targetRate * 3),
            reason: 'False positive rate $actualRate exceeds '
                '${targetRate * 3} (3x target)');
      });

      test('false positives should be possible (probabilistic nature)', () {
        // Use a very small filter to force false positives
        final filter = BloomFilter<int>.withSize(50, 3);

        // Add many elements to fill the filter
        for (var i = 0; i < 100; i++) {
          filter.add(i);
        }

        // With such a small filter, we should see false positives
        var falsePositives = 0;
        for (var i = 100; i < 200; i++) {
          if (filter.contains(i)) {
            falsePositives++;
          }
        }

        // Should have at least some false positives
        expect(falsePositives, greaterThan(0),
            reason: 'Expected some false positives with a small filter');
      });

      test('larger filter should have fewer false positives', () {
        final numElements = 100;

        // Small filter
        final smallFilter = BloomFilter<int>(numElements, 0.1);
        // Large filter
        final largeFilter = BloomFilter<int>(numElements, 0.001);

        for (var i = 0; i < numElements; i++) {
          smallFilter.add(i);
          largeFilter.add(i);
        }

        var smallFP = 0;
        var largeFP = 0;
        final testCount = 1000;

        for (var i = numElements; i < numElements + testCount; i++) {
          if (smallFilter.contains(i)) smallFP++;
          if (largeFilter.contains(i)) largeFP++;
        }

        expect(largeFP, lessThan(smallFP),
            reason: 'Larger filter should have fewer false positives');
      });

      test('random elements maintain probabilistic guarantees', () {
        final random = Random(42); // Fixed seed for reproducibility
        final filter = BloomFilter<int>(500, 0.01);
        final added = <int>{};

        // Add random elements
        for (var i = 0; i < 500; i++) {
          final element = random.nextInt(1000000);
          filter.add(element);
          added.add(element);
        }

        // All added elements must be found
        for (final element in added) {
          expect(filter.contains(element), isTrue);
        }

        // Check false positive rate on random non-added elements
        var falsePositives = 0;
        var tested = 0;

        for (var i = 0; i < 10000; i++) {
          final testElement = random.nextInt(1000000);
          if (!added.contains(testElement)) {
            tested++;
            if (filter.contains(testElement)) {
              falsePositives++;
            }
          }
        }

        if (tested > 0) {
          final fpRate = falsePositives / tested;
          expect(fpRate, lessThan(0.05),
              reason: 'FP rate $fpRate is too high');
        }
      });
    });

    group('toString', () {
      test('should return descriptive string', () {
        final filter = BloomFilter<String>.withSize(100, 5);
        filter.add('test');

        final str = filter.toString();
        expect(str, contains('BloomFilter'));
        expect(str, contains('100'));
        expect(str, contains('5'));
      });

      test('should show element count and fill ratio', () {
        final filter = BloomFilter<String>.withSize(100, 5);
        filter.addAll(['a', 'b', 'c']);

        final str = filter.toString();
        expect(str, contains('~3'));
        expect(str, contains('%'));
      });
    });
  });
}

/// Test helper class with custom hashCode
class _TestObject {
  final int id;
  final String name;

  _TestObject(this.id, this.name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  bool operator ==(Object other) =>
      other is _TestObject && other.id == id && other.name == name;
}
