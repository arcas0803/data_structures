/// # Doubly Linked List
///
/// A doubly linked list where each node has references to both
/// the next and previous nodes.
///
/// Time Complexity:
/// - Access: O(n)
/// - Search: O(n)
/// - Insertion at head/tail: O(1)
/// - Deletion at head/tail: O(1)
/// - Deletion by reference: O(1)
library;

/// Node for the doubly linked list.
class DoublyLinkedListNode<T> {
  /// The value stored in this node.
  T value;

  /// Reference to the next node.
  DoublyLinkedListNode<T>? next;

  /// Reference to the previous node.
  DoublyLinkedListNode<T>? prev;

  /// Creates a new node with the given [value].
  DoublyLinkedListNode(this.value, {this.prev, this.next});

  @override
  String toString() => 'Node($value)';
}

/// A doubly linked list data structure.
class DoublyLinkedList<T> {
  DoublyLinkedListNode<T>? _head;
  DoublyLinkedListNode<T>? _tail;
  int _length = 0;

  /// Creates an empty doubly linked list.
  DoublyLinkedList();

  /// Creates a doubly linked list from an iterable.
  factory DoublyLinkedList.from(Iterable<T> elements) {
    final list = DoublyLinkedList<T>();
    for (final element in elements) {
      list.addLast(element);
    }
    return list;
  }

  /// Returns the first node of the list.
  DoublyLinkedListNode<T>? get head => _head;

  /// Returns the last node of the list.
  DoublyLinkedListNode<T>? get tail => _tail;

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
    final newNode = DoublyLinkedListNode(value, next: _head);
    if (_head != null) {
      _head!.prev = newNode;
    } else {
      _tail = newNode;
    }
    _head = newNode;
    _length++;
  }

  /// Adds an element at the end of the list. O(1)
  void addLast(T value) {
    final newNode = DoublyLinkedListNode(value, prev: _tail);
    if (_tail != null) {
      _tail!.next = newNode;
    } else {
      _head = newNode;
    }
    _tail = newNode;
    _length++;
  }

  /// Alias for [addLast].
  void add(T value) => addLast(value);

  /// Inserts an element at the specified [index]. O(n)
  /// Throws [RangeError] if [index] is out of bounds.
  void insertAt(int index, T value) {
    if (index < 0 || index > _length) {
      throw RangeError.range(index, 0, _length);
    }
    if (index == 0) {
      addFirst(value);
      return;
    }
    if (index == _length) {
      addLast(value);
      return;
    }

    final node = _nodeAt(index);
    final newNode = DoublyLinkedListNode(value, prev: node!.prev, next: node);
    node.prev!.next = newNode;
    node.prev = newNode;
    _length++;
  }

  /// Inserts a value after the given [node]. O(1)
  void insertAfter(DoublyLinkedListNode<T> node, T value) {
    final newNode = DoublyLinkedListNode(value, prev: node, next: node.next);
    if (node.next != null) {
      node.next!.prev = newNode;
    } else {
      _tail = newNode;
    }
    node.next = newNode;
    _length++;
  }

  /// Inserts a value before the given [node]. O(1)
  void insertBefore(DoublyLinkedListNode<T> node, T value) {
    final newNode = DoublyLinkedListNode(value, prev: node.prev, next: node);
    if (node.prev != null) {
      node.prev!.next = newNode;
    } else {
      _head = newNode;
    }
    node.prev = newNode;
    _length++;
  }

  /// Removes and returns the first element. O(1)
  /// Throws [StateError] if the list is empty.
  T removeFirst() {
    if (_head == null) {
      throw StateError('Cannot remove from empty list');
    }
    final value = _head!.value;
    _head = _head!.next;
    if (_head != null) {
      _head!.prev = null;
    } else {
      _tail = null;
    }
    _length--;
    return value;
  }

  /// Removes and returns the last element. O(1)
  /// Throws [StateError] if the list is empty.
  T removeLast() {
    if (_tail == null) {
      throw StateError('Cannot remove from empty list');
    }
    final value = _tail!.value;
    _tail = _tail!.prev;
    if (_tail != null) {
      _tail!.next = null;
    } else {
      _head = null;
    }
    _length--;
    return value;
  }

  /// Removes the specified [node] from the list. O(1)
  void removeNode(DoublyLinkedListNode<T> node) {
    if (node.prev != null) {
      node.prev!.next = node.next;
    } else {
      _head = node.next;
    }
    if (node.next != null) {
      node.next!.prev = node.prev;
    } else {
      _tail = node.prev;
    }
    _length--;
  }

  /// Removes the element at the specified [index]. O(n)
  /// Throws [RangeError] if [index] is out of bounds.
  T removeAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.range(index, 0, _length - 1);
    }
    if (index == 0) return removeFirst();
    if (index == _length - 1) return removeLast();

    final node = _nodeAt(index)!;
    node.prev!.next = node.next;
    node.next!.prev = node.prev;
    _length--;
    return node.value;
  }

  /// Removes the first occurrence of [value] from the list.
  /// Returns true if the element was found and removed.
  bool remove(T value) {
    var current = _head;
    while (current != null) {
      if (current.value == value) {
        removeNode(current);
        return true;
      }
      current = current.next;
    }
    return false;
  }

  /// Returns the node at the specified [index]. O(n)
  /// Optimized to traverse from the closer end.
  DoublyLinkedListNode<T>? _nodeAt(int index) {
    if (index < 0 || index >= _length) return null;

    if (index < _length ~/ 2) {
      var current = _head;
      for (var i = 0; i < index; i++) {
        current = current!.next;
      }
      return current;
    } else {
      var current = _tail;
      for (var i = _length - 1; i > index; i--) {
        current = current!.prev;
      }
      return current;
    }
  }

  /// Returns the element at the specified [index]. O(n)
  /// Throws [RangeError] if [index] is out of bounds.
  T elementAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.range(index, 0, _length - 1);
    }
    return _nodeAt(index)!.value;
  }

  /// Returns true if the list contains [value]. O(n)
  bool contains(T value) {
    var current = _head;
    while (current != null) {
      if (current.value == value) return true;
      current = current.next;
    }
    return false;
  }

  /// Returns the index of the first occurrence of [value].
  /// Returns -1 if [value] is not found.
  int indexOf(T value) {
    var current = _head;
    var index = 0;
    while (current != null) {
      if (current.value == value) return index;
      current = current.next;
      index++;
    }
    return -1;
  }

  /// Removes all elements from the list. O(1)
  void clear() {
    _head = null;
    _tail = null;
    _length = 0;
  }

  /// Reverses the list in place. O(n)
  void reverse() {
    var current = _head;
    _head = _tail;
    _tail = current;

    while (current != null) {
      final temp = current.next;
      current.next = current.prev;
      current.prev = temp;
      current = temp;
    }
  }

  /// Converts the list to a Dart List. O(n)
  List<T> toList() {
    final result = <T>[];
    var current = _head;
    while (current != null) {
      result.add(current.value);
      current = current.next;
    }
    return result;
  }

  /// Returns an iterator over the elements (forward).
  Iterable<T> get values sync* {
    var current = _head;
    while (current != null) {
      yield current.value;
      current = current.next;
    }
  }

  /// Returns an iterator over the elements (backward).
  Iterable<T> get valuesReversed sync* {
    var current = _tail;
    while (current != null) {
      yield current.value;
      current = current.prev;
    }
  }

  @override
  String toString() {
    if (_head == null) return 'DoublyLinkedList: []';
    final buffer = StringBuffer('DoublyLinkedList: [');
    var current = _head;
    while (current != null) {
      buffer.write(current.value);
      if (current.next != null) buffer.write(' <-> ');
      current = current.next;
    }
    buffer.write(']');
    return buffer.toString();
  }
}
