/// # Circular Linked Lists
///
/// Circular linked list implementations where the last node points back to
/// the first node, forming a continuous loop.
///
/// Includes:
/// - [CircularLinkedList]: Singly circular linked list
/// - [CircularDoublyLinkedList]: Doubly circular linked list
///
/// Time Complexity:
/// - Access: O(n)
/// - Search: O(n)
/// - Insertion at head/tail: O(1) for doubly, O(n) for singly
/// - Deletion at head: O(1)
/// - Rotation: O(steps) for singly, O(1) pointer update for doubly
library;

// ============================================================================
// Circular Singly Linked List
// ============================================================================

/// Node for the circular singly linked list.
class CircularLinkedListNode<T> {
  /// The value stored in this node.
  T value;

  /// Reference to the next node (never null in a valid circular list).
  CircularLinkedListNode<T>? next;

  /// Creates a new node with the given [value].
  CircularLinkedListNode(this.value, [this.next]);

  @override
  String toString() => 'Node($value)';
}

/// A singly circular linked list where the last node points back to the head.
class CircularLinkedList<T> {
  CircularLinkedListNode<T>? _head;
  CircularLinkedListNode<T>? _tail;
  int _length = 0;

  /// Creates an empty circular linked list.
  CircularLinkedList();

  /// Creates a circular linked list from an iterable.
  factory CircularLinkedList.from(Iterable<T> elements) {
    final list = CircularLinkedList<T>();
    for (final element in elements) {
      list.addLast(element);
    }
    return list;
  }

  /// Returns the first node of the list.
  CircularLinkedListNode<T>? get head => _head;

  /// Returns the last node of the list.
  CircularLinkedListNode<T>? get tail => _tail;

  /// Returns the number of elements in the list.
  int get length => _length;

  /// Returns true if the list is empty.
  bool get isEmpty => _head == null;

  /// Returns true if the list is not empty.
  bool get isNotEmpty => _head != null;

  /// Returns the first element of the list.
  /// Throws [StateError] if the list is empty.
  T get first {
    if (_head == null) {
      throw StateError('Cannot get first element of empty list');
    }
    return _head!.value;
  }

  /// Returns the last element of the list.
  /// Throws [StateError] if the list is empty.
  T get last {
    if (_tail == null) {
      throw StateError('Cannot get last element of empty list');
    }
    return _tail!.value;
  }

  /// Adds an element at the beginning of the list. O(1)
  void addFirst(T value) {
    final newNode = CircularLinkedListNode(value);
    if (_head == null) {
      _head = newNode;
      _tail = newNode;
      newNode.next = newNode;
    } else {
      newNode.next = _head;
      _tail!.next = newNode;
      _head = newNode;
    }
    _length++;
  }

  /// Adds an element at the end of the list. O(1)
  void addLast(T value) {
    final newNode = CircularLinkedListNode(value);
    if (_head == null) {
      _head = newNode;
      _tail = newNode;
      newNode.next = newNode;
    } else {
      newNode.next = _head;
      _tail!.next = newNode;
      _tail = newNode;
    }
    _length++;
  }

  /// Alias for [addLast].
  void add(T value) => addLast(value);

  /// Removes and returns the first element. O(1)
  /// Throws [StateError] if the list is empty.
  T removeFirst() {
    if (_head == null) {
      throw StateError('Cannot remove from empty list');
    }
    final value = _head!.value;
    if (_head == _tail) {
      _head = null;
      _tail = null;
    } else {
      _head = _head!.next;
      _tail!.next = _head;
    }
    _length--;
    return value;
  }

  /// Removes and returns the last element. O(n)
  /// Throws [StateError] if the list is empty.
  T removeLast() {
    if (_head == null) {
      throw StateError('Cannot remove from empty list');
    }
    final value = _tail!.value;
    if (_head == _tail) {
      _head = null;
      _tail = null;
    } else {
      var current = _head;
      while (current!.next != _tail) {
        current = current.next;
      }
      current.next = _head;
      _tail = current;
    }
    _length--;
    return value;
  }

  /// Removes the first occurrence of [value] from the list.
  /// Returns true if the element was found and removed.
  bool remove(T value) {
    if (_head == null) return false;

    if (_head!.value == value) {
      removeFirst();
      return true;
    }

    var current = _head;
    while (current!.next != _head) {
      if (current.next!.value == value) {
        if (current.next == _tail) {
          _tail = current;
        }
        current.next = current.next!.next;
        _length--;
        return true;
      }
      current = current.next;
    }
    return false;
  }

  /// Returns the element at the specified [index]. O(n)
  /// Throws [RangeError] if [index] is out of bounds.
  T elementAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.range(index, 0, _length - 1);
    }
    var current = _head;
    for (var i = 0; i < index; i++) {
      current = current!.next;
    }
    return current!.value;
  }

  /// Returns true if the list contains [value]. O(n)
  bool contains(T value) {
    if (_head == null) return false;
    var current = _head;
    do {
      if (current!.value == value) return true;
      current = current.next;
    } while (current != _head);
    return false;
  }

  /// Rotates the list by [steps] positions.
  /// Positive steps rotate forward (head moves toward tail).
  /// Negative steps rotate backward (tail moves toward head).
  void rotate(int steps) {
    if (_head == null || _length <= 1 || steps == 0) return;

    // Normalize steps to be within list length
    steps = steps % _length;
    if (steps < 0) steps += _length;
    if (steps == 0) return;

    // Move head forward by steps
    for (var i = 0; i < steps; i++) {
      _tail = _head;
      _head = _head!.next;
    }
  }

  /// Removes all elements from the list. O(1)
  void clear() {
    _head = null;
    _tail = null;
    _length = 0;
  }

  /// Converts the list to a Dart List. O(n)
  List<T> toList() {
    final result = <T>[];
    if (_head == null) return result;
    var current = _head;
    do {
      result.add(current!.value);
      current = current.next;
    } while (current != _head);
    return result;
  }

  /// Returns an iterator over the elements.
  Iterable<T> get values sync* {
    if (_head == null) return;
    var current = _head;
    do {
      yield current!.value;
      current = current.next;
    } while (current != _head);
  }

  @override
  String toString() {
    if (_head == null) return 'CircularLinkedList: []';
    final buffer = StringBuffer('CircularLinkedList: [');
    var current = _head;
    do {
      buffer.write(current!.value);
      current = current.next;
      if (current != _head) buffer.write(' -> ');
    } while (current != _head);
    buffer.write(' -> (head)]');
    return buffer.toString();
  }
}

// ============================================================================
// Circular Doubly Linked List
// ============================================================================

/// Node for the circular doubly linked list.
class CircularDoublyLinkedListNode<T> {
  /// The value stored in this node.
  T value;

  /// Reference to the next node.
  CircularDoublyLinkedListNode<T>? next;

  /// Reference to the previous node.
  CircularDoublyLinkedListNode<T>? prev;

  /// Creates a new node with the given [value].
  CircularDoublyLinkedListNode(this.value, {this.prev, this.next});

  @override
  String toString() => 'Node($value)';
}

/// A doubly circular linked list where head.prev = tail and tail.next = head.
class CircularDoublyLinkedList<T> {
  CircularDoublyLinkedListNode<T>? _head;
  int _length = 0;

  /// Creates an empty circular doubly linked list.
  CircularDoublyLinkedList();

  /// Creates a circular doubly linked list from an iterable.
  factory CircularDoublyLinkedList.from(Iterable<T> elements) {
    final list = CircularDoublyLinkedList<T>();
    for (final element in elements) {
      list.addLast(element);
    }
    return list;
  }

  /// Returns the first node of the list.
  CircularDoublyLinkedListNode<T>? get head => _head;

  /// Returns the last node of the list (head.prev in circular structure).
  CircularDoublyLinkedListNode<T>? get tail => _head?.prev;

  /// Returns the number of elements in the list.
  int get length => _length;

  /// Returns true if the list is empty.
  bool get isEmpty => _head == null;

  /// Returns true if the list is not empty.
  bool get isNotEmpty => _head != null;

  /// Returns the first element of the list.
  /// Throws [StateError] if the list is empty.
  T get first {
    if (_head == null) {
      throw StateError('Cannot get first element of empty list');
    }
    return _head!.value;
  }

  /// Returns the last element of the list.
  /// Throws [StateError] if the list is empty.
  T get last {
    if (_head == null) {
      throw StateError('Cannot get last element of empty list');
    }
    return _head!.prev!.value;
  }

  /// Adds an element at the beginning of the list. O(1)
  void addFirst(T value) {
    final newNode = CircularDoublyLinkedListNode(value);
    if (_head == null) {
      newNode.next = newNode;
      newNode.prev = newNode;
      _head = newNode;
    } else {
      final tail = _head!.prev!;
      newNode.next = _head;
      newNode.prev = tail;
      tail.next = newNode;
      _head!.prev = newNode;
      _head = newNode;
    }
    _length++;
  }

  /// Adds an element at the end of the list. O(1)
  void addLast(T value) {
    final newNode = CircularDoublyLinkedListNode(value);
    if (_head == null) {
      newNode.next = newNode;
      newNode.prev = newNode;
      _head = newNode;
    } else {
      final tail = _head!.prev!;
      newNode.next = _head;
      newNode.prev = tail;
      tail.next = newNode;
      _head!.prev = newNode;
    }
    _length++;
  }

  /// Alias for [addLast].
  void add(T value) => addLast(value);

  /// Removes and returns the first element. O(1)
  /// Throws [StateError] if the list is empty.
  T removeFirst() {
    if (_head == null) {
      throw StateError('Cannot remove from empty list');
    }
    final value = _head!.value;
    if (_length == 1) {
      _head = null;
    } else {
      final tail = _head!.prev!;
      final newHead = _head!.next!;
      tail.next = newHead;
      newHead.prev = tail;
      _head = newHead;
    }
    _length--;
    return value;
  }

  /// Removes and returns the last element. O(1)
  /// Throws [StateError] if the list is empty.
  T removeLast() {
    if (_head == null) {
      throw StateError('Cannot remove from empty list');
    }
    final tail = _head!.prev!;
    final value = tail.value;
    if (_length == 1) {
      _head = null;
    } else {
      final newTail = tail.prev!;
      newTail.next = _head;
      _head!.prev = newTail;
    }
    _length--;
    return value;
  }

  /// Removes the first occurrence of [value] from the list.
  /// Returns true if the element was found and removed.
  bool remove(T value) {
    if (_head == null) return false;

    var current = _head;
    do {
      if (current!.value == value) {
        _removeNode(current);
        return true;
      }
      current = current.next;
    } while (current != _head);
    return false;
  }

  /// Internal method to remove a specific node.
  void _removeNode(CircularDoublyLinkedListNode<T> node) {
    if (_length == 1) {
      _head = null;
    } else {
      node.prev!.next = node.next;
      node.next!.prev = node.prev;
      if (node == _head) {
        _head = node.next;
      }
    }
    _length--;
  }

  /// Returns the element at the specified [index]. O(n)
  /// Optimized to traverse from the closer end.
  /// Throws [RangeError] if [index] is out of bounds.
  T elementAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.range(index, 0, _length - 1);
    }
    return _nodeAt(index)!.value;
  }

  /// Returns the node at the specified [index]. O(n)
  /// Optimized to traverse from the closer end.
  CircularDoublyLinkedListNode<T>? _nodeAt(int index) {
    if (index < 0 || index >= _length) return null;

    CircularDoublyLinkedListNode<T>? current;
    if (index < _length ~/ 2) {
      current = _head;
      for (var i = 0; i < index; i++) {
        current = current!.next;
      }
    } else {
      current = _head!.prev;
      for (var i = _length - 1; i > index; i--) {
        current = current!.prev;
      }
    }
    return current;
  }

  /// Returns true if the list contains [value]. O(n)
  bool contains(T value) {
    if (_head == null) return false;
    var current = _head;
    do {
      if (current!.value == value) return true;
      current = current.next;
    } while (current != _head);
    return false;
  }

  /// Rotates the list forward by [steps] positions. O(1)
  /// The head moves toward the tail direction.
  void rotateForward(int steps) {
    if (_head == null || _length <= 1 || steps == 0) return;

    steps = steps % _length;
    if (steps < 0) steps += _length;
    if (steps == 0) return;

    for (var i = 0; i < steps; i++) {
      _head = _head!.next;
    }
  }

  /// Rotates the list backward by [steps] positions. O(1)
  /// The head moves toward the previous direction.
  void rotateBackward(int steps) {
    if (_head == null || _length <= 1 || steps == 0) return;

    steps = steps % _length;
    if (steps < 0) steps += _length;
    if (steps == 0) return;

    for (var i = 0; i < steps; i++) {
      _head = _head!.prev;
    }
  }

  /// Removes all elements from the list. O(1)
  void clear() {
    _head = null;
    _length = 0;
  }

  /// Converts the list to a Dart List. O(n)
  List<T> toList() {
    final result = <T>[];
    if (_head == null) return result;
    var current = _head;
    do {
      result.add(current!.value);
      current = current.next;
    } while (current != _head);
    return result;
  }

  /// Returns an iterator over the elements (forward).
  Iterable<T> get values sync* {
    if (_head == null) return;
    var current = _head;
    do {
      yield current!.value;
      current = current.next;
    } while (current != _head);
  }

  /// Returns an iterator over the elements (backward).
  Iterable<T> get valuesReversed sync* {
    if (_head == null) return;
    var current = _head!.prev;
    do {
      yield current!.value;
      current = current.prev;
    } while (current != _head!.prev);
  }

  @override
  String toString() {
    if (_head == null) return 'CircularDoublyLinkedList: []';
    final buffer = StringBuffer('CircularDoublyLinkedList: [');
    var current = _head;
    do {
      buffer.write(current!.value);
      current = current.next;
      if (current != _head) buffer.write(' <-> ');
    } while (current != _head);
    buffer.write(' <-> (head)]');
    return buffer.toString();
  }
}
