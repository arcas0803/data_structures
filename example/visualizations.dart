/// Visual representations of all data structures
/// Run with: dart run example/visualizations.dart
library;

import 'package:data_structures/data_structures.dart';

/// ANSI color codes
class C {
  static const reset = '\x1B[0m';
  static const bold = '\x1B[1m';
  static const dim = '\x1B[2m';
  static const red = '\x1B[31m';
  static const green = '\x1B[32m';
  static const yellow = '\x1B[33m';
  static const blue = '\x1B[34m';
  static const magenta = '\x1B[35m';
  static const cyan = '\x1B[36m';
}

void printTitle(String title) {
  print('');
  print('${C.bold}${C.magenta}╔${'═' * (title.length + 2)}╗${C.reset}');
  print('${C.bold}${C.magenta}║ $title ║${C.reset}');
  print('${C.bold}${C.magenta}╚${'═' * (title.length + 2)}╝${C.reset}');
  print('');
}

void printSection(String title) {
  print('');
  print('${C.bold}${C.cyan}━━━ $title ━━━${C.reset}');
}

void main() {
  print('${C.bold}${C.green}');
  print(r'''
   ____        _          ____  _                   _                       
  |  _ \  __ _| |_ __ _  / ___|| |_ _ __ _   _  ___| |_ _   _ _ __ ___  ___ 
  | | | |/ _` | __/ _` | \___ \| __| '__| | | |/ __| __| | | | '__/ _ \/ __|
  | |_| | (_| | || (_| |  ___) | |_| |  | |_| | (__| |_| |_| | | |  __/\__ \
  |____/ \__,_|\__\__,_| |____/ \__|_|   \__,_|\___|\__|\__,_|_|  \___||___/
                                                                            
               ╦  ╦┬┌─┐┬ ┬┌─┐┬  ┬┌─┐┌─┐┌┬┐┬┌─┐┌┐┌┌─┐
               ╚╗╔╝│└─┐│ │├─┤│  │┌─┘├─┤ │ ││ ││││└─┐
                ╚╝ ┴└─┘└─┘┴ ┴┴─┘┴└─┘┴ ┴ ┴ ┴└─┘┘└┘└─┘
  ''');
  print(C.reset);

  // ================================================================
  // LINKED LISTS
  // ================================================================
  printTitle('LINKED LISTS');

  printSection('Singly Linked List');
  final linkedList = LinkedList<int>();
  [10, 20, 30, 40, 50].forEach(linkedList.add);
  print('Adding: 10 → 20 → 30 → 40 → 50');
  print('');
  print('  ┌────┐    ┌────┐    ┌────┐    ┌────┐    ┌────┐');
  print('  │ ${_fmt(10)} │───▶│ ${_fmt(20)} │───▶│ ${_fmt(30)} │───▶│ ${_fmt(40)} │───▶│ ${_fmt(50)} │───▶ null');
  print('  └────┘    └────┘    └────┘    └────┘    └────┘');
  print('    ▲');
  print('   head');

  printSection('Doubly Linked List');
  final doublyList = DoublyLinkedList<String>();
  ['A', 'B', 'C', 'D'].forEach(doublyList.add);
  print('Adding: A ↔ B ↔ C ↔ D');
  print('');
  print('         ┌───┐    ┌───┐    ┌───┐    ┌───┐');
  print('  null◀──│ A │◀══▶│ B │◀══▶│ C │◀══▶│ D │──▶null');
  print('         └───┘    └───┘    └───┘    └───┘');
  print('           ▲                          ▲');
  print('         head                        tail');

  printSection('Circular Linked List');
  final circularList = CircularLinkedList<int>();
  [1, 2, 3, 4].forEach(circularList.add);
  print('Adding: 1 → 2 → 3 → 4 → (back to 1)');
  print('');
  print('              ┌───────────────────────┐');
  print('              ▼                       │');
  print('           ┌───┐    ┌───┐    ┌───┐    ┌───┐');
  print('           │ 1 │───▶│ 2 │───▶│ 3 │───▶│ 4 │');
  print('           └───┘    └───┘    └───┘    └───┘');
  print('             ▲');
  print('           head');

  printSection('Circular Doubly Linked List');
  print('Adding: W ↔ X ↔ Y ↔ Z ↔ (circular)');
  print('');
  print('           ┌──────────────────────────────────┐');
  print('           │    ┌───┐    ┌───┐    ┌───┐    ┌───┐    │');
  print('           └──▶│ W │◀══▶│ X │◀══▶│ Y │◀══▶│ Z │◀──┘');
  print('                └───┘    └───┘    └───┘    └───┘');
  print('                  ▲');
  print('                head');

  // ================================================================
  // STACK AND QUEUE
  // ================================================================
  printTitle('STACK AND QUEUE');

  printSection('Stack (LIFO)');
  print('Operations: push(A), push(B), push(C), pop()');
  print('');
  print('    push(A)     push(B)     push(C)      pop()');
  print('   ┌─────┐     ┌─────┐     ┌─────┐     ┌─────┐');
  print('   │     │     │     │     │  C  │ ◀── │     │  → returns C');
  print('   │     │     │  B  │     │  B  │     │  B  │');
  print('   │  A  │     │  A  │     │  A  │     │  A  │');
  print('   └─────┘     └─────┘     └─────┘     └─────┘');
  print('    TOP↑        TOP↑        TOP↑        TOP↑');

  printSection('Queue (FIFO)');
  print('Operations: enqueue(1), enqueue(2), enqueue(3), dequeue()');
  print('');
  print('  enqueue(1)   enqueue(2)   enqueue(3)    dequeue()');
  print('  ┌───┐        ┌───┬───┐    ┌───┬───┬───┐ ┌───┬───┐');
  print('  │ 1 │        │ 1 │ 2 │    │ 1 │ 2 │ 3 │ │ 2 │ 3 │  → returns 1');
  print('  └───┘        └───┴───┘    └───┴───┴───┘ └───┴───┘');
  print('    ▲            ▲              ▲   ▲         ▲   ▲');
  print('  front        front          front rear    front rear');

  printSection('Deque (Double-Ended Queue)');
  print('Can add/remove from both ends!');
  print('');
  print('       addFirst(A)  addLast(B)  addFirst(C)  removeLast()');
  print('         ┌───┐       ┌───┬───┐   ┌───┬───┬───┐  ┌───┬───┐');
  print('         │ A │       │ A │ B │   │ C │ A │ B │  │ C │ A │ → B');
  print('         └───┘       └───┴───┘   └───┴───┴───┘  └───┴───┘');

  // ================================================================
  // SKIP LIST
  // ================================================================
  printTitle('SKIP LIST');

  printSection('Skip List Structure');
  print('A probabilistic data structure with multiple levels for O(log n) search');
  print('');
  print('Level 3:  ╔═══╗─────────────────────────────────────────▶╔═══╗');
  print('          ║ H ║                                          ║ ∞ ║');
  print('          ╚═╤═╝                                          ╚═╤═╝');
  print('            │                                              │');
  print('Level 2:  ╔═╧═╗───────────────▶╔═══╗─────────────────────▶╔═╧═╗');
  print('          ║ H ║                ║ 5 ║                      ║ ∞ ║');
  print('          ╚═╤═╝                ╚═╤═╝                      ╚═╤═╝');
  print('            │                    │                          │');
  print('Level 1:  ╔═╧═╗───────▶╔═══╗───▶╔═╧═╗───────▶╔═══╗───────▶╔═╧═╗');
  print('          ║ H ║        ║ 3 ║    ║ 5 ║        ║ 8 ║        ║ ∞ ║');
  print('          ╚═╤═╝        ╚═╤═╝    ╚═╤═╝        ╚═╤═╝        ╚═╤═╝');
  print('            │            │        │            │            │');
  print('Level 0:  ╔═╧═╗──▶╔═══╗─▶╔═╧═╗──▶╔═╧═╗──▶╔═══╗─▶╔═╧═╗──▶╔═══╗─▶╔═╧═╗');
  print('          ║ H ║   ║ 1 ║  ║ 3 ║   ║ 5 ║   ║ 6 ║  ║ 8 ║   ║ 9 ║  ║ ∞ ║');
  print('          ╚═══╝   ╚═══╝  ╚═══╝   ╚═══╝   ╚═══╝  ╚═══╝   ╚═══╝  ╚═══╝');
  print('');
  print('  H = Head sentinel, ∞ = Tail sentinel');
  print('  Search for 6: Start at Level 3, drop down when needed');

  // ================================================================
  // HASH TABLE
  // ================================================================
  printTitle('HASH TABLE');

  printSection('Hash Table with Chaining');
  print('Resolving collisions using linked lists');
  print('');
  print('  Index   Buckets (chains)');
  print('  ┌───┐');
  print('  │ 0 │──▶ null');
  print('  ├───┤');
  print('  │ 1 │──▶ [${C.green}"apple"${C.reset}:5] ──▶ [${C.green}"kiwi"${C.reset}:3] ──▶ null');
  print('  ├───┤');
  print('  │ 2 │──▶ [${C.green}"banana"${C.reset}:7] ──▶ null');
  print('  ├───┤');
  print('  │ 3 │──▶ null');
  print('  ├───┤');
  print('  │ 4 │──▶ [${C.green}"orange"${C.reset}:2] ──▶ [${C.green}"grape"${C.reset}:9] ──▶ null');
  print('  └───┘');
  print('');
  print('  hash("apple") % 5 = 1');
  print('  hash("kiwi") % 5 = 1  ← collision, chain it!');

  printSection('Bloom Filter');
  print('Probabilistic set membership with possible false positives');
  print('');
  print('  Bit Array (m=16 bits, k=3 hash functions):');
  print('  ┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐');
  print('  │0│${C.green}1${C.reset}│0│${C.green}1${C.reset}│0│0│${C.green}1${C.reset}│0│${C.green}1${C.reset}│0│0│${C.green}1${C.reset}│0│${C.green}1${C.reset}│0│0│');
  print('  └─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘');
  print('   0 1 2 3 4 5 6 7 8 9 ...');
  print('');
  print('  insert("hello"): h₁=1, h₂=6, h₃=11 → set bits 1,6,11');
  print('  insert("world"): h₁=3, h₂=8, h₃=13 → set bits 3,8,13');
  print('');
  print('  contains("hello")? Check bits 1,6,11 → all 1 → ${C.green}probably yes${C.reset}');
  print('  contains("test")?  Check bits 2,5,9 → some 0 → ${C.red}definitely no${C.reset}');

  // ================================================================
  // UNION FIND
  // ================================================================
  printTitle('UNION FIND (DISJOINT SET)');

  printSection('Union-Find Operations');
  print('Tracking connected components with path compression');
  print('');
  print('  Initial:     After union(1,2):   After union(3,4):');
  print('   1  2  3  4       1                   1       3');
  print('   ○  ○  ○  ○       │                   │       │');
  print('                    2                   2       4');
  print('');
  print('  After union(1,3):              After find(4) with compression:');
  print('        1                               1');
  print('       /│\\                            / | \\');
  print('      2 3                            2  3  4');
  print('        │');
  print('        4');
  print('');
  print('  Path compression flattens the tree!');

  // ================================================================
  // BINARY TREES
  // ================================================================
  printTitle('BINARY TREES');

  printSection('Binary Search Tree');
  final bst = BinarySearchTree<int>();
  [50, 30, 70, 20, 40, 60, 80].forEach(bst.insert);
  print('Inserting: 50, 30, 70, 20, 40, 60, 80');
  print('');
  print('              ┌────┐');
  print('              │ 50 │');
  print('              └──┬─┘');
  print('          ┌──────┴──────┐');
  print('        ┌─┴──┐        ┌─┴──┐');
  print('        │ 30 │        │ 70 │');
  print('        └──┬─┘        └──┬─┘');
  print('       ┌───┴───┐     ┌───┴───┐');
  print('     ┌─┴─┐   ┌─┴─┐ ┌─┴─┐   ┌─┴─┐');
  print('     │20 │   │40 │ │60 │   │80 │');
  print('     └───┘   └───┘ └───┘   └───┘');
  print('');
  print('  In-order:   ${bst.inOrder.toList()}');
  print('  Pre-order:  ${bst.preOrder.toList()}');
  print('  Post-order: ${bst.postOrder.toList()}');

  printSection('AVL Tree (Self-Balancing)');
  print('Inserting 1,2,3,4,5 sequentially:');
  print('');
  print('  BST (unbalanced):          AVL (balanced):');
  print('        1                         2');
  print('         \\                       / \\');
  print('          2                     1   4');
  print('           \\                       / \\');
  print('            3                     3   5');
  print('             \\');
  print('              4                Height: 3');
  print('               \\');
  print('                5');
  print('');
  print('  Height: 5');
  print('');
  print('  ${C.green}AVL maintains O(log n) height through rotations!${C.reset}');

  printSection('AVL Rotations');
  print('');
  print('  ${C.yellow}Right Rotation (LL case):${C.reset}');
  print('       3              2');
  print('      /      ──▶     / \\');
  print('     2              1   3');
  print('    /');
  print('   1');
  print('');
  print('  ${C.yellow}Left-Right Rotation (LR case):${C.reset}');
  print('       3              3             2');
  print('      /      ──▶     /    ──▶      / \\');
  print('     1              2             1   3');
  print('      \\            /');
  print('       2          1');

  // ================================================================
  // N-ARY TREE
  // ================================================================
  printTitle('N-ARY TREE');

  printSection('General Tree (File System Example)');
  print('');
  print('                    ┌──────────┐');
  print('                    │   root   │');
  print('                    └────┬─────┘');
  print('          ┌──────────────┼──────────────┐');
  print('          ▼              ▼              ▼');
  print('     ┌────────┐    ┌────────┐    ┌────────┐');
  print('     │  bin   │    │  home  │    │  etc   │');
  print('     └────────┘    └───┬────┘    └────────┘');
  print('                   ┌───┴───┐');
  print('                   ▼       ▼');
  print('              ┌───────┐ ┌───────┐');
  print('              │ user1 │ │ user2 │');
  print('              └───┬───┘ └───────┘');
  print('              ┌───┴───┐');
  print('              ▼       ▼');
  print('         ┌───────┐ ┌───────┐');
  print('         │  docs │ │ music │');
  print('         └───────┘ └───────┘');

  // ================================================================
  // TRIE
  // ================================================================
  printTitle('TRIE (PREFIX TREE)');

  printSection('Trie Structure');
  final trie = Trie();
  trie.insertAll(['car', 'card', 'care', 'careful', 'cat']);
  print('Words: car, card, care, careful, cat');
  print('');
  print('                     ┌─────┐');
  print('                     │root │');
  print('                     └──┬──┘');
  print('                        │ c');
  print('                     ┌──┴──┐');
  print('                     │  c  │');
  print('                     └──┬──┘');
  print('                        │ a');
  print('                     ┌──┴──┐');
  print('                     │  a  │');
  print('                     └──┬──┘');
  print('                   ┌────┴────┐');
  print('                   │ r       │ t');
  print('                ┌──┴──┐   ┌──┴──┐');
  print('                │ r${C.green}*${C.reset}  │   │ t${C.green}*${C.reset}  │  ← ${C.green}*${C.reset} = end of word');
  print('                └──┬──┘   └─────┘');
  print('              ┌────┴────┐');
  print('              │ d       │ e');
  print('           ┌──┴──┐   ┌──┴──┐');
  print('           │ d${C.green}*${C.reset}  │   │ e${C.green}*${C.reset}  │');
  print('           └─────┘   └──┬──┘');
  print('                        │ f');
  print('                     ┌──┴──┐');
  print('                     │  f  │');
  print('                     └──┬──┘');
  print('                        │ u');
  print('                     ┌──┴──┐');
  print('                     │  u  │');
  print('                     └──┬──┘');
  print('                        │ l');
  print('                     ┌──┴──┐');
  print('                     │ l${C.green}*${C.reset}  │');
  print('                     └─────┘');
  print('');
  print('  Prefix "car" → [${trie.getWordsWithPrefix('car').join(', ')}]');

  // ================================================================
  // HEAP
  // ================================================================
  printTitle('HEAPS');

  printSection('Min-Heap (Array Representation)');
  final heap = Heap<int>.minHeap();
  heap.addAll([3, 1, 4, 1, 5, 9, 2, 6]);
  print('Elements: 3, 1, 4, 1, 5, 9, 2, 6');
  print('');
  print('  Tree view:                 Array: [1, 1, 2, 3, 5, 9, 4, 6]');
  print('                                     0  1  2  3  4  5  6  7');
  print('           1');
  print('         /   \\               Parent of i: (i-1)/2');
  print('        1     2              Left child:  2*i + 1');
  print('       / \\   / \\             Right child: 2*i + 2');
  print('      3   5 9   4');
  print('     /');
  print('    6');
  print('');
  print('  ${C.yellow}Min-heap property: parent ≤ children${C.reset}');

  printSection('Min-Max Heap');
  print('Alternating min and max levels');
  print('');
  print('  Level 0 (min):       ${C.cyan}3${C.reset}');
  print('                      / \\');
  print('  Level 1 (max):    ${C.yellow}91${C.reset}   ${C.yellow}84${C.reset}');
  print('                   /  \\   / \\');
  print('  Level 2 (min): ${C.cyan}12${C.reset}  ${C.cyan}19${C.reset} ${C.cyan}23${C.reset} ${C.cyan}31${C.reset}');
  print('');
  print('  peekMin() = ${C.cyan}3${C.reset}  (root)');
  print('  peekMax() = ${C.yellow}91${C.reset} (max of level 1)');
  print('  Both operations are O(1)!');

  printSection('Fibonacci Heap');
  print('Lazy heap with excellent amortized bounds');
  print('');
  print('  min─▶ ┌───┐   ┌───┐   ┌───┐');
  print('        │ 3 │◀─▶│ 7 │◀─▶│ 2 │◀─┐  ← Circular root list');
  print('        └─┬─┘   └───┘   └─┬─┘  │');
  print('          │               │    │');
  print('          ▼               ▼    │');
  print('        ┌───┐           ┌───┐  │');
  print('        │ 5 │           │ 8 │  │');
  print('        └─┬─┘           └───┘  │');
  print('          │                    │');
  print('          ▼                    │');
  print('        ┌───┐                  │');
  print('        │ 9 │──────────────────┘');
  print('        └───┘');
  print('');
  print('  insert: O(1) - just add to root list');
  print('  decreaseKey: O(1) amortized - cut and add to root list');
  print('  extractMin: O(log n) amortized - consolidate trees');

  // ================================================================
  // B-TREE
  // ================================================================
  printTitle('B-TREE');

  printSection('B-Tree Structure (t=2)');
  print('Each node has between t-1 and 2t-1 keys');
  print('');
  print('                    ┌─────────────┐');
  print('                    │   10 | 20   │');
  print('                    └──────┬──────┘');
  print('              ┌───────────┬┴┬───────────┐');
  print('              ▼           ▼ ▼           ▼');
  print('         ┌────────┐ ┌─────────┐ ┌────────────┐');
  print('         │ 5 | 7  │ │ 12 | 15 │ │ 25 | 30|35 │');
  print('         └────────┘ └─────────┘ └────────────┘');
  print('');
  print('  Properties:');
  print('  • All leaves at same depth');
  print('  • Nodes are sorted');
  print('  • Optimized for disk access (many keys per node)');

  printSection('B+ Tree (Variant)');
  print('All values in leaves, leaves linked for range queries');
  print('');
  print('                    ┌─────────────┐');
  print('                    │   10 | 20   │  ← Internal (only keys)');
  print('                    └──────┬──────┘');
  print('              ┌───────────┬┴┬───────────┐');
  print('              ▼           ▼ ▼           ▼');
  print('         ┌────────┐ ┌─────────┐ ┌────────────┐');
  print('         │5:v|7:v │◀▶│12:v|15:v│◀▶│25:v|30:v  │ ← Leaves (key:value, linked)');
  print('         └────────┘ └─────────┘ └────────────┘');
  print('');
  print('  ${C.green}Range query [12, 25]: scan linked leaves!${C.reset}');

  // ================================================================
  // SEGMENT TREE
  // ================================================================
  printTitle('SEGMENT TREE & FENWICK TREE');

  printSection('Segment Tree (Sum)');
  print('Array: [1, 3, 5, 7, 9, 11]');
  print('');
  print('                     ┌────────┐');
  print('                     │sum=36  │  [0,5]');
  print('                     └───┬────┘');
  print('              ┌──────────┴──────────┐');
  print('          ┌───┴────┐           ┌────┴───┐');
  print('          │sum=9   │ [0,2]     │sum=27  │ [3,5]');
  print('          └───┬────┘           └────┬───┘');
  print('        ┌─────┴─────┐         ┌─────┴─────┐');
  print('     ┌──┴──┐     ┌──┴──┐   ┌──┴──┐     ┌──┴──┐');
  print('     │s=4  │[0,1]│s=5  │[2]│s=16 │[3,4]│s=11 │[5]');
  print('     └──┬──┘     └─────┘   └──┬──┘     └─────┘');
  print('    ┌───┴───┐             ┌───┴───┐');
  print('  ┌─┴─┐   ┌─┴─┐         ┌─┴─┐   ┌─┴─┐');
  print('  │ 1 │   │ 3 │         │ 7 │   │ 9 │');
  print('  └───┘   └───┘         └───┘   └───┘');
  print('  [0]     [1]           [3]     [4]');
  print('');
  print('  query(1, 4) = 3+5+7+9 = 24  → O(log n)');

  printSection('Fenwick Tree (Binary Indexed Tree)');
  print('Space-efficient prefix sums');
  print('');
  print('  Index:    1    2    3    4    5    6    7    8');
  print('  Array:   [3]  [2]  [5]  [1]  [7]  [4]  [2]  [6]');
  print('  BIT:     [3]  [5]  [5]  [11] [7]  [11] [2]  [30]');
  print('');
  print('  BIT[i] stores sum of elements from (i - lowbit(i) + 1) to i');
  print('  lowbit(i) = i & (-i)');
  print('');
  print('  prefixSum(5) = BIT[4] + BIT[5] = 11 + 7 = 18');

  // ================================================================
  // GRAPHS
  // ================================================================
  printTitle('GRAPHS');

  printSection('Adjacency List vs Adjacency Matrix');
  print('');
  print('  Graph:  A ─── B');
  print('          │ \\   │');
  print('          │  \\  │');
  print('          │   \\ │');
  print('          C ─── D');
  print('');
  print('  Adjacency List:              Adjacency Matrix:');
  print('  A → [B, C, D]                   A  B  C  D');
  print('  B → [A, D]                   A  0  1  1  1');
  print('  C → [A, D]                   B  1  0  0  1');
  print('  D → [A, B, C]                C  1  0  0  1');
  print('                               D  1  1  1  0');
  print('');
  print('  List: O(V+E) space, O(degree) edge lookup');
  print('  Matrix: O(V²) space, O(1) edge lookup');

  printSection('Graph Traversals');
  print('');
  print('  Graph:     1 ─── 2');
  print('            /|\\    |');
  print('           / | \\   |');
  print('          3  4  5──6');
  print('');
  print('  BFS from 1: [${C.cyan}1${C.reset}, 2, 3, 4, 5, 6]  ← Level by level');
  print('');
  print('  Level 0:  ${C.cyan}1${C.reset}');
  print('  Level 1:  2, 3, 4, 5');
  print('  Level 2:  6');
  print('');
  print('  DFS from 1: [${C.yellow}1${C.reset}, 2, 6, 5, 3, 4]  ← Go deep first');
  print('');
  print('  Stack: 1→2→6→(backtrack)→5→(backtrack)→3→4');

  printSection('Directed Acyclic Graph (DAG) - Topological Sort');
  print('');
  print('  Task dependencies:');
  print('    A ───▶ B ───▶ D');
  print('    │      │      │');
  print('    │      ▼      ▼');
  print('    └────▶ C ───▶ E');
  print('');
  print('  Topological order: [A, B, C, D, E] or [A, B, D, C, E]');
  print('  ${C.green}Every task appears after its dependencies!${C.reset}');

  printSection('Flow Network - Max Flow');
  print('');
  print('  Capacities:');
  print('       ┌──10──▶ B ──5──┐');
  print('       │        │      ▼');
  print('    S ─┤        3      T');
  print('       │        ▼      ▲');
  print('       └──15──▶ C ──10─┘');
  print('');
  print('  Maximum flow S→T = 15');
  print('');
  print('  Flow assignment:');
  print('       ┌──10/10─▶ B ─5/5─┐');
  print('       │          │      ▼');
  print('    S ─┤         3/3     T');
  print('       │          ▼      ▲');
  print('       └──10/15─▶ C ─10/10');
  print('');
  print('  ${C.cyan}Blue: flow/capacity${C.reset}');

  // ================================================================
  // SUMMARY
  // ================================================================
  print('');
  print('${C.bold}${C.green}');
  print('╔═══════════════════════════════════════════════════════════════════╗');
  print('║                    VISUALIZATIONS COMPLETE                        ║');
  print('╠═══════════════════════════════════════════════════════════════════╣');
  print('║  All data structures illustrated with ASCII art                  ║');
  print('║  Run the examples and benchmarks for more details!               ║');
  print('╚═══════════════════════════════════════════════════════════════════╝');
  print(C.reset);
}

String _fmt(int n) => n.toString().padLeft(2);
