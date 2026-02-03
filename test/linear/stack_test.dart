import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('Stack', () {
    late Stack<int> stack;

    setUp(() {
      stack = Stack<int>();
    });

    test('should start empty', () {
      expect(stack.isEmpty, isTrue);
      expect(stack.length, equals(0));
    });

    test('should push elements', () {
      stack.push(1);
      stack.push(2);
      stack.push(3);
      expect(stack.length, equals(3));
      expect(stack.isNotEmpty, isTrue);
    });

    test('should pop elements in LIFO order', () {
      stack.push(1);
      stack.push(2);
      stack.push(3);
      expect(stack.pop(), equals(3));
      expect(stack.pop(), equals(2));
      expect(stack.pop(), equals(1));
      expect(stack.isEmpty, isTrue);
    });

    test('should peek at top element', () {
      stack.push(1);
      stack.push(2);
      expect(stack.peek(), equals(2));
      expect(stack.length, equals(2)); // peek doesn't remove
    });

    test('should throw on pop from empty stack', () {
      expect(() => stack.pop(), throwsStateError);
    });

    test('should throw on peek from empty stack', () {
      expect(() => stack.peek(), throwsStateError);
    });

    test('should tryPop return null for empty stack', () {
      expect(stack.tryPop(), isNull);
    });

    test('should tryPeek return null for empty stack', () {
      expect(stack.tryPeek(), isNull);
    });

    test('should check contains', () {
      stack.push(1);
      stack.push(2);
      stack.push(3);
      expect(stack.contains(2), isTrue);
      expect(stack.contains(5), isFalse);
    });

    test('should search for element position from top', () {
      stack.push(1);
      stack.push(2);
      stack.push(3);
      expect(stack.search(3), equals(1)); // top
      expect(stack.search(2), equals(2));
      expect(stack.search(1), equals(3)); // bottom
      expect(stack.search(5), equals(-1)); // not found
    });

    test('should clear the stack', () {
      stack.push(1);
      stack.push(2);
      stack.clear();
      expect(stack.isEmpty, isTrue);
    });

    test('should convert to list', () {
      stack.push(1);
      stack.push(2);
      stack.push(3);
      expect(stack.toList(), equals([1, 2, 3]));
    });

    test('should iterate from top to bottom', () {
      stack.push(1);
      stack.push(2);
      stack.push(3);
      expect(stack.values.toList(), equals([3, 2, 1]));
    });

    test('should create from iterable', () {
      final newStack = Stack.from([1, 2, 3]);
      expect(newStack.peek(), equals(3));
      expect(newStack.pop(), equals(3));
      expect(newStack.pop(), equals(2));
    });
  });
}
