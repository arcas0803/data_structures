import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('LinkedList', () {
    late LinkedList<int> list;

    setUp(() {
      list = LinkedList<int>();
    });

    test('should start empty', () {
      expect(list.isEmpty, isTrue);
      expect(list.length, equals(0));
    });

    test('should add elements at the end', () {
      list.add(1);
      list.add(2);
      list.add(3);
      expect(list.length, equals(3));
      expect(list.toList(), equals([1, 2, 3]));
    });

    test('should add elements at the beginning', () {
      list.addFirst(1);
      list.addFirst(2);
      list.addFirst(3);
      expect(list.toList(), equals([3, 2, 1]));
    });

    test('should get first and last elements', () {
      list.addAll([1, 2, 3]);
      expect(list.first, equals(1));
      expect(list.last, equals(3));
    });

    test('should throw on empty first/last', () {
      expect(() => list.first, throwsStateError);
      expect(() => list.last, throwsStateError);
    });

    test('should insert at index', () {
      list.addAll([1, 3, 4]);
      list.insertAt(1, 2);
      expect(list.toList(), equals([1, 2, 3, 4]));
    });

    test('should remove first element', () {
      list.addAll([1, 2, 3]);
      expect(list.removeFirst(), equals(1));
      expect(list.toList(), equals([2, 3]));
    });

    test('should remove last element', () {
      list.addAll([1, 2, 3]);
      expect(list.removeLast(), equals(3));
      expect(list.toList(), equals([1, 2]));
    });

    test('should remove at index', () {
      list.addAll([1, 2, 3, 4]);
      expect(list.removeAt(1), equals(2));
      expect(list.toList(), equals([1, 3, 4]));
    });

    test('should remove by value', () {
      list.addAll([1, 2, 3, 2, 4]);
      expect(list.remove(2), isTrue);
      expect(list.toList(), equals([1, 3, 2, 4]));
      expect(list.remove(5), isFalse);
    });

    test('should check contains', () {
      list.addAll([1, 2, 3]);
      expect(list.contains(2), isTrue);
      expect(list.contains(5), isFalse);
    });

    test('should find index of element', () {
      list.addAll([1, 2, 3, 2]);
      expect(list.indexOf(2), equals(1));
      expect(list.indexOf(5), equals(-1));
    });

    test('should get element at index', () {
      list.addAll([1, 2, 3]);
      expect(list.elementAt(1), equals(2));
      expect(() => list.elementAt(5), throwsRangeError);
    });

    test('should reverse the list', () {
      list.addAll([1, 2, 3, 4]);
      list.reverse();
      expect(list.toList(), equals([4, 3, 2, 1]));
    });

    test('should clear the list', () {
      list.addAll([1, 2, 3]);
      list.clear();
      expect(list.isEmpty, isTrue);
      expect(list.length, equals(0));
    });

    test('should create from iterable', () {
      final newList = LinkedList.from([1, 2, 3, 4, 5]);
      expect(newList.toList(), equals([1, 2, 3, 4, 5]));
    });

    test('should iterate over values', () {
      list.addAll([1, 2, 3]);
      expect(list.values.toList(), equals([1, 2, 3]));
    });
  });

  group('LinkedListNode', () {
    test('should create node with value', () {
      final node = LinkedListNode(42);
      expect(node.value, equals(42));
      expect(node.next, isNull);
    });

    test('should chain nodes', () {
      final node3 = LinkedListNode(3);
      final node2 = LinkedListNode(2, node3);
      final node1 = LinkedListNode(1, node2);

      expect(node1.next, equals(node2));
      expect(node2.next, equals(node3));
      expect(node3.next, isNull);
    });
  });
}

extension on LinkedList<int> {
  void addAll(List<int> elements) {
    for (final e in elements) {
      add(e);
    }
  }
}
