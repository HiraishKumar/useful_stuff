class Node:
    def __init__(self, info):
        self.info = info  
        self.left = None  
        self.right = None 
        self.level = None 

    def __str__(self):
        return str(self.info) 

def preOrder(root):
    if root == None:
        return
    print (root.info, end=" ")
    preOrder(root.left)
    preOrder(root.right)
    
class BinarySearchTree:
    def __init__(self): 
        self.root = None

#Node is defined as
#self.left (the left child of the node)
#self.right (the right child of the node)
#self.info (the value of the node)
    def insert(self, val):
        # If the tree is empty, create a new node as the root
        if self.root is None:
            self.root = Node(val)
        else:
            # Call the recursive insert method starting from the root
            self._insert_recursive(self.root, val)

    def _insert_recursive(self, node, val):
        # Compare the value to be inserted with the current node's value
        if val < node.info:
            # If the value is smaller, go to the left child
            if node.left is None:
                # If the left child is None, create a new node
                node.left = Node(val)
            else:
                # Recursively insert into the left subtree
                self._insert_recursive(node.left, val)
        elif val > node.info:
            # If the value is greater, go to the right child
            if node.right is None:
                # If the right child is None, create a new node
                node.right = Node(val)
            else:
                # Recursively insert into the right subtree
                self._insert_recursive(node.right, val)
        
tree = BinarySearchTree()
t = int(input())

arr = list(map(int, input().split()))

for i in range(t):
    
    tree.insert(arr[i])

preOrder(tree.root)
