# Graph Structures / Estructuras de Grafos

[🇬🇧 English](#english) | [🇪🇸 Español](#español)

---

<a name="english"></a>
## 🇬🇧 English

Non-linear data structures representing relationships between entities. Graphs consist of vertices (nodes) connected by edges.

### Graph

A flexible graph implementation supporting directed/undirected and weighted/unweighted graphs using an adjacency list representation.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Add Vertex | O(1) |
| Add Edge | O(1) |
| Remove Vertex | O(V + E) |
| Remove Edge | O(E) |
| Get Neighbors | O(1) |
| BFS/DFS | O(V + E) |
| Has Edge | O(neighbors) |

**Features:**
- Directed or undirected edges
- Weighted edges with customizable weights
- Breadth-First Search (BFS)
- Depth-First Search (DFS)
- Cycle detection
- Topological sorting (for DAGs)
- Path finding
- Connected component detection

**Basic Usage:**
```dart
// Undirected graph (default)
final graph = Graph<String>();

// Add vertices
graph.addVertex('A');
graph.addVertex('B');
graph.addVertex('C');
graph.addVertex('D');

// Add edges (creates vertices if they don't exist)
graph.addEdge('A', 'B');
graph.addEdge('B', 'C');
graph.addEdge('C', 'D');
graph.addEdge('A', 'D');

// Query the graph
print(graph.hasVertex('A'));     // true
print(graph.hasEdge('A', 'B'));  // true
print(graph.neighbors('A'));     // [B, D]
print(graph.degree('A'));        // 2

// Properties
print(graph.vertexCount); // 4
print(graph.edgeCount);   // 4
print(graph.vertices);    // [A, B, C, D]
print(graph.edges);       // list of all edges
```

**Directed Graph:**
```dart
final digraph = Graph<String>(directed: true);

digraph.addEdge('A', 'B'); // A → B
digraph.addEdge('B', 'C'); // B → C
digraph.addEdge('A', 'C'); // A → C

print(digraph.hasEdge('A', 'B')); // true
print(digraph.hasEdge('B', 'A')); // false (directed!)

print(digraph.inDegree('C'));  // 2 (edges coming in)
print(digraph.outDegree('A')); // 2 (edges going out)
```

**Weighted Graph:**
```dart
final weighted = Graph<String>();

weighted.addEdge('A', 'B', weight: 4);
weighted.addEdge('B', 'C', weight: 3);
weighted.addEdge('A', 'C', weight: 10);

final edge = weighted.getEdge('A', 'B');
print(edge?.weight); // 4.0

// Update weight
weighted.updateEdgeWeight('A', 'C', 5);
```

---

### Graph Traversals

#### BFS (Breadth-First Search)

Explores neighbors before going deeper. Useful for finding shortest paths in unweighted graphs.

```dart
final graph = Graph<int>();
graph.addEdge(1, 2);
graph.addEdge(1, 3);
graph.addEdge(2, 4);
graph.addEdge(2, 5);
graph.addEdge(3, 6);

// BFS traversal
final order = graph.bfs(1);
print(order); // [1, 2, 3, 4, 5, 6]

// BFS with callback
graph.bfsWithCallback(1, (vertex) {
  print('Visiting: $vertex');
  return true; // continue traversal
});

// Stop early when finding target
graph.bfsWithCallback(1, (vertex) {
  if (vertex == 4) {
    print('Found 4!');
    return false; // stop traversal
  }
  return true;
});

// Get BFS spanning tree
final tree = graph.bfsTree(1);
// Returns map of vertex → parent
// Useful for reconstructing paths
```

#### DFS (Depth-First Search)

Explores as deep as possible before backtracking. Useful for topological sorting, cycle detection, and pathfinding.

```dart
// DFS traversal
final order = graph.dfs(1);
print(order); // [1, 2, 4, 5, 3, 6]

// Iterative DFS (uses explicit stack)
final iterOrder = graph.dfsIterative(1);

// DFS with callback
graph.dfsWithCallback(1, (vertex) {
  print('Visiting: $vertex');
  return true;
});

// Get DFS spanning tree
final tree = graph.dfsTree(1);
```

---

### Path Finding

```dart
final graph = Graph<String>();
graph.addEdge('A', 'B');
graph.addEdge('B', 'C');
graph.addEdge('C', 'D');
graph.addEdge('A', 'D'); // shortcut

// Find any path (BFS - shortest in unweighted)
final path = graph.findPath('A', 'D');
print(path); // [A, D] - shortest path

// Check if path exists
print(graph.hasPath('A', 'D')); // true
print(graph.hasPath('D', 'A')); // true (undirected)

// All paths between vertices
final allPaths = graph.findAllPaths('A', 'D');
for (final p in allPaths) {
  print(p); // [A, D], [A, B, C, D]
}
```

---

### Cycle Detection

```dart
final graph = Graph<int>(directed: true);
graph.addEdge(1, 2);
graph.addEdge(2, 3);
graph.addEdge(3, 1); // creates cycle

print(graph.hasCycle); // true

// Works for undirected graphs too
final undirected = Graph<int>();
undirected.addEdge(1, 2);
undirected.addEdge(2, 3);
undirected.addEdge(3, 1);
print(undirected.hasCycle); // true
```

---

### Topological Sort

Orders vertices such that for every edge (u, v), u comes before v. Only works on Directed Acyclic Graphs (DAGs).

```dart
final dag = Graph<String>(directed: true);

// Build order: A before B, B before D, etc.
dag.addEdge('A', 'B');
dag.addEdge('A', 'C');
dag.addEdge('B', 'D');
dag.addEdge('C', 'D');
dag.addEdge('D', 'E');

final sorted = dag.topologicalSort();
print(sorted); // [A, C, B, D, E] or [A, B, C, D, E]
// Any valid ordering where dependencies come first

// Returns null if graph has cycles
final cyclic = Graph<int>(directed: true);
cyclic.addEdge(1, 2);
cyclic.addEdge(2, 1);
print(cyclic.topologicalSort()); // null
```

**Use cases:**
- Task scheduling with dependencies
- Build systems
- Course prerequisites
- Package dependency resolution

---

### Connected Components

```dart
final graph = Graph<int>();

// Component 1
graph.addEdge(1, 2);
graph.addEdge(2, 3);

// Component 2 (disconnected)
graph.addEdge(4, 5);

// Component 3 (isolated vertex)
graph.addVertex(6);

print(graph.isConnected); // false

final components = graph.connectedComponents();
print(components.length); // 3
// [[1, 2, 3], [4, 5], [6]]
```

---

### Graph Utilities

```dart
// Clear the graph
graph.clear();

// Remove elements
graph.removeVertex('A'); // removes vertex and all its edges
graph.removeEdge('B', 'C');

// Create from edge list
final g = Graph<int>.fromEdges([
  (1, 2),
  (2, 3),
  (3, 4),
], directed: false);

// Visualize
print(graph.toDot()); // GraphViz DOT format
```

---

### AdjacencyMatrixGraph

A graph implementation using an adjacency matrix representation. Better suited for dense graphs where most vertices are connected.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Add Vertex | O(V²) |
| Add Edge | O(1) |
| Remove Vertex | O(V²) |
| Remove Edge | O(1) |
| Get Neighbors | O(V) |
| Has Edge | O(1) |
| Space | O(V²) |

**Features:**
- O(1) edge lookup and modification
- Efficient for dense graphs
- Directed or undirected edges
- Weighted edges support
- Matrix-based operations

**Basic Usage:**
```dart
// Create with initial capacity
final graph = AdjacencyMatrixGraph<String>(initialCapacity: 10);

// Add vertices
graph.addVertex('A');
graph.addVertex('B');
graph.addVertex('C');

// Add edges
graph.addEdge('A', 'B');
graph.addEdge('B', 'C', weight: 5);

// O(1) edge check
print(graph.hasEdge('A', 'B')); // true
print(graph.hasEdge('B', 'A')); // true (undirected)

// Get edge weight
print(graph.getWeight('B', 'C')); // 5.0

// Neighbors (requires O(V) scan)
print(graph.neighbors('A')); // [B]
```

**Directed Graph:**
```dart
final digraph = AdjacencyMatrixGraph<int>(directed: true);

digraph.addVertex(1);
digraph.addVertex(2);
digraph.addVertex(3);

digraph.addEdge(1, 2);
digraph.addEdge(2, 3);

print(digraph.hasEdge(1, 2)); // true
print(digraph.hasEdge(2, 1)); // false
```

**Matrix Operations:**
```dart
// Get the raw adjacency matrix
final matrix = graph.getMatrix();

// Check matrix value directly
final weight = matrix[graph.indexOf('A')][graph.indexOf('B')];

// Density calculation
print(graph.density); // ratio of edges to possible edges
```

**Comparison: Adjacency List vs Adjacency Matrix:**
| Aspect | Adjacency List | Adjacency Matrix |
|--------|----------------|------------------|
| Space | O(V + E) | O(V²) |
| Add Edge | O(1) | O(1) |
| Remove Edge | O(E) | O(1) |
| Has Edge | O(degree) | O(1) |
| Get Neighbors | O(1) | O(V) |
| Best for | Sparse graphs | Dense graphs |
| Memory efficient | Yes | No |

**Use cases:**
- Dense graphs (E ≈ V²)
- Frequent edge existence checks
- Matrix-based graph algorithms
- Small graphs where O(V²) space is acceptable
- Floyd-Warshall algorithm implementation

---

### FlowNetwork

A specialized directed graph for solving maximum flow and minimum cut problems using Ford-Fulkerson method with Edmonds-Karp (BFS) implementation.

**Time Complexity:**
| Operation | Complexity |
|-----------|------------|
| Add Vertex | O(1) |
| Add Edge | O(1) |
| Max Flow (Edmonds-Karp) | O(V × E²) |
| Min Cut | O(V × E²) |
| Get Residual Graph | O(V + E) |

**Key Concepts:**
- **Capacity**: Maximum flow an edge can carry
- **Flow**: Current flow through an edge
- **Residual Capacity**: Remaining capacity (capacity - flow)
- **Augmenting Path**: Path from source to sink with available capacity
- **Residual Graph**: Graph showing remaining capacities
- **Min Cut**: Minimum capacity edges to disconnect source from sink

**Basic Usage:**
```dart
final network = FlowNetwork<String>();

// Add vertices
network.addVertex('S'); // source
network.addVertex('A');
network.addVertex('B');
network.addVertex('T'); // sink

// Add edges with capacities
network.addEdge('S', 'A', capacity: 10);
network.addEdge('S', 'B', capacity: 5);
network.addEdge('A', 'B', capacity: 15);
network.addEdge('A', 'T', capacity: 10);
network.addEdge('B', 'T', capacity: 10);

// Calculate maximum flow
final maxFlow = network.maxFlow('S', 'T');
print(maxFlow); // 15

// Get flow on specific edge
print(network.getFlow('S', 'A')); // flow value
print(network.getResidualCapacity('S', 'A')); // remaining capacity
```

**Ford-Fulkerson with Edmonds-Karp:**
```dart
final network = FlowNetwork<int>();

// Build network
network.addEdge(0, 1, capacity: 16);
network.addEdge(0, 2, capacity: 13);
network.addEdge(1, 2, capacity: 10);
network.addEdge(1, 3, capacity: 12);
network.addEdge(2, 1, capacity: 4);
network.addEdge(2, 4, capacity: 14);
network.addEdge(3, 2, capacity: 9);
network.addEdge(3, 5, capacity: 20);
network.addEdge(4, 3, capacity: 7);
network.addEdge(4, 5, capacity: 4);

// Compute max flow from source (0) to sink (5)
final result = network.maxFlow(0, 5);
print('Maximum flow: $result'); // 23

// Get the residual graph after max flow
final residual = network.getResidualGraph();
```

**Minimum Cut:**
```dart
// Find minimum cut (edges that, if removed, disconnect source from sink)
final minCut = network.minCut('S', 'T');

for (final edge in minCut) {
  print('Cut edge: ${edge.from} -> ${edge.to}, capacity: ${edge.capacity}');
}

// Total capacity of min cut equals max flow
final cutCapacity = minCut.fold(0.0, (sum, e) => sum + e.capacity);
print(cutCapacity == maxFlow); // true (Max-flow Min-cut theorem)
```

**Flow Analysis:**
```dart
// Check if network has valid flow
print(network.isValidFlow());

// Get all edges with their current flow
for (final edge in network.edges) {
  print('${edge.from} -> ${edge.to}: ${edge.flow}/${edge.capacity}');
}

// Reset flow to compute again with different source/sink
network.resetFlow();
```

**Use cases:**
- Network bandwidth optimization
- Bipartite matching
- Airline scheduling
- Project selection
- Image segmentation
- Baseball elimination problem
- Circulation with demands

---

<a name="español"></a>
## 🇪🇸 Español

Estructuras de datos no lineales que representan relaciones entre entidades. Los grafos consisten en vértices (nodos) conectados por aristas.

### Graph (Grafo)

Una implementación flexible de grafos que soporta grafos dirigidos/no dirigidos y ponderados/no ponderados usando representación de lista de adyacencia.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Agregar Vértice | O(1) |
| Agregar Arista | O(1) |
| Eliminar Vértice | O(V + E) |
| Eliminar Arista | O(E) |
| Obtener Vecinos | O(1) |
| BFS/DFS | O(V + E) |
| Tiene Arista | O(vecinos) |

**Características:**
- Aristas dirigidas o no dirigidas
- Aristas ponderadas con pesos personalizables
- Búsqueda en Anchura (BFS)
- Búsqueda en Profundidad (DFS)
- Detección de ciclos
- Ordenamiento topológico (para DAGs)
- Búsqueda de caminos
- Detección de componentes conexos

**Uso Básico:**
```dart
// Grafo no dirigido (por defecto)
final grafo = Graph<String>();

// Agregar vértices
grafo.addVertex('A');
grafo.addVertex('B');
grafo.addVertex('C');
grafo.addVertex('D');

// Agregar aristas (crea vértices si no existen)
grafo.addEdge('A', 'B');
grafo.addEdge('B', 'C');
grafo.addEdge('C', 'D');
grafo.addEdge('A', 'D');

// Consultar el grafo
print(grafo.hasVertex('A'));     // true
print(grafo.hasEdge('A', 'B'));  // true
print(grafo.neighbors('A'));     // [B, D]
print(grafo.degree('A'));        // 2

// Propiedades
print(grafo.vertexCount); // 4
print(grafo.edgeCount);   // 4
print(grafo.vertices);    // [A, B, C, D]
print(grafo.edges);       // lista de todas las aristas
```

**Grafo Dirigido:**
```dart
final digrafo = Graph<String>(directed: true);

digrafo.addEdge('A', 'B'); // A → B
digrafo.addEdge('B', 'C'); // B → C
digrafo.addEdge('A', 'C'); // A → C

print(digrafo.hasEdge('A', 'B')); // true
print(digrafo.hasEdge('B', 'A')); // false (¡dirigido!)

print(digrafo.inDegree('C'));  // 2 (aristas entrantes)
print(digrafo.outDegree('A')); // 2 (aristas salientes)
```

**Grafo Ponderado:**
```dart
final ponderado = Graph<String>();

ponderado.addEdge('A', 'B', weight: 4);
ponderado.addEdge('B', 'C', weight: 3);
ponderado.addEdge('A', 'C', weight: 10);

final arista = ponderado.getEdge('A', 'B');
print(arista?.weight); // 4.0

// Actualizar peso
ponderado.updateEdgeWeight('A', 'C', 5);
```

---

### Recorridos del Grafo

#### BFS (Búsqueda en Anchura)

Explora vecinos antes de profundizar. Útil para encontrar caminos más cortos en grafos no ponderados.

```dart
final grafo = Graph<int>();
grafo.addEdge(1, 2);
grafo.addEdge(1, 3);
grafo.addEdge(2, 4);
grafo.addEdge(2, 5);
grafo.addEdge(3, 6);

// Recorrido BFS
final orden = grafo.bfs(1);
print(orden); // [1, 2, 3, 4, 5, 6]

// BFS con callback
grafo.bfsWithCallback(1, (vertice) {
  print('Visitando: $vertice');
  return true; // continuar recorrido
});

// Detener temprano al encontrar objetivo
grafo.bfsWithCallback(1, (vertice) {
  if (vertice == 4) {
    print('¡Encontrado 4!');
    return false; // detener recorrido
  }
  return true;
});

// Obtener árbol de expansión BFS
final arbol = grafo.bfsTree(1);
// Retorna mapa de vértice → padre
// Útil para reconstruir caminos
```

#### DFS (Búsqueda en Profundidad)

Explora lo más profundo posible antes de retroceder. Útil para ordenamiento topológico, detección de ciclos y búsqueda de caminos.

```dart
// Recorrido DFS
final orden = grafo.dfs(1);
print(orden); // [1, 2, 4, 5, 3, 6]

// DFS iterativo (usa pila explícita)
final ordenIter = grafo.dfsIterative(1);

// DFS con callback
grafo.dfsWithCallback(1, (vertice) {
  print('Visitando: $vertice');
  return true;
});

// Obtener árbol de expansión DFS
final arbol = grafo.dfsTree(1);
```

---

### Búsqueda de Caminos

```dart
final grafo = Graph<String>();
grafo.addEdge('A', 'B');
grafo.addEdge('B', 'C');
grafo.addEdge('C', 'D');
grafo.addEdge('A', 'D'); // atajo

// Encontrar cualquier camino (BFS - más corto en no ponderado)
final camino = grafo.findPath('A', 'D');
print(camino); // [A, D] - camino más corto

// Verificar si existe camino
print(grafo.hasPath('A', 'D')); // true
print(grafo.hasPath('D', 'A')); // true (no dirigido)

// Todos los caminos entre vértices
final todosCaminos = grafo.findAllPaths('A', 'D');
for (final c in todosCaminos) {
  print(c); // [A, D], [A, B, C, D]
}
```

---

### Detección de Ciclos

```dart
final grafo = Graph<int>(directed: true);
grafo.addEdge(1, 2);
grafo.addEdge(2, 3);
grafo.addEdge(3, 1); // crea ciclo

print(grafo.hasCycle); // true

// También funciona para grafos no dirigidos
final noDirigido = Graph<int>();
noDirigido.addEdge(1, 2);
noDirigido.addEdge(2, 3);
noDirigido.addEdge(3, 1);
print(noDirigido.hasCycle); // true
```

---

### Ordenamiento Topológico

Ordena los vértices de manera que para cada arista (u, v), u viene antes que v. Solo funciona en Grafos Acíclicos Dirigidos (DAGs).

```dart
final dag = Graph<String>(directed: true);

// Orden de construcción: A antes de B, B antes de D, etc.
dag.addEdge('A', 'B');
dag.addEdge('A', 'C');
dag.addEdge('B', 'D');
dag.addEdge('C', 'D');
dag.addEdge('D', 'E');

final ordenado = dag.topologicalSort();
print(ordenado); // [A, C, B, D, E] o [A, B, C, D, E]
// Cualquier ordenamiento válido donde las dependencias vienen primero

// Retorna null si el grafo tiene ciclos
final ciclico = Graph<int>(directed: true);
ciclico.addEdge(1, 2);
ciclico.addEdge(2, 1);
print(ciclico.topologicalSort()); // null
```

**Casos de uso:**
- Programación de tareas con dependencias
- Sistemas de compilación
- Prerrequisitos de cursos
- Resolución de dependencias de paquetes

---

### Componentes Conexos

```dart
final grafo = Graph<int>();

// Componente 1
grafo.addEdge(1, 2);
grafo.addEdge(2, 3);

// Componente 2 (desconectado)
grafo.addEdge(4, 5);

// Componente 3 (vértice aislado)
grafo.addVertex(6);

print(grafo.isConnected); // false

final componentes = grafo.connectedComponents();
print(componentes.length); // 3
// [[1, 2, 3], [4, 5], [6]]
```

---

### Utilidades del Grafo

```dart
// Limpiar el grafo
grafo.clear();

// Eliminar elementos
grafo.removeVertex('A'); // elimina vértice y todas sus aristas
grafo.removeEdge('B', 'C');

// Crear desde lista de aristas
final g = Graph<int>.fromEdges([
  (1, 2),
  (2, 3),
  (3, 4),
], directed: false);

// Visualizar
print(grafo.toDot()); // formato GraphViz DOT
```

---

### AdjacencyMatrixGraph (Grafo con Matriz de Adyacencia)

Una implementación de grafo usando representación de matriz de adyacencia. Más adecuada para grafos densos donde la mayoría de los vértices están conectados.

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Agregar Vértice | O(V²) |
| Agregar Arista | O(1) |
| Eliminar Vértice | O(V²) |
| Eliminar Arista | O(1) |
| Obtener Vecinos | O(V) |
| Tiene Arista | O(1) |
| Espacio | O(V²) |

**Características:**
- Consulta y modificación de aristas en O(1)
- Eficiente para grafos densos
- Aristas dirigidas o no dirigidas
- Soporte para aristas ponderadas
- Operaciones basadas en matrices

**Uso Básico:**
```dart
// Crear con capacidad inicial
final grafo = AdjacencyMatrixGraph<String>(initialCapacity: 10);

// Agregar vértices
grafo.addVertex('A');
grafo.addVertex('B');
grafo.addVertex('C');

// Agregar aristas
grafo.addEdge('A', 'B');
grafo.addEdge('B', 'C', weight: 5);

// Verificación de arista en O(1)
print(grafo.hasEdge('A', 'B')); // true
print(grafo.hasEdge('B', 'A')); // true (no dirigido)

// Obtener peso de arista
print(grafo.getWeight('B', 'C')); // 5.0

// Vecinos (requiere escaneo O(V))
print(grafo.neighbors('A')); // [B]
```

**Grafo Dirigido:**
```dart
final digrafo = AdjacencyMatrixGraph<int>(directed: true);

digrafo.addVertex(1);
digrafo.addVertex(2);
digrafo.addVertex(3);

digrafo.addEdge(1, 2);
digrafo.addEdge(2, 3);

print(digrafo.hasEdge(1, 2)); // true
print(digrafo.hasEdge(2, 1)); // false
```

**Operaciones de Matriz:**
```dart
// Obtener la matriz de adyacencia
final matriz = grafo.getMatrix();

// Verificar valor de matriz directamente
final peso = matriz[grafo.indexOf('A')][grafo.indexOf('B')];

// Cálculo de densidad
print(grafo.density); // proporción de aristas sobre posibles aristas
```

**Comparación: Lista de Adyacencia vs Matriz de Adyacencia:**
| Aspecto | Lista de Adyacencia | Matriz de Adyacencia |
|---------|---------------------|----------------------|
| Espacio | O(V + E) | O(V²) |
| Agregar Arista | O(1) | O(1) |
| Eliminar Arista | O(E) | O(1) |
| Tiene Arista | O(grado) | O(1) |
| Obtener Vecinos | O(1) | O(V) |
| Mejor para | Grafos dispersos | Grafos densos |
| Eficiente en memoria | Sí | No |

**Casos de uso:**
- Grafos densos (E ≈ V²)
- Verificaciones frecuentes de existencia de aristas
- Algoritmos de grafos basados en matrices
- Grafos pequeños donde el espacio O(V²) es aceptable
- Implementación del algoritmo Floyd-Warshall

---

### FlowNetwork (Red de Flujo)

Un grafo dirigido especializado para resolver problemas de flujo máximo y corte mínimo usando el método Ford-Fulkerson con implementación Edmonds-Karp (BFS).

**Complejidad Temporal:**
| Operación | Complejidad |
|-----------|-------------|
| Agregar Vértice | O(1) |
| Agregar Arista | O(1) |
| Flujo Máximo (Edmonds-Karp) | O(V × E²) |
| Corte Mínimo | O(V × E²) |
| Obtener Grafo Residual | O(V + E) |

**Conceptos Clave:**
- **Capacidad**: Flujo máximo que una arista puede transportar
- **Flujo**: Flujo actual a través de una arista
- **Capacidad Residual**: Capacidad restante (capacidad - flujo)
- **Camino Aumentante**: Camino de fuente a sumidero con capacidad disponible
- **Grafo Residual**: Grafo que muestra las capacidades restantes
- **Corte Mínimo**: Aristas de capacidad mínima para desconectar fuente del sumidero

**Uso Básico:**
```dart
final red = FlowNetwork<String>();

// Agregar vértices
red.addVertex('S'); // fuente
red.addVertex('A');
red.addVertex('B');
red.addVertex('T'); // sumidero

// Agregar aristas con capacidades
red.addEdge('S', 'A', capacity: 10);
red.addEdge('S', 'B', capacity: 5);
red.addEdge('A', 'B', capacity: 15);
red.addEdge('A', 'T', capacity: 10);
red.addEdge('B', 'T', capacity: 10);

// Calcular flujo máximo
final flujoMax = red.maxFlow('S', 'T');
print(flujoMax); // 15

// Obtener flujo en arista específica
print(red.getFlow('S', 'A')); // valor del flujo
print(red.getResidualCapacity('S', 'A')); // capacidad restante
```

**Ford-Fulkerson con Edmonds-Karp:**
```dart
final red = FlowNetwork<int>();

// Construir red
red.addEdge(0, 1, capacity: 16);
red.addEdge(0, 2, capacity: 13);
red.addEdge(1, 2, capacity: 10);
red.addEdge(1, 3, capacity: 12);
red.addEdge(2, 1, capacity: 4);
red.addEdge(2, 4, capacity: 14);
red.addEdge(3, 2, capacity: 9);
red.addEdge(3, 5, capacity: 20);
red.addEdge(4, 3, capacity: 7);
red.addEdge(4, 5, capacity: 4);

// Calcular flujo máximo de fuente (0) a sumidero (5)
final resultado = red.maxFlow(0, 5);
print('Flujo máximo: $resultado'); // 23

// Obtener el grafo residual después del flujo máximo
final residual = red.getResidualGraph();
```

**Corte Mínimo:**
```dart
// Encontrar corte mínimo (aristas que, si se eliminan, desconectan fuente del sumidero)
final corteMin = red.minCut('S', 'T');

for (final arista in corteMin) {
  print('Arista cortada: ${arista.from} -> ${arista.to}, capacidad: ${arista.capacity}');
}

// La capacidad total del corte mínimo es igual al flujo máximo
final capacidadCorte = corteMin.fold(0.0, (suma, e) => suma + e.capacity);
print(capacidadCorte == flujoMax); // true (Teorema Max-flow Min-cut)
```

**Análisis de Flujo:**
```dart
// Verificar si la red tiene flujo válido
print(red.isValidFlow());

// Obtener todas las aristas con su flujo actual
for (final arista in red.edges) {
  print('${arista.from} -> ${arista.to}: ${arista.flow}/${arista.capacity}');
}

// Reiniciar flujo para calcular de nuevo con diferente fuente/sumidero
red.resetFlow();
```

**Casos de uso:**
- Optimización de ancho de banda de red
- Emparejamiento bipartito
- Programación de aerolíneas
- Selección de proyectos
- Segmentación de imágenes
- Problema de eliminación de béisbol
- Circulación con demandas
