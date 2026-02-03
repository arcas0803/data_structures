# Linear Structures / Estructuras Lineales

[🇬🇧 English](#english) | [🇪🇸 Español](#español)

---

<a name="english"></a>
## 🇬🇧 English

Linear data structures store elements sequentially. Each element has a predecessor and successor (except first and last).

### Structures

#### LinkedList (Singly Linked List)

A sequence of nodes where each node contains a value and a reference to the next node.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Access by index | O(n) |
| Search | O(n) |
| Insert at head | O(1) |
| Insert at tail | O(n) |
| Delete | O(n) |

**Usage:**
```dart
final list = LinkedList<int>();
list.add(1);
list.add(2);
list.addFirst(0);
print(list); // LinkedList: [0 -> 1 -> 2]

list.reverse();
print(list.toList()); // [2, 1, 0]

print(list.contains(1)); // true
print(list.indexOf(2)); // 0
```

**Key Methods:**
- `add(value)` / `addLast(value)` - Add at end
- `addFirst(value)` - Add at beginning
- `insertAt(index, value)` - Insert at position
- `remove(value)` - Remove first occurrence
- `removeFirst()` / `removeLast()` - Remove from ends
- `removeAt(index)` - Remove at position
- `contains(value)` - Check if exists
- `indexOf(value)` - Find position
- `reverse()` - Reverse in place
- `elementAt(index)` - Access by index

---

#### DoublyLinkedList

Each node has references to both next and previous nodes, allowing bidirectional traversal.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Access by index | O(n) |
| Search | O(n) |
| Insert at head/tail | O(1) |
| Delete at head/tail | O(1) |
| Delete by reference | O(1) |

**Usage:**
```dart
final list = DoublyLinkedList<String>();
list.add('B');
list.addFirst('A');
list.addLast('C');
print(list); // DoublyLinkedList: [A <-> B <-> C]

// Bidirectional iteration
print(list.values.toList());         // [A, B, C]
print(list.valuesReversed.toList()); // [C, B, A]

// Insert relative to a node
list.insertAfter(list.head!, 'A2');
list.insertBefore(list.tail!, 'B2');
```

**Additional Methods:**
- `insertAfter(node, value)` - Insert after a specific node O(1)
- `insertBefore(node, value)` - Insert before a specific node O(1)
- `removeNode(node)` - Remove a specific node O(1)
- `valuesReversed` - Iterate backwards

---

#### Stack (LIFO)

Last-In-First-Out structure. Elements are added and removed from the same end (top).

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Push | O(1) |
| Pop | O(1) |
| Peek | O(1) |
| Search | O(n) |

**Usage:**
```dart
final stack = Stack<String>();
stack.push('first');
stack.push('second');
stack.push('third');

print(stack.peek()); // third (doesn't remove)
print(stack.pop());  // third (removes)
print(stack.pop());  // second

// Safe methods that don't throw
print(stack.tryPeek()); // first
print(stack.tryPop());  // first
print(stack.tryPop());  // null (empty)

// Search returns position from top (1-based)
stack.push('a');
stack.push('b');
stack.push('c');
print(stack.search('c')); // 1 (at top)
print(stack.search('a')); // 3
```

**Key Methods:**
- `push(value)` - Add to top
- `pop()` - Remove and return top (throws if empty)
- `peek()` - View top without removing (throws if empty)
- `tryPop()` / `tryPeek()` - Safe versions returning null
- `search(value)` - Position from top (1-based, -1 if not found)

---

#### Queue (FIFO)

First-In-First-Out structure. Elements are added at rear and removed from front.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Enqueue | O(1) |
| Dequeue | O(1) |
| Peek | O(1) |

**Usage:**
```dart
final queue = Queue<int>();
queue.enqueue(1);
queue.enqueue(2);
queue.enqueue(3);

print(queue.front); // 1
print(queue.rear);  // 3

print(queue.dequeue()); // 1
print(queue.dequeue()); // 2
print(queue.peek());    // 3 (same as front)

// Safe methods
print(queue.tryDequeue()); // 3
print(queue.tryDequeue()); // null
```

---

#### Deque (Double-Ended Queue)

Elements can be added and removed from both ends.

**Usage:**
```dart
final deque = Deque<int>();
deque.addFirst(2);
deque.addFirst(1);
deque.addLast(3);
deque.addLast(4);

print(deque.toList()); // [1, 2, 3, 4]

print(deque.removeFirst()); // 1
print(deque.removeLast());  // 4

print(deque.peekFirst()); // 2
print(deque.peekLast());  // 3
```

---

#### CircularLinkedList (Singly Circular Linked List)

A linked list where the last node points back to the first, forming a circle.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Access by index | O(n) |
| Search | O(n) |
| Insert at head | O(1) |
| Insert at tail | O(1) |
| Delete | O(n) |

**Usage:**
```dart
final list = CircularLinkedList<int>();
list.add(1);
list.add(2);
list.add(3);
print(list); // CircularLinkedList: [1 -> 2 -> 3 -> (head)]

list.addFirst(0);
print(list.toList()); // [0, 1, 2, 3]

// Circular iteration
final iterator = list.circularIterator();
for (var i = 0; i < 6; i++) {
  iterator.moveNext();
  print(iterator.current); // 0, 1, 2, 3, 0, 1...
}
```

**Key Methods:**
- `add(value)` / `addLast(value)` - Add at end O(1)
- `addFirst(value)` - Add at beginning O(1)
- `remove(value)` - Remove first occurrence
- `removeFirst()` / `removeLast()` - Remove from ends
- `contains(value)` - Check if exists
- `circularIterator()` - Infinite circular iteration

---

#### CircularDoublyLinkedList (Doubly Circular Linked List)

A doubly linked list where head.prev points to tail and tail.next points to head.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Access by index | O(n) |
| Search | O(n) |
| Insert at head/tail | O(1) |
| Delete at head/tail | O(1) |
| Delete by reference | O(1) |

**Usage:**
```dart
final list = CircularDoublyLinkedList<String>();
list.add('A');
list.add('B');
list.add('C');
print(list); // CircularDoublyLinkedList: [A <-> B <-> C <-> (head)]

// Bidirectional circular iteration
final forward = list.circularIterator();
final backward = list.circularIterator(reverse: true);

// Navigate in both directions infinitely
forward.moveNext();  // A
forward.moveNext();  // B
backward.moveNext(); // C
backward.moveNext(); // B
```

**Key Methods:**
- `add(value)` / `addLast(value)` - Add at end O(1)
- `addFirst(value)` - Add at beginning O(1)
- `insertAfter(node, value)` - Insert after node O(1)
- `insertBefore(node, value)` - Insert before node O(1)
- `removeNode(node)` - Remove specific node O(1)
- `circularIterator({reverse})` - Infinite circular iteration in either direction

---

#### SkipList

A probabilistic data structure that allows O(log n) average search, insert, and delete by maintaining multiple layers of linked lists.

**Time Complexity:**
| Operation | Average | Worst |
|-----------|---------|-------|
| Search | O(log n) | O(n) |
| Insert | O(log n) | O(n) |
| Delete | O(log n) | O(n) |
| Access min | O(1) | O(1) |

**Usage:**
```dart
final skipList = SkipList<int>();
skipList.insert(3);
skipList.insert(1);
skipList.insert(4);
skipList.insert(1);
skipList.insert(5);

print(skipList.contains(4)); // true
print(skipList.contains(2)); // false

print(skipList.first); // 1 (minimum element)
print(skipList.toList()); // [1, 1, 3, 4, 5] (sorted)

skipList.remove(1); // Removes one occurrence
print(skipList.toList()); // [1, 3, 4, 5]
```

**Key Methods:**
- `insert(value)` - Add element (maintains sorted order)
- `remove(value)` - Remove one occurrence
- `contains(value)` - Check if exists O(log n)
- `first` - Access minimum element O(1)
- `toList()` - Get sorted list of elements
- `clear()` - Remove all elements

---

<a name="español"></a>
## 🇪🇸 Español

Las estructuras de datos lineales almacenan elementos secuencialmente. Cada elemento tiene un predecesor y sucesor (excepto el primero y último).

### Estructuras

#### LinkedList (Lista Enlazada Simple)

Una secuencia de nodos donde cada nodo contiene un valor y una referencia al siguiente nodo.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Acceso por índice | O(n) |
| Búsqueda | O(n) |
| Insertar al inicio | O(1) |
| Insertar al final | O(n) |
| Eliminar | O(n) |

**Uso:**
```dart
final lista = LinkedList<int>();
lista.add(1);
lista.add(2);
lista.addFirst(0);
print(lista); // LinkedList: [0 -> 1 -> 2]

lista.reverse();
print(lista.toList()); // [2, 1, 0]

print(lista.contains(1)); // true
print(lista.indexOf(2)); // 0
```

**Métodos Principales:**
- `add(valor)` / `addLast(valor)` - Agregar al final
- `addFirst(valor)` - Agregar al inicio
- `insertAt(indice, valor)` - Insertar en posición
- `remove(valor)` - Eliminar primera ocurrencia
- `removeFirst()` / `removeLast()` - Eliminar de los extremos
- `removeAt(indice)` - Eliminar en posición
- `contains(valor)` - Verificar si existe
- `indexOf(valor)` - Encontrar posición
- `reverse()` - Invertir en su lugar
- `elementAt(indice)` - Acceder por índice

---

#### DoublyLinkedList (Lista Doblemente Enlazada)

Cada nodo tiene referencias al nodo siguiente y anterior, permitiendo recorrido bidireccional.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Acceso por índice | O(n) |
| Búsqueda | O(n) |
| Insertar al inicio/final | O(1) |
| Eliminar al inicio/final | O(1) |
| Eliminar por referencia | O(1) |

**Uso:**
```dart
final lista = DoublyLinkedList<String>();
lista.add('B');
lista.addFirst('A');
lista.addLast('C');
print(lista); // DoublyLinkedList: [A <-> B <-> C]

// Iteración bidireccional
print(lista.values.toList());         // [A, B, C]
print(lista.valuesReversed.toList()); // [C, B, A]

// Insertar relativo a un nodo
lista.insertAfter(lista.head!, 'A2');
lista.insertBefore(lista.tail!, 'B2');
```

**Métodos Adicionales:**
- `insertAfter(nodo, valor)` - Insertar después de un nodo específico O(1)
- `insertBefore(nodo, valor)` - Insertar antes de un nodo específico O(1)
- `removeNode(nodo)` - Eliminar un nodo específico O(1)
- `valuesReversed` - Iterar hacia atrás

---

#### Stack (Pila - LIFO)

Estructura Último en Entrar, Primero en Salir. Los elementos se agregan y eliminan del mismo extremo (tope).

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Push (apilar) | O(1) |
| Pop (desapilar) | O(1) |
| Peek (ver tope) | O(1) |
| Búsqueda | O(n) |

**Uso:**
```dart
final pila = Stack<String>();
pila.push('primero');
pila.push('segundo');
pila.push('tercero');

print(pila.peek()); // tercero (no elimina)
print(pila.pop());  // tercero (elimina)
print(pila.pop());  // segundo

// Métodos seguros que no lanzan excepciones
print(pila.tryPeek()); // primero
print(pila.tryPop());  // primero
print(pila.tryPop());  // null (vacía)

// search retorna posición desde el tope (base 1)
pila.push('a');
pila.push('b');
pila.push('c');
print(pila.search('c')); // 1 (en el tope)
print(pila.search('a')); // 3
```

**Métodos Principales:**
- `push(valor)` - Agregar al tope
- `pop()` - Eliminar y retornar tope (lanza excepción si vacía)
- `peek()` - Ver tope sin eliminar (lanza excepción si vacía)
- `tryPop()` / `tryPeek()` - Versiones seguras que retornan null
- `search(valor)` - Posición desde el tope (base 1, -1 si no encontrado)

---

#### Queue (Cola - FIFO)

Estructura Primero en Entrar, Primero en Salir. Los elementos se agregan al final y se eliminan del frente.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Encolar | O(1) |
| Desencolar | O(1) |
| Peek | O(1) |

**Uso:**
```dart
final cola = Queue<int>();
cola.enqueue(1);
cola.enqueue(2);
cola.enqueue(3);

print(cola.front); // 1
print(cola.rear);  // 3

print(cola.dequeue()); // 1
print(cola.dequeue()); // 2
print(cola.peek());    // 3 (igual que front)

// Métodos seguros
print(cola.tryDequeue()); // 3
print(cola.tryDequeue()); // null
```

---

#### Deque (Cola de Doble Extremo)

Los elementos pueden agregarse y eliminarse de ambos extremos.

**Uso:**
```dart
final deque = Deque<int>();
deque.addFirst(2);
deque.addFirst(1);
deque.addLast(3);
deque.addLast(4);

print(deque.toList()); // [1, 2, 3, 4]

print(deque.removeFirst()); // 1
print(deque.removeLast());  // 4

print(deque.peekFirst()); // 2
print(deque.peekLast());  // 3
```

---

#### CircularLinkedList (Lista Enlazada Circular Simple)

Una lista enlazada donde el último nodo apunta de vuelta al primero, formando un círculo.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Acceso por índice | O(n) |
| Búsqueda | O(n) |
| Insertar al inicio | O(1) |
| Insertar al final | O(1) |
| Eliminar | O(n) |

**Uso:**
```dart
final lista = CircularLinkedList<int>();
lista.add(1);
lista.add(2);
lista.add(3);
print(lista); // CircularLinkedList: [1 -> 2 -> 3 -> (head)]

lista.addFirst(0);
print(lista.toList()); // [0, 1, 2, 3]

// Iteración circular
final iterador = lista.circularIterator();
for (var i = 0; i < 6; i++) {
  iterador.moveNext();
  print(iterador.current); // 0, 1, 2, 3, 0, 1...
}
```

**Métodos Principales:**
- `add(valor)` / `addLast(valor)` - Agregar al final O(1)
- `addFirst(valor)` - Agregar al inicio O(1)
- `remove(valor)` - Eliminar primera ocurrencia
- `removeFirst()` / `removeLast()` - Eliminar de los extremos
- `contains(valor)` - Verificar si existe
- `circularIterator()` - Iteración circular infinita

---

#### CircularDoublyLinkedList (Lista Doblemente Enlazada Circular)

Una lista doblemente enlazada donde head.prev apunta a tail y tail.next apunta a head.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Acceso por índice | O(n) |
| Búsqueda | O(n) |
| Insertar al inicio/final | O(1) |
| Eliminar al inicio/final | O(1) |
| Eliminar por referencia | O(1) |

**Uso:**
```dart
final lista = CircularDoublyLinkedList<String>();
lista.add('A');
lista.add('B');
lista.add('C');
print(lista); // CircularDoublyLinkedList: [A <-> B <-> C <-> (head)]

// Iteración circular bidireccional
final adelante = lista.circularIterator();
final atras = lista.circularIterator(reverse: true);

// Navegar en ambas direcciones infinitamente
adelante.moveNext();  // A
adelante.moveNext();  // B
atras.moveNext();     // C
atras.moveNext();     // B
```

**Métodos Principales:**
- `add(valor)` / `addLast(valor)` - Agregar al final O(1)
- `addFirst(valor)` - Agregar al inicio O(1)
- `insertAfter(nodo, valor)` - Insertar después de nodo O(1)
- `insertBefore(nodo, valor)` - Insertar antes de nodo O(1)
- `removeNode(nodo)` - Eliminar nodo específico O(1)
- `circularIterator({reverse})` - Iteración circular infinita en cualquier dirección

---

#### SkipList (Lista de Salto)

Una estructura de datos probabilística que permite búsqueda, inserción y eliminación en O(log n) promedio, manteniendo múltiples capas de listas enlazadas.

**Complejidad Temporal:**
| Operación | Promedio | Peor Caso |
|-----------|----------|-----------|
| Búsqueda | O(log n) | O(n) |
| Inserción | O(log n) | O(n) |
| Eliminación | O(log n) | O(n) |
| Acceso mínimo | O(1) | O(1) |

**Uso:**
```dart
final skipList = SkipList<int>();
skipList.insert(3);
skipList.insert(1);
skipList.insert(4);
skipList.insert(1);
skipList.insert(5);

print(skipList.contains(4)); // true
print(skipList.contains(2)); // false

print(skipList.first); // 1 (elemento mínimo)
print(skipList.toList()); // [1, 1, 3, 4, 5] (ordenado)

skipList.remove(1); // Elimina una ocurrencia
print(skipList.toList()); // [1, 3, 4, 5]
```

**Métodos Principales:**
- `insert(valor)` - Agregar elemento (mantiene orden)
- `remove(valor)` - Eliminar una ocurrencia
- `contains(valor)` - Verificar si existe O(log n)
- `first` - Acceder al elemento mínimo O(1)
- `toList()` - Obtener lista ordenada de elementos
- `clear()` - Eliminar todos los elementos
