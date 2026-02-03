/// # Stack
///
/// A Last-In-First-Out (LIFO) data structure.
/// Elements are added and removed from the same end (top).
///
/// Time Complexity:
/// - Push: O(1)
/// - Pop: O(1)
/// - Peek: O(1)
/// - Search: O(n)
library;

/// A stack (LIFO) data structure.
class Stack<T> {
  final List<T> _items = [];

  /// Creates an empty stack.
  Stack();

  /// Creates a stack from an iterable.
  /// The last element of the iterable becomes the top of the stack.
  factory Stack.from(Iterable<T> elements) {
    final stack = Stack<T>();
    for (final element in elements) {
      stack.push(element);
    }
    return stack;
  }

  /// Returns the number of elements in the stack.
  int get length => _items.length;

  /// Returns true if the stack is empty.
  bool get isEmpty => _items.isEmpty;

  /// Returns true if the stack is not empty.
  bool get isNotEmpty => _items.isNotEmpty;

  /// Adds an element to the top of the stack. O(1)
  void push(T value) {
    _items.add(value);
  }

  /// Removes and returns the top element. O(1)
  /// Throws [StateError] if the stack is empty.
  T pop() {
    if (_items.isEmpty) {
      throw StateError('Cannot pop from empty stack');
    }
    return _items.removeLast();
  }

  /// Returns the top element without removing it. O(1)
  /// Throws [StateError] if the stack is empty.
  T peek() {
    if (_items.isEmpty) {
      throw StateError('Cannot peek empty stack');
    }
    return _items.last;
  }

  /// Returns the top element without removing it, or null if empty. O(1)
  T? tryPeek() {
    if (_items.isEmpty) return null;
    return _items.last;
  }

  /// Removes and returns the top element, or null if empty. O(1)
  T? tryPop() {
    if (_items.isEmpty) return null;
    return _items.removeLast();
  }

  /// Returns true if the stack contains [value]. O(n)
  bool contains(T value) => _items.contains(value);

  /// Returns the 1-based position of [value] from the top.
  /// Returns -1 if [value] is not found.
  /// Example: [1, 2, 3] with 3 on top -> search(3) returns 1
  int search(T value) {
    for (var i = _items.length - 1; i >= 0; i--) {
      if (_items[i] == value) {
        return _items.length - i;
      }
    }
    return -1;
  }

  /// Removes all elements from the stack. O(1)
  void clear() {
    _items.clear();
  }

  /// Converts the stack to a Dart List. O(n)
  /// The last element of the list is the top of the stack.
  List<T> toList() => List.from(_items);

  /// Returns an iterator over the elements from top to bottom.
  Iterable<T> get values sync* {
    for (var i = _items.length - 1; i >= 0; i--) {
      yield _items[i];
    }
  }

  @override
  String toString() {
    if (_items.isEmpty) return 'Stack: [] (empty)';
    final reversed = _items.reversed.toList();
    return 'Stack: [${reversed.join(' -> ')}] (top first)';
  }
}
