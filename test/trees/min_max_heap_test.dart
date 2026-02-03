import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('MinMaxHeap', () {
    late MinMaxHeap<int> heap;

    setUp(() {
      heap = MinMaxHeap<int>();
    });

    group('empty heap operations', () {
      test('should start empty', () {
        expect(heap.isEmpty, isTrue);
        expect(heap.isNotEmpty, isFalse);
        expect(heap.length, equals(0));
      });

      test('should throw on min from empty', () {
        expect(() => heap.min, throwsStateError);
      });

      test('should throw on max from empty', () {
        expect(() => heap.max, throwsStateError);
      });

      test('should throw on peekMin from empty', () {
        expect(() => heap.peekMin(), throwsStateError);
      });

      test('should throw on peekMax from empty', () {
        expect(() => heap.peekMax(), throwsStateError);
      });

      test('should throw on extractMin from empty', () {
        expect(() => heap.extractMin(), throwsStateError);
      });

      test('should throw on extractMax from empty', () {
        expect(() => heap.extractMax(), throwsStateError);
      });

      test('should return null for tryPeekMin on empty', () {
        expect(heap.tryPeekMin(), isNull);
      });

      test('should return null for tryPeekMax on empty', () {
        expect(heap.tryPeekMax(), isNull);
      });

      test('should return empty list for toList on empty', () {
        expect(heap.toList(), isEmpty);
      });

      test('should return empty list for toSortedList on empty', () {
        expect(heap.toSortedList(), isEmpty);
      });

      test('should be valid when empty', () {
        expect(heap.isValid, isTrue);
      });
    });

    group('insert', () {
      test('should insert single element', () {
        heap.insert(5);
        expect(heap.length, equals(1));
        expect(heap.isNotEmpty, isTrue);
        expect(heap.isEmpty, isFalse);
        expect(heap.min, equals(5));
        expect(heap.max, equals(5));
      });

      test('should insert multiple elements', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        expect(heap.length, equals(3));
      });

      test('should maintain min at root after insertions', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        expect(heap.min, equals(1));
      });

      test('should track max correctly after insertions', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        expect(heap.max, equals(7));
      });

      test('should use add as alias for insert', () {
        heap.add(5);
        heap.add(3);
        expect(heap.length, equals(2));
        expect(heap.min, equals(3));
      });

      test('should maintain heap property after many insertions', () {
        for (var i = 20; i >= 1; i--) {
          heap.insert(i);
          expect(heap.isValid, isTrue);
        }
        expect(heap.min, equals(1));
        expect(heap.max, equals(20));
      });
    });

    group('extractMin', () {
      test('should extract minimum element', () {
        heap.addAll([5, 3, 7, 1, 9]);
        expect(heap.extractMin(), equals(1));
        expect(heap.length, equals(4));
      });

      test('should extract elements in ascending order', () {
        heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
        final extracted = <int>[];
        while (heap.isNotEmpty) {
          extracted.add(heap.extractMin());
        }
        expect(extracted, equals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]));
      });

      test('should maintain heap property after extractMin', () {
        heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
        while (heap.isNotEmpty) {
          heap.extractMin();
          expect(heap.isValid, isTrue);
        }
      });

      test('should use removeMin as alias for extractMin', () {
        heap.addAll([3, 1, 2]);
        expect(heap.removeMin(), equals(1));
      });
    });

    group('extractMax', () {
      test('should extract maximum element', () {
        heap.addAll([5, 3, 7, 1, 9]);
        expect(heap.extractMax(), equals(9));
        expect(heap.length, equals(4));
      });

      test('should extract elements in descending order', () {
        heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
        final extracted = <int>[];
        while (heap.isNotEmpty) {
          extracted.add(heap.extractMax());
        }
        expect(extracted, equals([9, 8, 7, 6, 5, 4, 3, 2, 1, 0]));
      });

      test('should maintain heap property after extractMax', () {
        heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
        while (heap.isNotEmpty) {
          heap.extractMax();
          expect(heap.isValid, isTrue);
        }
      });

      test('should use removeMax as alias for extractMax', () {
        heap.addAll([3, 1, 2]);
        expect(heap.removeMax(), equals(3));
      });
    });

    group('peekMin and peekMax', () {
      test('should peekMin without removing', () {
        heap.addAll([5, 3, 7]);
        expect(heap.peekMin(), equals(3));
        expect(heap.length, equals(3));
        expect(heap.peekMin(), equals(3));
      });

      test('should peekMax without removing', () {
        heap.addAll([5, 3, 7]);
        expect(heap.peekMax(), equals(7));
        expect(heap.length, equals(3));
        expect(heap.peekMax(), equals(7));
      });

      test('should have O(1) access via min and max properties', () {
        heap.addAll([5, 3, 7, 1, 9, 2, 8]);
        expect(heap.min, equals(1));
        expect(heap.max, equals(9));
      });
    });

    group('properties', () {
      test('should track isEmpty correctly', () {
        expect(heap.isEmpty, isTrue);
        heap.insert(1);
        expect(heap.isEmpty, isFalse);
        heap.extractMin();
        expect(heap.isEmpty, isTrue);
      });

      test('should track isNotEmpty correctly', () {
        expect(heap.isNotEmpty, isFalse);
        heap.insert(1);
        expect(heap.isNotEmpty, isTrue);
        heap.extractMax();
        expect(heap.isNotEmpty, isFalse);
      });

      test('should track length correctly', () {
        expect(heap.length, equals(0));
        heap.insert(1);
        expect(heap.length, equals(1));
        heap.insert(2);
        expect(heap.length, equals(2));
        heap.extractMin();
        expect(heap.length, equals(1));
        heap.extractMax();
        expect(heap.length, equals(0));
      });
    });

    group('addAll', () {
      test('should add all elements from iterable', () {
        heap.addAll([5, 3, 7, 1, 9]);
        expect(heap.length, equals(5));
        expect(heap.min, equals(1));
        expect(heap.max, equals(9));
      });

      test('should maintain heap property after addAll', () {
        heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
        expect(heap.isValid, isTrue);
      });

      test('should add to existing heap', () {
        heap.addAll([5, 3]);
        heap.addAll([1, 9]);
        expect(heap.length, equals(4));
        expect(heap.min, equals(1));
        expect(heap.max, equals(9));
      });
    });

    group('clear', () {
      test('should clear all elements', () {
        heap.addAll([1, 2, 3, 4, 5]);
        heap.clear();
        expect(heap.isEmpty, isTrue);
        expect(heap.length, equals(0));
      });

      test('should be valid after clear', () {
        heap.addAll([1, 2, 3]);
        heap.clear();
        expect(heap.isValid, isTrue);
      });

      test('should allow reuse after clear', () {
        heap.addAll([1, 2, 3]);
        heap.clear();
        heap.insert(5);
        expect(heap.min, equals(5));
        expect(heap.max, equals(5));
      });
    });

    group('toList', () {
      test('should return list of elements', () {
        heap.addAll([5, 3, 7, 1]);
        final list = heap.toList();
        expect(list.length, equals(4));
        expect(list.toSet(), equals({1, 3, 5, 7}));
      });

      test('should not modify heap', () {
        heap.addAll([5, 3, 7, 1]);
        final lengthBefore = heap.length;
        heap.toList();
        expect(heap.length, equals(lengthBefore));
      });

      test('should return independent copy', () {
        heap.addAll([5, 3, 7, 1]);
        final list = heap.toList();
        list.add(100);
        expect(heap.length, equals(4));
      });
    });

    group('toSortedList', () {
      test('should return sorted list', () {
        heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
        expect(heap.toSortedList(), equals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]));
      });

      test('should not modify heap', () {
        heap.addAll([5, 3, 7, 1]);
        final lengthBefore = heap.length;
        final minBefore = heap.min;
        heap.toSortedList();
        expect(heap.length, equals(lengthBefore));
        expect(heap.min, equals(minBefore));
      });

      test('should handle duplicates in sorted output', () {
        heap.addAll([3, 1, 2, 1, 3, 2]);
        expect(heap.toSortedList(), equals([1, 1, 2, 2, 3, 3]));
      });
    });

    group('MinMaxHeap.from factory', () {
      test('should create heap from iterable', () {
        final newHeap = MinMaxHeap.from([5, 3, 7, 1, 4, 6, 8]);
        expect(newHeap.isValid, isTrue);
        expect(newHeap.min, equals(1));
        expect(newHeap.max, equals(8));
      });

      test('should build heap in O(n) using heapify', () {
        final newHeap = MinMaxHeap.from([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
        expect(newHeap.length, equals(10));
        expect(newHeap.isValid, isTrue);
      });

      test('should handle empty iterable', () {
        final newHeap = MinMaxHeap<int>.from([]);
        expect(newHeap.isEmpty, isTrue);
        expect(newHeap.isValid, isTrue);
      });

      test('should handle single element iterable', () {
        final newHeap = MinMaxHeap.from([42]);
        expect(newHeap.min, equals(42));
        expect(newHeap.max, equals(42));
        expect(newHeap.isValid, isTrue);
      });
    });

    group('isValid', () {
      test('should return true for valid heap', () {
        heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
        expect(heap.isValid, isTrue);
      });

      test('should verify min-max levels maintained after operations', () {
        heap.addAll([10, 20, 30, 40, 50, 25, 35, 5, 15]);
        expect(heap.isValid, isTrue);

        for (var i = 0; i < 5; i++) {
          heap.extractMin();
          expect(heap.isValid, isTrue);
        }
      });
    });

    group('edge cases', () {
      group('single element', () {
        test('should handle single element for min and max', () {
          heap.insert(42);
          expect(heap.min, equals(42));
          expect(heap.max, equals(42));
        });

        test('should extract single element from min', () {
          heap.insert(42);
          expect(heap.extractMin(), equals(42));
          expect(heap.isEmpty, isTrue);
        });

        test('should extract single element from max', () {
          heap.insert(42);
          expect(heap.extractMax(), equals(42));
          expect(heap.isEmpty, isTrue);
        });
      });

      group('two elements', () {
        test('should handle two elements correctly', () {
          heap.insert(5);
          heap.insert(3);
          expect(heap.min, equals(3));
          expect(heap.max, equals(5));
        });

        test('should extract min from two elements', () {
          heap.insert(5);
          heap.insert(3);
          expect(heap.extractMin(), equals(3));
          expect(heap.min, equals(5));
          expect(heap.max, equals(5));
        });

        test('should extract max from two elements', () {
          heap.insert(5);
          heap.insert(3);
          expect(heap.extractMax(), equals(5));
          expect(heap.min, equals(3));
          expect(heap.max, equals(3));
        });

        test('should handle two elements in ascending order', () {
          heap.insert(3);
          heap.insert(5);
          expect(heap.min, equals(3));
          expect(heap.max, equals(5));
        });

        test('should handle two equal elements', () {
          heap.insert(5);
          heap.insert(5);
          expect(heap.min, equals(5));
          expect(heap.max, equals(5));
          expect(heap.length, equals(2));
        });
      });

      group('duplicates', () {
        test('should handle duplicate values', () {
          heap.addAll([3, 1, 2, 1, 3, 2]);
          expect(heap.length, equals(6));
          expect(heap.min, equals(1));
          expect(heap.max, equals(3));
          expect(heap.isValid, isTrue);
        });

        test('should extract duplicates correctly from min', () {
          heap.addAll([2, 1, 1, 2]);
          expect(heap.extractMin(), equals(1));
          expect(heap.extractMin(), equals(1));
          expect(heap.extractMin(), equals(2));
          expect(heap.extractMin(), equals(2));
        });

        test('should extract duplicates correctly from max', () {
          heap.addAll([2, 1, 1, 2]);
          expect(heap.extractMax(), equals(2));
          expect(heap.extractMax(), equals(2));
          expect(heap.extractMax(), equals(1));
          expect(heap.extractMax(), equals(1));
        });
      });

      group('all same values', () {
        test('should handle all identical values', () {
          heap.addAll([5, 5, 5, 5, 5]);
          expect(heap.min, equals(5));
          expect(heap.max, equals(5));
          expect(heap.length, equals(5));
          expect(heap.isValid, isTrue);
        });

        test('should extract all identical values via min', () {
          heap.addAll([7, 7, 7]);
          expect(heap.extractMin(), equals(7));
          expect(heap.extractMin(), equals(7));
          expect(heap.extractMin(), equals(7));
          expect(heap.isEmpty, isTrue);
        });

        test('should extract all identical values via max', () {
          heap.addAll([7, 7, 7]);
          expect(heap.extractMax(), equals(7));
          expect(heap.extractMax(), equals(7));
          expect(heap.extractMax(), equals(7));
          expect(heap.isEmpty, isTrue);
        });
      });
    });

    group('alternating extractMin/extractMax', () {
      test('should alternate extractMin and extractMax correctly', () {
        heap.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

        expect(heap.extractMin(), equals(1));
        expect(heap.extractMax(), equals(10));
        expect(heap.extractMin(), equals(2));
        expect(heap.extractMax(), equals(9));
        expect(heap.extractMin(), equals(3));
        expect(heap.extractMax(), equals(8));
        expect(heap.extractMin(), equals(4));
        expect(heap.extractMax(), equals(7));
        expect(heap.extractMin(), equals(5));
        expect(heap.extractMax(), equals(6));
        expect(heap.isEmpty, isTrue);
      });

      test('should maintain heap property during alternating operations', () {
        heap.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

        for (var i = 0; i < 5; i++) {
          heap.extractMin();
          expect(heap.isValid, isTrue);
          heap.extractMax();
          expect(heap.isValid, isTrue);
        }
      });

      test('should handle mixed insert and extract operations', () {
        heap.insert(5);
        heap.insert(3);
        expect(heap.extractMax(), equals(5));
        heap.insert(7);
        expect(heap.extractMin(), equals(3));
        heap.insert(1);
        heap.insert(9);
        expect(heap.min, equals(1));
        expect(heap.max, equals(9));
        expect(heap.isValid, isTrue);
      });
    });

    group('min and max levels maintained', () {
      test('should maintain correct min at root (level 0)', () {
        heap.addAll([50, 25, 75, 10, 30, 60, 80]);
        expect(heap.min, equals(10));
      });

      test('should maintain correct max at level 1', () {
        heap.addAll([50, 25, 75, 10, 30, 60, 80]);
        expect(heap.max, equals(80));
      });

      test('should verify structure after complex operations', () {
        // Insert in specific order to test level maintenance
        for (var i = 1; i <= 15; i++) {
          heap.insert(i);
          expect(heap.isValid, isTrue);
          expect(heap.min, equals(1));
          expect(heap.max, equals(i));
        }
      });

      test('should verify structure with reverse insertions', () {
        for (var i = 15; i >= 1; i--) {
          heap.insert(i);
          expect(heap.isValid, isTrue);
          expect(heap.min, equals(i));
          expect(heap.max, equals(15));
        }
      });
    });

    group('large data sets', () {
      test('should handle 100+ elements', () {
        final elements = List.generate(150, (i) => i);
        elements.shuffle();
        heap.addAll(elements);

        expect(heap.length, equals(150));
        expect(heap.min, equals(0));
        expect(heap.max, equals(149));
        expect(heap.isValid, isTrue);
      });

      test('should extract min correctly from large set', () {
        final elements = List.generate(100, (i) => i);
        elements.shuffle();
        heap.addAll(elements);

        for (var i = 0; i < 100; i++) {
          expect(heap.extractMin(), equals(i));
        }
        expect(heap.isEmpty, isTrue);
      });

      test('should extract max correctly from large set', () {
        final elements = List.generate(100, (i) => i);
        elements.shuffle();
        heap.addAll(elements);

        for (var i = 99; i >= 0; i--) {
          expect(heap.extractMax(), equals(i));
        }
        expect(heap.isEmpty, isTrue);
      });

      test('should build from large set using factory', () {
        final elements = List.generate(200, (i) => i);
        elements.shuffle();
        final largeHeap = MinMaxHeap.from(elements);

        expect(largeHeap.length, equals(200));
        expect(largeHeap.min, equals(0));
        expect(largeHeap.max, equals(199));
        expect(largeHeap.isValid, isTrue);
      });

      test('should handle alternating operations on large set', () {
        final elements = List.generate(100, (i) => i);
        elements.shuffle();
        heap.addAll(elements);

        for (var i = 0; i < 50; i++) {
          expect(heap.extractMin(), equals(i));
          expect(heap.extractMax(), equals(99 - i));
          expect(heap.isValid, isTrue);
        }
        expect(heap.isEmpty, isTrue);
      });

      test('should maintain performance with many operations', () {
        // Insert 500 elements
        for (var i = 0; i < 500; i++) {
          heap.insert(i);
        }
        expect(heap.isValid, isTrue);

        // Alternating extracts
        for (var i = 0; i < 100; i++) {
          heap.extractMin();
          heap.extractMax();
        }
        expect(heap.length, equals(300));
        expect(heap.isValid, isTrue);

        // Clear and rebuild
        heap.clear();
        heap.addAll(List.generate(500, (i) => 500 - i));
        expect(heap.min, equals(1));
        expect(heap.max, equals(500));
        expect(heap.isValid, isTrue);
      });
    });

    group('contains', () {
      test('should find existing element', () {
        heap.addAll([5, 3, 7, 1, 9]);
        expect(heap.contains(5), isTrue);
        expect(heap.contains(1), isTrue);
        expect(heap.contains(9), isTrue);
      });

      test('should not find non-existing element', () {
        heap.addAll([5, 3, 7, 1, 9]);
        expect(heap.contains(10), isFalse);
        expect(heap.contains(0), isFalse);
        expect(heap.contains(100), isFalse);
      });

      test('should return false for empty heap', () {
        expect(heap.contains(5), isFalse);
      });
    });

    group('toString', () {
      test('should show empty heap', () {
        expect(heap.toString(), equals('MinMaxHeap: []'));
      });

      test('should show heap with elements', () {
        heap.addAll([3, 1, 2]);
        final str = heap.toString();
        expect(str, contains('MinMaxHeap:'));
        expect(str, contains('min: 1'));
        expect(str, contains('max: 3'));
      });
    });

    group('toTreeString', () {
      test('should show empty tree', () {
        expect(heap.toTreeString(), equals('(empty)'));
      });

      test('should show tree with elements', () {
        heap.addAll([5, 3, 7, 1]);
        final treeStr = heap.toTreeString();
        expect(treeStr, contains('min'));
        expect(treeStr, contains('max'));
      });
    });

    group('tryPeek operations', () {
      test('should tryPeekMin return value when not empty', () {
        heap.insert(5);
        expect(heap.tryPeekMin(), equals(5));
      });

      test('should tryPeekMax return value when not empty', () {
        heap.insert(5);
        expect(heap.tryPeekMax(), equals(5));
      });

      test('should tryPeekMin return null when empty', () {
        expect(heap.tryPeekMin(), isNull);
      });

      test('should tryPeekMax return null when empty', () {
        expect(heap.tryPeekMax(), isNull);
      });
    });

    group('negative numbers', () {
      test('should handle negative numbers', () {
        heap.addAll([-5, -3, -7, -1, -9]);
        expect(heap.min, equals(-9));
        expect(heap.max, equals(-1));
        expect(heap.isValid, isTrue);
      });

      test('should handle mixed positive and negative', () {
        heap.addAll([-5, 3, -7, 1, 9, -2, 0]);
        expect(heap.min, equals(-7));
        expect(heap.max, equals(9));
        expect(heap.isValid, isTrue);
      });

      test('should extract negative numbers in order', () {
        heap.addAll([-3, -1, -2]);
        expect(heap.extractMin(), equals(-3));
        expect(heap.extractMin(), equals(-2));
        expect(heap.extractMin(), equals(-1));
      });
    });
  });
}
