import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('Queue', () {
    late Queue<int> queue;

    setUp(() {
      queue = Queue<int>();
    });

    test('should start empty', () {
      expect(queue.isEmpty, isTrue);
      expect(queue.length, equals(0));
    });

    test('should enqueue elements', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.enqueue(3);
      expect(queue.length, equals(3));
      expect(queue.isNotEmpty, isTrue);
    });

    test('should dequeue elements in FIFO order', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.enqueue(3);
      expect(queue.dequeue(), equals(1));
      expect(queue.dequeue(), equals(2));
      expect(queue.dequeue(), equals(3));
      expect(queue.isEmpty, isTrue);
    });

    test('should peek at front element', () {
      queue.enqueue(1);
      queue.enqueue(2);
      expect(queue.peek(), equals(1));
      expect(queue.length, equals(2)); // peek doesn't remove
    });

    test('should get front and rear', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.enqueue(3);
      expect(queue.front, equals(1));
      expect(queue.rear, equals(3));
    });

    test('should throw on dequeue from empty queue', () {
      expect(() => queue.dequeue(), throwsStateError);
    });

    test('should throw on peek from empty queue', () {
      expect(() => queue.front, throwsStateError);
    });

    test('should tryDequeue return null for empty queue', () {
      expect(queue.tryDequeue(), isNull);
    });

    test('should tryPeek return null for empty queue', () {
      expect(queue.tryPeek(), isNull);
    });

    test('should check contains', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.enqueue(3);
      expect(queue.contains(2), isTrue);
      expect(queue.contains(5), isFalse);
    });

    test('should clear the queue', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.clear();
      expect(queue.isEmpty, isTrue);
    });

    test('should convert to list', () {
      queue.enqueue(1);
      queue.enqueue(2);
      queue.enqueue(3);
      expect(queue.toList(), equals([1, 2, 3]));
    });

    test('should create from iterable', () {
      final newQueue = Queue.from([1, 2, 3]);
      expect(newQueue.dequeue(), equals(1));
      expect(newQueue.dequeue(), equals(2));
    });
  });

  group('Deque', () {
    late Deque<int> deque;

    setUp(() {
      deque = Deque<int>();
    });

    test('should start empty', () {
      expect(deque.isEmpty, isTrue);
      expect(deque.length, equals(0));
    });

    test('should add at both ends', () {
      deque.addFirst(2);
      deque.addFirst(1);
      deque.addLast(3);
      deque.addLast(4);
      expect(deque.toList(), equals([1, 2, 3, 4]));
    });

    test('should remove from both ends', () {
      deque.addLast(1);
      deque.addLast(2);
      deque.addLast(3);
      expect(deque.removeFirst(), equals(1));
      expect(deque.removeLast(), equals(3));
      expect(deque.toList(), equals([2]));
    });

    test('should peek at both ends', () {
      deque.addLast(1);
      deque.addLast(2);
      deque.addLast(3);
      expect(deque.peekFirst(), equals(1));
      expect(deque.peekLast(), equals(3));
    });

    test('should return null for empty peek', () {
      expect(deque.peekFirst(), isNull);
      expect(deque.peekLast(), isNull);
    });

    test('should check contains', () {
      deque.addLast(1);
      deque.addLast(2);
      expect(deque.contains(1), isTrue);
      expect(deque.contains(5), isFalse);
    });

    test('should clear the deque', () {
      deque.addLast(1);
      deque.addLast(2);
      deque.clear();
      expect(deque.isEmpty, isTrue);
    });

    test('should create from iterable', () {
      final newDeque = Deque.from([1, 2, 3]);
      expect(newDeque.toList(), equals([1, 2, 3]));
    });
  });
}
