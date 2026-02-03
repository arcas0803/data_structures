/// # Queue
///
/// A First-In-First-Out (FIFO) data structure.
/// Elements are added at the rear and removed from the front.
///
/// Time Complexity:
/// - Enqueue: O(1)
/// - Dequeue: O(1) amortized
/// - Peek: O(1)
/// - Search: O(n)
library;

import 'doubly_linked_list.dart';

/// A queue (FIFO) data structure implemented with a doubly linked list.
class Queue<T> {
  final DoublyLinkedList<T> _list = DoublyLinkedList<T>();

  /// Creates an empty queue.
  Queue();

  /// Creates a queue from an iterable.
  /// The first element of the iterable is at the front of the queue.
  factory Queue.from(Iterable<T> elements) {
    final queue = Queue<T>();
    for (final element in elements) {
      queue.enqueue(element);
    }
    return queue;
  }

  /// Returns the number of elements in the queue.
  int get length => _list.length;

  /// Returns true if the queue is empty.
  bool get isEmpty => _list.isEmpty;

  /// Returns true if the queue is not empty.
  bool get isNotEmpty => _list.isNotEmpty;

  /// Returns the front element without removing it. O(1)
  /// Throws [StateError] if the queue is empty.
  T get front {
    if (_list.isEmpty) {
      throw StateError('Cannot get front of empty queue');
    }
    return _list.first;
  }

  /// Returns the rear element without removing it. O(1)
  /// Throws [StateError] if the queue is empty.
  T get rear {
    if (_list.isEmpty) {
      throw StateError('Cannot get rear of empty queue');
    }
    return _list.last;
  }

  /// Adds an element to the rear of the queue. O(1)
  void enqueue(T value) {
    _list.addLast(value);
  }

  /// Alias for [enqueue].
  void add(T value) => enqueue(value);

  /// Removes and returns the front element. O(1)
  /// Throws [StateError] if the queue is empty.
  T dequeue() {
    if (_list.isEmpty) {
      throw StateError('Cannot dequeue from empty queue');
    }
    return _list.removeFirst();
  }

  /// Returns the front element without removing it. O(1)
  /// Throws [StateError] if the queue is empty.
  T peek() => front;

  /// Returns the front element without removing it, or null if empty. O(1)
  T? tryPeek() {
    if (_list.isEmpty) return null;
    return _list.first;
  }

  /// Removes and returns the front element, or null if empty. O(1)
  T? tryDequeue() {
    if (_list.isEmpty) return null;
    return _list.removeFirst();
  }

  /// Returns true if the queue contains [value]. O(n)
  bool contains(T value) => _list.contains(value);

  /// Removes all elements from the queue. O(1)
  void clear() {
    _list.clear();
  }

  /// Converts the queue to a Dart List. O(n)
  /// The first element of the list is the front of the queue.
  List<T> toList() => _list.toList();

  /// Returns an iterator over the elements from front to rear.
  Iterable<T> get values => _list.values;

  @override
  String toString() {
    if (_list.isEmpty) return 'Queue: [] (empty)';
    return 'Queue: [${_list.toList().join(' <- ')}] (front first)';
  }
}

/// A double-ended queue (Deque) data structure.
/// Elements can be added and removed from both ends.
class Deque<T> {
  final DoublyLinkedList<T> _list = DoublyLinkedList<T>();

  /// Creates an empty deque.
  Deque();

  /// Creates a deque from an iterable.
  factory Deque.from(Iterable<T> elements) {
    final deque = Deque<T>();
    for (final element in elements) {
      deque.addLast(element);
    }
    return deque;
  }

  /// Returns the number of elements in the deque.
  int get length => _list.length;

  /// Returns true if the deque is empty.
  bool get isEmpty => _list.isEmpty;

  /// Returns true if the deque is not empty.
  bool get isNotEmpty => _list.isNotEmpty;

  /// Returns the first element. O(1)
  T get first => _list.first;

  /// Returns the last element. O(1)
  T get last => _list.last;

  /// Adds an element at the front. O(1)
  void addFirst(T value) => _list.addFirst(value);

  /// Adds an element at the end. O(1)
  void addLast(T value) => _list.addLast(value);

  /// Removes and returns the first element. O(1)
  T removeFirst() => _list.removeFirst();

  /// Removes and returns the last element. O(1)
  T removeLast() => _list.removeLast();

  /// Returns the first element, or null if empty. O(1)
  T? peekFirst() => _list.isEmpty ? null : _list.first;

  /// Returns the last element, or null if empty. O(1)
  T? peekLast() => _list.isEmpty ? null : _list.last;

  /// Returns true if the deque contains [value]. O(n)
  bool contains(T value) => _list.contains(value);

  /// Removes all elements from the deque. O(1)
  void clear() => _list.clear();

  /// Converts the deque to a Dart List. O(n)
  List<T> toList() => _list.toList();

  @override
  String toString() {
    if (_list.isEmpty) return 'Deque: [] (empty)';
    return 'Deque: [${_list.toList().join(' | ')}]';
  }
}
