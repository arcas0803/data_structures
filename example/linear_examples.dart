/// Comprehensive examples for Linear Structures
/// Run with: dart run example/linear_examples.dart
library;

import 'package:data_structures/data_structures.dart';

void main() {
  print('═══════════════════════════════════════════════════════════════');
  print('                    LINEAR STRUCTURES EXAMPLES');
  print('═══════════════════════════════════════════════════════════════\n');

  linkedListExamples();
  doublyLinkedListExamples();
  circularLinkedListExamples();
  stackExamples();
  queueExamples();
  dequeExamples();
  skipListExamples();
}

void linkedListExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                      LINKED LIST                           │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final list = LinkedList<int>();

  // Basic operations
  print('--- Basic Operations ---');
  list.add(1);
  list.add(2);
  list.add(3);
  print('After add(1,2,3): $list');

  list.addFirst(0);
  print('After addFirst(0): $list');

  list.addLast(4);
  print('After addLast(4): $list');

  list.insertAt(2, 100);
  print('After insertAt(2, 100): $list');

  // Access operations
  print('\n--- Access Operations ---');
  print('First element: ${list.first}');
  print('Last element: ${list.last}');
  print('Element at index 3: ${list.elementAt(3)}');
  print('Length: ${list.length}');

  // Search operations
  print('\n--- Search Operations ---');
  print('Contains 100? ${list.contains(100)}');
  print('Contains 999? ${list.contains(999)}');
  print('Index of 100: ${list.indexOf(100)}');

  // Remove operations
  print('\n--- Remove Operations ---');
  list.remove(100);
  print('After remove(100): $list');

  list.removeFirst();
  print('After removeFirst(): $list');

  list.removeLast();
  print('After removeLast(): $list');

  list.removeAt(1);
  print('After removeAt(1): $list');

  // Transformation
  print('\n--- Transformations ---');
  list.add(10);
  list.add(20);
  print('List: $list');
  list.reverse();
  print('After reverse(): $list');
  print('As Dart List: ${list.toList()}');

  // Iteration
  print('\n--- Iteration ---');
  print('forEach: ');
  for (final value in list.values) {
    print('  - $value');
  }

  // Factory constructor
  print('\n--- Factory Constructor ---');
  final fromIterable = LinkedList.from([100, 200, 300]);
  print('LinkedList.from([100,200,300]): $fromIterable');

  print('\n');
}

void doublyLinkedListExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                  DOUBLY LINKED LIST                        │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final list = DoublyLinkedList<String>();

  // Basic operations
  print('--- Basic Operations ---');
  list.add('B');
  list.addFirst('A');
  list.addLast('C');
  print('After add(B), addFirst(A), addLast(C): $list');

  // Bidirectional traversal
  print('\n--- Bidirectional Traversal ---');
  list.add('D');
  list.add('E');
  print('Forward: ${list.values.toList()}');
  print('Backward: ${list.valuesReversed.toList()}');

  // Insert after/before
  print('\n--- Insert After/Before ---');
  // Get node at index 2 (C) by traversing
  var currentNode = list.head;
  for (var i = 0; i < 2 && currentNode != null; i++) {
    currentNode = currentNode.next;
  }
  if (currentNode != null) {
    list.insertAfter(currentNode, 'C2');
    print('After insertAfter(C, C2): $list');
    list.insertBefore(currentNode, 'C0');
    print('After insertBefore(C, C0): $list');
  }

  // Access from both ends
  print('\n--- Access from Both Ends ---');
  print('First: ${list.first}');
  print('Last: ${list.last}');
  print('Element at 0: ${list.elementAt(0)}');
  print('Element at ${list.length - 1}: ${list.elementAt(list.length - 1)}');

  // Remove from both ends
  print('\n--- Remove from Both Ends ---');
  print('Current: $list');
  list.removeFirst();
  print('After removeFirst(): $list');
  list.removeLast();
  print('After removeLast(): $list');

  // Optimized access (from closer end)
  print('\n--- Optimized Access ---');
  final bigList = DoublyLinkedList<int>();
  for (var i = 0; i < 10; i++) bigList.add(i);
  print('List: ${bigList.values.toList()}');
  print('elementAt(2) - accessed from head');
  print('elementAt(8) - accessed from tail (closer!)');
  print('Value at 8: ${bigList.elementAt(8)}');

  print('\n');
}

void circularLinkedListExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                  CIRCULAR LINKED LISTS                     │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  // Circular Singly Linked List
  print('--- Circular Singly Linked List ---');
  final circular = CircularLinkedList<int>();
  for (var i = 1; i <= 5; i++) circular.add(i);
  print('Initial: $circular');

  // Rotation
  print('\n--- Rotation ---');
  circular.rotate(1);
  print('After rotate(1): $circular');
  circular.rotate(2);
  print('After rotate(2): $circular');
  circular.rotate(-1);
  print('After rotate(-1): $circular');

  // Real-world use case: Round-robin scheduling
  print('\n--- Use Case: Round-Robin Scheduling ---');
  final tasks = CircularLinkedList<String>();
  for (final task in ['Task A', 'Task B', 'Task C']) {
    tasks.add(task);
  }
  print('Tasks: $tasks');
  for (var i = 0; i < 6; i++) {
    print('Executing: ${tasks.first}');
    tasks.rotate(1);
  }

  // Circular Doubly Linked List
  print('\n--- Circular Doubly Linked List ---');
  final circularDouble = CircularDoublyLinkedList<String>();
  for (final day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']) {
    circularDouble.add(day);
  }
  print('Days: $circularDouble');

  print('\n--- Bidirectional Rotation ---');
  circularDouble.rotateForward(2);
  print('After rotateForward(2): $circularDouble');
  circularDouble.rotateBackward(1);
  print('After rotateBackward(1): $circularDouble');

  // Use case: Media player playlist
  print('\n--- Use Case: Playlist Navigation ---');
  final playlist = CircularDoublyLinkedList<String>();
  for (final song in ['Song 1', 'Song 2', 'Song 3', 'Song 4']) {
    playlist.add(song);
  }
  print('Playlist: $playlist');
  print('Now playing: ${playlist.first}');
  playlist.rotateForward(1);
  print('Next: ${playlist.first}');
  playlist.rotateBackward(2);
  print('Previous x2: ${playlist.first}');

  print('\n');
}

void stackExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                         STACK                              │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final stack = Stack<String>();

  // Basic operations
  print('--- Basic Operations ---');
  stack.push('A');
  stack.push('B');
  stack.push('C');
  print('After push(A,B,C): $stack');
  print('Peek (top): ${stack.peek}');
  print('Pop: ${stack.pop()}');
  print('After pop: $stack');

  // Bulk operations
  print('\n--- Bulk Operations ---');
  for (final item in ['D', 'E', 'F']) {
    stack.push(item);
  }
  print('After pushing D, E, F: $stack');
  final popped = <String>[];
  while (stack.isNotEmpty) {
    popped.add(stack.pop());
  }
  print('Pop all: $popped');
  print('After popAll: $stack');

  // Safe operations
  print('\n--- Safe Operations ---');
  print('tryPeek on empty: ${stack.tryPeek()}');
  print('tryPop on empty: ${stack.tryPop()}');

  // Use case: Balanced parentheses
  print('\n--- Use Case: Balanced Parentheses Check ---');
  bool isBalanced(String expr) {
    final stack = Stack<String>();
    final pairs = {')': '(', ']': '[', '}': '{'};

    for (final char in expr.split('')) {
      if ('([{'.contains(char)) {
        stack.push(char);
      } else if (')]}'.contains(char)) {
        if (stack.isEmpty || stack.pop() != pairs[char]) {
          return false;
        }
      }
    }
    return stack.isEmpty;
  }

  print('"(a+b)*(c+d)" balanced? ${isBalanced("(a+b)*(c+d)")}');
  print('"[(a+b])*(c+d)" balanced? ${isBalanced("[(a+b])*(c+d)")}');
  print('"{[()]}" balanced? ${isBalanced("{[()]}")}');

  // Use case: Undo/Redo
  print('\n--- Use Case: Undo/Redo System ---');
  final undoStack = Stack<String>();
  final redoStack = Stack<String>();

  void doAction(String action) {
    undoStack.push(action);
    redoStack.clear();
    print('Do: $action');
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      final action = undoStack.pop();
      redoStack.push(action);
      print('Undo: $action');
    }
  }

  void redo() {
    if (redoStack.isNotEmpty) {
      final action = redoStack.pop();
      undoStack.push(action);
      print('Redo: $action');
    }
  }

  doAction('Type "Hello"');
  doAction('Type " World"');
  doAction('Delete " World"');
  undo();
  undo();
  redo();

  print('\n');
}

void queueExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                         QUEUE                              │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final queue = Queue<String>();

  // Basic operations
  print('--- Basic Operations ---');
  queue.enqueue('First');
  queue.enqueue('Second');
  queue.enqueue('Third');
  print('After enqueue(First,Second,Third): $queue');
  print('Front: ${queue.front}');
  print('Rear: ${queue.rear}');
  print('Dequeue: ${queue.dequeue()}');
  print('After dequeue: $queue');

  // Bulk operations
  print('\n--- Bulk Operations ---');
  for (final item in ['A', 'B', 'C']) {
    queue.enqueue(item);
  }
  print('After enqueuing A, B, C: $queue');

  // Safe operations
  print('\n--- Safe Operations ---');
  final emptyQueue = Queue<int>();
  print('tryDequeue on empty: ${emptyQueue.tryDequeue()}');
  print('tryPeek on empty: ${emptyQueue.tryPeek()}');

  // Use case: Print job queue
  print('\n--- Use Case: Print Job Queue ---');
  final printQueue = Queue<String>();

  void addPrintJob(String doc) {
    printQueue.enqueue(doc);
    print('Added to queue: $doc');
  }

  void processPrintJobs() {
    while (printQueue.isNotEmpty) {
      final job = printQueue.dequeue();
      print('Printing: $job');
    }
  }

  addPrintJob('Document1.pdf');
  addPrintJob('Report.docx');
  addPrintJob('Image.png');
  print('Queue: $printQueue');
  print('Processing...');
  processPrintJobs();

  // Use case: BFS level tracking
  print('\n--- Use Case: Level Order Traversal ---');
  final levels = Queue<List<int>>();
  levels.enqueue([1]);
  levels.enqueue([2, 3]);
  levels.enqueue([4, 5, 6, 7]);

  var level = 0;
  while (levels.isNotEmpty) {
    print('Level $level: ${levels.dequeue()}');
    level++;
  }

  print('\n');
}

void dequeExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                         DEQUE                              │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final deque = Deque<int>();

  // Add from both ends
  print('--- Add from Both Ends ---');
  deque.addLast(2);
  print('addLast(2): $deque');
  deque.addFirst(1);
  print('addFirst(1): $deque');
  deque.addLast(3);
  print('addLast(3): $deque');
  deque.addFirst(0);
  print('addFirst(0): $deque');

  // Remove from both ends
  print('\n--- Remove from Both Ends ---');
  print('removeFirst: ${deque.removeFirst()}');
  print('After: $deque');
  print('removeLast: ${deque.removeLast()}');
  print('After: $deque');

  // Peek both ends
  print('\n--- Peek Both Ends ---');
  print('peekFirst: ${deque.peekFirst()}');
  print('peekLast: ${deque.peekLast()}');

  // Use case: Sliding window
  print('\n--- Use Case: Sliding Window Maximum ---');
  List<int> maxSlidingWindow(List<int> nums, int k) {
    final result = <int>[];
    final deque = Deque<int>(); // Store indices

    for (var i = 0; i < nums.length; i++) {
      // Remove indices outside window
      while (deque.isNotEmpty && deque.peekFirst()! < i - k + 1) {
        deque.removeFirst();
      }

      // Remove smaller elements
      while (deque.isNotEmpty && nums[deque.peekLast()!] < nums[i]) {
        deque.removeLast();
      }

      deque.addLast(i);

      if (i >= k - 1) {
        result.add(nums[deque.peekFirst()!]);
      }
    }

    return result;
  }

  final nums = [1, 3, -1, -3, 5, 3, 6, 7];
  final k = 3;
  print('Array: $nums, Window size: $k');
  print('Max in each window: ${maxSlidingWindow(nums, k)}');

  // Use case: Palindrome check
  print('\n--- Use Case: Palindrome Check ---');
  bool isPalindrome(String s) {
    final deque = Deque<String>();
    for (final char in s.toLowerCase().split('')) {
      if (RegExp(r'[a-z]').hasMatch(char)) {
        deque.addLast(char);
      }
    }

    while (deque.length > 1) {
      if (deque.removeFirst() != deque.removeLast()) {
        return false;
      }
    }
    return true;
  }

  print('"racecar" is palindrome? ${isPalindrome("racecar")}');
  print(
      '"A man a plan a canal Panama" is palindrome? ${isPalindrome("A man a plan a canal Panama")}');
  print('"hello" is palindrome? ${isPalindrome("hello")}');

  print('\n');
}

void skipListExamples() {
  print('┌─────────────────────────────────────────────────────────────┐');
  print('│                       SKIP LIST                            │');
  print('└─────────────────────────────────────────────────────────────┘\n');

  final skipList = SkipList<int>();

  // Basic operations
  print('--- Basic Operations ---');
  skipList.insert(3);
  skipList.insert(1);
  skipList.insert(4);
  skipList.insert(1);
  skipList.insert(5);
  skipList.insert(9);
  skipList.insert(2);
  skipList.insert(6);
  print('After inserting [3,1,4,1,5,9,2,6]');
  print('Sorted values: ${skipList.toList()}');
  print('Current level: ${skipList.currentLevel}');

  // Search
  print('\n--- Search Operations ---');
  print('Contains 5? ${skipList.contains(5)}');
  print('Contains 7? ${skipList.contains(7)}');
  print('Search for 4: ${skipList.search(4)?.value}');

  // Min/Max
  print('\n--- Min/Max ---');
  print('Min: ${skipList.min}');
  print('Max: ${skipList.max}');

  // Remove
  print('\n--- Remove Operations ---');
  skipList.remove(1);
  print('After remove(1): ${skipList.toList()}');
  skipList.remove(9);
  print('After remove(9): ${skipList.toList()}');

  // Comparison with BST
  print('\n--- Skip List vs BST ---');
  print('Skip List advantages:');
  print('  • Simpler implementation than balanced trees');
  print('  • Lock-free concurrent versions possible');
  print('  • Good cache performance');
  print('  • Probabilistic O(log n) without complex rotations');

  // Large dataset
  print('\n--- Large Dataset Performance ---');
  final largeSkipList = SkipList<int>();
  final stopwatch = Stopwatch()..start();
  for (var i = 0; i < 10000; i++) {
    largeSkipList.insert(i);
  }
  print('Insert 10,000 elements: ${stopwatch.elapsedMilliseconds}ms');

  stopwatch.reset();
  stopwatch.start();
  for (var i = 0; i < 10000; i++) {
    largeSkipList.contains(i);
  }
  print('Search 10,000 elements: ${stopwatch.elapsedMilliseconds}ms');
  print('Final level: ${largeSkipList.currentLevel}');

  print('\n');
}
