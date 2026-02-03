import 'package:test/test.dart';
import 'package:data_structures/data_structures.dart';

void main() {
  group('Trie', () {
    late Trie trie;

    setUp(() {
      trie = Trie();
    });

    group('empty trie operations', () {
      test('should start empty', () {
        expect(trie.isEmpty, isTrue);
        expect(trie.isNotEmpty, isFalse);
        expect(trie.wordCount, equals(0));
        expect(trie.size, equals(1)); // root node
      });

      test('should return empty list for getAllWords', () {
        expect(trie.getAllWords(), isEmpty);
      });

      test('should return empty list for getWordsWithPrefix', () {
        expect(trie.getWordsWithPrefix('test'), isEmpty);
      });

      test('should return false for contains', () {
        expect(trie.contains('test'), isFalse);
      });

      test('should return false for search', () {
        expect(trie.search('test'), isFalse);
      });

      test('should return false for startsWith', () {
        expect(trie.startsWith('test'), isFalse);
      });

      test('should return empty string for longestCommonPrefix', () {
        expect(trie.longestCommonPrefix(), equals(''));
      });

      test('should return empty list for toList', () {
        expect(trie.toList(), isEmpty);
      });

      test('should have proper toString', () {
        expect(trie.toString(), equals('Trie: (empty)'));
      });

      test('should have proper toTreeString', () {
        expect(trie.toTreeString(), equals('(empty)'));
      });
    });

    group('insert', () {
      test('should insert single word', () {
        expect(trie.insert('hello'), isTrue);
        expect(trie.wordCount, equals(1));
        expect(trie.contains('hello'), isTrue);
      });

      test('should insert multiple words', () {
        expect(trie.insert('hello'), isTrue);
        expect(trie.insert('world'), isTrue);
        expect(trie.insert('dart'), isTrue);
        expect(trie.wordCount, equals(3));
        expect(trie.contains('hello'), isTrue);
        expect(trie.contains('world'), isTrue);
        expect(trie.contains('dart'), isTrue);
      });

      test('should not insert duplicates', () {
        expect(trie.insert('hello'), isTrue);
        expect(trie.insert('hello'), isFalse);
        expect(trie.wordCount, equals(1));
      });

      test('should not insert empty string', () {
        expect(trie.insert(''), isFalse);
        expect(trie.wordCount, equals(0));
      });

      test('should insert single character', () {
        expect(trie.insert('a'), isTrue);
        expect(trie.contains('a'), isTrue);
        expect(trie.wordCount, equals(1));
      });

      test('should handle overlapping prefixes', () {
        trie.insert('car');
        trie.insert('card');
        trie.insert('care');
        trie.insert('careful');
        expect(trie.wordCount, equals(4));
        expect(trie.contains('car'), isTrue);
        expect(trie.contains('card'), isTrue);
        expect(trie.contains('care'), isTrue);
        expect(trie.contains('careful'), isTrue);
        expect(trie.contains('ca'), isFalse);
      });

      test('should update node count correctly', () {
        trie.insert('abc');
        expect(trie.size, equals(4)); // root + a + b + c
        trie.insert('abd');
        expect(trie.size, equals(5)); // adds 'd' node
      });
    });

    group('insertAll', () {
      test('should insert all words from list', () {
        final count = trie.insertAll(['apple', 'banana', 'cherry']);
        expect(count, equals(3));
        expect(trie.wordCount, equals(3));
      });

      test('should skip duplicates and return correct count', () {
        trie.insert('apple');
        final count = trie.insertAll(['apple', 'banana', 'apple', 'cherry']);
        expect(count, equals(2));
        expect(trie.wordCount, equals(3));
      });

      test('should handle empty iterable', () {
        final count = trie.insertAll([]);
        expect(count, equals(0));
        expect(trie.wordCount, equals(0));
      });
    });

    group('remove', () {
      test('should remove existing word', () {
        trie.insert('hello');
        expect(trie.remove('hello'), isTrue);
        expect(trie.contains('hello'), isFalse);
        expect(trie.wordCount, equals(0));
      });

      test('should return false for non-existing word', () {
        trie.insert('hello');
        expect(trie.remove('world'), isFalse);
        expect(trie.wordCount, equals(1));
      });

      test('should not remove empty string', () {
        trie.insert('hello');
        expect(trie.remove(''), isFalse);
        expect(trie.wordCount, equals(1));
      });

      test('should not remove prefix of another word', () {
        trie.insert('hello');
        expect(trie.remove('hel'), isFalse);
        expect(trie.contains('hello'), isTrue);
      });

      test('should remove word that is prefix of another', () {
        trie.insert('car');
        trie.insert('card');
        expect(trie.remove('car'), isTrue);
        expect(trie.contains('car'), isFalse);
        expect(trie.contains('card'), isTrue);
        expect(trie.wordCount, equals(1));
      });

      test('should clean up unused nodes', () {
        trie.insert('abc');
        expect(trie.size, equals(4));
        trie.remove('abc');
        expect(trie.size, equals(1)); // only root
      });

      test('should not clean up shared nodes', () {
        trie.insert('abc');
        trie.insert('abd');
        expect(trie.size, equals(5));
        trie.remove('abc');
        expect(trie.size, equals(4)); // only 'c' removed
        expect(trie.contains('abd'), isTrue);
      });
    });

    group('removeAll', () {
      test('should remove all words from list', () {
        trie.insertAll(['apple', 'banana', 'cherry']);
        final count = trie.removeAll(['apple', 'cherry']);
        expect(count, equals(2));
        expect(trie.wordCount, equals(1));
        expect(trie.contains('banana'), isTrue);
      });

      test('should skip non-existing words', () {
        trie.insertAll(['apple', 'banana']);
        final count = trie.removeAll(['apple', 'grape', 'banana', 'orange']);
        expect(count, equals(2));
        expect(trie.wordCount, equals(0));
      });

      test('should handle empty iterable', () {
        trie.insert('apple');
        final count = trie.removeAll([]);
        expect(count, equals(0));
        expect(trie.wordCount, equals(1));
      });
    });

    group('contains/search', () {
      test('should return true for existing word', () {
        trie.insert('hello');
        expect(trie.contains('hello'), isTrue);
        expect(trie.search('hello'), isTrue);
      });

      test('should return false for non-existing word', () {
        trie.insert('hello');
        expect(trie.contains('world'), isFalse);
        expect(trie.search('world'), isFalse);
      });

      test('should return false for prefix only', () {
        trie.insert('hello');
        expect(trie.contains('hel'), isFalse);
        expect(trie.search('hel'), isFalse);
      });

      test('should return false for empty string', () {
        trie.insert('hello');
        expect(trie.contains(''), isFalse);
        expect(trie.search(''), isFalse);
      });
    });

    group('startsWith', () {
      test('should return true for valid prefix', () {
        trie.insert('hello');
        expect(trie.startsWith('hel'), isTrue);
        expect(trie.startsWith('h'), isTrue);
        expect(trie.startsWith('hello'), isTrue);
      });

      test('should return false for invalid prefix', () {
        trie.insert('hello');
        expect(trie.startsWith('wor'), isFalse);
        expect(trie.startsWith('helloworld'), isFalse);
      });

      test('should return true for empty prefix when trie has words', () {
        trie.insert('hello');
        expect(trie.startsWith(''), isTrue);
      });

      test('should return false for empty prefix when trie is empty', () {
        expect(trie.startsWith(''), isFalse);
      });
    });

    group('getWordsWithPrefix', () {
      setUp(() {
        trie.insertAll(['car', 'card', 'care', 'careful', 'cat', 'dog']);
      });

      test('should return all words with given prefix', () {
        final words = trie.getWordsWithPrefix('car');
        expect(words, containsAll(['car', 'card', 'care', 'careful']));
        expect(words.length, equals(4));
      });

      test('should return single word when prefix is exact match', () {
        final words = trie.getWordsWithPrefix('dog');
        expect(words, equals(['dog']));
      });

      test('should return empty list for non-matching prefix', () {
        final words = trie.getWordsWithPrefix('bird');
        expect(words, isEmpty);
      });

      test('should return all words for empty prefix', () {
        final words = trie.getWordsWithPrefix('');
        expect(words.length, equals(6));
      });

      test('should return empty for prefix longer than any word', () {
        final words = trie.getWordsWithPrefix('carefully');
        expect(words, isEmpty);
      });
    });

    group('getAllWords', () {
      test('should return all words', () {
        trie.insertAll(['apple', 'banana', 'cherry']);
        final words = trie.getAllWords();
        expect(words.length, equals(3));
        expect(words, containsAll(['apple', 'banana', 'cherry']));
      });

      test('should return empty list for empty trie', () {
        expect(trie.getAllWords(), isEmpty);
      });
    });

    group('longestCommonPrefix', () {
      test('should return common prefix for similar words', () {
        trie.insertAll(['flower', 'flow', 'flight']);
        expect(trie.longestCommonPrefix(), equals('fl'));
      });

      test('should return empty string when no common prefix', () {
        trie.insertAll(['dog', 'racecar', 'car']);
        expect(trie.longestCommonPrefix(), equals(''));
      });

      test('should return shortest word when all share prefix', () {
        trie.insertAll(['prefix', 'prefixes', 'prefixing']);
        expect(trie.longestCommonPrefix(), equals('prefix'));
      });

      test('should return empty for empty trie', () {
        expect(trie.longestCommonPrefix(), equals(''));
      });

      test('should return full word for single word', () {
        trie.insert('hello');
        expect(trie.longestCommonPrefix(), equals('hello'));
      });
    });

    group('properties', () {
      test('isEmpty should reflect word count', () {
        expect(trie.isEmpty, isTrue);
        trie.insert('test');
        expect(trie.isEmpty, isFalse);
        trie.remove('test');
        expect(trie.isEmpty, isTrue);
      });

      test('isNotEmpty should be inverse of isEmpty', () {
        expect(trie.isNotEmpty, isFalse);
        trie.insert('test');
        expect(trie.isNotEmpty, isTrue);
      });

      test('wordCount should track words correctly', () {
        expect(trie.wordCount, equals(0));
        trie.insert('a');
        expect(trie.wordCount, equals(1));
        trie.insert('b');
        expect(trie.wordCount, equals(2));
        trie.remove('a');
        expect(trie.wordCount, equals(1));
      });

      test('size should track nodes correctly', () {
        expect(trie.size, equals(1)); // root
        trie.insert('ab');
        expect(trie.size, equals(3)); // root + a + b
        trie.insert('ac');
        expect(trie.size, equals(4)); // adds c
        trie.remove('ab');
        expect(trie.size, equals(3)); // removes b
      });
    });

    group('clear', () {
      test('should remove all words', () {
        trie.insertAll(['apple', 'banana', 'cherry']);
        trie.clear();
        expect(trie.isEmpty, isTrue);
        expect(trie.wordCount, equals(0));
        expect(trie.size, equals(1));
      });

      test('should allow inserting after clear', () {
        trie.insert('hello');
        trie.clear();
        trie.insert('world');
        expect(trie.contains('world'), isTrue);
        expect(trie.wordCount, equals(1));
      });
    });

    group('toList', () {
      test('should return sorted list of words', () {
        trie.insertAll(['cherry', 'apple', 'banana']);
        expect(trie.toList(), equals(['apple', 'banana', 'cherry']));
      });

      test('should return empty list for empty trie', () {
        expect(trie.toList(), isEmpty);
      });
    });

    group('toString', () {
      test('should show empty for empty trie', () {
        expect(trie.toString(), equals('Trie: (empty)'));
      });

      test('should show sorted words', () {
        trie.insertAll(['cat', 'apple', 'dog']);
        expect(trie.toString(), equals('Trie: [apple, cat, dog]'));
      });
    });

    group('toTreeString', () {
      test('should show empty for empty trie', () {
        expect(trie.toTreeString(), equals('(empty)'));
      });

      test('should show tree structure', () {
        trie.insertAll(['cat', 'car']);
        final treeStr = trie.toTreeString();
        expect(treeStr, contains('(root)'));
        expect(treeStr, contains('c'));
        expect(treeStr, contains('a'));
      });
    });

    group('factory Trie.from', () {
      test('should create trie from iterable', () {
        final newTrie = Trie.from(['apple', 'banana', 'cherry']);
        expect(newTrie.wordCount, equals(3));
        expect(newTrie.contains('apple'), isTrue);
        expect(newTrie.contains('banana'), isTrue);
        expect(newTrie.contains('cherry'), isTrue);
      });

      test('should handle duplicates in iterable', () {
        final newTrie = Trie.from(['apple', 'apple', 'banana']);
        expect(newTrie.wordCount, equals(2));
      });

      test('should create empty trie from empty iterable', () {
        final newTrie = Trie.from([]);
        expect(newTrie.isEmpty, isTrue);
      });
    });

    group('edge cases', () {
      test('should handle single character words', () {
        trie.insertAll(['a', 'b', 'c']);
        expect(trie.wordCount, equals(3));
        expect(trie.contains('a'), isTrue);
        expect(trie.getAllWords(), containsAll(['a', 'b', 'c']));
      });

      test('should handle words with same prefix', () {
        trie.insertAll(['a', 'ab', 'abc', 'abcd']);
        expect(trie.wordCount, equals(4));
        expect(trie.getWordsWithPrefix('a').length, equals(4));
        expect(trie.getWordsWithPrefix('ab').length, equals(3));
        expect(trie.getWordsWithPrefix('abc').length, equals(2));
      });

      test('should handle special characters', () {
        trie.insert('hello-world');
        trie.insert('hello_world');
        trie.insert('hello.world');
        expect(trie.wordCount, equals(3));
        expect(trie.contains('hello-world'), isTrue);
        expect(trie.contains('hello_world'), isTrue);
        expect(trie.contains('hello.world'), isTrue);
      });

      test('should handle unicode characters', () {
        trie.insert('café');
        trie.insert('naïve');
        expect(trie.wordCount, equals(2));
        expect(trie.contains('café'), isTrue);
        expect(trie.contains('naïve'), isTrue);
      });

      test('should handle numbers in words', () {
        trie.insert('test123');
        trie.insert('123test');
        expect(trie.wordCount, equals(2));
        expect(trie.contains('test123'), isTrue);
        expect(trie.contains('123test'), isTrue);
      });
    });

    group('large word sets', () {
      test('should handle dictionary-like insertions', () {
        final words = List.generate(1000, (i) => 'word$i');
        trie.insertAll(words);
        expect(trie.wordCount, equals(1000));
        expect(trie.contains('word0'), isTrue);
        expect(trie.contains('word999'), isTrue);
        expect(trie.contains('word1000'), isFalse);
      });

      test('should efficiently find words with common prefix', () {
        final words = [
          ...List.generate(100, (i) => 'apple$i'),
          ...List.generate(100, (i) => 'banana$i'),
          ...List.generate(100, (i) => 'cherry$i'),
        ];
        trie.insertAll(words);
        expect(trie.wordCount, equals(300));

        final appleWords = trie.getWordsWithPrefix('apple');
        expect(appleWords.length, equals(100));

        final bananaWords = trie.getWordsWithPrefix('banana');
        expect(bananaWords.length, equals(100));
      });

      test('should handle bulk removal', () {
        final words = List.generate(100, (i) => 'word$i');
        trie.insertAll(words);
        expect(trie.wordCount, equals(100));

        final toRemove = List.generate(50, (i) => 'word$i');
        final removed = trie.removeAll(toRemove);
        expect(removed, equals(50));
        expect(trie.wordCount, equals(50));
      });

      test('should maintain integrity after many operations', () {
        // Insert 500 words
        for (var i = 0; i < 500; i++) {
          trie.insert('word$i');
        }
        expect(trie.wordCount, equals(500));

        // Remove every other word
        for (var i = 0; i < 500; i += 2) {
          trie.remove('word$i');
        }
        expect(trie.wordCount, equals(250));

        // Verify remaining words
        for (var i = 1; i < 500; i += 2) {
          expect(trie.contains('word$i'), isTrue);
        }
        for (var i = 0; i < 500; i += 2) {
          expect(trie.contains('word$i'), isFalse);
        }
      });
    });

    group('TrieNode', () {
      test('should have correct initial state', () {
        final node = TrieNode();
        expect(node.isEndOfWord, isFalse);
        expect(node.isLeaf, isTrue);
        expect(node.childCount, equals(0));
      });

      test('should track children correctly', () {
        final node = TrieNode();
        node.children['a'] = TrieNode();
        node.children['b'] = TrieNode();
        expect(node.isLeaf, isFalse);
        expect(node.childCount, equals(2));
      });

      test('should have proper toString', () {
        final node = TrieNode();
        node.children['a'] = TrieNode();
        node.isEndOfWord = true;
        final str = node.toString();
        expect(str, contains('TrieNode'));
        expect(str, contains('a'));
        expect(str, contains('true'));
      });
    });

    group('root access', () {
      test('should provide access to root node', () {
        expect(trie.root, isNotNull);
        expect(trie.root.isLeaf, isTrue);

        trie.insert('test');
        expect(trie.root.isLeaf, isFalse);
        expect(trie.root.children.containsKey('t'), isTrue);
      });
    });
  });
}
