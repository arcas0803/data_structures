/// Performance benchmarks for all data structures
/// Run with: dart run example/benchmarks.dart
library;

import 'dart:math';
import 'package:data_structures/data_structures.dart';

/// ANSI color codes for console output
class Colors {
  static const reset = '\x1B[0m';
  static const bold = '\x1B[1m';
  static const dim = '\x1B[2m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const magenta = '\x1B[35m';
  static const cyan = '\x1B[36m';
  static const white = '\x1B[37m';
}

/// Benchmark result holder
class BenchmarkResult {
  final String name;
  final int operations;
  final Duration duration;
  
  BenchmarkResult(this.name, this.operations, this.duration);
  
  double get opsPerSecond => operations / (duration.inMicroseconds / 1000000);
  double get microsPerOp => duration.inMicroseconds / operations;
  
  @override
  String toString() {
    final opsStr = opsPerSecond > 1000000 
        ? '${(opsPerSecond / 1000000).toStringAsFixed(2)}M ops/sec'
        : opsPerSecond > 1000
            ? '${(opsPerSecond / 1000).toStringAsFixed(2)}K ops/sec'
            : '${opsPerSecond.toStringAsFixed(2)} ops/sec';
    return '${name.padRight(30)} ${opsStr.padLeft(18)} (${microsPerOp.toStringAsFixed(3)} µs/op)';
  }
}

/// Run a benchmark and return result
BenchmarkResult benchmark(String name, int iterations, void Function() operation) {
  // Warmup
  for (var i = 0; i < min(1000, iterations ~/ 10); i++) {
    operation();
  }
  
  final stopwatch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    operation();
  }
  stopwatch.stop();
  
  return BenchmarkResult(name, iterations, stopwatch.elapsed);
}

void printHeader(String title) {
  print('');
  print('${Colors.bold}${Colors.cyan}${'=' * 70}${Colors.reset}');
  print('${Colors.bold}${Colors.cyan}  $title${Colors.reset}');
  print('${Colors.bold}${Colors.cyan}${'=' * 70}${Colors.reset}');
}

void printSubHeader(String title) {
  print('');
  print('${Colors.yellow}--- $title ---${Colors.reset}');
}

void main() {
  final random = Random(42); // Fixed seed for reproducibility
  
  print('${Colors.bold}${Colors.magenta}');
  print(r'''
  ╔═══════════════════════════════════════════════════════════════════╗
  ║           DATA STRUCTURES PERFORMANCE BENCHMARKS                  ║
  ╚═══════════════════════════════════════════════════════════════════╝
  ''');
  print(Colors.reset);

  // ============================================================
  // LINEAR STRUCTURES
  // ============================================================
  printHeader('LINEAR STRUCTURES');
  
  printSubHeader('LinkedList vs DoublyLinkedList vs DynamicArray');
  const n = 10000;
  
  // Insert at head
  print(benchmark('LinkedList.addFirst', n, () {
    final list = LinkedList<int>();
    for (var i = 0; i < 100; i++) list.addFirst(i);
  }));
  
  print(benchmark('DoublyLinkedList.addFirst', n, () {
    final list = DoublyLinkedList<int>();
    for (var i = 0; i < 100; i++) list.addFirst(i);
  }));
  
  print(benchmark('DynamicArray.insert(0)', n, () {
    final arr = DynamicArray<int>();
    for (var i = 0; i < 100; i++) arr.insert(0, i);
  }));
  
  // Insert at tail
  print('');
  print(benchmark('LinkedList.add (tail)', n, () {
    final list = LinkedList<int>();
    for (var i = 0; i < 100; i++) list.add(i);
  }));
  
  print(benchmark('DoublyLinkedList.add (tail)', n, () {
    final list = DoublyLinkedList<int>();
    for (var i = 0; i < 100; i++) list.add(i);
  }));
  
  print(benchmark('DynamicArray.add (tail)', n, () {
    final arr = DynamicArray<int>();
    for (var i = 0; i < 100; i++) arr.add(i);
  }));

  // ============================================================
  // CIRCULAR LISTS
  // ============================================================
  printSubHeader('Circular Lists - Rotation Performance');
  
  final circularList = CircularLinkedList<int>();
  for (var i = 0; i < 1000; i++) circularList.add(i);
  
  print(benchmark('CircularLinkedList.rotate(1)', 100000, () {
    circularList.rotate(1);
  }));
  
  print(benchmark('CircularLinkedList.rotate(100)', 10000, () {
    circularList.rotate(100);
  }));
  
  final circularDoubly = CircularDoublyLinkedList<int>();
  for (var i = 0; i < 1000; i++) circularDoubly.add(i);
  
  print(benchmark('CircularDoublyLinkedList.rotateForward(1)', 100000, () {
    circularDoubly.rotateForward(1);
  }));
  
  print(benchmark('CircularDoublyLinkedList.rotateBackward(1)', 100000, () {
    circularDoubly.rotateBackward(1);
  }));

  // ============================================================
  // SKIP LIST vs BST vs AVL
  // ============================================================
  printSubHeader('SkipList vs BST vs AVL - Search Performance');
  
  final skipList = SkipList<int>();
  final bst = BinarySearchTree<int>();
  final avl = AVLTree<int>();
  
  // Insert random values
  final searchValues = <int>[];
  for (var i = 0; i < 10000; i++) {
    final v = random.nextInt(100000);
    skipList.insert(v);
    bst.insert(v);
    avl.insert(v);
    if (i % 100 == 0) searchValues.add(v);
  }
  
  print(benchmark('SkipList.contains (10K elements)', 10000, () {
    for (final v in searchValues) skipList.contains(v);
  }));
  
  print(benchmark('BST.contains (10K elements)', 10000, () {
    for (final v in searchValues) bst.contains(v);
  }));
  
  print(benchmark('AVL.contains (10K elements)', 10000, () {
    for (final v in searchValues) avl.contains(v);
  }));

  // ============================================================
  // STACK vs QUEUE vs DEQUE
  // ============================================================
  printSubHeader('Stack vs Queue vs Deque');
  
  print(benchmark('Stack push/pop', n, () {
    final stack = Stack<int>();
    for (var i = 0; i < 100; i++) stack.push(i);
    while (stack.isNotEmpty) stack.pop();
  }));
  
  print(benchmark('Queue enqueue/dequeue', n, () {
    final queue = Queue<int>();
    for (var i = 0; i < 100; i++) queue.enqueue(i);
    while (queue.isNotEmpty) queue.dequeue();
  }));
  
  print(benchmark('Deque addLast/removeFirst', n, () {
    final deque = Deque<int>();
    for (var i = 0; i < 100; i++) deque.addLast(i);
    while (deque.isNotEmpty) deque.removeFirst();
  }));

  // ============================================================
  // HASH STRUCTURES
  // ============================================================
  printHeader('HASH STRUCTURES');
  
  printSubHeader('HashTable Operations');
  
  final hashTable = HashTable<int, int>();
  for (var i = 0; i < 10000; i++) hashTable[i] = i * 2;
  
  print(benchmark('HashTable.put', 100000, () {
    hashTable[random.nextInt(100000)] = 42;
  }));
  
  print(benchmark('HashTable.get (hit)', 100000, () {
    hashTable[random.nextInt(10000)];
  }));
  
  print(benchmark('HashTable.containsKey (miss)', 100000, () {
    hashTable.containsKey(random.nextInt(100000) + 50000);
  }));
  
  printSubHeader('BloomFilter vs HashSet - Membership Test');
  
  final bloomFilter = BloomFilter<int>(10000, 0.01);
  final hashSet = HashSet<int>();
  
  for (var i = 0; i < 10000; i++) {
    bloomFilter.add(i);
    hashSet.add(i);
  }
  
  print(benchmark('BloomFilter.contains', 100000, () {
    bloomFilter.contains(random.nextInt(20000));
  }));
  
  print(benchmark('HashSet.contains', 100000, () {
    hashSet.contains(random.nextInt(20000));
  }));

  // ============================================================
  // UNION FIND
  // ============================================================
  printSubHeader('UnionFind vs UnionFindInt');
  
  print(benchmark('UnionFind<int> union', 1000, () {
    final uf = UnionFind<int>();
    for (var i = 0; i < 1000; i++) uf.makeSet(i);
    for (var i = 0; i < 999; i++) uf.union(i, i + 1);
  }));
  
  print(benchmark('UnionFindInt union', 1000, () {
    final uf = UnionFindInt(1000);
    for (var i = 0; i < 999; i++) uf.union(i, i + 1);
  }));
  
  final ufInt = UnionFindInt(10000);
  for (var i = 0; i < 9999; i += 2) ufInt.union(i, i + 1);
  
  print(benchmark('UnionFindInt.find (with compression)', 100000, () {
    ufInt.find(random.nextInt(10000));
  }));

  // ============================================================
  // TREE STRUCTURES
  // ============================================================
  printHeader('TREE STRUCTURES');
  
  printSubHeader('BST vs AVL - Sequential Insert (Worst Case for BST)');
  
  print(benchmark('BST sequential insert (1-1000)', 100, () {
    final tree = BinarySearchTree<int>();
    for (var i = 1; i <= 1000; i++) tree.insert(i);
  }));
  
  print(benchmark('AVL sequential insert (1-1000)', 100, () {
    final tree = AVLTree<int>();
    for (var i = 1; i <= 1000; i++) tree.insert(i);
  }));
  
  printSubHeader('Heap Operations');
  
  print(benchmark('Heap.insert', 10000, () {
    final heap = Heap<int>.minHeap();
    for (var i = 0; i < 100; i++) heap.insert(random.nextInt(1000));
  }));
  
  print(benchmark('Heap.extract', 10000, () {
    final heap = Heap<int>.minHeap();
    for (var i = 0; i < 100; i++) heap.insert(random.nextInt(1000));
    while (heap.isNotEmpty) heap.extract();
  }));
  
  print(benchmark('Heap.from (heapify)', 10000, () {
    final data = List.generate(100, (_) => random.nextInt(1000));
    Heap.from(data, type: HeapType.min);
  }));
  
  printSubHeader('Fibonacci Heap vs Binary Heap');
  
  print(benchmark('BinaryHeap insert+extract', 1000, () {
    final heap = Heap<int>.minHeap();
    for (var i = 0; i < 100; i++) heap.insert(random.nextInt(1000));
    for (var i = 0; i < 50; i++) heap.extract();
  }));
  
  print(benchmark('FibonacciHeap insert+extract', 1000, () {
    final heap = FibonacciHeap<int>.minHeap();
    for (var i = 0; i < 100; i++) heap.insert(random.nextInt(1000));
    for (var i = 0; i < 50; i++) heap.extractMin();
  }));
  
  printSubHeader('MinMaxHeap - Double-Ended Access');
  
  final mmHeap = MinMaxHeap<int>();
  for (var i = 0; i < 10000; i++) mmHeap.insert(random.nextInt(100000));
  
  print(benchmark('MinMaxHeap.peekMin', 100000, () {
    mmHeap.peekMin();
  }));
  
  print(benchmark('MinMaxHeap.peekMax', 100000, () {
    mmHeap.peekMax();
  }));

  // ============================================================
  // TRIE
  // ============================================================
  printSubHeader('Trie - String Operations');
  
  final words = [
    'apple', 'application', 'apply', 'banana', 'band', 'bandana',
    'cat', 'car', 'card', 'care', 'careful', 'careless',
  ];
  
  final trie = Trie();
  for (final word in words) trie.insert(word);
  
  print(benchmark('Trie.insert', 10000, () {
    final t = Trie();
    for (final word in words) t.insert(word);
  }));
  
  print(benchmark('Trie.contains', 100000, () {
    trie.contains('careful');
  }));
  
  print(benchmark('Trie.startsWith', 100000, () {
    trie.startsWith('car');
  }));
  
  print(benchmark('Trie.getWordsWithPrefix', 10000, () {
    trie.getWordsWithPrefix('car');
  }));

  // ============================================================
  // B-TREE
  // ============================================================
  printSubHeader('BTree vs BPlusTree');
  
  print(benchmark('BTree insert (t=3)', 1000, () {
    final tree = BTree<int, int>(3);
    for (var i = 0; i < 100; i++) tree.insert(random.nextInt(10000), i);
  }));
  
  print(benchmark('BPlusTree insert (t=3)', 1000, () {
    final tree = BPlusTree<int, int>(3);
    for (var i = 0; i < 100; i++) tree.insert(random.nextInt(10000), i);
  }));
  
  final bPlusTree = BPlusTree<int, String>(3);
  for (var i = 0; i < 1000; i++) bPlusTree.insert(i, 'value$i');
  
  print(benchmark('BPlusTree.range query', 10000, () {
    bPlusTree.range(100, 200).toList();
  }));

  // ============================================================
  // SEGMENT TREE & FENWICK TREE
  // ============================================================
  printSubHeader('SegmentTree vs FenwickTree - Range Queries');
  
  final data = List.generate(10000, (i) => i);
  final segTree = SegmentTree<num>.sum(data);
  final fenwick = FenwickTree(data);
  
  print(benchmark('SegmentTree.query', 100000, () {
    segTree.query(random.nextInt(5000), 5000 + random.nextInt(5000));
  }));
  
  print(benchmark('FenwickTree.rangeSum', 100000, () {
    fenwick.rangeSum(random.nextInt(5000), 5000 + random.nextInt(5000));
  }));
  
  print(benchmark('SegmentTree.update', 100000, () {
    segTree.update(random.nextInt(10000), random.nextInt(100));
  }));
  
  print(benchmark('FenwickTree.update', 100000, () {
    fenwick.update(random.nextInt(10000), random.nextInt(100));
  }));

  // ============================================================
  // GRAPH STRUCTURES
  // ============================================================
  printHeader('GRAPH STRUCTURES');
  
  printSubHeader('Adjacency List vs Adjacency Matrix');
  
  // Sparse graph
  print('${Colors.dim}Sparse graph (100 vertices, 200 edges):${Colors.reset}');
  
  print(benchmark('Graph (adj list) build', 1000, () {
    final g = Graph<int>();
    for (var i = 0; i < 100; i++) g.addVertex(i);
    for (var i = 0; i < 200; i++) {
      g.addEdge(random.nextInt(100), random.nextInt(100));
    }
  }));
  
  print(benchmark('AdjacencyMatrixGraph build', 1000, () {
    final g = AdjacencyMatrixGraph<int>();
    for (var i = 0; i < 100; i++) g.addVertex(i);
    for (var i = 0; i < 200; i++) {
      g.addEdge(random.nextInt(100), random.nextInt(100));
    }
  }));
  
  final sparseGraph = Graph<int>();
  final sparseMatrix = AdjacencyMatrixGraph<int>();
  for (var i = 0; i < 100; i++) {
    sparseGraph.addVertex(i);
    sparseMatrix.addVertex(i);
  }
  for (var i = 0; i < 200; i++) {
    final a = random.nextInt(100), b = random.nextInt(100);
    sparseGraph.addEdge(a, b);
    sparseMatrix.addEdge(a, b);
  }
  
  print(benchmark('Graph.hasEdge', 100000, () {
    sparseGraph.hasEdge(random.nextInt(100), random.nextInt(100));
  }));
  
  print(benchmark('AdjacencyMatrixGraph.hasEdge', 100000, () {
    sparseMatrix.hasEdge(random.nextInt(100), random.nextInt(100));
  }));
  
  printSubHeader('Graph Traversals');
  
  final traversalGraph = Graph<int>();
  for (var i = 0; i < 1000; i++) traversalGraph.addVertex(i);
  for (var i = 0; i < 2000; i++) {
    traversalGraph.addEdge(random.nextInt(1000), random.nextInt(1000));
  }
  
  print(benchmark('Graph.bfs (1000 vertices)', 100, () {
    traversalGraph.bfs(0).toList();
  }));
  
  print(benchmark('Graph.dfs (1000 vertices)', 100, () {
    traversalGraph.dfs(0).toList();
  }));
  
  printSubHeader('Flow Network - Max Flow');
  
  print(benchmark('FlowNetwork.maxFlow (small)', 100, () {
    final flow = FlowNetwork<String>();
    flow.addEdge('s', 'a', 10);
    flow.addEdge('s', 'b', 10);
    flow.addEdge('a', 'b', 2);
    flow.addEdge('a', 'c', 4);
    flow.addEdge('a', 'd', 8);
    flow.addEdge('b', 'd', 9);
    flow.addEdge('c', 't', 10);
    flow.addEdge('d', 'c', 6);
    flow.addEdge('d', 't', 10);
    flow.maxFlow('s', 't');
  }));

  // ============================================================
  // SUMMARY
  // ============================================================
  print('');
  print('${Colors.bold}${Colors.green}');
  print(r'''
  ╔═══════════════════════════════════════════════════════════════════╗
  ║                    BENCHMARKS COMPLETE                            ║
  ╚═══════════════════════════════════════════════════════════════════╝
  ''');
  print(Colors.reset);
  
  print('${Colors.dim}Note: Results may vary based on system load and Dart VM state.${Colors.reset}');
  print('${Colors.dim}Run multiple times for more accurate measurements.${Colors.reset}');
}
