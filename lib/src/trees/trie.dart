/// # Trie (Prefix Tree)
///
/// A tree-like data structure for efficient string storage and retrieval.
/// Each node represents a character, and paths from root to marked nodes
/// form complete words.
///
/// Time Complexity:
/// - Insert: O(m) where m is the word length
/// - Search: O(m)
/// - StartsWith: O(m)
/// - Remove: O(m)
/// - GetWordsWithPrefix: O(m + k) where k is total chars in matching words
///
/// Use cases: autocomplete, spell checkers, IP routing, dictionary.
library;

/// Node for the trie structure.
class TrieNode {
  /// Map of child nodes, keyed by character.
  final Map<String, TrieNode> children = {};

  /// Marks if this node represents the end of a complete word.
  bool isEndOfWord = false;

  /// Creates a new trie node.
  TrieNode();

  /// Returns true if this node has no children.
  bool get isLeaf => children.isEmpty;

  /// Returns the number of children.
  int get childCount => children.length;

  @override
  String toString() => 'TrieNode(children: ${children.keys.toList()}, end: $isEndOfWord)';
}

/// A trie (prefix tree) data structure for efficient string operations.
class Trie {
  final TrieNode _root = TrieNode();
  int _wordCount = 0;
  int _nodeCount = 1; // Count root node

  /// Creates an empty trie.
  Trie();

  /// Creates a trie from an iterable of words.
  factory Trie.from(Iterable<String> words) {
    final trie = Trie();
    trie.insertAll(words);
    return trie;
  }

  /// Returns the root node.
  TrieNode get root => _root;

  /// Returns the number of words in the trie.
  int get wordCount => _wordCount;

  /// Returns the total number of nodes in the trie.
  int get size => _nodeCount;

  /// Returns true if the trie contains no words.
  bool get isEmpty => _wordCount == 0;

  /// Returns true if the trie contains at least one word.
  bool get isNotEmpty => _wordCount > 0;

  /// Inserts a word into the trie. O(m)
  /// Returns true if the word was inserted (not a duplicate).
  bool insert(String word) {
    if (word.isEmpty) return false;

    var current = _root;
    for (var i = 0; i < word.length; i++) {
      final char = word[i];
      if (!current.children.containsKey(char)) {
        current.children[char] = TrieNode();
        _nodeCount++;
      }
      current = current.children[char]!;
    }

    if (current.isEndOfWord) {
      return false; // Word already exists
    }

    current.isEndOfWord = true;
    _wordCount++;
    return true;
  }

  /// Inserts all words from an iterable into the trie.
  /// Returns the number of words successfully inserted.
  int insertAll(Iterable<String> words) {
    var count = 0;
    for (final word in words) {
      if (insert(word)) count++;
    }
    return count;
  }

  /// Removes a word from the trie. O(m)
  /// Returns true if the word was found and removed.
  bool remove(String word) {
    if (word.isEmpty) return false;
    return _remove(_root, word, 0);
  }

  bool _remove(TrieNode node, String word, int depth) {
    if (depth == word.length) {
      if (!node.isEndOfWord) {
        return false; // Word doesn't exist
      }
      node.isEndOfWord = false;
      _wordCount--;
      return true;
    }

    final char = word[depth];
    final child = node.children[char];
    if (child == null) {
      return false; // Word doesn't exist
    }

    final removed = _remove(child, word, depth + 1);

    // Clean up unused nodes
    if (removed && !child.isEndOfWord && child.children.isEmpty) {
      node.children.remove(char);
      _nodeCount--;
    }

    return removed;
  }

  /// Removes all words from an iterable from the trie.
  /// Returns the number of words successfully removed.
  int removeAll(Iterable<String> words) {
    var count = 0;
    for (final word in words) {
      if (remove(word)) count++;
    }
    return count;
  }

  /// Returns true if the trie contains the exact [word]. O(m)
  bool contains(String word) {
    if (word.isEmpty) return false;

    final node = _findNode(word);
    return node != null && node.isEndOfWord;
  }

  /// Alias for [contains]. Returns true if the exact [word] exists. O(m)
  bool search(String word) => contains(word);

  /// Returns true if any word in the trie starts with [prefix]. O(m)
  bool startsWith(String prefix) {
    if (prefix.isEmpty) return _wordCount > 0;
    return _findNode(prefix) != null;
  }

  /// Returns the node at the end of [prefix], or null if not found.
  TrieNode? _findNode(String prefix) {
    var current = _root;
    for (var i = 0; i < prefix.length; i++) {
      final char = prefix[i];
      if (!current.children.containsKey(char)) {
        return null;
      }
      current = current.children[char]!;
    }
    return current;
  }

  /// Returns all words that start with [prefix]. O(m + k)
  /// Useful for autocomplete functionality.
  List<String> getWordsWithPrefix(String prefix) {
    final results = <String>[];

    if (prefix.isEmpty) {
      _collectWords(_root, '', results);
      return results;
    }

    final node = _findNode(prefix);
    if (node == null) return results;

    _collectWords(node, prefix, results);
    return results;
  }

  void _collectWords(TrieNode node, String prefix, List<String> results) {
    if (node.isEndOfWord) {
      results.add(prefix);
    }
    for (final entry in node.children.entries) {
      _collectWords(entry.value, prefix + entry.key, results);
    }
  }

  /// Returns all words in the trie. O(n)
  List<String> getAllWords() => getWordsWithPrefix('');

  /// Returns the longest common prefix of all words in the trie. O(m)
  /// Returns empty string if trie is empty or has no common prefix.
  String longestCommonPrefix() {
    if (_wordCount == 0) return '';

    final buffer = StringBuffer();
    var current = _root;

    while (true) {
      // Stop if we reach a word ending or have multiple branches
      if (current.isEndOfWord || current.children.length != 1) {
        break;
      }

      final entry = current.children.entries.first;
      buffer.write(entry.key);
      current = entry.value;
    }

    return buffer.toString();
  }

  /// Removes all words from the trie. O(1)
  void clear() {
    _root.children.clear();
    _root.isEndOfWord = false;
    _wordCount = 0;
    _nodeCount = 1;
  }

  /// Converts the trie to a sorted list of words. O(n)
  List<String> toList() {
    final words = getAllWords();
    words.sort();
    return words;
  }

  @override
  String toString() {
    if (_wordCount == 0) return 'Trie: (empty)';
    return 'Trie: [${toList().join(', ')}]';
  }

  /// Returns a visual representation of the trie structure.
  String toTreeString() {
    if (_root.children.isEmpty) return '(empty)';
    final buffer = StringBuffer();
    buffer.writeln('(root)');
    _buildTreeString(_root, '', true, buffer);
    return buffer.toString();
  }

  void _buildTreeString(
    TrieNode node,
    String prefix,
    bool isLast,
    StringBuffer buffer,
  ) {
    final entries = node.children.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final isLastChild = i == entries.length - 1;
      final endMarker = entry.value.isEndOfWord ? '*' : '';

      buffer.writeln('$prefix${isLastChild ? '└── ' : '├── '}${entry.key}$endMarker');

      _buildTreeString(
        entry.value,
        '$prefix${isLastChild ? '    ' : '│   '}',
        isLastChild,
        buffer,
      );
    }
  }
}
