import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('CircularLinkedList', () {
    late CircularLinkedList<int> list;

    setUp(() {
      list = CircularLinkedList<int>();
    });

    group('empty list operations', () {
      test('should start empty', () {
        expect(list.isEmpty, isTrue);
        expect(list.isNotEmpty, isFalse);
        expect(list.length, equals(0));
      });

      test('should throw on first/last of empty list', () {
        expect(() => list.first, throwsStateError);
        expect(() => list.last, throwsStateError);
      });

      test('should throw on removeFirst of empty list', () {
        expect(() => list.removeFirst(), throwsStateError);
      });

      test('should throw on removeLast of empty list', () {
        expect(() => list.removeLast(), throwsStateError);
      });

      test('should return false on remove from empty list', () {
        expect(list.remove(1), isFalse);
      });

      test('should return false on contains for empty list', () {
        expect(list.contains(1), isFalse);
      });

      test('should throw on elementAt for empty list', () {
        expect(() => list.elementAt(0), throwsRangeError);
      });

      test('should return empty list from toList', () {
        expect(list.toList(), isEmpty);
      });

      test('should return empty iterable from values', () {
        expect(list.values.toList(), isEmpty);
      });
    });

    group('add operations', () {
      test('should add elements at the end', () {
        list.add(1);
        list.add(2);
        list.add(3);
        expect(list.length, equals(3));
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should add elements at the beginning with addFirst', () {
        list.addFirst(1);
        list.addFirst(2);
        list.addFirst(3);
        expect(list.toList(), equals([3, 2, 1]));
      });

      test('should add elements at the end with addLast', () {
        list.addLast(1);
        list.addLast(2);
        list.addLast(3);
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should get first and last elements', () {
        list.addAll([1, 2, 3]);
        expect(list.first, equals(1));
        expect(list.last, equals(3));
      });
    });

    group('remove operations', () {
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

      test('should remove by value', () {
        list.addAll([1, 2, 3, 2, 4]);
        expect(list.remove(2), isTrue);
        expect(list.toList(), equals([1, 3, 2, 4]));
        expect(list.remove(5), isFalse);
      });

      test('should remove first element by value', () {
        list.addAll([1, 2, 3]);
        expect(list.remove(1), isTrue);
        expect(list.toList(), equals([2, 3]));
      });

      test('should remove last element by value', () {
        list.addAll([1, 2, 3]);
        expect(list.remove(3), isTrue);
        expect(list.toList(), equals([1, 2]));
      });
    });

    group('contains and elementAt', () {
      test('should check contains', () {
        list.addAll([1, 2, 3]);
        expect(list.contains(2), isTrue);
        expect(list.contains(5), isFalse);
      });

      test('should get element at index', () {
        list.addAll([1, 2, 3]);
        expect(list.elementAt(0), equals(1));
        expect(list.elementAt(1), equals(2));
        expect(list.elementAt(2), equals(3));
      });

      test('should throw on elementAt with invalid index', () {
        list.addAll([1, 2, 3]);
        expect(() => list.elementAt(-1), throwsRangeError);
        expect(() => list.elementAt(3), throwsRangeError);
      });
    });

    group('length and isEmpty', () {
      test('should track length correctly', () {
        expect(list.length, equals(0));
        list.add(1);
        expect(list.length, equals(1));
        list.add(2);
        expect(list.length, equals(2));
        list.removeFirst();
        expect(list.length, equals(1));
      });

      test('should report isEmpty correctly', () {
        expect(list.isEmpty, isTrue);
        expect(list.isNotEmpty, isFalse);
        list.add(1);
        expect(list.isEmpty, isFalse);
        expect(list.isNotEmpty, isTrue);
      });
    });

    group('clear', () {
      test('should clear the list', () {
        list.addAll([1, 2, 3]);
        list.clear();
        expect(list.isEmpty, isTrue);
        expect(list.length, equals(0));
        expect(list.toList(), isEmpty);
      });
    });

    group('toList and values', () {
      test('should convert to list', () {
        list.addAll([1, 2, 3, 4, 5]);
        expect(list.toList(), equals([1, 2, 3, 4, 5]));
      });

      test('should iterate over values', () {
        list.addAll([1, 2, 3]);
        expect(list.values.toList(), equals([1, 2, 3]));
      });
    });

    group('rotate', () {
      test('should rotate forward', () {
        list.addAll([1, 2, 3, 4, 5]);
        list.rotate(2);
        expect(list.toList(), equals([3, 4, 5, 1, 2]));
      });

      test('should rotate backward with negative steps', () {
        list.addAll([1, 2, 3, 4, 5]);
        list.rotate(-2);
        expect(list.toList(), equals([4, 5, 1, 2, 3]));
      });

      test('should not change list when rotating by 0', () {
        list.addAll([1, 2, 3]);
        list.rotate(0);
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should handle rotation by list length', () {
        list.addAll([1, 2, 3]);
        list.rotate(3);
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should handle rotation greater than list length', () {
        list.addAll([1, 2, 3]);
        list.rotate(5);
        expect(list.toList(), equals([3, 1, 2]));
      });

      test('should not rotate empty list', () {
        list.rotate(2);
        expect(list.toList(), isEmpty);
      });

      test('should not rotate single element list', () {
        list.add(1);
        list.rotate(5);
        expect(list.toList(), equals([1]));
      });
    });

    group('circular nature verification', () {
      test('tail should point back to head', () {
        list.addAll([1, 2, 3]);
        expect(list.tail!.next, equals(list.head));
      });

      test('should traverse circularly beyond length', () {
        list.addAll([1, 2, 3]);
        var current = list.head;
        final values = <int>[];
        for (var i = 0; i < 7; i++) {
          values.add(current!.value);
          current = current.next;
        }
        expect(values, equals([1, 2, 3, 1, 2, 3, 1]));
      });
    });

    group('edge cases: single element', () {
      test('should handle single element add', () {
        list.add(1);
        expect(list.first, equals(1));
        expect(list.last, equals(1));
        expect(list.length, equals(1));
        expect(list.head, equals(list.tail));
        expect(list.head!.next, equals(list.head));
      });

      test('should handle single element remove', () {
        list.add(1);
        expect(list.removeFirst(), equals(1));
        expect(list.isEmpty, isTrue);
      });

      test('should handle single element removeLast', () {
        list.add(1);
        expect(list.removeLast(), equals(1));
        expect(list.isEmpty, isTrue);
      });
    });

    group('edge cases: two elements', () {
      test('should handle two elements correctly', () {
        list.addAll([1, 2]);
        expect(list.first, equals(1));
        expect(list.last, equals(2));
        expect(list.head!.next, equals(list.tail));
        expect(list.tail!.next, equals(list.head));
      });

      test('should handle removeFirst with two elements', () {
        list.addAll([1, 2]);
        list.removeFirst();
        expect(list.first, equals(2));
        expect(list.last, equals(2));
        expect(list.head, equals(list.tail));
      });

      test('should handle removeLast with two elements', () {
        list.addAll([1, 2]);
        list.removeLast();
        expect(list.first, equals(1));
        expect(list.last, equals(1));
        expect(list.head, equals(list.tail));
      });
    });

    group('toString', () {
      test('should return correct string for empty list', () {
        expect(list.toString(), equals('CircularLinkedList: []'));
      });

      test('should return correct string for non-empty list', () {
        list.addAll([1, 2, 3]);
        expect(
          list.toString(),
          equals('CircularLinkedList: [1 -> 2 -> 3 -> (head)]'),
        );
      });
    });

    group('factory constructor', () {
      test('should create from iterable', () {
        final newList = CircularLinkedList.from([1, 2, 3, 4, 5]);
        expect(newList.toList(), equals([1, 2, 3, 4, 5]));
      });
    });
  });

  group('CircularDoublyLinkedList', () {
    late CircularDoublyLinkedList<int> list;

    setUp(() {
      list = CircularDoublyLinkedList<int>();
    });

    group('empty list operations', () {
      test('should start empty', () {
        expect(list.isEmpty, isTrue);
        expect(list.isNotEmpty, isFalse);
        expect(list.length, equals(0));
      });

      test('should throw on first/last of empty list', () {
        expect(() => list.first, throwsStateError);
        expect(() => list.last, throwsStateError);
      });

      test('should throw on removeFirst of empty list', () {
        expect(() => list.removeFirst(), throwsStateError);
      });

      test('should throw on removeLast of empty list', () {
        expect(() => list.removeLast(), throwsStateError);
      });

      test('should return false on remove from empty list', () {
        expect(list.remove(1), isFalse);
      });

      test('should return false on contains for empty list', () {
        expect(list.contains(1), isFalse);
      });

      test('should throw on elementAt for empty list', () {
        expect(() => list.elementAt(0), throwsRangeError);
      });

      test('should return empty list from toList', () {
        expect(list.toList(), isEmpty);
      });

      test('should return empty iterable from values', () {
        expect(list.values.toList(), isEmpty);
      });

      test('should return empty iterable from valuesReversed', () {
        expect(list.valuesReversed.toList(), isEmpty);
      });
    });

    group('add operations', () {
      test('should add elements at the end', () {
        list.add(1);
        list.add(2);
        list.add(3);
        expect(list.length, equals(3));
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should add elements at the beginning with addFirst', () {
        list.addFirst(1);
        list.addFirst(2);
        list.addFirst(3);
        expect(list.toList(), equals([3, 2, 1]));
      });

      test('should add elements at the end with addLast', () {
        list.addLast(1);
        list.addLast(2);
        list.addLast(3);
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should get first and last elements', () {
        list.addAll([1, 2, 3]);
        expect(list.first, equals(1));
        expect(list.last, equals(3));
      });
    });

    group('remove operations', () {
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

      test('should remove by value', () {
        list.addAll([1, 2, 3, 2, 4]);
        expect(list.remove(2), isTrue);
        expect(list.toList(), equals([1, 3, 2, 4]));
        expect(list.remove(5), isFalse);
      });

      test('should remove first element by value', () {
        list.addAll([1, 2, 3]);
        expect(list.remove(1), isTrue);
        expect(list.toList(), equals([2, 3]));
      });

      test('should remove last element by value', () {
        list.addAll([1, 2, 3]);
        expect(list.remove(3), isTrue);
        expect(list.toList(), equals([1, 2]));
      });

      test('should remove middle element by value', () {
        list.addAll([1, 2, 3]);
        expect(list.remove(2), isTrue);
        expect(list.toList(), equals([1, 3]));
      });
    });

    group('contains and elementAt', () {
      test('should check contains', () {
        list.addAll([1, 2, 3]);
        expect(list.contains(2), isTrue);
        expect(list.contains(5), isFalse);
      });

      test('should get element at index', () {
        list.addAll([1, 2, 3]);
        expect(list.elementAt(0), equals(1));
        expect(list.elementAt(1), equals(2));
        expect(list.elementAt(2), equals(3));
      });

      test('should throw on elementAt with invalid index', () {
        list.addAll([1, 2, 3]);
        expect(() => list.elementAt(-1), throwsRangeError);
        expect(() => list.elementAt(3), throwsRangeError);
      });

      test('should access elements from both ends efficiently', () {
        list.addAll([1, 2, 3, 4, 5, 6]);
        expect(list.elementAt(0), equals(1));
        expect(list.elementAt(5), equals(6));
        expect(list.elementAt(2), equals(3));
        expect(list.elementAt(4), equals(5));
      });
    });

    group('length and isEmpty', () {
      test('should track length correctly', () {
        expect(list.length, equals(0));
        list.add(1);
        expect(list.length, equals(1));
        list.add(2);
        expect(list.length, equals(2));
        list.removeFirst();
        expect(list.length, equals(1));
      });

      test('should report isEmpty correctly', () {
        expect(list.isEmpty, isTrue);
        expect(list.isNotEmpty, isFalse);
        list.add(1);
        expect(list.isEmpty, isFalse);
        expect(list.isNotEmpty, isTrue);
      });
    });

    group('clear', () {
      test('should clear the list', () {
        list.addAll([1, 2, 3]);
        list.clear();
        expect(list.isEmpty, isTrue);
        expect(list.length, equals(0));
        expect(list.toList(), isEmpty);
      });
    });

    group('toList and values', () {
      test('should convert to list', () {
        list.addAll([1, 2, 3, 4, 5]);
        expect(list.toList(), equals([1, 2, 3, 4, 5]));
      });

      test('should iterate over values', () {
        list.addAll([1, 2, 3]);
        expect(list.values.toList(), equals([1, 2, 3]));
      });

      test('should iterate over values in reverse', () {
        list.addAll([1, 2, 3]);
        expect(list.valuesReversed.toList(), equals([3, 2, 1]));
      });
    });

    group('rotateForward', () {
      test('should rotate forward', () {
        list.addAll([1, 2, 3, 4, 5]);
        list.rotateForward(2);
        expect(list.toList(), equals([3, 4, 5, 1, 2]));
      });

      test('should not change list when rotating by 0', () {
        list.addAll([1, 2, 3]);
        list.rotateForward(0);
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should handle rotation by list length', () {
        list.addAll([1, 2, 3]);
        list.rotateForward(3);
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should handle rotation greater than list length', () {
        list.addAll([1, 2, 3]);
        list.rotateForward(5);
        expect(list.toList(), equals([3, 1, 2]));
      });

      test('should not rotate empty list', () {
        list.rotateForward(2);
        expect(list.toList(), isEmpty);
      });

      test('should not rotate single element list', () {
        list.add(1);
        list.rotateForward(5);
        expect(list.toList(), equals([1]));
      });
    });

    group('rotateBackward', () {
      test('should rotate backward', () {
        list.addAll([1, 2, 3, 4, 5]);
        list.rotateBackward(2);
        expect(list.toList(), equals([4, 5, 1, 2, 3]));
      });

      test('should not change list when rotating by 0', () {
        list.addAll([1, 2, 3]);
        list.rotateBackward(0);
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should handle rotation by list length', () {
        list.addAll([1, 2, 3]);
        list.rotateBackward(3);
        expect(list.toList(), equals([1, 2, 3]));
      });

      test('should handle rotation greater than list length', () {
        list.addAll([1, 2, 3]);
        list.rotateBackward(5);
        expect(list.toList(), equals([2, 3, 1]));
      });

      test('should not rotate empty list', () {
        list.rotateBackward(2);
        expect(list.toList(), isEmpty);
      });

      test('should not rotate single element list', () {
        list.add(1);
        list.rotateBackward(5);
        expect(list.toList(), equals([1]));
      });
    });

    group('rotateForward and rotateBackward equivalence', () {
      test('rotateForward and rotateBackward should be inverse operations', () {
        list.addAll([1, 2, 3, 4, 5]);
        list.rotateForward(2);
        list.rotateBackward(2);
        expect(list.toList(), equals([1, 2, 3, 4, 5]));
      });
    });

    group('circular nature verification', () {
      test('tail should point back to head (head.prev = tail)', () {
        list.addAll([1, 2, 3]);
        expect(list.head!.prev, equals(list.tail));
        expect(list.tail!.next, equals(list.head));
      });

      test('should traverse circularly forward beyond length', () {
        list.addAll([1, 2, 3]);
        var current = list.head;
        final values = <int>[];
        for (var i = 0; i < 7; i++) {
          values.add(current!.value);
          current = current.next;
        }
        expect(values, equals([1, 2, 3, 1, 2, 3, 1]));
      });

      test('should traverse circularly backward beyond length', () {
        list.addAll([1, 2, 3]);
        var current = list.head;
        final values = <int>[];
        for (var i = 0; i < 7; i++) {
          values.add(current!.value);
          current = current.prev;
        }
        expect(values, equals([1, 3, 2, 1, 3, 2, 1]));
      });
    });

    group('edge cases: single element', () {
      test('should handle single element add', () {
        list.add(1);
        expect(list.first, equals(1));
        expect(list.last, equals(1));
        expect(list.length, equals(1));
        expect(list.head!.next, equals(list.head));
        expect(list.head!.prev, equals(list.head));
      });

      test('should handle single element remove', () {
        list.add(1);
        expect(list.removeFirst(), equals(1));
        expect(list.isEmpty, isTrue);
      });

      test('should handle single element removeLast', () {
        list.add(1);
        expect(list.removeLast(), equals(1));
        expect(list.isEmpty, isTrue);
      });
    });

    group('edge cases: two elements', () {
      test('should handle two elements correctly', () {
        list.addAll([1, 2]);
        expect(list.first, equals(1));
        expect(list.last, equals(2));
        expect(list.head!.next, equals(list.tail));
        expect(list.head!.prev, equals(list.tail));
        expect(list.tail!.next, equals(list.head));
        expect(list.tail!.prev, equals(list.head));
      });

      test('should handle removeFirst with two elements', () {
        list.addAll([1, 2]);
        list.removeFirst();
        expect(list.first, equals(2));
        expect(list.last, equals(2));
        expect(list.head!.next, equals(list.head));
        expect(list.head!.prev, equals(list.head));
      });

      test('should handle removeLast with two elements', () {
        list.addAll([1, 2]);
        list.removeLast();
        expect(list.first, equals(1));
        expect(list.last, equals(1));
        expect(list.head!.next, equals(list.head));
        expect(list.head!.prev, equals(list.head));
      });
    });

    group('toString', () {
      test('should return correct string for empty list', () {
        expect(list.toString(), equals('CircularDoublyLinkedList: []'));
      });

      test('should return correct string for non-empty list', () {
        list.addAll([1, 2, 3]);
        expect(
          list.toString(),
          equals('CircularDoublyLinkedList: [1 <-> 2 <-> 3 <-> (head)]'),
        );
      });
    });

    group('factory constructor', () {
      test('should create from iterable', () {
        final newList = CircularDoublyLinkedList.from([1, 2, 3, 4, 5]);
        expect(newList.toList(), equals([1, 2, 3, 4, 5]));
      });
    });
  });

  group('CircularLinkedListNode', () {
    test('should create node with value', () {
      final node = CircularLinkedListNode(42);
      expect(node.value, equals(42));
      expect(node.next, isNull);
    });

    test('should chain nodes', () {
      final node3 = CircularLinkedListNode(3);
      final node2 = CircularLinkedListNode(2, node3);
      final node1 = CircularLinkedListNode(1, node2);

      expect(node1.next, equals(node2));
      expect(node2.next, equals(node3));
    });

    test('should have correct toString', () {
      final node = CircularLinkedListNode(42);
      expect(node.toString(), equals('Node(42)'));
    });
  });

  group('CircularDoublyLinkedListNode', () {
    test('should create node with value', () {
      final node = CircularDoublyLinkedListNode(42);
      expect(node.value, equals(42));
      expect(node.next, isNull);
      expect(node.prev, isNull);
    });

    test('should chain nodes bidirectionally', () {
      final node1 = CircularDoublyLinkedListNode(1);
      final node2 = CircularDoublyLinkedListNode(2, prev: node1);
      final node3 = CircularDoublyLinkedListNode(3, prev: node2);
      node1.next = node2;
      node2.next = node3;

      expect(node1.next, equals(node2));
      expect(node2.next, equals(node3));
      expect(node2.prev, equals(node1));
      expect(node3.prev, equals(node2));
    });

    test('should have correct toString', () {
      final node = CircularDoublyLinkedListNode(42);
      expect(node.toString(), equals('Node(42)'));
    });
  });
}

extension on CircularLinkedList<int> {
  void addAll(List<int> elements) {
    for (final e in elements) {
      add(e);
    }
  }
}

extension on CircularDoublyLinkedList<int> {
  void addAll(List<int> elements) {
    for (final e in elements) {
      add(e);
    }
  }
}
