import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('DoublyLinkedList', () {
    late DoublyLinkedList<int> list;

    setUp(() {
      list = DoublyLinkedList<int>();
    });

    test('should start empty', () {
      expect(list.isEmpty, isTrue);
      expect(list.length, equals(0));
      expect(list.head, isNull);
      expect(list.tail, isNull);
    });

    test('should add elements at the end', () {
      list.add(1);
      list.add(2);
      list.add(3);
      expect(list.length, equals(3));
      expect(list.toList(), equals([1, 2, 3]));
      expect(list.first, equals(1));
      expect(list.last, equals(3));
    });

    test('should add elements at the beginning', () {
      list.addFirst(1);
      list.addFirst(2);
      list.addFirst(3);
      expect(list.toList(), equals([3, 2, 1]));
    });

    test('should maintain prev/next pointers', () {
      list.addAll([1, 2, 3]);
      expect(list.head!.prev, isNull);
      expect(list.head!.next!.value, equals(2));
      expect(list.tail!.next, isNull);
      expect(list.tail!.prev!.value, equals(2));
    });

    test('should insert at index', () {
      list.addAll([1, 3, 4]);
      list.insertAt(1, 2);
      expect(list.toList(), equals([1, 2, 3, 4]));
    });

    test('should insert after node', () {
      list.addAll([1, 3]);
      list.insertAfter(list.head!, 2);
      expect(list.toList(), equals([1, 2, 3]));
    });

    test('should insert before node', () {
      list.addAll([1, 3]);
      list.insertBefore(list.tail!, 2);
      expect(list.toList(), equals([1, 2, 3]));
    });

    test('should remove first element', () {
      list.addAll([1, 2, 3]);
      expect(list.removeFirst(), equals(1));
      expect(list.toList(), equals([2, 3]));
      expect(list.head!.prev, isNull);
    });

    test('should remove last element', () {
      list.addAll([1, 2, 3]);
      expect(list.removeLast(), equals(3));
      expect(list.toList(), equals([1, 2]));
      expect(list.tail!.next, isNull);
    });

    test('should remove node directly', () {
      list.addAll([1, 2, 3]);
      list.removeNode(list.head!.next!);
      expect(list.toList(), equals([1, 3]));
    });

    test('should remove at index', () {
      list.addAll([1, 2, 3, 4]);
      expect(list.removeAt(2), equals(3));
      expect(list.toList(), equals([1, 2, 4]));
    });

    test('should remove by value', () {
      list.addAll([1, 2, 3]);
      expect(list.remove(2), isTrue);
      expect(list.toList(), equals([1, 3]));
      expect(list.remove(5), isFalse);
    });

    test('should access element at index efficiently', () {
      list.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
      expect(list.elementAt(0), equals(1));
      expect(list.elementAt(4), equals(5));
      expect(list.elementAt(9), equals(10));
    });

    test('should find index of element', () {
      list.addAll([1, 2, 3, 2]);
      expect(list.indexOf(2), equals(1));
      expect(list.indexOf(5), equals(-1));
    });

    test('should check contains', () {
      list.addAll([1, 2, 3]);
      expect(list.contains(2), isTrue);
      expect(list.contains(5), isFalse);
    });

    test('should reverse the list', () {
      list.addAll([1, 2, 3, 4]);
      list.reverse();
      expect(list.toList(), equals([4, 3, 2, 1]));
      expect(list.first, equals(4));
      expect(list.last, equals(1));
    });

    test('should iterate forward and backward', () {
      list.addAll([1, 2, 3]);
      expect(list.values.toList(), equals([1, 2, 3]));
      expect(list.valuesReversed.toList(), equals([3, 2, 1]));
    });

    test('should clear the list', () {
      list.addAll([1, 2, 3]);
      list.clear();
      expect(list.isEmpty, isTrue);
      expect(list.head, isNull);
      expect(list.tail, isNull);
    });

    test('should create from iterable', () {
      final newList = DoublyLinkedList.from([1, 2, 3, 4, 5]);
      expect(newList.toList(), equals([1, 2, 3, 4, 5]));
    });
  });
}

extension on DoublyLinkedList<int> {
  void addAll(List<int> elements) {
    for (final e in elements) {
      add(e);
    }
  }
}
