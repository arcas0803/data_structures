import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('NaryTree', () {
    late NaryTree<int> tree;

    setUp(() {
      tree = NaryTree<int>();
    });

    group('empty tree operations', () {
      test('should start empty', () {
        expect(tree.isEmpty, isTrue);
        expect(tree.isNotEmpty, isFalse);
        expect(tree.size, equals(0));
        expect(tree.root, isNull);
      });

      test('should have height -1 when empty', () {
        expect(tree.height, equals(-1));
      });

      test('should return empty traversals', () {
        expect(tree.preOrder.toList(), isEmpty);
        expect(tree.postOrder.toList(), isEmpty);
        expect(tree.levelOrder.toList(), isEmpty);
      });

      test('should not find anything in empty tree', () {
        expect(tree.find(1), isNull);
        expect(tree.contains(1), isFalse);
      });

      test('should not remove from empty tree', () {
        expect(tree.remove(1), isFalse);
      });

      test('should convert to empty list', () {
        expect(tree.toList(), isEmpty);
      });

      test('should display empty tree string', () {
        expect(tree.toString(), equals('NaryTree: (empty)'));
        expect(tree.toTreeString(), equals('(empty)'));
      });
    });

    group('setRoot', () {
      test('should set root on empty tree', () {
        final root = tree.setRoot(10);
        expect(tree.isEmpty, isFalse);
        expect(tree.isNotEmpty, isTrue);
        expect(tree.size, equals(1));
        expect(tree.root, equals(root));
        expect(root.value, equals(10));
      });

      test('should replace existing root', () {
        tree.setRoot(10);
        final newRoot = tree.setRoot(20);
        expect(tree.size, equals(1));
        expect(tree.root?.value, equals(20));
        expect(newRoot.value, equals(20));
      });

      test('root node should be root and leaf', () {
        final root = tree.setRoot(10);
        expect(root.isRoot, isTrue);
        expect(root.isLeaf, isTrue);
        expect(root.parent, isNull);
      });
    });

    group('NaryTree.withRoot constructor', () {
      test('should create tree with root', () {
        final treeWithRoot = NaryTree<int>.withRoot(42);
        expect(treeWithRoot.isEmpty, isFalse);
        expect(treeWithRoot.size, equals(1));
        expect(treeWithRoot.root?.value, equals(42));
      });
    });

    group('addChild', () {
      test('should add child to root', () {
        tree.setRoot(1);
        final child = tree.addChild(1, 2);
        expect(child, isNotNull);
        expect(child?.value, equals(2));
        expect(tree.size, equals(2));
      });

      test('should add multiple children to same parent', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(1, 4);
        expect(tree.size, equals(4));
        expect(tree.root?.childCount, equals(3));
      });

      test('should add child to non-root node', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        final grandchild = tree.addChild(2, 5);
        expect(grandchild, isNotNull);
        expect(grandchild?.value, equals(5));
        expect(tree.size, equals(3));
      });

      test('should return null when parent not found', () {
        tree.setRoot(1);
        final child = tree.addChild(99, 2);
        expect(child, isNull);
        expect(tree.size, equals(1));
      });

      test('should return null when tree is empty', () {
        final child = tree.addChild(1, 2);
        expect(child, isNull);
      });

      test('child should have correct parent reference', () {
        tree.setRoot(1);
        final child = tree.addChild(1, 2);
        expect(child?.parent?.value, equals(1));
        expect(child?.isRoot, isFalse);
      });

      test('parent should no longer be leaf after adding child', () {
        final root = tree.setRoot(1);
        expect(root.isLeaf, isTrue);
        tree.addChild(1, 2);
        expect(root.isLeaf, isFalse);
      });
    });

    group('find', () {
      setUp(() {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(2, 4);
        tree.addChild(2, 5);
        tree.addChild(3, 6);
      });

      test('should find root', () {
        final node = tree.find(1);
        expect(node, isNotNull);
        expect(node?.value, equals(1));
      });

      test('should find child nodes', () {
        expect(tree.find(2)?.value, equals(2));
        expect(tree.find(3)?.value, equals(3));
      });

      test('should find grandchild nodes', () {
        expect(tree.find(4)?.value, equals(4));
        expect(tree.find(5)?.value, equals(5));
        expect(tree.find(6)?.value, equals(6));
      });

      test('should return null for non-existent value', () {
        expect(tree.find(99), isNull);
      });
    });

    group('contains', () {
      setUp(() {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
      });

      test('should return true for existing values', () {
        expect(tree.contains(1), isTrue);
        expect(tree.contains(2), isTrue);
        expect(tree.contains(3), isTrue);
      });

      test('should return false for non-existent values', () {
        expect(tree.contains(99), isFalse);
        expect(tree.contains(0), isFalse);
      });
    });

    group('remove', () {
      test('should remove leaf node', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        expect(tree.remove(2), isTrue);
        expect(tree.size, equals(2));
        expect(tree.contains(2), isFalse);
        expect(tree.contains(3), isTrue);
      });

      test('should remove node with children (entire subtree)', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(2, 4);
        tree.addChild(2, 5);
        tree.addChild(1, 3);
        expect(tree.size, equals(5));
        expect(tree.remove(2), isTrue);
        expect(tree.size, equals(2));
        expect(tree.contains(2), isFalse);
        expect(tree.contains(4), isFalse);
        expect(tree.contains(5), isFalse);
        expect(tree.contains(1), isTrue);
        expect(tree.contains(3), isTrue);
      });

      test('should remove root', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        expect(tree.remove(1), isTrue);
        expect(tree.isEmpty, isTrue);
        expect(tree.size, equals(0));
      });

      test('should return false for non-existent value', () {
        tree.setRoot(1);
        expect(tree.remove(99), isFalse);
        expect(tree.size, equals(1));
      });

      test('should return false for empty tree', () {
        expect(tree.remove(1), isFalse);
      });
    });

    group('clear', () {
      test('should clear all nodes', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.clear();
        expect(tree.isEmpty, isTrue);
        expect(tree.size, equals(0));
        expect(tree.root, isNull);
      });

      test('should be safe to clear empty tree', () {
        tree.clear();
        expect(tree.isEmpty, isTrue);
      });
    });

    group('height', () {
      test('should be -1 for empty tree', () {
        expect(tree.height, equals(-1));
      });

      test('should be 0 for single root', () {
        tree.setRoot(1);
        expect(tree.height, equals(0));
      });

      test('should be 1 for root with children', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        expect(tree.height, equals(1));
      });

      test('should be 2 for three levels', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(2, 4);
        expect(tree.height, equals(2));
      });

      test('should return max depth for unbalanced tree', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(2, 4);
        tree.addChild(4, 5);
        tree.addChild(5, 6);
        expect(tree.height, equals(4));
      });
    });

    group('preOrder traversal', () {
      test('should traverse single root', () {
        tree.setRoot(1);
        expect(tree.preOrder.toList(), equals([1]));
      });

      test('should traverse root then children left to right', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(1, 4);
        expect(tree.preOrder.toList(), equals([1, 2, 3, 4]));
      });

      test('should traverse deep tree correctly', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(2, 4);
        tree.addChild(2, 5);
        tree.addChild(3, 6);
        expect(tree.preOrder.toList(), equals([1, 2, 4, 5, 3, 6]));
      });
    });

    group('postOrder traversal', () {
      test('should traverse single root', () {
        tree.setRoot(1);
        expect(tree.postOrder.toList(), equals([1]));
      });

      test('should traverse children then root', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(1, 4);
        expect(tree.postOrder.toList(), equals([2, 3, 4, 1]));
      });

      test('should traverse deep tree correctly', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(2, 4);
        tree.addChild(2, 5);
        tree.addChild(3, 6);
        expect(tree.postOrder.toList(), equals([4, 5, 2, 6, 3, 1]));
      });
    });

    group('levelOrder traversal', () {
      test('should traverse single root', () {
        tree.setRoot(1);
        expect(tree.levelOrder.toList(), equals([1]));
      });

      test('should traverse level by level', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(2, 4);
        tree.addChild(2, 5);
        tree.addChild(3, 6);
        expect(tree.levelOrder.toList(), equals([1, 2, 3, 4, 5, 6]));
      });

      test('should traverse wide tree correctly', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(1, 4);
        tree.addChild(1, 5);
        expect(tree.levelOrder.toList(), equals([1, 2, 3, 4, 5]));
      });
    });

    group('toList', () {
      test('should convert to list using preOrder', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        expect(tree.toList(), equals([1, 2, 3]));
      });
    });

    group('toString', () {
      test('should display empty tree', () {
        expect(tree.toString(), equals('NaryTree: (empty)'));
      });

      test('should display tree contents', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        expect(tree.toString(), equals('NaryTree: [1, 2, 3]'));
      });
    });

    group('toTreeString visualization', () {
      test('should display empty tree', () {
        expect(tree.toTreeString(), equals('(empty)'));
      });

      test('should display single root', () {
        tree.setRoot(1);
        final output = tree.toTreeString();
        expect(output, contains('1'));
        expect(output, contains('└──'));
      });

      test('should display multi-level tree', () {
        tree.setRoot(1);
        tree.addChild(1, 2);
        tree.addChild(1, 3);
        tree.addChild(2, 4);
        final output = tree.toTreeString();
        expect(output, contains('1'));
        expect(output, contains('2'));
        expect(output, contains('3'));
        expect(output, contains('4'));
      });
    });

    group('edge cases', () {
      group('single root', () {
        test('should handle all operations on single root', () {
          tree.setRoot(42);
          expect(tree.size, equals(1));
          expect(tree.height, equals(0));
          expect(tree.contains(42), isTrue);
          expect(tree.preOrder.toList(), equals([42]));
          expect(tree.postOrder.toList(), equals([42]));
          expect(tree.levelOrder.toList(), equals([42]));
        });
      });

      group('deep tree', () {
        test('should handle deeply nested tree', () {
          tree.setRoot(1);
          for (var i = 2; i <= 10; i++) {
            tree.addChild(i - 1, i);
          }
          expect(tree.size, equals(10));
          expect(tree.height, equals(9));
          expect(tree.contains(10), isTrue);
          expect(tree.find(10)?.isLeaf, isTrue);
        });

        test('should remove deep leaf correctly', () {
          tree.setRoot(1);
          for (var i = 2; i <= 5; i++) {
            tree.addChild(i - 1, i);
          }
          expect(tree.remove(5), isTrue);
          expect(tree.size, equals(4));
          expect(tree.height, equals(3));
        });
      });

      group('wide tree', () {
        test('should handle tree with many children', () {
          tree.setRoot(1);
          for (var i = 2; i <= 101; i++) {
            tree.addChild(1, i);
          }
          expect(tree.size, equals(101));
          expect(tree.height, equals(1));
          expect(tree.root?.childCount, equals(100));
        });

        test('should traverse wide tree correctly', () {
          tree.setRoot(1);
          tree.addChild(1, 2);
          tree.addChild(1, 3);
          tree.addChild(1, 4);
          tree.addChild(1, 5);
          expect(tree.levelOrder.toList(), equals([1, 2, 3, 4, 5]));
        });
      });

      group('duplicate values', () {
        test('should allow duplicate values', () {
          tree.setRoot(1);
          tree.addChild(1, 2);
          tree.addChild(1, 2);
          expect(tree.size, equals(3));
        });

        test('should find first occurrence of duplicate', () {
          tree.setRoot(1);
          tree.addChild(1, 2);
          tree.addChild(1, 2);
          final found = tree.find(2);
          expect(found, isNotNull);
        });
      });
    });

    group('with strings', () {
      late NaryTree<String> stringTree;

      setUp(() {
        stringTree = NaryTree<String>();
      });

      test('should work with string values', () {
        stringTree.setRoot('root');
        stringTree.addChild('root', 'child1');
        stringTree.addChild('root', 'child2');
        expect(stringTree.size, equals(3));
        expect(stringTree.contains('child1'), isTrue);
        expect(
            stringTree.preOrder.toList(), equals(['root', 'child1', 'child2']));
      });
    });
  });

  group('NaryTreeNode', () {
    test('should create node with value', () {
      final node = NaryTreeNode<int>(42);
      expect(node.value, equals(42));
      expect(node.children, isEmpty);
      expect(node.parent, isNull);
    });

    test('should be leaf when no children', () {
      final node = NaryTreeNode<int>(1);
      expect(node.isLeaf, isTrue);
    });

    test('should not be leaf when has children', () {
      final node = NaryTreeNode<int>(1);
      node.addChild(2);
      expect(node.isLeaf, isFalse);
    });

    test('should be root when no parent', () {
      final node = NaryTreeNode<int>(1);
      expect(node.isRoot, isTrue);
    });

    test('should not be root when has parent', () {
      final parent = NaryTreeNode<int>(1);
      final child = parent.addChild(2);
      expect(child.isRoot, isFalse);
    });

    test('should add child and set parent reference', () {
      final parent = NaryTreeNode<int>(1);
      final child = parent.addChild(2);
      expect(parent.children.length, equals(1));
      expect(parent.children.first, equals(child));
      expect(child.parent, equals(parent));
    });

    test('should return child count', () {
      final node = NaryTreeNode<int>(1);
      expect(node.childCount, equals(0));
      node.addChild(2);
      node.addChild(3);
      expect(node.childCount, equals(2));
    });

    test('should remove child', () {
      final parent = NaryTreeNode<int>(1);
      final child = parent.addChild(2);
      expect(parent.removeChild(child), isTrue);
      expect(parent.children, isEmpty);
    });

    test('should return false when removing non-existent child', () {
      final parent = NaryTreeNode<int>(1);
      final unrelated = NaryTreeNode<int>(99);
      expect(parent.removeChild(unrelated), isFalse);
    });

    test('should have correct toString', () {
      final node = NaryTreeNode<int>(42);
      expect(node.toString(), equals('NaryTreeNode(42)'));
    });

    test('value should be mutable', () {
      final node = NaryTreeNode<int>(1);
      node.value = 99;
      expect(node.value, equals(99));
    });

    test('should create node with initial children', () {
      final child1 = NaryTreeNode<int>(2);
      final child2 = NaryTreeNode<int>(3);
      final parent = NaryTreeNode<int>(1, children: [child1, child2]);
      expect(parent.childCount, equals(2));
      expect(parent.children, contains(child1));
      expect(parent.children, contains(child2));
    });

    test('should create node with parent', () {
      final parent = NaryTreeNode<int>(1);
      final child = NaryTreeNode<int>(2, parent: parent);
      expect(child.parent, equals(parent));
      expect(child.isRoot, isFalse);
    });
  });
}
