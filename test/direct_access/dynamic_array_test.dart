import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('DynamicArray', () {
    late DynamicArray<int> array;

    setUp(() {
      array = DynamicArray<int>();
    });

    test('should start empty', () {
      expect(array.isEmpty, isTrue);
      expect(array.length, equals(0));
      expect(array.capacity, greaterThan(0));
    });

    test('should add elements', () {
      array.add(1);
      array.add(2);
      array.add(3);
      expect(array.length, equals(3));
      expect(array.toList(), equals([1, 2, 3]));
    });

    test('should access elements by index', () {
      array.add(1);
      array.add(2);
      array.add(3);
      expect(array[0], equals(1));
      expect(array[1], equals(2));
      expect(array[2], equals(3));
    });

    test('should set elements by index', () {
      array.add(1);
      array.add(2);
      array.add(3);
      array[1] = 10;
      expect(array.toList(), equals([1, 10, 3]));
    });

    test('should throw on out of bounds access', () {
      array.add(1);
      expect(() => array[5], throwsRangeError);
      expect(() => array[-1], throwsRangeError);
    });

    test('should get first and last', () {
      array.addAll([1, 2, 3]);
      expect(array.first, equals(1));
      expect(array.last, equals(3));
    });

    test('should throw on empty first/last', () {
      expect(() => array.first, throwsStateError);
      expect(() => array.last, throwsStateError);
    });

    test('should insert at index', () {
      array.addAll([1, 3, 4]);
      array.insert(1, 2);
      expect(array.toList(), equals([1, 2, 3, 4]));
    });

    test('should remove last', () {
      array.addAll([1, 2, 3]);
      expect(array.removeLast(), equals(3));
      expect(array.toList(), equals([1, 2]));
    });

    test('should remove at index', () {
      array.addAll([1, 2, 3, 4]);
      expect(array.removeAt(1), equals(2));
      expect(array.toList(), equals([1, 3, 4]));
    });

    test('should remove by value', () {
      array.addAll([1, 2, 3, 2]);
      expect(array.remove(2), isTrue);
      expect(array.toList(), equals([1, 3, 2]));
      expect(array.remove(5), isFalse);
    });

    test('should removeWhere', () {
      array.addAll([1, 2, 3, 4, 5, 6]);
      array.removeWhere((e) => e % 2 == 0);
      expect(array.toList(), equals([1, 3, 5]));
    });

    test('should find indexOf', () {
      array.addAll([1, 2, 3, 2]);
      expect(array.indexOf(2), equals(1));
      expect(array.lastIndexOf(2), equals(3));
      expect(array.indexOf(5), equals(-1));
    });

    test('should check contains', () {
      array.addAll([1, 2, 3]);
      expect(array.contains(2), isTrue);
      expect(array.contains(5), isFalse);
    });

    test('should reverse', () {
      array.addAll([1, 2, 3, 4]);
      array.reverse();
      expect(array.toList(), equals([4, 3, 2, 1]));
    });

    test('should sort', () {
      array.addAll([3, 1, 4, 1, 5, 9, 2, 6]);
      array.sort();
      expect(array.toList(), equals([1, 1, 2, 3, 4, 5, 6, 9]));
    });

    test('should sort with custom comparator', () {
      array.addAll([1, 2, 3, 4, 5]);
      array.sort((a, b) => b.compareTo(a)); // descending
      expect(array.toList(), equals([5, 4, 3, 2, 1]));
    });

    test('should get sublist', () {
      array.addAll([1, 2, 3, 4, 5]);
      final sub = array.sublist(1, 4);
      expect(sub.toList(), equals([2, 3, 4]));
    });

    test('should grow capacity automatically', () {
      final smallArray = DynamicArray<int>(2);
      expect(smallArray.capacity, equals(2));
      smallArray.addAll([1, 2, 3, 4, 5]);
      expect(smallArray.capacity, greaterThan(2));
      expect(smallArray.toList(), equals([1, 2, 3, 4, 5]));
    });

    test('should trim to size', () {
      array.addAll([1, 2, 3]);
      array.trimToSize();
      expect(array.capacity, equals(3));
    });

    test('should clear', () {
      array.addAll([1, 2, 3]);
      array.clear();
      expect(array.isEmpty, isTrue);
    });

    test('should map elements', () {
      array.addAll([1, 2, 3]);
      final mapped = array.map((e) => e * 2);
      expect(mapped.toList(), equals([2, 4, 6]));
    });

    test('should filter elements', () {
      array.addAll([1, 2, 3, 4, 5]);
      final filtered = array.where((e) => e % 2 == 0);
      expect(filtered.toList(), equals([2, 4]));
    });

    test('should iterate with forEach', () {
      array.addAll([1, 2, 3]);
      final result = <int>[];
      array.forEach((e) => result.add(e * 2));
      expect(result, equals([2, 4, 6]));
    });

    test('should create from iterable', () {
      final newArray = DynamicArray.from([1, 2, 3, 4, 5]);
      expect(newArray.toList(), equals([1, 2, 3, 4, 5]));
    });

    test('should create filled', () {
      final filled = DynamicArray.filled(5, 0);
      expect(filled.toList(), equals([0, 0, 0, 0, 0]));
    });
  });
}
