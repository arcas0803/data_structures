# Direct Access Structures / Estructuras de Acceso Directo

[🇬🇧 English](#english) | [🇪🇸 Español](#español)

---

<a name="english"></a>
## 🇬🇧 English

These structures provide efficient random access and key-based lookup operations.

### Structures

#### DynamicArray (Vector)

A resizable array that automatically grows when capacity is exceeded. Similar to ArrayList in Java or std::vector in C++.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Access by index | O(1) |
| Search | O(n) |
| Insert at end | O(1) amortized |
| Insert at index | O(n) |
| Delete at end | O(1) |
| Delete at index | O(n) |

**Usage:**
```dart
// Create with initial capacity
final array = DynamicArray<int>(4);

// Add elements (auto-resizes when needed)
for (var i = 0; i < 10; i++) {
  array.add(i * 10);
}
print(array); // DynamicArray: [0, 10, 20, ...] (size: 10, capacity: 16)

// Index access
print(array[5]);  // 50
array[5] = 500;
print(array[5]);  // 500

// Insert and remove
array.insert(0, -10);  // Insert at beginning
array.removeLast();    // Remove last element
array.removeAt(3);     // Remove at index

// Find elements
print(array.contains(20));   // true
print(array.indexOf(20));    // index of first occurrence
print(array.lastIndexOf(20)); // index of last occurrence

// Transform
array.reverse();
array.sort();
array.sort((a, b) => b.compareTo(a)); // descending

// Filter and map
final evens = array.where((e) => e % 2 == 0);
final doubled = array.map((e) => e * 2);

// Get sublist
final sub = array.sublist(2, 5);

// Memory management
print(array.capacity);  // Current capacity
array.trimToSize();     // Reduce capacity to size
array.setCapacity(100); // Manually set capacity
```

**Factory Constructors:**
```dart
final fromList = DynamicArray.from([1, 2, 3, 4, 5]);
final filled = DynamicArray.filled(10, 0); // 10 zeros
```

---

#### HashTable (HashMap)

A hash map implementation using separate chaining for collision resolution. Provides O(1) average-case operations.

**Time Complexity:**
| Operation | Average | Worst |
|-----------|---------|-------|
| Get | O(1) | O(n) |
| Put | O(1) | O(n) |
| Remove | O(1) | O(n) |
| Contains Key | O(1) | O(n) |

**Usage:**
```dart
final map = HashTable<String, int>();

// Add entries
map.put('one', 1);
map.put('two', 2);
map['three'] = 3;  // operator syntax

// Get values
print(map.get('one'));  // 1
print(map['two']);      // 2

// Safe get methods
print(map.tryGet('missing'));        // null
print(map.getOrDefault('missing', 0)); // 0

// Update existing or insert new
map.update('one', (v) => v + 10);
map.update('four', (v) => v, ifAbsent: () => 4);

// Put if absent
map.putIfAbsent('five', () => 5);

// Check existence
print(map.containsKey('one'));   // true
print(map.containsValue(1));     // true

// Remove
final removed = map.remove('one'); // returns removed value

// Iterate
for (final key in map.keys) { ... }
for (final value in map.values) { ... }
for (final (key, value) in map.entries) { ... }
map.forEach((k, v) => print('$k: $v'));

// Convert to Dart Map
final dartMap = map.toMap();

// Statistics
print(map.stats);
// {size: 3, capacity: 16, loadFactor: 0.1875, usedBuckets: 3, ...}
```

---

#### HashSet

A set backed by a hash table. Stores unique elements only.

**Time Complexity:**
| Operation | Average | Worst |
|-----------|---------|-------|
| Add | O(1) | O(n) |
| Remove | O(1) | O(n) |
| Contains | O(1) | O(n) |

**Usage:**
```dart
final set = HashSet<int>();

// Add elements (duplicates ignored)
set.add(1);
set.add(2);
set.add(1);  // ignored
print(set.length); // 2

set.addAll([3, 4, 5]);

// Check and remove
print(set.contains(3)); // true
set.remove(3);

// Set operations
final a = HashSet.from([1, 2, 3, 4]);
final b = HashSet.from([3, 4, 5, 6]);

final union = a.union(b);         // {1, 2, 3, 4, 5, 6}
final intersection = a.intersection(b); // {3, 4}
final difference = a.difference(b);    // {1, 2}

// Check subset
print(HashSet.from([1, 2]).isSubsetOf(a)); // true

// Convert
final dartSet = set.toSet();
final list = set.toList();
```

---

#### UnionFind\<T\> (Disjoint Set Union)

A data structure that tracks a set of elements partitioned into disjoint (non-overlapping) subsets. Also known as Disjoint Set Union (DSU). Uses path compression and union by rank for near-constant time operations.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Find | O(α(n)) ≈ O(1) |
| Union | O(α(n)) ≈ O(1) |
| Connected | O(α(n)) ≈ O(1) |
| Add | O(1) |

*α(n) is the inverse Ackermann function, effectively constant for all practical purposes.*

**Usage:**
```dart
final uf = UnionFind<String>();

// Add elements
uf.add('A');
uf.add('B');
uf.add('C');
uf.add('D');

// Union elements into groups
uf.union('A', 'B');  // A and B are now in the same group
uf.union('C', 'D');  // C and D are now in the same group

// Check connectivity
print(uf.connected('A', 'B'));  // true
print(uf.connected('A', 'C'));  // false

// Find representative (root) of a group
print(uf.find('A'));  // returns root of A's group
print(uf.find('B'));  // same as find('A')

// Merge groups
uf.union('B', 'C');  // Now A, B, C, D are all connected
print(uf.connected('A', 'D'));  // true

// Get number of disjoint sets
print(uf.setCount);  // 1

// Get all elements in same set
final group = uf.getSet('A');  // {'A', 'B', 'C', 'D'}

// Get all disjoint sets
final allSets = uf.getAllSets();  // [{'A', 'B', 'C', 'D'}]
```

**Factory Constructors:**
```dart
final uf = UnionFind.from(['A', 'B', 'C', 'D', 'E']);
```

**Use Cases:**
- Network connectivity (checking if two nodes are connected)
- Kruskal's minimum spanning tree algorithm
- Image processing (connected components)
- Social network analysis (friend groups)
- Cycle detection in undirected graphs

---

#### UnionFindInt (Optimized Integer Union-Find)

An optimized version of Union-Find specifically for integer elements (0 to n-1). Uses arrays instead of hash maps for better performance and memory efficiency.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Find | O(α(n)) ≈ O(1) |
| Union | O(α(n)) ≈ O(1) |
| Connected | O(α(n)) ≈ O(1) |

**Usage:**
```dart
// Create with size (elements 0 to n-1)
final uf = UnionFindInt(10);  // elements 0-9

// Union elements
uf.union(0, 1);
uf.union(2, 3);
uf.union(1, 3);  // Now 0, 1, 2, 3 are connected

// Check connectivity
print(uf.connected(0, 2));  // true
print(uf.connected(0, 5));  // false

// Find representative
print(uf.find(2));  // root of the set containing 2

// Get set count
print(uf.setCount);  // number of disjoint sets

// Get size of a specific set
print(uf.getSetSize(0));  // size of set containing element 0
```

**Use Cases:**
- Competitive programming (faster than generic version)
- Graph algorithms with numbered vertices
- Dynamic connectivity problems
- Percolation simulations

---

#### BloomFilter\<T\>

A space-efficient probabilistic data structure for testing set membership. Can have false positives but never false negatives. Ideal for checking if an element is "possibly in set" or "definitely not in set".

**Characteristics:**
- **False Positives:** Possible (configurable probability)
- **False Negatives:** Never
- **Space:** Much smaller than storing actual elements
- **Deletion:** Not supported

**Usage:**
```dart
// Create with expected elements and false positive rate
final filter = BloomFilter<String>(
  expectedElements: 1000,
  falsePositiveRate: 0.01,  // 1% false positive rate
);

// Add elements
filter.add('apple');
filter.add('banana');
filter.add('cherry');

// Check membership
print(filter.mightContain('apple'));   // true (definitely added)
print(filter.mightContain('grape'));   // false (definitely NOT added)
print(filter.mightContain('orange'));  // might be true (false positive possible)

// Add multiple elements
filter.addAll(['date', 'elderberry', 'fig']);

// Get filter statistics
print(filter.size);                    // number of elements added
print(filter.bitCount);                // size of bit array
print(filter.hashCount);               // number of hash functions
print(filter.expectedFalsePositiveRate); // current expected FP rate

// Clear the filter
filter.clear();
```

**Custom Hash Function:**
```dart
final filter = BloomFilter<MyClass>(
  expectedElements: 500,
  falsePositiveRate: 0.05,
  hashCode: (obj) => obj.customHash(),
);
```

**Use Cases:**
- Cache filtering (avoid expensive lookups for non-existent keys)
- Spell checkers (quick "not a word" check)
- Database query optimization
- Web crawlers (avoid revisiting URLs)
- Malware detection (quick signature matching)
- Network routers (packet filtering)

---

<a name="español"></a>
## 🇪🇸 Español

Estas estructuras proporcionan acceso aleatorio eficiente y operaciones de búsqueda basadas en claves.

### Estructuras

#### DynamicArray (Arreglo Dinámico / Vector)

Un arreglo redimensionable que crece automáticamente cuando se excede la capacidad. Similar a ArrayList en Java o std::vector en C++.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Acceso por índice | O(1) |
| Búsqueda | O(n) |
| Insertar al final | O(1) amortizado |
| Insertar en índice | O(n) |
| Eliminar al final | O(1) |
| Eliminar en índice | O(n) |

**Uso:**
```dart
// Crear con capacidad inicial
final arreglo = DynamicArray<int>(4);

// Agregar elementos (redimensiona automáticamente)
for (var i = 0; i < 10; i++) {
  arreglo.add(i * 10);
}
print(arreglo); // DynamicArray: [0, 10, 20, ...] (size: 10, capacity: 16)

// Acceso por índice
print(arreglo[5]);  // 50
arreglo[5] = 500;
print(arreglo[5]);  // 500

// Insertar y eliminar
arreglo.insert(0, -10);  // Insertar al inicio
arreglo.removeLast();    // Eliminar último elemento
arreglo.removeAt(3);     // Eliminar en índice

// Buscar elementos
print(arreglo.contains(20));   // true
print(arreglo.indexOf(20));    // índice de primera ocurrencia
print(arreglo.lastIndexOf(20)); // índice de última ocurrencia

// Transformar
arreglo.reverse();
arreglo.sort();
arreglo.sort((a, b) => b.compareTo(a)); // descendente

// Filtrar y mapear
final pares = arreglo.where((e) => e % 2 == 0);
final dobles = arreglo.map((e) => e * 2);

// Obtener sublista
final sub = arreglo.sublist(2, 5);

// Gestión de memoria
print(arreglo.capacity);  // Capacidad actual
arreglo.trimToSize();     // Reducir capacidad al tamaño
arreglo.setCapacity(100); // Establecer capacidad manualmente
```

**Constructores Factory:**
```dart
final desdeLista = DynamicArray.from([1, 2, 3, 4, 5]);
final relleno = DynamicArray.filled(10, 0); // 10 ceros
```

---

#### HashTable (Tabla Hash / Mapa Hash)

Implementación de mapa hash usando encadenamiento separado para resolución de colisiones. Proporciona operaciones O(1) en caso promedio.

**Complejidad Temporal:**
| Operación | Promedio | Peor Caso |
|-----------|----------|-----------|
| Obtener | O(1) | O(n) |
| Insertar | O(1) | O(n) |
| Eliminar | O(1) | O(n) |
| Contiene Clave | O(1) | O(n) |

**Uso:**
```dart
final mapa = HashTable<String, int>();

// Agregar entradas
mapa.put('uno', 1);
mapa.put('dos', 2);
mapa['tres'] = 3;  // sintaxis de operador

// Obtener valores
print(mapa.get('uno'));  // 1
print(mapa['dos']);      // 2

// Métodos de obtención seguros
print(mapa.tryGet('faltante'));           // null
print(mapa.getOrDefault('faltante', 0));  // 0

// Actualizar existente o insertar nuevo
mapa.update('uno', (v) => v + 10);
mapa.update('cuatro', (v) => v, ifAbsent: () => 4);

// Insertar si ausente
mapa.putIfAbsent('cinco', () => 5);

// Verificar existencia
print(mapa.containsKey('uno'));   // true
print(mapa.containsValue(1));     // true

// Eliminar
final eliminado = mapa.remove('uno'); // retorna valor eliminado

// Iterar
for (final clave in mapa.keys) { ... }
for (final valor in mapa.values) { ... }
for (final (clave, valor) in mapa.entries) { ... }
mapa.forEach((k, v) => print('$k: $v'));

// Convertir a Map de Dart
final mapaDart = mapa.toMap();

// Estadísticas
print(mapa.stats);
// {size: 3, capacity: 16, loadFactor: 0.1875, usedBuckets: 3, ...}
```

---

#### HashSet (Conjunto Hash)

Un conjunto respaldado por tabla hash. Almacena solo elementos únicos.

**Complejidad Temporal:**
| Operación | Promedio | Peor Caso |
|-----------|----------|-----------|
| Agregar | O(1) | O(n) |
| Eliminar | O(1) | O(n) |
| Contiene | O(1) | O(n) |

**Uso:**
```dart
final conjunto = HashSet<int>();

// Agregar elementos (duplicados ignorados)
conjunto.add(1);
conjunto.add(2);
conjunto.add(1);  // ignorado
print(conjunto.length); // 2

conjunto.addAll([3, 4, 5]);

// Verificar y eliminar
print(conjunto.contains(3)); // true
conjunto.remove(3);

// Operaciones de conjuntos
final a = HashSet.from([1, 2, 3, 4]);
final b = HashSet.from([3, 4, 5, 6]);

final union = a.union(b);              // {1, 2, 3, 4, 5, 6}
final interseccion = a.intersection(b); // {3, 4}
final diferencia = a.difference(b);     // {1, 2}

// Verificar subconjunto
print(HashSet.from([1, 2]).isSubsetOf(a)); // true

// Convertir
final setDart = conjunto.toSet();
final lista = conjunto.toList();
```

---

#### UnionFind\<T\> (Unión-Búsqueda / Conjuntos Disjuntos)

Una estructura de datos que rastrea un conjunto de elementos particionados en subconjuntos disjuntos (no superpuestos). También conocido como Disjoint Set Union (DSU). Utiliza compresión de caminos y unión por rango para operaciones en tiempo casi constante.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Encontrar | O(α(n)) ≈ O(1) |
| Unir | O(α(n)) ≈ O(1) |
| Conectados | O(α(n)) ≈ O(1) |
| Agregar | O(1) |

*α(n) es la función inversa de Ackermann, efectivamente constante para todos los propósitos prácticos.*

**Uso:**
```dart
final uf = UnionFind<String>();

// Agregar elementos
uf.add('A');
uf.add('B');
uf.add('C');
uf.add('D');

// Unir elementos en grupos
uf.union('A', 'B');  // A y B ahora están en el mismo grupo
uf.union('C', 'D');  // C y D ahora están en el mismo grupo

// Verificar conectividad
print(uf.connected('A', 'B'));  // true
print(uf.connected('A', 'C'));  // false

// Encontrar representante (raíz) de un grupo
print(uf.find('A'));  // retorna raíz del grupo de A
print(uf.find('B'));  // igual que find('A')

// Fusionar grupos
uf.union('B', 'C');  // Ahora A, B, C, D están todos conectados
print(uf.connected('A', 'D'));  // true

// Obtener número de conjuntos disjuntos
print(uf.setCount);  // 1

// Obtener todos los elementos en el mismo conjunto
final grupo = uf.getSet('A');  // {'A', 'B', 'C', 'D'}

// Obtener todos los conjuntos disjuntos
final todosConjuntos = uf.getAllSets();  // [{'A', 'B', 'C', 'D'}]
```

**Constructores Factory:**
```dart
final uf = UnionFind.from(['A', 'B', 'C', 'D', 'E']);
```

**Casos de Uso:**
- Conectividad de redes (verificar si dos nodos están conectados)
- Algoritmo de árbol de expansión mínima de Kruskal
- Procesamiento de imágenes (componentes conectados)
- Análisis de redes sociales (grupos de amigos)
- Detección de ciclos en grafos no dirigidos

---

#### UnionFindInt (Union-Find Optimizado para Enteros)

Una versión optimizada de Union-Find específicamente para elementos enteros (0 a n-1). Utiliza arreglos en lugar de mapas hash para mejor rendimiento y eficiencia de memoria.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Encontrar | O(α(n)) ≈ O(1) |
| Unir | O(α(n)) ≈ O(1) |
| Conectados | O(α(n)) ≈ O(1) |

**Uso:**
```dart
// Crear con tamaño (elementos 0 a n-1)
final uf = UnionFindInt(10);  // elementos 0-9

// Unir elementos
uf.union(0, 1);
uf.union(2, 3);
uf.union(1, 3);  // Ahora 0, 1, 2, 3 están conectados

// Verificar conectividad
print(uf.connected(0, 2));  // true
print(uf.connected(0, 5));  // false

// Encontrar representante
print(uf.find(2));  // raíz del conjunto que contiene 2

// Obtener conteo de conjuntos
print(uf.setCount);  // número de conjuntos disjuntos

// Obtener tamaño de un conjunto específico
print(uf.getSetSize(0));  // tamaño del conjunto que contiene el elemento 0
```

**Casos de Uso:**
- Programación competitiva (más rápido que la versión genérica)
- Algoritmos de grafos con vértices numerados
- Problemas de conectividad dinámica
- Simulaciones de percolación

---

#### BloomFilter\<T\> (Filtro de Bloom)

Una estructura de datos probabilística eficiente en espacio para probar pertenencia a un conjunto. Puede tener falsos positivos pero nunca falsos negativos. Ideal para verificar si un elemento está "posiblemente en el conjunto" o "definitivamente no está en el conjunto".

**Características:**
- **Falsos Positivos:** Posibles (probabilidad configurable)
- **Falsos Negativos:** Nunca
- **Espacio:** Mucho menor que almacenar elementos reales
- **Eliminación:** No soportada

**Uso:**
```dart
// Crear con elementos esperados y tasa de falsos positivos
final filtro = BloomFilter<String>(
  expectedElements: 1000,
  falsePositiveRate: 0.01,  // 1% de tasa de falsos positivos
);

// Agregar elementos
filtro.add('manzana');
filtro.add('banana');
filtro.add('cereza');

// Verificar pertenencia
print(filtro.mightContain('manzana'));  // true (definitivamente agregado)
print(filtro.mightContain('uva'));      // false (definitivamente NO agregado)
print(filtro.mightContain('naranja'));  // podría ser true (falso positivo posible)

// Agregar múltiples elementos
filtro.addAll(['dátil', 'mora', 'higo']);

// Obtener estadísticas del filtro
print(filtro.size);                    // número de elementos agregados
print(filtro.bitCount);                // tamaño del arreglo de bits
print(filtro.hashCount);               // número de funciones hash
print(filtro.expectedFalsePositiveRate); // tasa esperada actual de FP

// Limpiar el filtro
filtro.clear();
```

**Función Hash Personalizada:**
```dart
final filtro = BloomFilter<MiClase>(
  expectedElements: 500,
  falsePositiveRate: 0.05,
  hashCode: (obj) => obj.hashPersonalizado(),
);
```

**Casos de Uso:**
- Filtrado de caché (evitar búsquedas costosas para claves inexistentes)
- Correctores ortográficos (verificación rápida de "no es una palabra")
- Optimización de consultas de base de datos
- Rastreadores web (evitar revisitar URLs)
- Detección de malware (coincidencia rápida de firmas)
- Routers de red (filtrado de paquetes)
