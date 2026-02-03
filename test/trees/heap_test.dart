import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('Heap (MinHeap)', () {
    late Heap<int> heap;

    setUp(() {
      heap = Heap.minHeap();
    });

    test('should start empty', () {
      expect(heap.isEmpty, isTrue);
      expect(heap.length, equals(0));
    });

    test('should insert elements', () {
      heap.insert(5);
      heap.insert(3);
      heap.insert(7);
      expect(heap.length, equals(3));
      expect(heap.isNotEmpty, isTrue);
    });

    test('should maintain min at root', () {
      heap.insert(5);
      heap.insert(3);
      heap.insert(7);
      heap.insert(1);
      expect(heap.peek, equals(1));
    });

    test('should extract minimum', () {
      heap.insert(5);
      heap.insert(3);
      heap.insert(7);
      heap.insert(1);
      expect(heap.extract(), equals(1));
      expect(heap.extract(), equals(3));
      expect(heap.extract(), equals(5));
      expect(heap.extract(), equals(7));
      expect(heap.isEmpty, isTrue);
    });

    test('should throw on extract from empty', () {
      expect(() => heap.extract(), throwsStateError);
    });

    test('should throw on peek from empty', () {
      expect(() => heap.peek, throwsStateError);
    });

    test('should tryPeek return null for empty', () {
      expect(heap.tryPeek(), isNull);
    });

    test('should tryExtract return null for empty', () {
      expect(heap.tryExtract(), isNull);
    });

    test('should replace root', () {
      heap.insert(5);
      heap.insert(3);
      heap.insert(7);
      final old = heap.replace(1);
      expect(old, equals(3));
      expect(heap.peek, equals(1));
    });

    test('should check contains', () {
      heap.insert(5);
      heap.insert(3);
      heap.insert(7);
      expect(heap.contains(5), isTrue);
      expect(heap.contains(10), isFalse);
    });

    test('should maintain heap property', () {
      heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
      expect(heap.isValid, isTrue);

      while (heap.isNotEmpty) {
        heap.extract();
        expect(heap.isValid, isTrue);
      }
    });

    test('should extractAll in sorted order', () {
      heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
      expect(heap.extractAll(), equals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]));
      expect(heap.isEmpty, isTrue);
    });

    test('should toSortedList without emptying', () {
      heap.addAll([5, 3, 7, 1]);
      expect(heap.toSortedList(), equals([1, 3, 5, 7]));
    });

    test('should clear', () {
      heap.addAll([1, 2, 3]);
      heap.clear();
      expect(heap.isEmpty, isTrue);
    });

    test('should create from iterable (heapify)', () {
      final newHeap = Heap.from([5, 3, 7, 1, 4, 6, 8]);
      expect(newHeap.isValid, isTrue);
      expect(newHeap.peek, equals(1));
    });

    test('should merge heaps', () {
      heap.addAll([1, 3, 5]);
      final other = Heap<int>.from([2, 4, 6]);
      heap.merge(other);
      expect(heap.length, equals(6));
      expect(heap.isValid, isTrue);
      expect(heap.extractAll(), equals([1, 2, 3, 4, 5, 6]));
    });
  });

  group('Heap (MaxHeap)', () {
    late Heap<int> heap;

    setUp(() {
      heap = Heap.maxHeap();
    });

    test('should maintain max at root', () {
      heap.insert(5);
      heap.insert(3);
      heap.insert(7);
      heap.insert(1);
      expect(heap.peek, equals(7));
    });

    test('should extract maximum', () {
      heap.addAll([5, 3, 7, 1, 9]);
      expect(heap.extract(), equals(9));
      expect(heap.extract(), equals(7));
      expect(heap.extract(), equals(5));
    });

    test('should extractAll in descending order', () {
      heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
      expect(heap.extractAll(), equals([9, 8, 7, 6, 5, 4, 3, 2, 1, 0]));
    });

    test('should maintain heap property', () {
      heap.addAll([5, 3, 7, 1, 4, 6, 8, 2, 9, 0]);
      expect(heap.isValid, isTrue);
    });

    test('should create from iterable', () {
      final newHeap = Heap.from([5, 3, 7, 1, 4, 6, 8], type: HeapType.max);
      expect(newHeap.isValid, isTrue);
      expect(newHeap.peek, equals(8));
    });
  });

  group('PriorityQueue', () {
    late PriorityQueue<int> queue;

    setUp(() {
      queue = PriorityQueue<int>();
    });

    test('should start empty', () {
      expect(queue.isEmpty, isTrue);
      expect(queue.length, equals(0));
    });

    test('should enqueue and dequeue by priority', () {
      queue.enqueue(5);
      queue.enqueue(3);
      queue.enqueue(7);
      queue.enqueue(1);

      expect(queue.dequeue(), equals(1));
      expect(queue.dequeue(), equals(3));
      expect(queue.dequeue(), equals(5));
      expect(queue.dequeue(), equals(7));
    });

    test('should peek at highest priority', () {
      queue.enqueue(5);
      queue.enqueue(3);
      queue.enqueue(7);
      expect(queue.peek(), equals(3));
      expect(queue.length, equals(3)); // peek doesn't remove
    });

    test('should tryPeek return null for empty', () {
      expect(queue.tryPeek(), isNull);
    });

    test('should tryDequeue return null for empty', () {
      expect(queue.tryDequeue(), isNull);
    });

    test('should check contains', () {
      queue.enqueue(5);
      queue.enqueue(3);
      expect(queue.contains(5), isTrue);
      expect(queue.contains(10), isFalse);
    });

    test('should clear', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.clear();
      expect(queue.isEmpty, isTrue);
    });

    test('should toSortedList', () {
      queue.enqueue(5);
      queue.enqueue(3);
      queue.enqueue(7);
      queue.enqueue(1);
      expect(queue.toSortedList(), equals([1, 3, 5, 7]));
    });

    test('should create max priority queue', () {
      final maxQueue = PriorityQueue<int>.maxPriority();
      maxQueue.enqueue(5);
      maxQueue.enqueue(3);
      maxQueue.enqueue(7);
      expect(maxQueue.dequeue(), equals(7));
      expect(maxQueue.dequeue(), equals(5));
    });

    test('should create from iterable', () {
      final newQueue = PriorityQueue.from([5, 3, 7, 1, 4]);
      expect(newQueue.dequeue(), equals(1));
      expect(newQueue.dequeue(), equals(3));
    });
  });
}
