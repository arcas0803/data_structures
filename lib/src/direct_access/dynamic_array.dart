/// # Dynamic Array
///
/// A dynamic array that automatically resizes when capacity is reached.
/// Similar to ArrayList in Java or std::vector in C++.
///
/// Time Complexity:
/// - Access by index: O(1)
/// - Search: O(n)
/// - Insertion at end: O(1) amortized
/// - Insertion at index: O(n)
/// - Deletion at end: O(1)
/// - Deletion at index: O(n)
library;

/// A dynamic array (vector) data structure.
class DynamicArray<T> {
  static const int _defaultCapacity = 16;
  static const double _growthFactor = 2.0;
  static const double _shrinkThreshold = 0.25;

  List<T?> _data;
  int _size = 0;

  /// Creates an empty dynamic array with optional initial [capacity].
  DynamicArray([int capacity = _defaultCapacity])
      : _data = List<T?>.filled(capacity < 1 ? _defaultCapacity : capacity, null);

  /// Creates a dynamic array from an iterable.
  factory DynamicArray.from(Iterable<T> elements) {
    final list = elements.toList();
    final array = DynamicArray<T>(list.length);
    for (final element in list) {
      array.add(element);
    }
    return array;
  }

  /// Creates a dynamic array filled with [value] repeated [count] times.
  factory DynamicArray.filled(int count, T value) {
    final array = DynamicArray<T>(count);
    for (var i = 0; i < count; i++) {
      array.add(value);
    }
    return array;
  }

  /// Returns the number of elements in the array.
  int get length => _size;

  /// Returns the current capacity of the array.
  int get capacity => _data.length;

  /// Returns true if the array is empty.
  bool get isEmpty => _size == 0;

  /// Returns true if the array is not empty.
  bool get isNotEmpty => _size > 0;

  /// Returns the first element.
  /// Throws [StateError] if the array is empty.
  T get first {
    if (_size == 0) {
      throw StateError('Cannot get first element of empty array');
    }
    return _data[0] as T;
  }

  /// Returns the last element.
  /// Throws [StateError] if the array is empty.
  T get last {
    if (_size == 0) {
      throw StateError('Cannot get last element of empty array');
    }
    return _data[_size - 1] as T;
  }

  /// Returns the element at [index]. O(1)
  /// Throws [RangeError] if [index] is out of bounds.
  T operator [](int index) {
    if (index < 0 || index >= _size) {
      throw RangeError.range(index, 0, _size - 1);
    }
    return _data[index] as T;
  }

  /// Sets the element at [index] to [value]. O(1)
  /// Throws [RangeError] if [index] is out of bounds.
  void operator []=(int index, T value) {
    if (index < 0 || index >= _size) {
      throw RangeError.range(index, 0, _size - 1);
    }
    _data[index] = value;
  }

  /// Adds an element at the end of the array. O(1) amortized
  void add(T value) {
    _ensureCapacity();
    _data[_size] = value;
    _size++;
  }

  /// Adds all elements from an iterable. O(n)
  void addAll(Iterable<T> elements) {
    for (final element in elements) {
      add(element);
    }
  }

  /// Inserts an element at the specified [index]. O(n)
  /// Throws [RangeError] if [index] is out of bounds.
  void insert(int index, T value) {
    if (index < 0 || index > _size) {
      throw RangeError.range(index, 0, _size);
    }
    if (index == _size) {
      add(value);
      return;
    }
    _ensureCapacity();
    // Shift elements to the right
    for (var i = _size; i > index; i--) {
      _data[i] = _data[i - 1];
    }
    _data[index] = value;
    _size++;
  }

  /// Removes and returns the last element. O(1)
  /// Throws [StateError] if the array is empty.
  T removeLast() {
    if (_size == 0) {
      throw StateError('Cannot remove from empty array');
    }
    final value = _data[_size - 1] as T;
    _data[_size - 1] = null;
    _size--;
    _shrinkIfNeeded();
    return value;
  }

  /// Removes and returns the element at [index]. O(n)
  /// Throws [RangeError] if [index] is out of bounds.
  T removeAt(int index) {
    if (index < 0 || index >= _size) {
      throw RangeError.range(index, 0, _size - 1);
    }
    final value = _data[index] as T;
    // Shift elements to the left
    for (var i = index; i < _size - 1; i++) {
      _data[i] = _data[i + 1];
    }
    _data[_size - 1] = null;
    _size--;
    _shrinkIfNeeded();
    return value;
  }

  /// Removes the first occurrence of [value]. O(n)
  /// Returns true if the element was found and removed.
  bool remove(T value) {
    final index = indexOf(value);
    if (index == -1) return false;
    removeAt(index);
    return true;
  }

  /// Removes all elements matching [test]. O(n)
  void removeWhere(bool Function(T) test) {
    var writeIndex = 0;
    for (var readIndex = 0; readIndex < _size; readIndex++) {
      if (!test(_data[readIndex] as T)) {
        _data[writeIndex] = _data[readIndex];
        writeIndex++;
      }
    }
    for (var i = writeIndex; i < _size; i++) {
      _data[i] = null;
    }
    _size = writeIndex;
    _shrinkIfNeeded();
  }

  /// Returns true if the array contains [value]. O(n)
  bool contains(T value) => indexOf(value) != -1;

  /// Returns the index of the first occurrence of [value]. O(n)
  /// Returns -1 if [value] is not found.
  int indexOf(T value) {
    for (var i = 0; i < _size; i++) {
      if (_data[i] == value) return i;
    }
    return -1;
  }

  /// Returns the index of the last occurrence of [value]. O(n)
  /// Returns -1 if [value] is not found.
  int lastIndexOf(T value) {
    for (var i = _size - 1; i >= 0; i--) {
      if (_data[i] == value) return i;
    }
    return -1;
  }

  /// Removes all elements from the array. O(1)
  void clear() {
    _data = List<T?>.filled(_defaultCapacity, null);
    _size = 0;
  }

  /// Reverses the array in place. O(n)
  void reverse() {
    for (var i = 0; i < _size ~/ 2; i++) {
      final temp = _data[i];
      _data[i] = _data[_size - 1 - i];
      _data[_size - 1 - i] = temp;
    }
  }

  /// Sorts the array using the provided [compare] function. O(n log n)
  void sort([int Function(T a, T b)? compare]) {
    final list = toList();
    list.sort(compare);
    for (var i = 0; i < _size; i++) {
      _data[i] = list[i];
    }
  }

  /// Returns a sublist from [start] to [end] (exclusive). O(n)
  DynamicArray<T> sublist(int start, [int? end]) {
    end ??= _size;
    if (start < 0 || start > _size) {
      throw RangeError.range(start, 0, _size);
    }
    if (end < start || end > _size) {
      throw RangeError.range(end, start, _size);
    }
    final result = DynamicArray<T>(end - start);
    for (var i = start; i < end; i++) {
      result.add(_data[i] as T);
    }
    return result;
  }

  /// Ensures there is capacity for at least one more element.
  void _ensureCapacity() {
    if (_size >= _data.length) {
      _resize((_data.length * _growthFactor).toInt());
    }
  }

  /// Shrinks the array if it's using less than [_shrinkThreshold] of capacity.
  void _shrinkIfNeeded() {
    if (_size > 0 && _size < _data.length * _shrinkThreshold && _data.length > _defaultCapacity) {
      _resize((_data.length / _growthFactor).toInt().clamp(_defaultCapacity, _data.length));
    }
  }

  /// Resizes the internal array to [newCapacity].
  void _resize(int newCapacity) {
    final newData = List<T?>.filled(newCapacity, null);
    for (var i = 0; i < _size; i++) {
      newData[i] = _data[i];
    }
    _data = newData;
  }

  /// Manually sets the capacity. O(n)
  /// If [newCapacity] is less than [length], elements are truncated.
  void setCapacity(int newCapacity) {
    if (newCapacity < _size) {
      _size = newCapacity;
    }
    _resize(newCapacity);
  }

  /// Trims excess capacity to match the current size. O(n)
  void trimToSize() {
    if (_size < _data.length) {
      _resize(_size == 0 ? _defaultCapacity : _size);
    }
  }

  /// Converts the dynamic array to a Dart List. O(n)
  List<T> toList() {
    return [for (var i = 0; i < _size; i++) _data[i] as T];
  }

  /// Returns an iterator over the elements.
  Iterable<T> get values sync* {
    for (var i = 0; i < _size; i++) {
      yield _data[i] as T;
    }
  }

  /// Applies [f] to each element.
  void forEach(void Function(T element) f) {
    for (var i = 0; i < _size; i++) {
      f(_data[i] as T);
    }
  }

  /// Returns a new array with elements transformed by [f].
  DynamicArray<R> map<R>(R Function(T element) f) {
    final result = DynamicArray<R>(_size);
    for (var i = 0; i < _size; i++) {
      result.add(f(_data[i] as T));
    }
    return result;
  }

  /// Returns a new array with elements matching [test].
  DynamicArray<T> where(bool Function(T element) test) {
    final result = DynamicArray<T>();
    for (var i = 0; i < _size; i++) {
      if (test(_data[i] as T)) {
        result.add(_data[i] as T);
      }
    }
    return result;
  }

  @override
  String toString() {
    if (_size == 0) return 'DynamicArray: [] (capacity: ${_data.length})';
    final elements = [for (var i = 0; i < _size; i++) _data[i]];
    return 'DynamicArray: $elements (size: $_size, capacity: ${_data.length})';
  }
}
