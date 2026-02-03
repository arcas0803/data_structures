import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('BinarySearchTree', () {
    late BinarySearchTree<int> tree;

    setUp(() {
      tree = BinarySearchTree<int>();
    });

    test('should start empty', () {
      expect(tree.isEmpty, isTrue);
      expect(tree.length, equals(0));
      expect(tree.root, isNull);
    });

    test('should insert elements', () {
      expect(tree.insert(5), isTrue);
      expect(tree.insert(3), isTrue);
      expect(tree.insert(7), isTrue);
      expect(tree.length, equals(3));
      expect(tree.isNotEmpty, isTrue);
    });

    test('should not insert duplicates', () {
      tree.insert(5);
      expect(tree.insert(5), isFalse);
      expect(tree.length, equals(1));
    });

    test('should check contains', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      expect(tree.contains(3), isTrue);
      expect(tree.contains(5), isTrue);
      expect(tree.contains(10), isFalse);
    });

    test('should search for nodes', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      expect(tree.search(3)?.value, equals(3));
      expect(tree.search(10), isNull);
    });

    test('should find min and max', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.insert(1);
      tree.insert(9);
      expect(tree.min, equals(1));
      expect(tree.max, equals(9));
    });

    test('should throw on min/max of empty tree', () {
      expect(() => tree.min, throwsStateError);
      expect(() => tree.max, throwsStateError);
    });

    test('should remove leaf node', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      expect(tree.remove(3), isTrue);
      expect(tree.contains(3), isFalse);
      expect(tree.length, equals(2));
    });

    test('should remove node with one child', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.insert(6);
      expect(tree.remove(7), isTrue);
      expect(tree.contains(6), isTrue);
    });

    test('should remove node with two children', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.insert(6);
      tree.insert(8);
      expect(tree.remove(7), isTrue);
      expect(tree.contains(6), isTrue);
      expect(tree.contains(8), isTrue);
    });

    test('should remove root', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      expect(tree.remove(5), isTrue);
      expect(tree.length, equals(2));
    });

    test('should not remove non-existent', () {
      tree.insert(5);
      expect(tree.remove(10), isFalse);
    });

    test('should traverse in-order (sorted)', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.insert(1);
      tree.insert(4);
      expect(tree.inOrder.toList(), equals([1, 3, 4, 5, 7]));
    });

    test('should traverse pre-order', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      expect(tree.preOrder.toList(), equals([5, 3, 7]));
    });

    test('should traverse post-order', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      expect(tree.postOrder.toList(), equals([3, 7, 5]));
    });

    test('should traverse level-order (BFS)', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.insert(1);
      tree.insert(4);
      expect(tree.levelOrder.toList(), equals([5, 3, 7, 1, 4]));
    });

    test('should find predecessor and successor', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.insert(1);
      tree.insert(4);
      tree.insert(6);
      tree.insert(9);

      expect(tree.predecessor(5), equals(4));
      expect(tree.successor(5), equals(6));
      expect(tree.predecessor(1), isNull);
      expect(tree.successor(9), isNull);
    });

    test('should find range', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.insert(1);
      tree.insert(4);
      tree.insert(6);
      tree.insert(9);

      expect(tree.range(3, 7).toList(), equals([3, 4, 5, 6, 7]));
    });

    test('should calculate height', () {
      expect(tree.height, equals(-1)); // empty tree
      tree.insert(5);
      expect(tree.height, equals(0));
      tree.insert(3);
      tree.insert(7);
      expect(tree.height, equals(1));
    });

    test('should check if balanced', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      expect(tree.isBalanced, isTrue);

      // Create unbalanced tree
      final unbalanced = BinarySearchTree<int>();
      unbalanced.insert(1);
      unbalanced.insert(2);
      unbalanced.insert(3);
      unbalanced.insert(4);
      expect(unbalanced.isBalanced, isFalse);
    });

    test('should clear the tree', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.clear();
      expect(tree.isEmpty, isTrue);
    });

    test('should convert to sorted list', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      tree.insert(1);
      expect(tree.toList(), equals([1, 3, 5, 7]));
    });

    test('should create from iterable', () {
      final newTree = BinarySearchTree.from([5, 3, 7, 1, 9]);
      expect(newTree.length, equals(5));
      expect(newTree.toList(), equals([1, 3, 5, 7, 9]));
    });
  });
}
