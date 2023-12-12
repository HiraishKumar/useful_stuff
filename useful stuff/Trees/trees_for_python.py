class Node:
    def __init__(self,value):
        self.right=None
        self.left=None
        self.data=value
        
class Tree:
    def createNode(self,data):
        return Node(data)
    def AddLeft(self,data):
        self.left = Node(data)
    def AddRight(self,data):
        self.right =Node(data)
    def find (self,Node,value):
        while True:
            if Node.data == value:
                return Node
            else:
                if Node.left and Node.left.data >= value:
                    Node=Node.left
                elif Node.right:
                    Node=Node.right 
                    
                else:
                    return None               
        