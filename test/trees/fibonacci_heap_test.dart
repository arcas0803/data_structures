import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('FibonacciHeap (MinHeap)', () {
    late FibonacciHeap<int> heap;

    setUp(() {
      heap = FibonacciHeap.minHeap();
    });

    group('Empty heap operations', () {
      test('should start empty', () {
        expect(heap.isEmpty, isTrue);
        expect(heap.isNotEmpty, isFalse);
        expect(heap.length, equals(0));
      });

      test('should throw on peek from empty', () {
        expect(() => heap.peek, throwsStateError);
      });

      test('should throw on min from empty', () {
        expect(() => heap.min, throwsStateError);
      });

      test('should throw on extractMin from empty', () {
        expect(() => heap.extractMin(), throwsStateError);
      });

      test('peekMin should return null for empty', () {
        expect(heap.peekMin, isNull);
      });

      test('peekMax should return null for min-heap', () {
        expect(heap.peekMax, isNull);
      });

      test('values should return empty list for empty heap', () {
        expect(heap.values, isEmpty);
      });

      test('extractAll should return empty list for empty heap', () {
        expect(heap.extractAll(), isEmpty);
      });

      test('clear on empty heap should not throw', () {
        expect(() => heap.clear(), returnsNormally);
      });
    });

    group('Factory constructors', () {
      test('minHeap() creates a min-heap', () {
        final minHeap = FibonacciHeap<int>.minHeap();
        minHeap.insert(5);
        minHeap.insert(3);
        minHeap.insert(7);
        expect(minHeap.peek, equals(3));
      });

      test('maxHeap() creates a max-heap', () {
        final maxHeap = FibonacciHeap<int>.maxHeap();
        maxHeap.insert(5);
        maxHeap.insert(3);
        maxHeap.insert(7);
        expect(maxHeap.peek, equals(7));
      });

      test('default constructor creates min-heap', () {
        final defaultHeap = FibonacciHeap<int>();
        defaultHeap.insert(5);
        defaultHeap.insert(3);
        expect(defaultHeap.peek, equals(3));
      });
    });

    group('Insert operations', () {
      test('insert returns a node', () {
        final node = heap.insert(5);
        expect(node, isA<FibonacciHeapNode<int>>());
        expect(node.value, equals(5));
      });

      test('single insert updates length', () {
        heap.insert(5);
        expect(heap.length, equals(1));
        expect(heap.isEmpty, isFalse);
        expect(heap.isNotEmpty, isTrue);
      });

      test('multiple inserts update length correctly', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        expect(heap.length, equals(3));
      });

      test('insert maintains min at root', () {
        heap.insert(5);
        expect(heap.peek, equals(5));
        heap.insert(3);
        expect(heap.peek, equals(3));
        heap.insert(7);
        expect(heap.peek, equals(3));
        heap.insert(1);
        expect(heap.peek, equals(1));
      });

      test('insert same value multiple times', () {
        heap.insert(5);
        heap.insert(5);
        heap.insert(5);
        expect(heap.length, equals(3));
        expect(heap.peek, equals(5));
      });
    });

    group('ExtractMin operations', () {
      test('extractMin returns minimum value', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        expect(heap.extractMin(), equals(1));
      });

      test('extractMin removes element', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        expect(heap.length, equals(3));
        heap.extractMin();
        expect(heap.length, equals(2));
      });

      test('extractMin returns elements in sorted order', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        heap.insert(4);
        expect(heap.extractMin(), equals(1));
        expect(heap.extractMin(), equals(3));
        expect(heap.extractMin(), equals(4));
        expect(heap.extractMin(), equals(5));
        expect(heap.extractMin(), equals(7));
        expect(heap.isEmpty, isTrue);
      });

      test('extractMin with single element', () {
        heap.insert(42);
        expect(heap.extractMin(), equals(42));
        expect(heap.isEmpty, isTrue);
      });
    });

    group('Peek operations', () {
      test('peek returns min without removing', () {
        heap.insert(5);
        heap.insert(3);
        expect(heap.peek, equals(3));
        expect(heap.length, equals(2));
        expect(heap.peek, equals(3)); // Still there
      });

      test('min getter works for min-heap', () {
        heap.insert(5);
        heap.insert(3);
        expect(heap.min, equals(3));
      });

      test('max getter throws for min-heap', () {
        heap.insert(5);
        expect(() => heap.max, throwsStateError);
      });

      test('peekMin returns min for min-heap', () {
        heap.insert(5);
        heap.insert(3);
        expect(heap.peekMin, equals(3));
      });
    });

    group('DecreaseKey operations', () {
      test('decreaseKey updates node value', () {
        final node = heap.insert(10);
        heap.decreaseKey(node, 5);
        expect(node.value, equals(5));
      });

      test('decreaseKey updates min if new value is smaller', () {
        heap.insert(5);
        final node = heap.insert(10);
        heap.decreaseKey(node, 3);
        expect(heap.peek, equals(3));
      });

      test('decreaseKey to same value is allowed', () {
        final node = heap.insert(5);
        expect(() => heap.decreaseKey(node, 5), returnsNormally);
      });

      test('decreaseKey throws if new value is larger', () {
        final node = heap.insert(5);
        expect(() => heap.decreaseKey(node, 10), throwsArgumentError);
      });

      test('decreaseKey on root node', () {
        final node = heap.insert(5);
        heap.insert(10);
        heap.decreaseKey(node, 3);
        expect(heap.peek, equals(3));
      });

      test('decreaseKey triggers cut when heap property violated', () {
        // Build a heap with parent-child relationship via extraction
        heap.insert(1);
        heap.insert(2);
        heap.insert(3);
        heap.insert(4);
        final node5 = heap.insert(5);
        heap.extractMin(); // Triggers consolidation

        // Decrease key to value smaller than potential parent
        heap.decreaseKey(node5, 0);
        expect(heap.peek, equals(0));
      });

      test('multiple decreaseKey operations maintain heap property', () {
        final nodes = <FibonacciHeapNode<int>>[];
        for (var i = 10; i < 20; i++) {
          nodes.add(heap.insert(i));
        }

        // Extract to consolidate
        heap.extractMin();

        // Decrease keys
        heap.decreaseKey(nodes[5], 5);
        heap.decreaseKey(nodes[3], 3);
        heap.decreaseKey(nodes[7], 1);

        expect(heap.peek, equals(1));

        // Verify sorted extraction
        final sorted = heap.extractAll();
        for (var i = 1; i < sorted.length; i++) {
          expect(sorted[i], greaterThanOrEqualTo(sorted[i - 1]));
        }
      });
    });

    group('Delete operations', () {
      test('delete removes a node', () {
        final node = heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        expect(heap.length, equals(3));
        heap.delete(node);
        expect(heap.length, equals(2));
        expect(heap.values, isNot(contains(5)));
      });

      test('delete minimum node', () {
        heap.insert(5);
        final minNode = heap.insert(1);
        heap.insert(7);
        heap.delete(minNode);
        expect(heap.peek, equals(5));
      });

      test('delete single element', () {
        final node = heap.insert(5);
        heap.delete(node);
        expect(heap.isEmpty, isTrue);
      });

      test('delete non-root node', () {
        heap.insert(1);
        heap.insert(2);
        final node = heap.insert(5);
        heap.insert(3);
        heap.extractMin(); // Consolidate

        heap.delete(node);
        expect(heap.values, isNot(contains(5)));
      });
    });

    group('Merge operations', () {
      test('merge two non-empty heaps', () {
        heap.insert(1);
        heap.insert(3);
        heap.insert(5);

        final other = FibonacciHeap<int>.minHeap();
        other.insert(2);
        other.insert(4);
        other.insert(6);

        heap.merge(other);

        expect(heap.length, equals(6));
        expect(heap.peek, equals(1));
        expect(heap.extractAll(), equals([1, 2, 3, 4, 5, 6]));
      });

      test('merge with empty heap', () {
        heap.insert(1);
        heap.insert(3);

        final empty = FibonacciHeap<int>.minHeap();
        heap.merge(empty);

        expect(heap.length, equals(2));
        expect(heap.peek, equals(1));
      });

      test('merge empty heap with non-empty', () {
        final other = FibonacciHeap<int>.minHeap();
        other.insert(1);
        other.insert(3);

        heap.merge(other);

        expect(heap.length, equals(2));
        expect(heap.peek, equals(1));
      });

      test('merge updates min if other has smaller', () {
        heap.insert(5);
        heap.insert(7);

        final other = FibonacciHeap<int>.minHeap();
        other.insert(1);
        other.insert(3);

        heap.merge(other);
        expect(heap.peek, equals(1));
      });

      test('merge clears the other heap', () {
        heap.insert(1);

        final other = FibonacciHeap<int>.minHeap();
        other.insert(2);

        heap.merge(other);

        expect(other.isEmpty, isTrue);
        expect(other.length, equals(0));
      });

      test('merge throws for different heap types', () {
        heap.insert(1);

        final maxHeap = FibonacciHeap<int>.maxHeap();
        maxHeap.insert(2);

        expect(() => heap.merge(maxHeap), throwsArgumentError);
      });
    });

    group('Clear operations', () {
      test('clear empties the heap', () {
        heap.insert(1);
        heap.insert(2);
        heap.insert(3);
        heap.clear();
        expect(heap.isEmpty, isTrue);
        expect(heap.length, equals(0));
      });

      test('heap is usable after clear', () {
        heap.insert(1);
        heap.clear();
        heap.insert(5);
        expect(heap.peek, equals(5));
      });
    });

    group('Edge cases', () {
      test('single element heap', () {
        heap.insert(42);
        expect(heap.length, equals(1));
        expect(heap.peek, equals(42));
        expect(heap.extractMin(), equals(42));
        expect(heap.isEmpty, isTrue);
      });

      test('duplicate values', () {
        heap.insert(5);
        heap.insert(5);
        heap.insert(3);
        heap.insert(3);
        heap.insert(7);

        expect(heap.extractMin(), equals(3));
        expect(heap.extractMin(), equals(3));
        expect(heap.extractMin(), equals(5));
        expect(heap.extractMin(), equals(5));
        expect(heap.extractMin(), equals(7));
      });

      test('negative values', () {
        heap.insert(-5);
        heap.insert(0);
        heap.insert(5);
        heap.insert(-10);

        expect(heap.extractMin(), equals(-10));
        expect(heap.extractMin(), equals(-5));
        expect(heap.extractMin(), equals(0));
        expect(heap.extractMin(), equals(5));
      });

      test('alternating insert and extract', () {
        heap.insert(5);
        expect(heap.extractMin(), equals(5));
        heap.insert(3);
        heap.insert(7);
        expect(heap.extractMin(), equals(3));
        heap.insert(1);
        expect(heap.extractMin(), equals(1));
        expect(heap.extractMin(), equals(7));
        expect(heap.isEmpty, isTrue);
      });
    });

    group('Heap property maintenance', () {
      test('heap property maintained after multiple operations', () {
        for (var i = 0; i < 20; i++) {
          heap.insert(i);
        }

        // Extract half
        for (var i = 0; i < 10; i++) {
          heap.extractMin();
        }

        // Verify remaining elements come out in order
        var prev = heap.extractMin();
        while (heap.isNotEmpty) {
          final curr = heap.extractMin();
          expect(curr, greaterThanOrEqualTo(prev));
          prev = curr;
        }
      });

      test('values property returns all elements', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);

        final values = heap.values;
        expect(values.length, equals(4));
        expect(values, containsAll([1, 3, 5, 7]));
      });

      test('extractAll returns sorted list', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        heap.insert(4);

        expect(heap.extractAll(), equals([1, 3, 4, 5, 7]));
        expect(heap.isEmpty, isTrue);
      });
    });

    group('Stress tests', () {
      test('many inserts followed by decreaseKey and extracts', () {
        final nodes = <FibonacciHeapNode<int>>[];
        const n = 100;

        // Insert n elements
        for (var i = 0; i < n; i++) {
          nodes.add(heap.insert(i * 10));
        }
        expect(heap.length, equals(n));

        // Extract some to consolidate
        for (var i = 0; i < 10; i++) {
          heap.extractMin();
        }

        // Decrease some keys
        for (var i = 50; i < 60; i++) {
          heap.decreaseKey(nodes[i], i - 100); // Make them negative
        }

        // Extract all and verify sorted
        final result = heap.extractAll();
        for (var i = 1; i < result.length; i++) {
          expect(result[i], greaterThanOrEqualTo(result[i - 1]));
        }
      });

      test('large number of random operations', () {
        final nodes = <FibonacciHeapNode<int>>[];

        // Insert 200 elements
        for (var i = 0; i < 200; i++) {
          nodes.add(heap.insert((i * 7) % 100));
        }

        // Extract 50
        for (var i = 0; i < 50; i++) {
          heap.extractMin();
        }

        // Verify remaining elements extract in order
        var prev = heap.extractMin();
        while (heap.isNotEmpty) {
          final curr = heap.extractMin();
          expect(curr, greaterThanOrEqualTo(prev));
          prev = curr;
        }
      });

      test('cascading cuts work correctly', () {
        // Insert elements to create a deep structure
        final nodes = <FibonacciHeapNode<int>>[];
        for (var i = 1; i <= 20; i++) {
          nodes.add(heap.insert(i * 10));
        }

        // Consolidate by extracting
        heap.extractMin();
        heap.extractMin();

        // Decrease keys to trigger cascading cuts
        heap.decreaseKey(nodes[10], 5);
        heap.decreaseKey(nodes[15], 3);
        heap.decreaseKey(nodes[18], 1);

        expect(heap.peek, equals(1));

        // Verify all extractions are sorted
        final result = heap.extractAll();
        for (var i = 1; i < result.length; i++) {
          expect(result[i], greaterThanOrEqualTo(result[i - 1]));
        }
      });
    });

    group('Comparison with regular heap behavior', () {
      test('FibonacciHeap produces same sorted output as regular Heap', () {
        final fibHeap = FibonacciHeap<int>.minHeap();
        final regularHeap = Heap<int>.minHeap();

        final values = [15, 3, 17, 8, 25, 1, 14, 7, 20, 2];

        for (final v in values) {
          fibHeap.insert(v);
          regularHeap.insert(v);
        }

        final fibResult = fibHeap.extractAll();
        final regularResult = regularHeap.extractAll();

        expect(fibResult, equals(regularResult));
      });

      test('both heaps handle duplicates the same way', () {
        final fibHeap = FibonacciHeap<int>.minHeap();
        final regularHeap = Heap<int>.minHeap();

        final values = [5, 3, 5, 7, 3, 1, 5];

        for (final v in values) {
          fibHeap.insert(v);
          regularHeap.insert(v);
        }

        final fibResult = fibHeap.extractAll();
        final regularResult = regularHeap.extractAll();

        expect(fibResult, equals(regularResult));
      });
    });

    group('String representation', () {
      test('toString for empty heap', () {
        expect(heap.toString(), contains('FibonacciMinHeap'));
        expect(heap.toString(), contains('[]'));
      });

      test('toString for non-empty heap', () {
        heap.insert(5);
        heap.insert(3);
        final str = heap.toString();
        expect(str, contains('FibonacciMinHeap'));
        expect(str, contains('3'));
        expect(str, contains('5'));
      });

      test('toTreeString for empty heap', () {
        expect(heap.toTreeString(), equals('(empty)'));
      });

      test('toTreeString for non-empty heap', () {
        heap.insert(5);
        heap.insert(3);
        final treeStr = heap.toTreeString();
        expect(treeStr, contains('Roots'));
      });
    });
  });

  group('FibonacciHeap (MaxHeap)', () {
    late FibonacciHeap<int> heap;

    setUp(() {
      heap = FibonacciHeap.maxHeap();
    });

    group('Basic operations', () {
      test('should maintain max at root', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        expect(heap.peek, equals(7));
      });

      test('max getter works for max-heap', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        expect(heap.max, equals(7));
      });

      test('min getter throws for max-heap', () {
        heap.insert(5);
        expect(() => heap.min, throwsStateError);
      });

      test('peekMax returns max for max-heap', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        expect(heap.peekMax, equals(7));
      });

      test('peekMin returns null for max-heap', () {
        heap.insert(5);
        expect(heap.peekMin, isNull);
      });

      test('extractMax returns maximum value', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        expect(heap.extractMax(), equals(7));
      });

      test('extractMin throws for max-heap', () {
        heap.insert(5);
        expect(() => heap.extractMin(), throwsStateError);
      });

      test('extractMax returns elements in descending order', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        heap.insert(9);
        expect(heap.extractMax(), equals(9));
        expect(heap.extractMax(), equals(7));
        expect(heap.extractMax(), equals(5));
        expect(heap.extractMax(), equals(3));
        expect(heap.extractMax(), equals(1));
      });
    });

    group('DecreaseKey for max-heap (actually increaseKey)', () {
      test('increaseKey updates node value', () {
        final node = heap.insert(5);
        heap.decreaseKey(node, 10); // For max-heap, this increases the key
        expect(node.value, equals(10));
      });

      test('increaseKey updates max if new value is larger', () {
        heap.insert(5);
        final node = heap.insert(3);
        heap.decreaseKey(node, 10);
        expect(heap.peek, equals(10));
      });

      test('decreaseKey throws if new value is smaller (for max-heap)', () {
        final node = heap.insert(10);
        expect(() => heap.decreaseKey(node, 5), throwsArgumentError);
      });
    });

    group('Merge max-heaps', () {
      test('merge two max-heaps', () {
        heap.insert(5);
        heap.insert(3);

        final other = FibonacciHeap<int>.maxHeap();
        other.insert(7);
        other.insert(1);

        heap.merge(other);

        expect(heap.length, equals(4));
        expect(heap.peek, equals(7));
        expect(heap.extractAll(), equals([7, 5, 3, 1]));
      });
    });

    group('Heap property maintenance', () {
      test('extractAll returns descending order', () {
        heap.insert(5);
        heap.insert(3);
        heap.insert(7);
        heap.insert(1);
        heap.insert(9);
        expect(heap.extractAll(), equals([9, 7, 5, 3, 1]));
      });

      test('heap property after stress operations', () {
        for (var i = 0; i < 50; i++) {
          heap.insert(i);
        }

        // Extract some
        for (var i = 0; i < 25; i++) {
          heap.extractMax();
        }

        // Verify remaining extract in order
        var prev = heap.extractMax();
        while (heap.isNotEmpty) {
          final curr = heap.extractMax();
          expect(curr, lessThanOrEqualTo(prev));
          prev = curr;
        }
      });
    });

    group('String representation', () {
      test('toString shows FibonacciMaxHeap', () {
        heap.insert(5);
        expect(heap.toString(), contains('FibonacciMaxHeap'));
      });
    });
  });

  group('FibonacciHeapNode', () {
    test('node toString shows value', () {
      final node = FibonacciHeapNode<int>(42);
      expect(node.toString(), equals('FibonacciHeapNode(42)'));
    });

    test('new node is self-referential in circular list', () {
      final node = FibonacciHeapNode<int>(5);
      expect(node.left, same(node));
      expect(node.right, same(node));
    });

    test('new node has no parent or child', () {
      final node = FibonacciHeapNode<int>(5);
      expect(node.parent, isNull);
      expect(node.child, isNull);
    });

    test('new node has degree 0', () {
      final node = FibonacciHeapNode<int>(5);
      expect(node.degree, equals(0));
    });

    test('new node is not marked', () {
      final node = FibonacciHeapNode<int>(5);
      expect(node.marked, isFalse);
    });
  });

  group('FibonacciHeap with custom Comparable types', () {
    test('works with String', () {
      final heap = FibonacciHeap<String>.minHeap();
      heap.insert('banana');
      heap.insert('apple');
      heap.insert('cherry');

      expect(heap.extractMin(), equals('apple'));
      expect(heap.extractMin(), equals('banana'));
      expect(heap.extractMin(), equals('cherry'));
    });

    test('works with double', () {
      final heap = FibonacciHeap<double>.minHeap();
      heap.insert(3.14);
      heap.insert(2.71);
      heap.insert(1.41);

      expect(heap.extractMin(), equals(1.41));
      expect(heap.extractMin(), equals(2.71));
      expect(heap.extractMin(), equals(3.14));
    });
  });
}
