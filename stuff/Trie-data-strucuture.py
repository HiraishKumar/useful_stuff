


class TrieNode:
    def __init__(self) -> None:
        self.children={}
        self.is_end_of_word = False
        
class Trie:
    def __init__(self) -> None:
        self.root = TrieNode()
    
    
    def insert(self,word) -> None:
        node = self.root
        for letter in word:
            if letter not in node.children:
                node.children[letter] = TrieNode()
            node = node.children[letter]
        node.is_end_of_word = True
        
    def search(self,word):
        node = self.root
        for letter in word:
            if letter not in node.children:
                return False
            node = node.children[letter]
        return node.is_end_of_word
    
    def starts_with(self,prefix):
        node = self.root
        for letter in prefix:
            if letter not in node.children:
                return False
            node = node.children[letter]
        return True
        
    def delete(self,word):
        def _delete(node,word,depth):
            if not node:
                return False
            
            if depth == len(word):
                if not node.is_end_of_word:
                    return False
                node.is_end_of_word = False
                return len(node.children) == 0
            
            letter = word[depth]
            if letter not in node.children:
                return False
            
            _should_delete_child = _delete(node.children[letter],word,depth+1)
            
            if _should_delete_child:
                del node.children[letter]
                return len(node.children) == 0
            
            return False 
        
        _delete(self.root,word,0)    
    
    
    
        

