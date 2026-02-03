# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-02-02

### Added

#### Linear Structures (Extended)
- **CircularLinkedList**: Circular singly linked list with rotate operation
- **CircularDoublyLinkedList**: Circular doubly linked list with bidirectional rotation
- **SkipList**: Probabilistic O(log n) search structure as alternative to balanced trees

#### Direct Access Structures (Extended)
- **UnionFind<T>**: Disjoint Set Union with path compression and union by rank
- **UnionFindInt**: Optimized integer-based DSU for better performance
- **BloomFilter<T>**: Probabilistic set membership with configurable false positive rate

#### Tree Structures (Extended)
- **NaryTree**: General tree where nodes can have any number of children
- **Trie**: Prefix tree for efficient string operations and autocomplete
- **BTree**: Self-balancing tree optimized for disk access (databases)
- **BPlusTree**: B+ tree variant with linked leaves for range queries
- **SegmentTree**: Range query structure with lazy propagation support
- **FenwickTree**: Binary Indexed Tree for space-efficient prefix sums
- **FibonacciHeap**: Heap with O(1) amortized insert and decrease-key
- **MinMaxHeap**: Double-ended priority queue with O(1) access to both min and max

#### Graph Structures (Extended)
- **AdjacencyMatrixGraph**: Matrix-based graph representation for dense graphs
- **FlowNetwork**: Network flow with Ford-Fulkerson/Edmonds-Karp max-flow algorithm

### Changed
- Code comments now English-only (removed Spanish translations from code)
- Documentation restructured: category-specific READMEs with bilingual content
- Main README now links to category documentation

### Testing
- 1246 total tests (up from 244) covering all structures

---

## [1.0.0] - 2026-02-02

### Added

#### Linear Structures / Estructuras Lineales
- **LinkedList**: Singly linked list with full CRUD operations
- **DoublyLinkedList**: Doubly linked list with O(1) insertions at both ends
- **Stack**: LIFO structure with push, pop, peek operations
- **Queue**: FIFO structure with enqueue, dequeue operations
- **Deque**: Double-ended queue supporting operations at both ends

#### Direct Access Structures / Estructuras de Acceso Directo
- **DynamicArray**: Auto-resizing array with O(1) amortized insertions
- **HashTable**: Hash map with separate chaining collision resolution
- **HashSet**: Hash-based set with union, intersection, difference operations

#### Tree Structures / Estructuras de Árboles
- **BinarySearchTree**: Standard BST with in-order, pre-order, post-order, level-order traversals
- **AVLTree**: Self-balancing BST with automatic rotations
- **Heap**: Binary heap supporting both min-heap and max-heap
- **PriorityQueue**: Priority queue implemented using heap

#### Graph Structures / Estructuras de Grafos
- **Graph**: Adjacency list representation supporting:
  - Directed and undirected graphs
  - Weighted edges
  - BFS (Breadth-First Search)
  - DFS (Depth-First Search)
  - Path finding
  - Cycle detection
  - Topological sort
  - Connected components

### Documentation / Documentación
- Complete bilingual documentation (English/Spanish) in all source files
- Comprehensive README with usage examples
- Time complexity documentation for all operations
