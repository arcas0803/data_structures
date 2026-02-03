/// Comprehensive examples for Tree Structures
/// Run with: dart run example/tree_examples.dart
library;

import 'package:data_structures/data_structures.dart';

void main() {
  print('═══════════════════════════════════════════════════════════════');
  print('                     TREE STRUCTURES EXAMPLES');
  print('═══════════════════════════════════════════════════════════════\n');

  bstExamples();
  avlExamples();
  heapExamples();
  priorityQueueExamples();
  naryTreeExamples();
  trieExamples();
  bTreeExamples();
  segmentTreeExamples();
  fibonacciHeapExamples();
  minMaxHeapExamples();
}

void bstExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                 BINARY SEARCH TREE (BST)                   │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final bst = BinarySearchTree<int>();

  // Insertion
  print('--- Building the Tree ---');
  [50, 30, 70, 20, 40, 60, 80, 10, 25, 35, 45].forEach(bst.insert);
  print('Inserted: 50, 30, 70, 20, 40, 60, 80, 10, 25, 35, 45');
  print('');
  print(bst.toTreeString());

  // Traversals
  print('--- Traversals ---');
  print('In-order (sorted):  ${bst.inOrder.toList()}');
  print('Pre-order (root first): ${bst.preOrder.toList()}');
  print('Post-order (root last): ${bst.postOrder.toList()}');
  print('Level-order (BFS): ${bst.levelOrder.toList()}');

  // Search
  print('\n--- Search Operations ---');
  print('Contains 40? ${bst.contains(40)}');
  print('Contains 55? ${bst.contains(55)}');
  print('Search node 40: ${bst.search(40)?.value}');

  // Min/Max
  print('\n--- Min/Max ---');
  print('Minimum: ${bst.min}');
  print('Maximum: ${bst.max}');

  // Predecessor/Successor
  print('\n--- Predecessor/Successor ---');
  print('Predecessor of 50: ${bst.predecessor(50)}');
  print('Successor of 50: ${bst.successor(50)}');
  print('Predecessor of 20: ${bst.predecessor(20)}');
  print('Successor of 80: ${bst.successor(80)}');

  // Range query
  print('\n--- Range Query ---');
  print('Values in range [25, 65]: ${bst.range(25, 65).toList()}');

  // Properties
  print('\n--- Tree Properties ---');
  print('Height: ${bst.height}');
  print('Length: ${bst.length}');
  print('Is balanced: ${bst.isBalanced}');

  // Deletion
  print('\n--- Deletion ---');
  print('Removing 30 (node with two children)...');
  bst.remove(30);
  print('In-order after removal: ${bst.inOrder.toList()}');

  // Use case: Finding kth smallest
  print('\n--- Use Case: Kth Smallest Element ---');
  int? kthSmallest(BinarySearchTree<int> tree, int k) {
    final sorted = tree.inOrder.toList();
    return k <= sorted.length ? sorted[k - 1] : null;
  }

  print('3rd smallest: ${kthSmallest(bst, 3)}');
  print('5th smallest: ${kthSmallest(bst, 5)}');

  print('\n');
}

void avlExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                    AVL TREE (BALANCED)                     │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Compare with BST
  print('--- BST vs AVL: Sequential Insertion ---');
  final bst = BinarySearchTree<int>();
  final avl = AVLTree<int>();

  for (var i = 1; i <= 15; i++) {
    bst.insert(i);
    avl.insert(i);
  }

  print('After inserting 1-15 sequentially:');
  print('BST height: ${bst.height} (degenerate - like a linked list!)');
  print('AVL height: ${avl.height} (balanced!)');
  print('');
  print('AVL Tree structure:');
  print(avl.toTreeString());

  // Validation
  print('--- AVL Validation ---');
  print('Is valid AVL tree: ${avl.isValid}');

  // All BST operations work
  print('\n--- Standard BST Operations ---');
  print('Contains 10: ${avl.contains(10)}');
  print('Min: ${avl.min}');
  print('Max: ${avl.max}');
  print('In-order: ${avl.inOrder.toList()}');

  // Insertion with rebalancing
  print('\n--- Insertion with Rebalancing ---');
  final avl2 = AVLTree<int>();
  print('Inserting values that would cause rotations...');

  // This causes a Left-Left case (Right rotation)
  avl2.insert(30);
  avl2.insert(20);
  avl2.insert(10); // Triggers right rotation
  print('After insert 30,20,10 (LL case - right rotation):');
  print(avl2.toTreeString());

  // This causes a Right-Right case (Left rotation)
  avl2.insert(40);
  avl2.insert(50); // Triggers left rotation
  print('After insert 40,50 (RR case - left rotation):');
  print(avl2.toTreeString());

  // Deletion with rebalancing
  print('\n--- Deletion with Rebalancing ---');
  print('Before deletion:');
  print('Height: ${avl2.height}, Valid: ${avl2.isValid}');
  avl2.remove(10);
  print('After removing 10:');
  print('Height: ${avl2.height}, Valid: ${avl2.isValid}');
  print(avl2.toTreeString());

  // Performance comparison
  print('\n--- Performance Comparison (Worst Case) ---');
  final largeBST = BinarySearchTree<int>();
  final largeAVL = AVLTree<int>();

  final stopwatch = Stopwatch();

  // Insert in order (worst case for BST)
  stopwatch.start();
  for (var i = 0; i < 1000; i++) {
    largeBST.insert(i);
  }
  print(
      'BST insert 1000 sequential: ${stopwatch.elapsedMilliseconds}ms (height: ${largeBST.height})');

  stopwatch.reset();
  stopwatch.start();
  for (var i = 0; i < 1000; i++) {
    largeAVL.insert(i);
  }
  print(
      'AVL insert 1000 sequential: ${stopwatch.elapsedMilliseconds}ms (height: ${largeAVL.height})');

  print('\n');
}

void heapExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                          HEAP                              │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Min-Heap
  print('--- Min-Heap ---');
  final minHeap = Heap<int>.minHeap();
  minHeap.addAll([5, 3, 8, 1, 9, 2, 7, 4, 6]);
  print('Added [5,3,8,1,9,2,7,4,6]');
  print('Peek (minimum): ${minHeap.peek}');
  print('Extract all (sorted ascending): ${minHeap.extractAll()}');

  // Max-Heap
  print('\n--- Max-Heap ---');
  final maxHeap = Heap<int>.maxHeap();
  maxHeap.addAll([5, 3, 8, 1, 9, 2, 7, 4, 6]);
  print('Added same values');
  print('Peek (maximum): ${maxHeap.peek}');
  print('Extract all (sorted descending): ${maxHeap.extractAll()}');

  // Building from array (O(n) heapify)
  print('\n--- Heapify O(n) ---');
  final data = [5, 3, 8, 1, 9, 2, 7, 4, 6];
  final heap = Heap.from(data, type: HeapType.min);
  print('Heap.from($data)');
  print('Valid heap: ${heap.isValid}');

  // Replace operation
  print('\n--- Replace Operation ---');
  heap.addAll([1, 2, 3, 4, 5]);
  print('Heap: ${heap.toSortedList()}');
  final old = heap.replace(10);
  print('Replace root with 10, old root was: $old');
  print('New heap: ${heap.toSortedList()}');

  // Merge heaps
  print('\n--- Merge Heaps ---');
  final heap1 = Heap<int>.minHeap()..addAll([1, 3, 5]);
  final heap2 = Heap<int>.minHeap()..addAll([2, 4, 6]);
  print('Heap1: ${heap1.toSortedList()}');
  print('Heap2: ${heap2.toSortedList()}');
  heap1.merge(heap2);
  print('After merge: ${heap1.toSortedList()}');

  // Use case: Heap Sort
  print('\n--- Use Case: Heap Sort ---');
  List<int> heapSort(List<int> arr) {
    final heap = Heap.from(arr, type: HeapType.min);
    return heap.extractAll();
  }

  final unsorted = [64, 34, 25, 12, 22, 11, 90];
  print('Unsorted: $unsorted');
  print('Sorted:   ${heapSort(unsorted)}');

  // Use case: Find K largest
  print('\n--- Use Case: Find K Largest Elements ---');
  List<int> kLargest(List<int> arr, int k) {
    final minHeap = Heap<int>.minHeap();
    for (final num in arr) {
      minHeap.insert(num);
      if (minHeap.length > k) {
        minHeap.extract();
      }
    }
    return minHeap.extractAll().reversed.toList();
  }

  final numbers = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5];
  print('Array: $numbers');
  print('3 largest: ${kLargest(numbers, 3)}');

  print('\n');
}

void priorityQueueExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                    PRIORITY QUEUE                          │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Min priority (smallest first)
  print('--- Min Priority Queue ---');
  final minPQ = PriorityQueue<int>();
  minPQ.enqueue(5);
  minPQ.enqueue(1);
  minPQ.enqueue(3);
  minPQ.enqueue(2);
  minPQ.enqueue(4);
  print('Enqueued: 5, 1, 3, 2, 4');
  print(
    'Dequeue order: ',
  );
  while (minPQ.isNotEmpty) {
    print('  ${minPQ.dequeue()}');
  }

  // Max priority (largest first)
  print('\n--- Max Priority Queue ---');
  final maxPQ = PriorityQueue<int>.maxPriority();
  maxPQ.enqueue(5);
  maxPQ.enqueue(1);
  maxPQ.enqueue(3);
  print('Enqueued: 5, 1, 3');
  print('Peek: ${maxPQ.peek}');
  print('Dequeue: ${maxPQ.dequeue()}');

  // Use case: Task scheduling by priority
  print('\n--- Use Case: Task Scheduling ---');
  final taskQueue = PriorityQueue<int>();

  print('Adding tasks with priorities (lower = more urgent):');
  final tasks = {'Email': 3, 'Bug fix': 1, 'Meeting': 2, 'Documentation': 4};
  for (final entry in tasks.entries) {
    taskQueue.enqueue(entry.value);
    print('  ${entry.key} (priority ${entry.value})');
  }

  print('\nProcessing order:');
  final priorityToTask = {
    1: 'Bug fix',
    2: 'Meeting',
    3: 'Email',
    4: 'Documentation'
  };
  while (taskQueue.isNotEmpty) {
    final priority = taskQueue.dequeue();
    print('  → ${priorityToTask[priority]}');
  }

  // Use case: Merge K sorted lists
  print('\n--- Use Case: Merge K Sorted Lists ---');
  List<int> mergeKSortedLists(List<List<int>> lists) {
    final result = <int>[];
    final pq = PriorityQueue<int>();

    for (final list in lists) {
      for (final num in list) {
        pq.enqueue(num);
      }
    }

    while (pq.isNotEmpty) {
      result.add(pq.dequeue());
    }
    return result;
  }

  final lists = [
    [1, 4, 5],
    [1, 3, 4],
    [2, 6],
  ];
  print('Lists: $lists');
  print('Merged: ${mergeKSortedLists(lists)}');

  print('\n');
}

void naryTreeExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                      N-ARY TREE                            │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // File system example
  print('--- File System Example ---');
  final fs = NaryTree<String>();
  fs.setRoot('/');
  fs.addChild('/', 'home');
  fs.addChild('/', 'etc');
  fs.addChild('/', 'var');
  fs.addChild('/home', 'user1');
  fs.addChild('/home', 'user2');
  fs.addChild('/home/user1', 'Documents');
  fs.addChild('/home/user1', 'Downloads');
  fs.addChild('/etc', 'config');

  print(fs.toTreeString());

  // Properties
  print('--- Properties ---');
  print('Size: ${fs.size}');
  print('Height: ${fs.height}');

  // Traversals
  print('\n--- Traversals ---');
  print('Pre-order: ${fs.preOrder.toList()}');
  print('Post-order: ${fs.postOrder.toList()}');
  print('Level-order: ${fs.levelOrder.toList()}');

  // Find and contains
  print('\n--- Search ---');
  print('Contains "Documents": ${fs.contains('/home/user1/Documents')}');
  print('Contains "Music": ${fs.contains('/home/user1/Music')}');
  final found = fs.find('/home/user1');
  print('Found user1: ${found?.value}');
  print('User1 children: ${found?.children.map((c) => c.value).toList()}');

  // Organization hierarchy
  print('\n--- Organization Hierarchy Example ---');
  final org = NaryTree<String>();
  org.setRoot('CEO');
  org.addChild('CEO', 'CTO');
  org.addChild('CEO', 'CFO');
  org.addChild('CEO', 'COO');
  org.addChild('CTO', 'Dev Lead');
  org.addChild('CTO', 'QA Lead');
  org.addChild('Dev Lead', 'Developer 1');
  org.addChild('Dev Lead', 'Developer 2');
  org.addChild('CFO', 'Accountant');

  print(org.toTreeString());
  print('Total employees: ${org.size}');

  print('\n');
}

void trieExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                         TRIE                               │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final trie = Trie();

  // Insertion
  print('--- Building Dictionary ---');
  final words = [
    'apple',
    'app',
    'application',
    'apply',
    'banana',
    'band',
    'bandana'
  ];
  trie.insertAll(words);
  print('Words: $words');
  print('Word count: ${trie.wordCount}');
  print('Total nodes: ${trie.size}');

  // Search
  print('\n--- Search Operations ---');
  print('Contains "apple": ${trie.contains('apple')}');
  print('Contains "app": ${trie.contains('app')}');
  print('Contains "appl": ${trie.contains('appl')}'); // Not a complete word

  // Prefix operations
  print('\n--- Prefix Operations ---');
  print('Starts with "app": ${trie.startsWith('app')}');
  print('Starts with "xyz": ${trie.startsWith('xyz')}');
  print('Words with prefix "app": ${trie.getWordsWithPrefix('app')}');
  print('Words with prefix "ban": ${trie.getWordsWithPrefix('ban')}');

  // All words
  print('\n--- All Words ---');
  print('All words (sorted): ${trie.getAllWords()..sort()}');

  // Longest common prefix
  print('\n--- Longest Common Prefix ---');
  final trie2 = Trie();
  trie2.insertAll(['flower', 'flow', 'flight']);
  print('Words: flower, flow, flight');
  print('Longest common prefix: "${trie2.longestCommonPrefix()}"');

  // Remove
  print('\n--- Remove Operations ---');
  print('Before: ${trie.getAllWords()..sort()}');
  trie.remove('app');
  print('After remove("app"): ${trie.getAllWords()..sort()}');
  print('"app" still a prefix? ${trie.startsWith('app')}');
  print('"apple" still exists? ${trie.contains('apple')}');

  // Use case: Autocomplete
  print('\n--- Use Case: Autocomplete ---');
  final autocomplete = Trie();
  autocomplete.insertAll([
    'hello',
    'help',
    'helicopter',
    'hell',
    'hero',
    'hear',
    'heart',
    'heat',
    'heavy'
  ]);

  String getSuggestions(String prefix) {
    final suggestions = autocomplete.getWordsWithPrefix(prefix);
    return suggestions.take(5).join(', ');
  }

  print('Type "he" → ${getSuggestions('he')}');
  print('Type "hel" → ${getSuggestions('hel')}');
  print('Type "help" → ${getSuggestions('help')}');

  // Use case: Spell checker
  print('\n--- Use Case: Simple Spell Checker ---');
  final dictionary = Trie();
  dictionary.insertAll(['the', 'their', 'there', 'they', 'them']);

  bool isValidWord(String word) => dictionary.contains(word.toLowerCase());

  final sentence = ['The', 'cat', 'is', 'there'];
  for (final word in sentence) {
    final valid = isValidWord(word);
    print('  "$word" - ${valid ? '✓' : '✗ (not in dictionary)'}');
  }

  print('\n');
}

void bTreeExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                    B-TREE / B+ TREE                        │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // B-Tree
  print('--- B-Tree (t=2) ---');
  final btree = BTree<int, String>(2);

  // Insert
  print('Inserting key-value pairs...');
  for (var i = 1; i <= 10; i++) {
    btree.insert(i, 'value$i');
  }
  print('Keys: ${btree.keys.toList()}');
  print('Length: ${btree.length}');
  print('Height: ${btree.height}');

  // Search
  print('\n--- Search ---');
  print('Get key 5: ${btree[5]}');
  print('Get key 15: ${btree[15]}');
  print('Contains 7: ${btree.contains(7)}');

  // Traversal
  print('\n--- In-Order Traversal ---');
  print('Key-value pairs:');
  for (final entry in btree.inOrder.take(5)) {
    print('  ${entry.key}: ${entry.value}');
  }
  print('  ...');

  // Remove
  print('\n--- Remove ---');
  btree.remove(5);
  print('After removing 5: ${btree.keys.toList()}');

  // B+ Tree
  print('\n--- B+ Tree (t=2) ---');
  final bplus = BPlusTree<int, String>(2);

  for (var i = 1; i <= 20; i++) {
    bplus.insert(i, 'data$i');
  }
  print('Keys: ${bplus.keys.toList()}');
  print('Height: ${bplus.height}');

  // Range query (B+ tree specialty)
  print('\n--- Range Query (B+ Tree Specialty) ---');
  print('Range [5, 15]:');
  for (final entry in bplus.range(5, 15)) {
    print('  ${entry.key}: ${entry.value}');
  }

  // First/Last
  print('\n--- First/Last Access ---');
  print('First: ${bplus.getFirst()}');
  print('Last: ${bplus.getLast()}');

  // Use case: Database index simulation
  print('\n--- Use Case: Database Index ---');
  final index = BPlusTree<int, Map<String, dynamic>>(3);

  final users = [
    {'id': 1, 'name': 'Alice', 'age': 30},
    {'id': 2, 'name': 'Bob', 'age': 25},
    {'id': 3, 'name': 'Charlie', 'age': 35},
    {'id': 4, 'name': 'Diana', 'age': 28},
    {'id': 5, 'name': 'Eve', 'age': 32},
  ];

  for (final user in users) {
    index.insert(user['id'] as int, user);
  }

  print('Find user with id=3: ${index[3]}');
  print('Users with id between 2 and 4:');
  for (final entry in index.range(2, 4)) {
    print('  ${entry.value}');
  }

  print('\n');
}

void segmentTreeExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│              SEGMENT TREE / FENWICK TREE                   │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Segment Tree for sum
  print('--- Segment Tree (Sum) ---');
  final arr = [1, 3, 5, 7, 9, 11];
  final sumTree = SegmentTree<num>.sum(arr);
  print('Array: $arr');
  print('Query sum [1,4]: ${sumTree.query(1, 4)}'); // 3+5+7+9 = 24
  print('Query sum [0,5]: ${sumTree.query(0, 5)}'); // All = 36

  // Update
  print('\n--- Update ---');
  sumTree.update(2, 10); // Change 5 to 10
  print('After update(2, 10):');
  print('Query sum [1,4]: ${sumTree.query(1, 4)}'); // 3+10+7+9 = 29

  // Segment Tree for min
  print('\n--- Segment Tree (Min) ---');
  final minTree = SegmentTree<num>.min(arr);
  print('Array: $arr');
  print('Query min [0,3]: ${minTree.query(0, 3)}');
  print('Query min [2,5]: ${minTree.query(2, 5)}');

  // Segment Tree for max
  print('\n--- Segment Tree (Max) ---');
  final maxTree = SegmentTree<num>.max(arr);
  print('Query max [0,3]: ${maxTree.query(0, 3)}');
  print('Query max [2,5]: ${maxTree.query(2, 5)}');

  // Fenwick Tree
  print('\n--- Fenwick Tree (Binary Indexed Tree) ---');
  final data = [3, 2, 5, 1, 7, 4, 2, 6];
  final fenwick = FenwickTree(data);
  print('Array: $data');
  print('Prefix sum [0,3]: ${fenwick.prefixSum(3)}'); // 3+2+5+1 = 11
  print('Range sum [2,5]: ${fenwick.rangeSum(2, 5)}'); // 5+1+7+4 = 17

  // Update Fenwick
  print('\n--- Fenwick Update ---');
  fenwick.update(2, 5); // Add 5 to index 2
  print('After update(2, +5):');
  print('Prefix sum [0,3]: ${fenwick.prefixSum(3)}'); // 3+2+10+1 = 16

  // Use case: Range sum with updates
  print('\n--- Use Case: Stock Portfolio Value ---');
  final stockPrices = [100, 150, 200, 175, 225];
  final portfolio = SegmentTree<num>.sum(stockPrices);

  print('Stock prices: $stockPrices');
  print('Total portfolio value: ${portfolio.query(0, 4)}');

  // Stock price changes
  portfolio.update(2, 180); // Stock 2: 200 -> 180
  portfolio.update(4, 250); // Stock 4: 225 -> 250
  print('After price changes: Total = ${portfolio.query(0, 4)}');

  // Use case: Count inversions helper
  print('\n--- Use Case: Counting Frequency ---');
  final freq = FenwickTree(List.filled(10, 0));
  final sequence = [3, 1, 4, 1, 5, 9, 2, 6];

  print('Adding elements: $sequence');
  for (final num in sequence) {
    freq.update(num, 1); // Increment frequency
  }

  print('Count of numbers <= 5: ${freq.prefixSum(5)}');
  print('Count of numbers in [2,6]: ${freq.rangeSum(2, 6)}');

  print('\n');
}

void fibonacciHeapExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                    FIBONACCI HEAP                          │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final fibHeap = FibonacciHeap<int>.minHeap();

  // Insert
  print('--- Insert (O(1) amortized) ---');
  final nodes = <FibonacciHeapNode<int>>[];
  for (final val in [5, 3, 8, 1, 9, 2, 7]) {
    final node = fibHeap.insert(val);
    nodes.add(node);
    print('Inserted $val');
  }
  print('Min: ${fibHeap.peek}');
  print('Size: ${fibHeap.length}');

  // Extract min
  print('\n--- Extract Min (O(log n) amortized) ---');
  print('Extract: ${fibHeap.extractMin()}');
  print('Extract: ${fibHeap.extractMin()}');
  print('New min: ${fibHeap.peek}');

  // Decrease key - the killer feature!
  print('\n--- Decrease Key (O(1) amortized) ---');
  print('This is why Fibonacci Heap excels in Dijkstra\'s algorithm!');

  final heap2 = FibonacciHeap<int>.minHeap();
  heap2.insert(10);
  heap2.insert(20);
  final nodeC = heap2.insert(30);
  heap2.insert(5);

  print('Heap min: ${heap2.peek}');
  print('Decreasing node with value 30 to 1...');
  heap2.decreaseKey(nodeC, 1);
  print('New min: ${heap2.peek}');

  // Merge heaps
  print('\n--- Merge (O(1)) ---');
  final heap3 = FibonacciHeap<int>.minHeap();
  heap3.insert(100);
  heap3.insert(200);

  final heap4 = FibonacciHeap<int>.minHeap();
  heap4.insert(50);
  heap4.insert(150);

  print('Heap3 min: ${heap3.peek}');
  print('Heap4 min: ${heap4.peek}');
  heap3.merge(heap4);
  print('After merge, min: ${heap3.peek}');
  print('Merged size: ${heap3.length}');

  // Use case: Dijkstra's algorithm simulation
  print('\n--- Use Case: Priority Updates (Dijkstra-like) ---');
  final distances = FibonacciHeap<int>.minHeap();
  final vertexNodes = <String, FibonacciHeapNode<int>>{};

  // Initialize distances
  vertexNodes['A'] = distances.insert(0); // Source
  vertexNodes['B'] = distances.insert(1000);
  vertexNodes['C'] = distances.insert(1000);
  vertexNodes['D'] = distances.insert(1000);

  print('Initial: Min distance = ${distances.peek} (source A)');

  // Simulate relaxation
  print('Relaxing edges...');
  distances.decreaseKey(vertexNodes['B']!, 5); // Found path to B with cost 5
  distances.decreaseKey(vertexNodes['C']!, 3); // Found path to C with cost 3
  print('After relaxation: Min = ${distances.peek} (should be 3 for C)');

  distances.extractMin(); // Process C
  distances.decreaseKey(vertexNodes['D']!, 4); // Found path C->D
  print('Next min: ${distances.peek}');

  print('\n');
}

void minMaxHeapExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                     MIN-MAX HEAP                           │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final heap = MinMaxHeap<int>();

  // Insert
  print('--- Insert ---');
  for (final val in [5, 3, 8, 1, 9, 2, 7, 4, 6]) {
    heap.insert(val);
  }
  print('Inserted: 5, 3, 8, 1, 9, 2, 7, 4, 6');
  print('Size: ${heap.length}');

  // Peek both ends - O(1)!
  print('\n--- O(1) Access to Both Extremes ---');
  print('Peek min: ${heap.peekMin()}');
  print('Peek max: ${heap.peekMax()}');

  // Extract from both ends
  print('\n--- Extract from Both Ends ---');
  print('Extract min: ${heap.extractMin()}');
  print('Extract max: ${heap.extractMax()}');
  print('New min: ${heap.peekMin()}, New max: ${heap.peekMax()}');

  // Use case: Sliding window median (simplified)
  print('\n--- Use Case: Track Running Min/Max ---');
  final runningHeap = MinMaxHeap<int>();
  final stream = [10, 5, 15, 3, 12, 8, 20];

  print('Processing stream: $stream');
  for (final val in stream) {
    runningHeap.insert(val);
    print(
        'After $val: min=${runningHeap.peekMin()}, max=${runningHeap.peekMax()}, range=${runningHeap.peekMax() - runningHeap.peekMin()}');
  }

  // Use case: Double-ended priority queue
  print('\n--- Use Case: Double-Ended Priority Queue ---');
  final depq = MinMaxHeap<int>();

  print('Simulating a cache with LRU (min) and MRU (max) eviction options:');
  for (var i = 1; i <= 5; i++) {
    depq.insert(i * 10);
    print('  Added priority ${i * 10}');
  }

  print('Evict lowest priority (LRU): ${depq.extractMin()}');
  print('Evict highest priority (MRU): ${depq.extractMax()}');
  print('Remaining: min=${depq.peekMin()}, max=${depq.peekMax()}');

  print('\n');
}
