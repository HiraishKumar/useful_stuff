class Node:
    def __init__(self, info): 
        self.info = info  
        self.left = None  
        self.right = None 
        self.level = None 

    def __str__(self):
        return str(self.info) 

class BinarySearchTree:
    def __init__(self): 
        self.root = None

    def create(self, val):  
        if self.root == None:
            self.root = Node(val)
        else:
            current = self.root
         
            while True:
                if val < current.info:
                    if current.left:
                        current = current.left
                    else:
                        current.left = Node(val)
                        break
                elif val > current.info:
                    if current.right:
                        current = current.right
                    else:
                        current.right = Node(val)
                        break
                else:
                    break

# Enter your code here. Read input from STDIN. Print output to STDOUT

class Node:
      def __init__(self,info): 
          self.info = info  
          self.left = None  
          self.right = None 
           



def lca(root:Node, v1:int, v2:int):
  #Enter your code here
    def find(node:Node,val:int):
        if node is None:
            return False
        if node.info == val:
            return True
        return (find(node.left,val) or find(node.right,val))
    res=root
    q=[root]
    while len(q)!=0:
        root=q.pop(0)
        if find(root.left,v1) and find(root.left,v2):
            res=root.left
            q.append(root.left)            
        if find(root.right,v1) and find(root.right,v2):
            res=root.right
            q.append(root.right) 
    return res
            
            
        
        

tree = BinarySearchTree()
t = int(input())

arr = list(map(int, input().split()))

for i in range(t):
    tree.create(arr[i])

v = list(map(int, input().split()))

ans = lca(tree.root, v[0], v[1])
print (ans.info)
