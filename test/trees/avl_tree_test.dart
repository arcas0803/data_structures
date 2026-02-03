import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('AVLTree', () {
    late AVLTree<int> tree;

    setUp(() {
      tree = AVLTree<int>();
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
    });

    test('should not insert duplicates', () {
      tree.insert(5);
      expect(tree.insert(5), isFalse);
      expect(tree.length, equals(1));
    });

    test('should maintain balance after insertions', () {
      // Insert in ascending order (would be unbalanced in regular BST)
      for (var i = 1; i <= 10; i++) {
        tree.insert(i);
        expect(tree.isValid, isTrue, reason: 'Tree should be valid after inserting $i');
      }
      expect(tree.height, lessThanOrEqualTo(4)); // log2(10) ~ 3.32
    });

    test('should balance after left-left case', () {
      tree.insert(30);
      tree.insert(20);
      tree.insert(10);
      expect(tree.isValid, isTrue);
      expect(tree.root!.value, equals(20));
    });

    test('should balance after right-right case', () {
      tree.insert(10);
      tree.insert(20);
      tree.insert(30);
      expect(tree.isValid, isTrue);
      expect(tree.root!.value, equals(20));
    });

    test('should balance after left-right case', () {
      tree.insert(30);
      tree.insert(10);
      tree.insert(20);
      expect(tree.isValid, isTrue);
      expect(tree.root!.value, equals(20));
    });

    test('should balance after right-left case', () {
      tree.insert(10);
      tree.insert(30);
      tree.insert(20);
      expect(tree.isValid, isTrue);
      expect(tree.root!.value, equals(20));
    });

    test('should check contains', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      expect(tree.contains(3), isTrue);
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
      for (var i = 1; i <= 10; i++) {
        tree.insert(i);
      }
      expect(tree.min, equals(1));
      expect(tree.max, equals(10));
    });

    test('should throw on min/max of empty tree', () {
      expect(() => tree.min, throwsStateError);
      expect(() => tree.max, throwsStateError);
    });

    test('should remove elements and maintain balance', () {
      for (var i = 1; i <= 10; i++) {
        tree.insert(i);
      }

      expect(tree.remove(5), isTrue);
      expect(tree.isValid, isTrue);
      expect(tree.contains(5), isFalse);

      expect(tree.remove(1), isTrue);
      expect(tree.isValid, isTrue);

      expect(tree.remove(10), isTrue);
      expect(tree.isValid, isTrue);
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
      final preOrder = tree.preOrder.toList();
      expect(preOrder.length, equals(3));
      expect(preOrder.first, equals(5)); // root
    });

    test('should traverse post-order', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      final postOrder = tree.postOrder.toList();
      expect(postOrder.length, equals(3));
      expect(postOrder.last, equals(5)); // root
    });

    test('should traverse level-order', () {
      tree.insert(5);
      tree.insert(3);
      tree.insert(7);
      final levelOrder = tree.levelOrder.toList();
      expect(levelOrder.first, equals(5)); // root
    });

    test('should find range', () {
      for (var i = 1; i <= 10; i++) {
        tree.insert(i);
      }
      expect(tree.range(3, 7).toList(), equals([3, 4, 5, 6, 7]));
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

    test('should handle stress test', () {
      // Insert many elements
      for (var i = 0; i < 1000; i++) {
        tree.insert(i);
        expect(tree.isValid, isTrue);
      }

      expect(tree.length, equals(1000));
      expect(tree.height, lessThanOrEqualTo(15)); // log2(1000) ~ 10

      // Remove half
      for (var i = 0; i < 500; i++) {
        tree.remove(i * 2);
        expect(tree.isValid, isTrue);
      }

      expect(tree.length, equals(500));
    });

    test('should create from iterable', () {
      final newTree = AVLTree.from([5, 3, 7, 1, 9, 2, 8]);
      expect(newTree.length, equals(7));
      expect(newTree.isValid, isTrue);
      expect(newTree.toList(), equals([1, 2, 3, 5, 7, 8, 9]));
    });
  });
}
