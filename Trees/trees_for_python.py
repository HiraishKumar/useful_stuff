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
    
lst=[5,63,41,8,56,69,36,15,1,65,2,15,2]
print(str(lst.count(5)),"is the number of 5s")

tree=Tree()
root=tree.createNode(lst[0])
for i in lst:
    tree.insert(root,i)
    # print(i)
tree.traverse_inOrder(root)
