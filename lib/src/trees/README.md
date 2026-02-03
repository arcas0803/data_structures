# Tree Structures / Estructuras de Árboles

[🇬🇧 English](#english) | [🇪🇸 Español](#español)

---

<a name="english"></a>
## 🇬🇧 English

Hierarchical data structures where each node can have children. Trees enable efficient searching, sorting, and hierarchical organization.

### Structures

#### BinarySearchTree (BST)

A binary tree where each node has at most two children. Left children are smaller, right children are larger.

**Time Complexity:**
| Operation | Average | Worst (unbalanced) |
|-----------|---------|-------------------|
| Search | O(log n) | O(n) |
| Insert | O(log n) | O(n) |
| Delete | O(log n) | O(n) |
| Min/Max | O(log n) | O(n) |

**Usage:**
```dart
final bst = BinarySearchTree<int>();

// Insert elements
bst.insert(50);
bst.insert(30);
bst.insert(70);
bst.insert(20);
bst.insert(40);

// Search
print(bst.contains(30)); // true
final node = bst.search(30); // returns the node

// Min and Max
print(bst.min); // 20
print(bst.max); // 70

// Traversals
print(bst.inOrder.toList());    // [20, 30, 40, 50, 70] - sorted!
print(bst.preOrder.toList());   // [50, 30, 20, 40, 70]
print(bst.postOrder.toList());  // [20, 40, 30, 70, 50]
print(bst.levelOrder.toList()); // [50, 30, 70, 20, 40] - BFS

// Find predecessor and successor
print(bst.predecessor(50)); // 40 (next smaller)
print(bst.successor(50));   // 70 (next larger)

// Range query
print(bst.range(25, 55).toList()); // [30, 40, 50]

// Remove
bst.remove(30);

// Properties
print(bst.height);     // tree height
print(bst.isBalanced); // true if balanced

// Visual representation
print(bst.toTreeString());
// └── 50
//     ├── 30
//     │   ├── 20
//     │   └── 40
//     └── 70
```

---

#### AVLTree (Self-Balancing BST)

An AVL tree automatically rebalances after insertions and deletions, guaranteeing O(log n) operations.

**Time Complexity (guaranteed):**
| Operation | Complexity |
|-----------|------------|
| Search | O(log n) |
| Insert | O(log n) |
| Delete | O(log n) |

**How it works:**
- Maintains a balance factor (-1, 0, or 1) for each node
- Performs rotations when balance factor exceeds bounds
- Four rotation types: Left-Left, Right-Right, Left-Right, Right-Left

**Usage:**
```dart
final avl = AVLTree<int>();

// Even inserting in order remains balanced
for (var i = 1; i <= 15; i++) {
  avl.insert(i);
}

// Height is O(log n), not O(n)
print(avl.height);  // ~4 (vs 14 if unbalanced)
print(avl.isValid); // true - maintains AVL property

// Same API as BinarySearchTree
print(avl.contains(10));
print(avl.min);
print(avl.max);
print(avl.inOrder.toList()); // [1, 2, 3, ..., 15]

// Remove also maintains balance
avl.remove(8);
print(avl.isValid); // still true

// Visual with balance info
print(avl.toTreeString());
// Shows node value, height, and balance factor
```

**When to use AVL vs BST:**
- Use AVL when you need guaranteed O(log n) performance
- Use BST when data is already somewhat random
- AVL has slightly slower inserts/deletes due to rebalancing

---

#### Heap (Binary Heap)

A complete binary tree satisfying the heap property. Used for priority queues and efficient min/max extraction.

**Types:**
- **Min-Heap**: Parent ≤ children (smallest at root)
- **Max-Heap**: Parent ≥ children (largest at root)

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Peek (min/max) | O(1) |
| Insert | O(log n) |
| Extract | O(log n) |
| Build from array | O(n) |

**Usage:**
```dart
// Min-Heap
final minHeap = Heap<int>.minHeap();
minHeap.insert(5);
minHeap.insert(3);
minHeap.insert(7);
minHeap.insert(1);

print(minHeap.peek);     // 1 (minimum)
print(minHeap.extract()); // 1 (removes and returns min)
print(minHeap.extract()); // 3

// Max-Heap
final maxHeap = Heap<int>.maxHeap();
maxHeap.addAll([5, 3, 7, 1, 9]);
print(maxHeap.peek);     // 9 (maximum)
print(maxHeap.extract()); // 9

// Build heap efficiently from existing data - O(n)
final heap = Heap.from([5, 3, 8, 1, 9, 2], type: HeapType.min);

// Replace root (more efficient than extract + insert)
final oldRoot = heap.replace(4);

// Extract all in sorted order
final sorted = heap.extractAll(); // empties heap

// Get sorted copy without emptying
final sortedCopy = heap.toSortedList();

// Merge heaps
heap.merge(anotherHeap);

// Validate heap property
print(heap.isValid);
```

---

#### PriorityQueue

A queue where elements are dequeued based on priority, not insertion order.

**Usage:**
```dart
// Min-priority (smallest first)
final pq = PriorityQueue<int>();
pq.enqueue(5);
pq.enqueue(1);
pq.enqueue(3);

print(pq.dequeue()); // 1
print(pq.dequeue()); // 3
print(pq.dequeue()); // 5

// Max-priority (largest first)
final maxPQ = PriorityQueue<int>.maxPriority();
maxPQ.enqueue(5);
maxPQ.enqueue(1);
maxPQ.enqueue(3);

print(maxPQ.dequeue()); // 5
print(maxPQ.dequeue()); // 3

// Safe methods
print(pq.tryPeek());    // null if empty
print(pq.tryDequeue()); // null if empty

// Create from existing data
final pq2 = PriorityQueue.from([5, 3, 8, 1]);
print(pq2.toSortedList()); // [1, 3, 5, 8]
```

---

#### NaryTree (N-ary Tree)

A tree where each node can have any number of children. Useful for representing hierarchical data like file systems, organization charts, or XML/JSON structures.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Insert child | O(1) |
| Remove child | O(k) where k = number of children |
| Search (DFS/BFS) | O(n) |
| Height | O(n) |

**Usage:**
```dart
final tree = NaryTree<String>('root');

// Add children to root
tree.addChild('child1');
tree.addChild('child2');
tree.addChild('child3');

// Add children to specific node
final child1 = tree.root.children.first;
child1.addChild('grandchild1');
child1.addChild('grandchild2');

// Traversals
print(tree.dfs().toList());  // Depth-first traversal
print(tree.bfs().toList());  // Breadth-first traversal

// Find node
final node = tree.find('grandchild1');

// Properties
print(tree.height);      // tree height
print(tree.nodeCount);   // total number of nodes
print(tree.leafCount);   // number of leaf nodes

// Remove child
child1.removeChild('grandchild1');

// Check if leaf
print(tree.root.isLeaf);  // false

// Visual representation
print(tree.toTreeString());
// root
// ├── child1
// │   └── grandchild2
// ├── child2
// └── child3
```

**Use Cases:**
- File system hierarchies
- Organization charts
- XML/HTML DOM representation
- Category trees
- Game scene graphs

---

#### Trie (Prefix Tree)

A tree structure for efficient string storage and prefix-based operations. Each path from root to leaf represents a string.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Insert | O(m) where m = string length |
| Search | O(m) |
| Prefix search | O(m + k) where k = matching words |
| Delete | O(m) |

**Usage:**
```dart
final trie = Trie();

// Insert words
trie.insert('apple');
trie.insert('app');
trie.insert('application');
trie.insert('banana');
trie.insert('band');

// Search for exact word
print(trie.search('apple'));  // true
print(trie.search('appl'));   // false

// Check if prefix exists
print(trie.startsWith('app'));  // true
print(trie.startsWith('ban'));  // true
print(trie.startsWith('cat'));  // false

// Get all words with prefix
print(trie.wordsWithPrefix('app'));  // ['app', 'apple', 'application']
print(trie.wordsWithPrefix('ban'));  // ['banana', 'band']

// Autocomplete suggestions
print(trie.autocomplete('ap', limit: 5));  // ['app', 'apple', 'application']

// Delete word
trie.delete('app');
print(trie.search('app'));    // false
print(trie.search('apple'));  // true (still exists)

// Properties
print(trie.wordCount);  // number of words
print(trie.isEmpty);

// Get all words
print(trie.allWords);
```

**Use Cases:**
- Autocomplete systems
- Spell checkers
- IP routing tables
- Dictionary implementations
- Word games (Scrabble, Boggle)

---

#### BTree

A self-balancing tree that maintains sorted data and allows searches, insertions, and deletions in logarithmic time. Optimized for disk-based storage.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Search | O(log n) |
| Insert | O(log n) |
| Delete | O(log n) |

**Properties:**
- All leaves are at the same level
- Nodes can have multiple keys (up to 2t-1 where t is minimum degree)
- Minimizes disk I/O operations

**Usage:**
```dart
// Create B-tree with minimum degree t=3
final btree = BTree<int>(minimumDegree: 3);

// Insert keys
btree.insert(10);
btree.insert(20);
btree.insert(5);
btree.insert(6);
btree.insert(12);
btree.insert(30);

// Search
print(btree.search(12));   // true
print(btree.search(100));  // false

// Get value (for key-value B-trees)
final value = btree.get(12);

// Delete
btree.delete(6);

// Range query
print(btree.range(5, 20).toList());  // [5, 10, 12, 20]

// Properties
print(btree.height);
print(btree.nodeCount);
print(btree.isEmpty);

// Traverse in order
print(btree.inOrder.toList());  // sorted keys
```

**Use Cases:**
- Database indexing
- File systems
- Multilevel indexing

---

#### BPlusTree

A B-tree variant where all values are stored in leaf nodes, and leaves are linked for efficient range queries.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Search | O(log n) |
| Insert | O(log n) |
| Delete | O(log n) |
| Range query | O(log n + k) where k = results |

**Properties:**
- Internal nodes only store keys (not values)
- All data stored in leaf nodes
- Leaf nodes form a linked list

**Usage:**
```dart
// Create B+ tree with order 4
final bPlusTree = BPlusTree<int, String>(order: 4);

// Insert key-value pairs
bPlusTree.insert(1, 'one');
bPlusTree.insert(5, 'five');
bPlusTree.insert(3, 'three');
bPlusTree.insert(7, 'seven');
bPlusTree.insert(9, 'nine');

// Point query
print(bPlusTree.get(5));  // 'five'

// Range query (efficient due to linked leaves)
final range = bPlusTree.range(3, 7);
print(range.toList());  // [(3, 'three'), (5, 'five'), (7, 'seven')]

// Iterate all in order (follows leaf links)
for (final entry in bPlusTree.entries) {
  print('${entry.key}: ${entry.value}');
}

// Delete
bPlusTree.delete(5);

// Bulk load (efficient for large datasets)
final bulkTree = BPlusTree<int, String>.bulkLoad(sortedEntries, order: 4);

// Properties
print(bPlusTree.height);
print(bPlusTree.length);
```

**Use Cases:**
- Database indexing (most RDBMS use B+ trees)
- Range queries on large datasets
- Sequential access patterns

---

#### SegmentTree

A tree structure for efficient range queries and updates on arrays. Each node stores information about a segment of the array.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Build | O(n) |
| Range query | O(log n) |
| Point update | O(log n) |
| Range update (lazy) | O(log n) |

**Usage:**
```dart
// Create segment tree for range sum queries
final data = [1, 3, 5, 7, 9, 11];
final segTree = SegmentTree<int>(
  data,
  merge: (a, b) => a + b,  // sum operation
  identity: 0,
);

// Range query: sum of elements from index 1 to 3
print(segTree.query(1, 3));  // 15 (3 + 5 + 7)

// Point update: set index 2 to 10
segTree.update(2, 10);
print(segTree.query(1, 3));  // 20 (3 + 10 + 7)

// Range min query
final minTree = SegmentTree<int>.minQuery(data);
print(minTree.query(0, 4));  // 1 (minimum in range)

// Range max query
final maxTree = SegmentTree<int>.maxQuery(data);
print(maxTree.query(0, 4));  // 9 (maximum in range)

// Range GCD query
final gcdTree = SegmentTree<int>.gcdQuery([12, 18, 24, 6]);
print(gcdTree.query(0, 2));  // 6

// Lazy propagation for range updates
final lazyTree = SegmentTree<int>.lazy(data, merge: (a, b) => a + b);
lazyTree.updateRange(1, 4, 5);  // Add 5 to all elements in range
```

**Use Cases:**
- Range sum/min/max queries
- Computational geometry
- Interval scheduling
- Dynamic programming optimization

---

#### FenwickTree (Binary Indexed Tree)

A space-efficient structure for computing prefix sums and range sums with efficient updates.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Build | O(n) |
| Prefix sum | O(log n) |
| Point update | O(log n) |
| Range sum | O(log n) |

**Properties:**
- More memory efficient than Segment Tree
- Simpler implementation
- Limited to invertible operations (like sum)

**Usage:**
```dart
// Create from data
final data = [3, 2, -1, 6, 5, 4, -3, 3, 7, 2];
final fenwick = FenwickTree(data);

// Prefix sum: sum of first 5 elements (indices 0-4)
print(fenwick.prefixSum(4));  // 15

// Range sum: sum from index 2 to 6
print(fenwick.rangeSum(2, 6));  // 11

// Point update: add 3 to index 3
fenwick.add(3, 3);
print(fenwick.prefixSum(4));  // 18

// Set value at index
fenwick.set(3, 10);

// Find index where prefix sum >= target (useful for order statistics)
final idx = fenwick.lowerBound(15);

// Get original value at index
print(fenwick.get(3));

// 2D Fenwick Tree for matrix prefix sums
final fenwick2D = FenwickTree2D(matrix);
print(fenwick2D.rangeSum(0, 0, 2, 2));  // sum of submatrix
fenwick2D.add(1, 1, 5);  // add to point
```

**Use Cases:**
- Running cumulative sums
- Counting inversions
- Order statistics
- 2D range queries

---

#### FibonacciHeap

An advanced heap with excellent amortized performance, particularly for decrease-key operations.

**Time Complexity:**
| Operation | Amortized | Worst |
|-----------|-----------|-------|
| Insert | O(1) | O(1) |
| Find min | O(1) | O(1) |
| Extract min | O(log n) | O(n) |
| Decrease key | O(1) | O(log n) |
| Merge | O(1) | O(1) |
| Delete | O(log n) | O(n) |

**Usage:**
```dart
final fibHeap = FibonacciHeap<int>();

// Insert elements (returns node handle for decrease-key)
final node1 = fibHeap.insert(10);
final node2 = fibHeap.insert(5);
final node3 = fibHeap.insert(15);

// Find minimum
print(fibHeap.minimum);  // 5

// Decrease key (O(1) amortized - key for Dijkstra's algorithm)
fibHeap.decreaseKey(node3, 3);
print(fibHeap.minimum);  // 3

// Extract minimum
print(fibHeap.extractMin());  // 3
print(fibHeap.extractMin());  // 5

// Merge two heaps (O(1))
final heap1 = FibonacciHeap<int>()..insertAll([1, 3, 5]);
final heap2 = FibonacciHeap<int>()..insertAll([2, 4, 6]);
heap1.merge(heap2);
print(heap1.minimum);  // 1

// Delete arbitrary node
fibHeap.delete(node1);

// Properties
print(fibHeap.length);
print(fibHeap.isEmpty);
```

**Use Cases:**
- Dijkstra's shortest path algorithm
- Prim's minimum spanning tree
- Any algorithm with many decrease-key operations

---

#### MinMaxHeap

A double-ended priority queue supporting efficient access to both minimum and maximum elements.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Find min | O(1) |
| Find max | O(1) |
| Insert | O(log n) |
| Extract min | O(log n) |
| Extract max | O(log n) |

**Usage:**
```dart
final mmHeap = MinMaxHeap<int>();

// Insert elements
mmHeap.insert(5);
mmHeap.insert(3);
mmHeap.insert(7);
mmHeap.insert(1);
mmHeap.insert(9);

// Access both ends in O(1)
print(mmHeap.min);  // 1
print(mmHeap.max);  // 9

// Extract from either end
print(mmHeap.extractMin());  // 1
print(mmHeap.extractMax());  // 9

print(mmHeap.min);  // 3
print(mmHeap.max);  // 7

// Build from array
final heap = MinMaxHeap.from([5, 2, 8, 1, 9, 3]);

// Safe methods
print(mmHeap.tryMin());         // null if empty
print(mmHeap.tryMax());         // null if empty
print(mmHeap.tryExtractMin());  // null if empty
print(mmHeap.tryExtractMax());  // null if empty

// Properties
print(mmHeap.length);
print(mmHeap.isEmpty);
print(mmHeap.isValid);  // validates heap property
```

**Use Cases:**
- Double-ended priority queues
- Median finding algorithms
- Sliding window min/max
- Bandwidth management (prioritize both high and low priority)

---

<a name="español"></a>
## 🇪🇸 Español

Estructuras de datos jerárquicas donde cada nodo puede tener hijos. Los árboles permiten búsqueda, ordenamiento y organización jerárquica eficientes.

### Estructuras

#### BinarySearchTree (Árbol Binario de Búsqueda - BST)

Un árbol binario donde cada nodo tiene como máximo dos hijos. Los hijos izquierdos son menores, los hijos derechos son mayores.

**Complejidad Temporal:**
| Operación | Promedio | Peor Caso (desbalanceado) |
|-----------|----------|--------------------------|
| Búsqueda | O(log n) | O(n) |
| Inserción | O(log n) | O(n) |
| Eliminación | O(log n) | O(n) |
| Mín/Máx | O(log n) | O(n) |

**Uso:**
```dart
final bst = BinarySearchTree<int>();

// Insertar elementos
bst.insert(50);
bst.insert(30);
bst.insert(70);
bst.insert(20);
bst.insert(40);

// Buscar
print(bst.contains(30)); // true
final nodo = bst.search(30); // retorna el nodo

// Mínimo y Máximo
print(bst.min); // 20
print(bst.max); // 70

// Recorridos
print(bst.inOrder.toList());    // [20, 30, 40, 50, 70] - ¡ordenado!
print(bst.preOrder.toList());   // [50, 30, 20, 40, 70]
print(bst.postOrder.toList());  // [20, 40, 30, 70, 50]
print(bst.levelOrder.toList()); // [50, 30, 70, 20, 40] - BFS

// Encontrar predecesor y sucesor
print(bst.predecessor(50)); // 40 (siguiente menor)
print(bst.successor(50));   // 70 (siguiente mayor)

// Consulta de rango
print(bst.range(25, 55).toList()); // [30, 40, 50]

// Eliminar
bst.remove(30);

// Propiedades
print(bst.height);     // altura del árbol
print(bst.isBalanced); // true si está balanceado

// Representación visual
print(bst.toTreeString());
```

---

#### AVLTree (Árbol AVL - BST Auto-Balanceado)

Un árbol AVL se rebalancea automáticamente después de inserciones y eliminaciones, garantizando operaciones O(log n).

**Complejidad Temporal (garantizada):**
| Operación | Complejidad |
|-----------|-------------|
| Búsqueda | O(log n) |
| Inserción | O(log n) |
| Eliminación | O(log n) |

**Cómo funciona:**
- Mantiene un factor de balance (-1, 0, o 1) para cada nodo
- Realiza rotaciones cuando el factor de balance excede los límites
- Cuatro tipos de rotación: Izquierda-Izquierda, Derecha-Derecha, Izquierda-Derecha, Derecha-Izquierda

**Uso:**
```dart
final avl = AVLTree<int>();

// Incluso insertando en orden permanece balanceado
for (var i = 1; i <= 15; i++) {
  avl.insert(i);
}

// La altura es O(log n), no O(n)
print(avl.height);  // ~4 (vs 14 si desbalanceado)
print(avl.isValid); // true - mantiene propiedad AVL

// Misma API que BinarySearchTree
print(avl.contains(10));
print(avl.min);
print(avl.max);
print(avl.inOrder.toList()); // [1, 2, 3, ..., 15]

// Eliminar también mantiene el balance
avl.remove(8);
print(avl.isValid); // sigue siendo true
```

**Cuándo usar AVL vs BST:**
- Usa AVL cuando necesites rendimiento O(log n) garantizado
- Usa BST cuando los datos ya son algo aleatorios
- AVL tiene inserciones/eliminaciones ligeramente más lentas por el rebalanceo

---

#### Heap (Montículo Binario)

Un árbol binario completo que satisface la propiedad del montículo. Usado para colas de prioridad y extracción eficiente de mín/máx.

**Tipos:**
- **Min-Heap**: Padre ≤ hijos (el menor en la raíz)
- **Max-Heap**: Padre ≥ hijos (el mayor en la raíz)

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Peek (mín/máx) | O(1) |
| Insertar | O(log n) |
| Extraer | O(log n) |
| Construir desde arreglo | O(n) |

**Uso:**
```dart
// Min-Heap
final minHeap = Heap<int>.minHeap();
minHeap.insert(5);
minHeap.insert(3);
minHeap.insert(7);
minHeap.insert(1);

print(minHeap.peek);     // 1 (mínimo)
print(minHeap.extract()); // 1 (elimina y retorna mín)
print(minHeap.extract()); // 3

// Max-Heap
final maxHeap = Heap<int>.maxHeap();
maxHeap.addAll([5, 3, 7, 1, 9]);
print(maxHeap.peek);     // 9 (máximo)
print(maxHeap.extract()); // 9

// Construir heap eficientemente desde datos existentes - O(n)
final heap = Heap.from([5, 3, 8, 1, 9, 2], type: HeapType.min);

// Reemplazar raíz (más eficiente que extract + insert)
final raizAnterior = heap.replace(4);

// Extraer todo en orden ordenado
final ordenado = heap.extractAll(); // vacía el heap

// Obtener copia ordenada sin vaciar
final copiaOrdenada = heap.toSortedList();

// Fusionar heaps
heap.merge(otroHeap);

// Validar propiedad del heap
print(heap.isValid);
```

---

#### PriorityQueue (Cola de Prioridad)

Una cola donde los elementos se desencolan basándose en prioridad, no en orden de inserción.

**Uso:**
```dart
// Prioridad mínima (el menor primero)
final cp = PriorityQueue<int>();
cp.enqueue(5);
cp.enqueue(1);
cp.enqueue(3);

print(cp.dequeue()); // 1
print(cp.dequeue()); // 3
print(cp.dequeue()); // 5

// Prioridad máxima (el mayor primero)
final cpMax = PriorityQueue<int>.maxPriority();
cpMax.enqueue(5);
cpMax.enqueue(1);
cpMax.enqueue(3);

print(cpMax.dequeue()); // 5
print(cpMax.dequeue()); // 3

// Métodos seguros
print(cp.tryPeek());    // null si vacía
print(cp.tryDequeue()); // null si vacía

// Crear desde datos existentes
final cp2 = PriorityQueue.from([5, 3, 8, 1]);
print(cp2.toSortedList()); // [1, 3, 5, 8]
```

---

#### NaryTree (Árbol N-ario)

Un árbol donde cada nodo puede tener cualquier número de hijos. Útil para representar datos jerárquicos como sistemas de archivos, organigramas o estructuras XML/JSON.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Insertar hijo | O(1) |
| Eliminar hijo | O(k) donde k = número de hijos |
| Búsqueda (DFS/BFS) | O(n) |
| Altura | O(n) |

**Uso:**
```dart
final tree = NaryTree<String>('raíz');

// Agregar hijos a la raíz
tree.addChild('hijo1');
tree.addChild('hijo2');
tree.addChild('hijo3');

// Agregar hijos a un nodo específico
final hijo1 = tree.root.children.first;
hijo1.addChild('nieto1');
hijo1.addChild('nieto2');

// Recorridos
print(tree.dfs().toList());  // Recorrido en profundidad
print(tree.bfs().toList());  // Recorrido en anchura

// Buscar nodo
final nodo = tree.find('nieto1');

// Propiedades
print(tree.height);      // altura del árbol
print(tree.nodeCount);   // número total de nodos
print(tree.leafCount);   // número de nodos hoja

// Eliminar hijo
hijo1.removeChild('nieto1');

// Verificar si es hoja
print(tree.root.isLeaf);  // false

// Representación visual
print(tree.toTreeString());
```

**Casos de Uso:**
- Jerarquías de sistemas de archivos
- Organigramas
- Representación DOM XML/HTML
- Árboles de categorías
- Grafos de escenas de juegos

---

#### Trie (Árbol de Prefijos)

Una estructura de árbol para almacenamiento eficiente de cadenas y operaciones basadas en prefijos. Cada camino desde la raíz a una hoja representa una cadena.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Insertar | O(m) donde m = longitud de cadena |
| Buscar | O(m) |
| Buscar prefijo | O(m + k) donde k = palabras coincidentes |
| Eliminar | O(m) |

**Uso:**
```dart
final trie = Trie();

// Insertar palabras
trie.insert('manzana');
trie.insert('mango');
trie.insert('mandarina');
trie.insert('banana');
trie.insert('bandeja');

// Buscar palabra exacta
print(trie.search('manzana'));  // true
print(trie.search('manza'));    // false

// Verificar si existe prefijo
print(trie.startsWith('man'));  // true
print(trie.startsWith('ban'));  // true
print(trie.startsWith('cat'));  // false

// Obtener todas las palabras con prefijo
print(trie.wordsWithPrefix('man'));  // ['mango', 'mandarina', 'manzana']
print(trie.wordsWithPrefix('ban'));  // ['banana', 'bandeja']

// Sugerencias de autocompletado
print(trie.autocomplete('ma', limit: 5));

// Eliminar palabra
trie.delete('mango');

// Propiedades
print(trie.wordCount);  // número de palabras
print(trie.isEmpty);

// Obtener todas las palabras
print(trie.allWords);
```

**Casos de Uso:**
- Sistemas de autocompletado
- Correctores ortográficos
- Tablas de enrutamiento IP
- Implementaciones de diccionarios
- Juegos de palabras (Scrabble, Boggle)

---

#### BTree (Árbol B)

Un árbol auto-balanceado que mantiene datos ordenados y permite búsquedas, inserciones y eliminaciones en tiempo logarítmico. Optimizado para almacenamiento en disco.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Búsqueda | O(log n) |
| Inserción | O(log n) |
| Eliminación | O(log n) |

**Propiedades:**
- Todas las hojas están al mismo nivel
- Los nodos pueden tener múltiples claves (hasta 2t-1 donde t es el grado mínimo)
- Minimiza operaciones de E/S en disco

**Uso:**
```dart
// Crear árbol B con grado mínimo t=3
final btree = BTree<int>(minimumDegree: 3);

// Insertar claves
btree.insert(10);
btree.insert(20);
btree.insert(5);
btree.insert(6);
btree.insert(12);
btree.insert(30);

// Buscar
print(btree.search(12));   // true
print(btree.search(100));  // false

// Obtener valor (para árboles B clave-valor)
final valor = btree.get(12);

// Eliminar
btree.delete(6);

// Consulta de rango
print(btree.range(5, 20).toList());  // [5, 10, 12, 20]

// Propiedades
print(btree.height);
print(btree.nodeCount);
print(btree.isEmpty);

// Recorrer en orden
print(btree.inOrder.toList());  // claves ordenadas
```

**Casos de Uso:**
- Indexación de bases de datos
- Sistemas de archivos
- Indexación multinivel

---

#### BPlusTree (Árbol B+)

Una variante del árbol B donde todos los valores se almacenan en nodos hoja, y las hojas están enlazadas para consultas de rango eficientes.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Búsqueda | O(log n) |
| Inserción | O(log n) |
| Eliminación | O(log n) |
| Consulta de rango | O(log n + k) donde k = resultados |

**Propiedades:**
- Los nodos internos solo almacenan claves (no valores)
- Todos los datos se almacenan en nodos hoja
- Los nodos hoja forman una lista enlazada

**Uso:**
```dart
// Crear árbol B+ con orden 4
final bPlusTree = BPlusTree<int, String>(order: 4);

// Insertar pares clave-valor
bPlusTree.insert(1, 'uno');
bPlusTree.insert(5, 'cinco');
bPlusTree.insert(3, 'tres');
bPlusTree.insert(7, 'siete');
bPlusTree.insert(9, 'nueve');

// Consulta puntual
print(bPlusTree.get(5));  // 'cinco'

// Consulta de rango (eficiente gracias a hojas enlazadas)
final rango = bPlusTree.range(3, 7);
print(rango.toList());  // [(3, 'tres'), (5, 'cinco'), (7, 'siete')]

// Iterar todo en orden (sigue enlaces de hojas)
for (final entrada in bPlusTree.entries) {
  print('${entrada.key}: ${entrada.value}');
}

// Eliminar
bPlusTree.delete(5);

// Carga masiva (eficiente para grandes conjuntos de datos)
final arbolMasivo = BPlusTree<int, String>.bulkLoad(entradasOrdenadas, order: 4);

// Propiedades
print(bPlusTree.height);
print(bPlusTree.length);
```

**Casos de Uso:**
- Indexación de bases de datos (la mayoría de RDBMS usan árboles B+)
- Consultas de rango en grandes conjuntos de datos
- Patrones de acceso secuencial

---

#### SegmentTree (Árbol de Segmentos)

Una estructura de árbol para consultas y actualizaciones de rango eficientes en arreglos. Cada nodo almacena información sobre un segmento del arreglo.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Construir | O(n) |
| Consulta de rango | O(log n) |
| Actualización puntual | O(log n) |
| Actualización de rango (lazy) | O(log n) |

**Uso:**
```dart
// Crear árbol de segmentos para consultas de suma de rango
final datos = [1, 3, 5, 7, 9, 11];
final segTree = SegmentTree<int>(
  datos,
  merge: (a, b) => a + b,  // operación suma
  identity: 0,
);

// Consulta de rango: suma de elementos del índice 1 al 3
print(segTree.query(1, 3));  // 15 (3 + 5 + 7)

// Actualización puntual: establecer índice 2 a 10
segTree.update(2, 10);
print(segTree.query(1, 3));  // 20 (3 + 10 + 7)

// Consulta de rango mínimo
final minTree = SegmentTree<int>.minQuery(datos);
print(minTree.query(0, 4));  // 1 (mínimo en rango)

// Consulta de rango máximo
final maxTree = SegmentTree<int>.maxQuery(datos);
print(maxTree.query(0, 4));  // 9 (máximo en rango)

// Consulta de rango MCD
final gcdTree = SegmentTree<int>.gcdQuery([12, 18, 24, 6]);
print(gcdTree.query(0, 2));  // 6

// Propagación perezosa para actualizaciones de rango
final lazyTree = SegmentTree<int>.lazy(datos, merge: (a, b) => a + b);
lazyTree.updateRange(1, 4, 5);  // Sumar 5 a todos los elementos en rango
```

**Casos de Uso:**
- Consultas de suma/mín/máx de rango
- Geometría computacional
- Programación de intervalos
- Optimización de programación dinámica

---

#### FenwickTree (Árbol de Fenwick / Árbol Indexado Binario)

Una estructura eficiente en espacio para calcular sumas de prefijos y sumas de rango con actualizaciones eficientes.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Construir | O(n) |
| Suma de prefijo | O(log n) |
| Actualización puntual | O(log n) |
| Suma de rango | O(log n) |

**Propiedades:**
- Más eficiente en memoria que el Árbol de Segmentos
- Implementación más simple
- Limitado a operaciones invertibles (como suma)

**Uso:**
```dart
// Crear desde datos
final datos = [3, 2, -1, 6, 5, 4, -3, 3, 7, 2];
final fenwick = FenwickTree(datos);

// Suma de prefijo: suma de los primeros 5 elementos (índices 0-4)
print(fenwick.prefixSum(4));  // 15

// Suma de rango: suma del índice 2 al 6
print(fenwick.rangeSum(2, 6));  // 11

// Actualización puntual: sumar 3 al índice 3
fenwick.add(3, 3);
print(fenwick.prefixSum(4));  // 18

// Establecer valor en índice
fenwick.set(3, 10);

// Encontrar índice donde suma de prefijo >= objetivo (útil para estadísticas de orden)
final idx = fenwick.lowerBound(15);

// Obtener valor original en índice
print(fenwick.get(3));

// Árbol de Fenwick 2D para sumas de prefijos de matrices
final fenwick2D = FenwickTree2D(matriz);
print(fenwick2D.rangeSum(0, 0, 2, 2));  // suma de submatriz
fenwick2D.add(1, 1, 5);  // sumar a punto
```

**Casos de Uso:**
- Sumas acumulativas continuas
- Conteo de inversiones
- Estadísticas de orden
- Consultas de rango 2D

---

#### FibonacciHeap (Montículo de Fibonacci)

Un montículo avanzado con excelente rendimiento amortizado, particularmente para operaciones de decrease-key.

**Complejidad Temporal:**
| Operación | Amortizada | Peor Caso |
|-----------|------------|-----------|
| Insertar | O(1) | O(1) |
| Encontrar mín | O(1) | O(1) |
| Extraer mín | O(log n) | O(n) |
| Decrementar clave | O(1) | O(log n) |
| Fusionar | O(1) | O(1) |
| Eliminar | O(log n) | O(n) |

**Uso:**
```dart
final fibHeap = FibonacciHeap<int>();

// Insertar elementos (retorna manejador de nodo para decrease-key)
final nodo1 = fibHeap.insert(10);
final nodo2 = fibHeap.insert(5);
final nodo3 = fibHeap.insert(15);

// Encontrar mínimo
print(fibHeap.minimum);  // 5

// Decrementar clave (O(1) amortizado - clave para algoritmo de Dijkstra)
fibHeap.decreaseKey(nodo3, 3);
print(fibHeap.minimum);  // 3

// Extraer mínimo
print(fibHeap.extractMin());  // 3
print(fibHeap.extractMin());  // 5

// Fusionar dos montículos (O(1))
final heap1 = FibonacciHeap<int>()..insertAll([1, 3, 5]);
final heap2 = FibonacciHeap<int>()..insertAll([2, 4, 6]);
heap1.merge(heap2);
print(heap1.minimum);  // 1

// Eliminar nodo arbitrario
fibHeap.delete(nodo1);

// Propiedades
print(fibHeap.length);
print(fibHeap.isEmpty);
```

**Casos de Uso:**
- Algoritmo de camino más corto de Dijkstra
- Árbol de expansión mínima de Prim
- Cualquier algoritmo con muchas operaciones de decrease-key

---

#### MinMaxHeap (Montículo Min-Max)

Una cola de prioridad de doble extremo que soporta acceso eficiente tanto al elemento mínimo como al máximo.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Encontrar mín | O(1) |
| Encontrar máx | O(1) |
| Insertar | O(log n) |
| Extraer mín | O(log n) |
| Extraer máx | O(log n) |

**Uso:**
```dart
final mmHeap = MinMaxHeap<int>();

// Insertar elementos
mmHeap.insert(5);
mmHeap.insert(3);
mmHeap.insert(7);
mmHeap.insert(1);
mmHeap.insert(9);

// Acceder a ambos extremos en O(1)
print(mmHeap.min);  // 1
print(mmHeap.max);  // 9

// Extraer de cualquier extremo
print(mmHeap.extractMin());  // 1
print(mmHeap.extractMax());  // 9

print(mmHeap.min);  // 3
print(mmHeap.max);  // 7

// Construir desde arreglo
final heap = MinMaxHeap.from([5, 2, 8, 1, 9, 3]);

// Métodos seguros
print(mmHeap.tryMin());         // null si vacío
print(mmHeap.tryMax());         // null si vacío
print(mmHeap.tryExtractMin());  // null si vacío
print(mmHeap.tryExtractMax());  // null si vacío

// Propiedades
print(mmHeap.length);
print(mmHeap.isEmpty);
print(mmHeap.isValid);  // valida propiedad del montículo
```

**Casos de Uso:**
- Colas de prioridad de doble extremo
- Algoritmos de búsqueda de mediana
- Ventana deslizante mín/máx
- Gestión de ancho de banda (priorizar tanto alta como baja prioridad)
