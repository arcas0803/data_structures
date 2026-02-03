/// # Linked List
///
/// A singly linked list implementation where each node contains a value
/// and a reference to the next node.
///
/// Time Complexity:
/// - Access: O(n)
/// - Search: O(n)
/// - Insertion at head: O(1)
/// - Insertion at tail: O(n)
/// - Deletion: O(n)
library;

/// Node for the linked list.
class LinkedListNode<T> {
  /// The value stored in this node.
  T value;

  /// Reference to the next node.
  LinkedListNode<T>? next;

  /// Creates a new node with the given [value].
  LinkedListNode(this.value, [this.next]);

  @override
  String toString() => 'Node($value)';
}

/// A singly linked list data structure.
class LinkedList<T> {
  LinkedListNode<T>? _head;
  int _length = 0;

  /// Creates an empty linked list.
  LinkedList();

  /// Creates a linked list from an iterable.
  factory LinkedList.from(Iterable<T> elements) {
    final list = LinkedList<T>();
    for (final element in elements) {
      list.addLast(element);
    }
    return list;
  }

  /// Returns the first node of the list.
  LinkedListNode<T>? get head => _head;

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
    var current = _head;
    while (current!.next != null) {
      current = current.next;
    }
    return current.value;
  }

  /// Adds an element at the beginning of the list. O(1)
  void addFirst(T value) {
    final newNode = LinkedListNode(value, _head);
    _head = newNode;
    _length++;
  }

  /// Adds an element at the end of the list. O(n)
  void addLast(T value) {
    final newNode = LinkedListNode(value);
    if (_head == null) {
      _head = newNode;
    } else {
      var current = _head;
      while (current!.next != null) {
        current = current.next;
      }
      current.next = newNode;
    }
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
    var current = _head;
    for (var i = 0; i < index - 1; i++) {
      current = current!.next;
    }
    final newNode = LinkedListNode(value, current!.next);
    current.next = newNode;
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
    _length--;
    return value;
  }

  /// Removes and returns the last element. O(n)
  /// Throws [StateError] if the list is empty.
  T removeLast() {
    if (_head == null) {
      throw StateError('Cannot remove from empty list');
    }
    if (_head!.next == null) {
      final value = _head!.value;
      _head = null;
      _length--;
      return value;
    }
    var current = _head;
    while (current!.next!.next != null) {
      current = current.next;
    }
    final value = current.next!.value;
    current.next = null;
    _length--;
    return value;
  }

  /// Removes the element at the specified [index]. O(n)
  /// Throws [RangeError] if [index] is out of bounds.
  T removeAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.range(index, 0, _length - 1);
    }
    if (index == 0) {
      return removeFirst();
    }
    var current = _head;
    for (var i = 0; i < index - 1; i++) {
      current = current!.next;
    }
    final value = current!.next!.value;
    current.next = current.next!.next;
    _length--;
    return value;
  }

  /// Removes the first occurrence of [value] from the list.
  /// Returns true if the element was found and removed.
  bool remove(T value) {
    if (_head == null) return false;

    if (_head!.value == value) {
      _head = _head!.next;
      _length--;
      return true;
    }

    var current = _head;
    while (current!.next != null) {
      if (current.next!.value == value) {
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
    _length = 0;
  }

  /// Reverses the list in place. O(n)
  void reverse() {
    LinkedListNode<T>? prev;
    var current = _head;
    while (current != null) {
      final next = current.next;
      current.next = prev;
      prev = current;
      current = next;
    }
    _head = prev;
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

  /// Returns an iterator over the elements.
  Iterable<T> get values sync* {
    var current = _head;
    while (current != null) {
      yield current.value;
      current = current.next;
    }
  }

  @override
  String toString() {
    if (_head == null) return 'LinkedList: []';
    final buffer = StringBuffer('LinkedList: [');
    var current = _head;
    while (current != null) {
      buffer.write(current.value);
      if (current.next != null) buffer.write(' -> ');
      current = current.next;
    }
    buffer.write(']');
    return buffer.toString();
  }
}
