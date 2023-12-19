class Node:
    def __init__(self,value:int):
        self.right=None
        self.left=None
        self.data=value        
class Tree:
    def createNode(self,data):
        return Node(data)
    def insert(self,node,data):
        if node == None:
            return self.createNode(data)           
        if data < node.data:
            node.left=self.insert(node.left,data)
        else:
            node.right=self.insert(node.right,data)
        return node
    def traverse_inOrder(self,root):
        if root is not None:
            self.traverse_inOrder(root.left)
            print(root.data)
            
            self.traverse_inOrder(root.right)
            
def Finder():
    