# Data Structures Library / Librería de Estructuras de Datos

[![Pub Version](https://img.shields.io/pub/v/data_structures)](https://pub.dev/packages/data_structures)
[![CI](https://github.com/arcas0803/data_structures/actions/workflows/ci.yml/badge.svg)](https://github.com/arcas0803/data_structures/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/arcas0803/data_structures/branch/main/graph/badge.svg)](https://codecov.io/gh/arcas0803/data_structures)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive, well-documented library of fundamental data structures implemented in Dart. Perfect for learning, teaching, and using in production applications.

Una librería completa y bien documentada de estructuras de datos fundamentales implementada en Dart. Perfecta para aprender, enseñar y usar en aplicaciones de producción.

---

## Table of Contents / Índice

- [🇬🇧 English](#english)
- [🇪🇸 Español](#español)

---

<a name="english"></a>
# 🇬🇧 English

## Categories

This library is organized into four main categories. Click on each category for detailed documentation:

### 📦 [1. Linear Structures](lib/src/linear/README.md)
Sequential data storage: **LinkedList**, **DoublyLinkedList**, **CircularLinkedList**, **CircularDoublyLinkedList**, **Stack**, **Queue**, **Deque**, **SkipList**

### 🔑 [2. Direct Access Structures](lib/src/direct_access/README.md)
Key-based and set operations: **DynamicArray**, **HashTable**, **HashSet**, **UnionFind**, **BloomFilter**

### 🌳 [3. Tree Structures](lib/src/trees/README.md)
Hierarchical and specialized trees: **BST**, **AVLTree**, **Heap**, **PriorityQueue**, **NaryTree**, **Trie**, **BTree**, **BPlusTree**, **SegmentTree**, **FenwickTree**, **FibonacciHeap**, **MinMaxHeap**

### 🕸️ [4. Graph Structures](lib/src/graphs/README.md)
Graph representations and algorithms: **Graph**, **AdjacencyMatrixGraph**, **FlowNetwork** with BFS, DFS, max-flow/min-cut

---

## Quick Start

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  data_structures:
    path: ../data_structures  # or use git/pub version
```

### Import

```dart
import 'package:data_structures/data_structures.dart';
```

### Quick Examples

```dart
// Stack - LIFO structure
final stack = Stack<int>()..pushAll([1, 2, 3]);
print(stack.pop()); // 3

// Queue - FIFO structure
final queue = Queue<int>()..enqueue(1)..enqueue(2);
print(queue.dequeue()); // 1

// HashTable - O(1) lookup
final map = HashTable<String, int>();
map['key'] = 42;
print(map['key']); // 42

// AVL Tree - self-balancing BST
final avl = AVLTree<int>();
for (var i = 1; i <= 100; i++) avl.insert(i);
print(avl.height); // ~7 (balanced!)

// Graph with BFS
final graph = Graph<String>();
graph.addEdge('A', 'B');
graph.addEdge('A', 'C');
print(graph.bfs('A')); // [A, B, C]
```

---

## Time Complexity Overview

| Structure | Access | Search | Insert | Delete |
|-----------|--------|--------|--------|--------|
| LinkedList | O(n) | O(n) | O(1)* | O(n) |
| SkipList | O(log n) | O(log n) | O(log n) | O(log n) |
| DynamicArray | O(1) | O(n) | O(1)** | O(n) |
| HashTable | O(1) | O(1) | O(1) | O(1) |
| UnionFind | - | O(α(n))*** | O(α(n)) | - |
| BST (average) | O(log n) | O(log n) | O(log n) | O(log n) |
| AVL Tree | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap | O(1)**** | O(n) | O(log n) | O(log n) |
| FibonacciHeap | O(1) | O(n) | O(1) | O(log n) |
| SegmentTree | O(log n) | O(log n) | O(log n) | - |
| Trie | O(m) | O(m) | O(m) | O(m) |
| Graph (adj list) | - | O(V+E) | O(1) | O(E) |

\* At head | \** Amortized | \*** Inverse Ackermann (nearly O(1)) | \**** Peek only | m = string length

---

## Running Tests

```bash
dart test
```

All 1246 tests covering edge cases and operations for all structures.

---

<a name="español"></a>
# 🇪🇸 Español

## Categorías

Esta librería está organizada en cuatro categorías principales. Haz clic en cada categoría para documentación detallada:

### 📦 [1. Estructuras Lineales](lib/src/linear/README.md)
Almacenamiento secuencial: **LinkedList**, **DoublyLinkedList**, **CircularLinkedList**, **CircularDoublyLinkedList**, **Stack**, **Queue**, **Deque**, **SkipList**

### 🔑 [2. Estructuras de Acceso Directo](lib/src/direct_access/README.md)
Operaciones por clave y conjuntos: **DynamicArray**, **HashTable**, **HashSet**, **UnionFind**, **BloomFilter**

### 🌳 [3. Estructuras de Árboles](lib/src/trees/README.md)
Árboles jerárquicos y especializados: **BST**, **AVLTree**, **Heap**, **PriorityQueue**, **NaryTree**, **Trie**, **BTree**, **BPlusTree**, **SegmentTree**, **FenwickTree**, **FibonacciHeap**, **MinMaxHeap**

### 🕸️ [4. Estructuras de Grafos](lib/src/graphs/README.md)
Representaciones y algoritmos: **Graph**, **AdjacencyMatrixGraph**, **FlowNetwork** con BFS, DFS, max-flow/min-cut

---

## Inicio Rápido

### Instalación

Agrega a tu `pubspec.yaml`:

```yaml
dependencies:
  data_structures:
    path: ../data_structures  # o usa versión de git/pub
```

### Importar

```dart
import 'package:data_structures/data_structures.dart';
```

### Ejemplos Rápidos

```dart
// Stack - estructura LIFO
final pila = Stack<int>()..pushAll([1, 2, 3]);
print(pila.pop()); // 3

// Queue - estructura FIFO
final cola = Queue<int>()..enqueue(1)..enqueue(2);
print(cola.dequeue()); // 1

// HashTable - búsqueda O(1)
final mapa = HashTable<String, int>();
mapa['clave'] = 42;
print(mapa['clave']); // 42

// AVL Tree - BST auto-balanceado
final avl = AVLTree<int>();
for (var i = 1; i <= 100; i++) avl.insert(i);
print(avl.height); // ~7 (¡balanceado!)

// Grafo con BFS
final grafo = Graph<String>();
grafo.addEdge('A', 'B');
grafo.addEdge('A', 'C');
print(grafo.bfs('A')); // [A, B, C]
```

---

## Resumen de Complejidad Temporal

| Estructura | Acceso | Búsqueda | Inserción | Eliminación |
|------------|--------|----------|-----------|-------------|
| LinkedList | O(n) | O(n) | O(1)* | O(n) |
| SkipList | O(log n) | O(log n) | O(log n) | O(log n) |
| DynamicArray | O(1) | O(n) | O(1)** | O(n) |
| HashTable | O(1) | O(1) | O(1) | O(1) |
| UnionFind | - | O(α(n))*** | O(α(n)) | - |
| BST (promedio) | O(log n) | O(log n) | O(log n) | O(log n) |
| AVL Tree | O(log n) | O(log n) | O(log n) | O(log n) |
| Heap | O(1)**** | O(n) | O(log n) | O(log n) |
| FibonacciHeap | O(1) | O(n) | O(1) | O(log n) |
| SegmentTree | O(log n) | O(log n) | O(log n) | - |
| Trie | O(m) | O(m) | O(m) | O(m) |
| Graph (adj list) | - | O(V+E) | O(1) | O(E) |

\* En cabeza | \** Amortizado | \*** Ackermann inverso (casi O(1)) | \**** Solo peek | m = longitud string

---

## Ejecutar Tests

```bash
dart test
```

1246 tests cubriendo casos límite y operaciones de todas las estructuras.

---

## License / Licencia

MIT License - see LICENSE file for details.

Licencia MIT - ver archivo LICENSE para más detalles.
