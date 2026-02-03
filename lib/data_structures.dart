/// # Data Structures Library
///
/// A comprehensive library of fundamental data structures implemented in Dart.
/// Includes linear structures, trees, hash tables, and graphs.
///
/// ## Categories:
///
/// ### 1. Linear Structures
/// - [LinkedList] - Singly linked list
/// - [DoublyLinkedList] - Doubly linked list
/// - [CircularLinkedList] - Circular singly linked list
/// - [CircularDoublyLinkedList] - Circular doubly linked list
/// - [Stack] - LIFO stack
/// - [Queue] - FIFO queue
/// - [Deque] - Double-ended queue
/// - [SkipList] - Probabilistic O(log n) search structure
///
/// ### 2. Direct Access Structures
/// - [DynamicArray] - Resizable array
/// - [HashTable] - Hash map
/// - [HashSet] - Hash set
/// - [UnionFind] - Disjoint Set Union (DSU)
/// - [BloomFilter] - Probabilistic set membership
///
/// ### 3. Tree Structures
/// - [BinarySearchTree] - BST
/// - [AVLTree] - Self-balancing BST
/// - [Heap] - Binary heap
/// - [PriorityQueue] - Priority queue using heap
/// - [NaryTree] - N-ary tree (general tree)
/// - [Trie] - Prefix tree for strings
/// - [BTree] / [BPlusTree] - B-tree and B+ tree
/// - [SegmentTree] / [FenwickTree] - Range query structures
/// - [FibonacciHeap] - Heap with O(1) amortized operations
/// - [MinMaxHeap] - Double-ended priority queue
///
/// ### 4. Graph Structures
/// - [Graph] - Adjacency list graph with BFS/DFS
/// - [AdjacencyMatrixGraph] - Matrix-based graph
/// - [FlowNetwork] - Max flow / min cut
library;

// Linear Structures
export 'src/linear/linked_list.dart';
export 'src/linear/doubly_linked_list.dart';
export 'src/linear/circular_linked_list.dart';
export 'src/linear/stack.dart';
export 'src/linear/queue.dart';
export 'src/linear/skip_list.dart';

// Direct Access Structures
export 'src/direct_access/dynamic_array.dart';
export 'src/direct_access/hash_table.dart';
export 'src/direct_access/union_find.dart';
export 'src/direct_access/bloom_filter.dart';

// Tree Structures
export 'src/trees/binary_search_tree.dart';
export 'src/trees/avl_tree.dart';
export 'src/trees/heap.dart';
export 'src/trees/n_ary_tree.dart';
export 'src/trees/trie.dart';
export 'src/trees/b_tree.dart';
export 'src/trees/segment_tree.dart';
export 'src/trees/fibonacci_heap.dart';
export 'src/trees/min_max_heap.dart';

// Graph Structures
export 'src/graphs/graph.dart';
export 'src/graphs/adjacency_matrix_graph.dart';
export 'src/graphs/flow_network.dart';
