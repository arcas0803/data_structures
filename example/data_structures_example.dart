/// Data Structures Library - Main Demo
///
/// Run this file for a quick overview: dart run example/data_structures_example.dart
///
/// For detailed examples, run:
///   dart run example/linear_examples.dart   - LinkedList, Stack, Queue, etc.
///   dart run example/tree_examples.dart     - BST, AVL, Heap, Trie, etc.
///   dart run example/hash_examples.dart     - HashTable, HashSet, BloomFilter, etc.
///   dart run example/graph_examples.dart    - Graph, FlowNetwork, algorithms
///   dart run example/benchmarks.dart        - Performance benchmarks
///   dart run example/visualizations.dart    - ASCII art structure diagrams
library;

import 'package:data_structures/data_structures.dart';

void main() {
  print(
      '╔═══════════════════════════════════════════════════════════════════╗');
  print('║           DATA STRUCTURES LIBRARY - QUICK DEMO                   ║');
  print(
      '╚═══════════════════════════════════════════════════════════════════╝');
  print('');
  print('This demo shows basic usage of each structure category.');
  print('Run individual example files for comprehensive examples.');
  print('');

  // ============ LINEAR STRUCTURES ============
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('                      LINEAR STRUCTURES');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Linked List
  print('📋 LinkedList');
  final linkedList = LinkedList<int>();
  for (final item in [1, 2, 3, 4, 5]) {
    linkedList.add(item);
  }
  print('   $linkedList');
  linkedList.reverse();
  print('   Reversed: ${linkedList.toList()}\n');

  // Circular List
  print('🔄 CircularLinkedList');
  final circular = CircularLinkedList<String>();
  for (final day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']) {
    circular.add(day);
  }
  print('   $circular');
  circular.rotate(2);
  print('   After rotate(2): $circular\n');

  // Stack
  print('📚 Stack (LIFO)');
  final stack = Stack<String>();
  for (final item in ['first', 'second', 'third']) {
    stack.push(item);
  }
  print('   $stack');
  print('   Pop: ${stack.pop()}, Peek: ${stack.peek}\n');

  // Queue
  print('📬 Queue (FIFO)');
  final queue = Queue<int>();
  for (final item in [1, 2, 3]) {
    queue.enqueue(item);
  }
  print('   $queue');
  print('   Dequeue: ${queue.dequeue()}, Front: ${queue.front}\n');

  // Skip List
  print('⏭️  SkipList');
  final skipList = SkipList<int>();
  for (final item in [5, 2, 8, 1, 9, 3]) {
    skipList.insert(item);
  }
  print('   Sorted: ${skipList.toList()}');
  print(
      '   Contains 5? ${skipList.contains(5)}, Min: ${skipList.min}, Max: ${skipList.max}\n');

  // ============ DIRECT ACCESS STRUCTURES ============
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('                   DIRECT ACCESS STRUCTURES');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Hash Table
  print('🗂️  HashTable');
  final hashTable = HashTable<String, int>();
  hashTable['apple'] = 5;
  hashTable['banana'] = 3;
  hashTable['cherry'] = 8;
  print('   $hashTable');
  print('   hashTable["banana"] = ${hashTable['banana']}\n');

  // Hash Set
  print('🎯 HashSet');
  final setA = HashSet<int>.from([1, 2, 3, 4]);
  final setB = HashSet<int>.from([3, 4, 5, 6]);
  print('   Set A: $setA');
  print('   Set B: $setB');
  print('   Union: ${setA.union(setB)}');
  print('   Intersection: ${setA.intersection(setB)}\n');

  // Union Find
  print('🔗 UnionFind');
  final uf = UnionFind<String>();
  ['A', 'B', 'C', 'D'].forEach(uf.makeSet);
  uf.union('A', 'B');
  uf.union('C', 'D');
  uf.union('A', 'C');
  print('   After unions: ${uf.setCount} sets');
  print('   A and D connected? ${uf.connected('A', 'D')}\n');

  // Bloom Filter
  print('🌸 BloomFilter');
  final bloom = BloomFilter<String>(1000, 0.01);
  bloom.addAll(['hello', 'world', 'dart']);
  print('   Contains "hello"? ${bloom.contains('hello')}');
  print('   Contains "java"? ${bloom.contains('java')}\n');

  // ============ TREE STRUCTURES ============
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('                       TREE STRUCTURES');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // BST
  print('🌲 BinarySearchTree');
  final bst = BinarySearchTree<int>();
  [50, 30, 70, 20, 40, 60, 80].forEach(bst.insert);
  print('   In-order: ${bst.inOrder.toList()}');
  print('   Min: ${bst.min}, Max: ${bst.max}, Height: ${bst.height}\n');

  // AVL
  print('⚖️  AVLTree (Self-Balancing)');
  final avl = AVLTree<int>();
  for (var i = 1; i <= 15; i++) avl.insert(i);
  print('   Sequential insert 1-15: height = ${avl.height} (balanced!)');
  print('   Is valid AVL: ${avl.isValid}\n');

  // Heap
  print('📊 Heap');
  final minHeap = Heap<int>.minHeap();
  minHeap.addAll([5, 3, 8, 1, 9, 2]);
  print('   Min-heap peek: ${minHeap.peek}');
  print('   Extract all: ${minHeap.extractAll()}\n');

  // Priority Queue
  print('🎖️  PriorityQueue');
  final pq = PriorityQueue<int>();
  for (final item in [5, 1, 3, 2, 4]) {
    pq.enqueue(item);
  }
  print('   Dequeue order: ${[pq.dequeue(), pq.dequeue(), pq.dequeue()]}\n');

  // Trie
  print('📝 Trie');
  final trie = Trie();
  trie.insertAll(['car', 'card', 'care', 'careful', 'cat']);
  print('   Words with prefix "car": ${trie.getWordsWithPrefix('car')}');
  print('   Contains "care"? ${trie.contains('care')}\n');

  // Segment Tree
  print('📈 SegmentTree');
  final segTree = SegmentTree<num>.sum([1, 2, 3, 4, 5]);
  print('   Array: [1, 2, 3, 4, 5]');
  print('   Sum query [1,3]: ${segTree.query(1, 3)} (2+3+4=9)\n');

  // Fibonacci Heap
  print('🌀 FibonacciHeap');
  final fibHeap = FibonacciHeap<int>.minHeap();
  final nodes = [5, 3, 8, 1].map((v) => fibHeap.insert(v)).toList();
  print('   Min: ${fibHeap.peek}');
  fibHeap.decreaseKey(nodes[2], 0); // Decrease 8 to 0
  print('   After decreaseKey(8→0): min = ${fibHeap.peek}\n');

  // Min-Max Heap
  print('↕️  MinMaxHeap');
  final mmHeap = MinMaxHeap<int>();
  mmHeap.addAll([5, 3, 8, 1, 9, 2]);
  print('   Min: ${mmHeap.peekMin()}, Max: ${mmHeap.peekMax()}\n');

  // ============ GRAPH STRUCTURES ============
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('                      GRAPH STRUCTURES');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  // Graph
  print('🕸️  Graph');
  final graph = Graph<String>();
  graph.addEdge('A', 'B');
  graph.addEdge('A', 'C');
  graph.addEdge('B', 'D');
  graph.addEdge('C', 'D');
  print('   BFS from A: ${graph.bfs('A').toList()}');
  print('   DFS from A: ${graph.dfs('A').toList()}');
  print('   Path A → D: ${graph.bfsPath('A', 'D')}\n');

  // Directed Graph
  print('➡️  Directed Graph');
  final digraph = Graph<String>(type: GraphType.directed);
  digraph.addEdge('A', 'B');
  digraph.addEdge('A', 'C');
  digraph.addEdge('B', 'D');
  digraph.addEdge('C', 'D');
  print('   Topological sort: ${digraph.topologicalSort()}');
  print('   Has cycle: ${digraph.hasCycle}\n');

  // Flow Network
  print('🌊 FlowNetwork');
  final flow = FlowNetwork<String>();
  flow.addEdge('S', 'A', 10);
  flow.addEdge('S', 'B', 8);
  flow.addEdge('A', 'T', 7);
  flow.addEdge('B', 'T', 9);
  flow.addEdge('A', 'B', 5);
  print('   Max flow S → T: ${flow.maxFlow('S', 'T')}\n');

  // ============ SUMMARY ============
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('                          SUMMARY');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  print('📦 Linear:        LinkedList, DoublyLinkedList, CircularLinkedList,');
  print('                  Stack, Queue, Deque, SkipList');
  print('');
  print('🔑 Direct Access: DynamicArray, HashTable, HashSet,');
  print('                  UnionFind, BloomFilter');
  print('');
  print('🌳 Trees:         BST, AVLTree, Heap, PriorityQueue,');
  print('                  NaryTree, Trie, BTree, BPlusTree,');
  print('                  SegmentTree, FenwickTree,');
  print('                  FibonacciHeap, MinMaxHeap');
  print('');
  print('🕸️  Graphs:        Graph, AdjacencyMatrixGraph, FlowNetwork');
  print('');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('For more details, run the specialized example files!');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
}
