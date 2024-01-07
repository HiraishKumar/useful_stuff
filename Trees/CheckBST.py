""" Node is defined as
class node:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None
"""

def checkBST(root):
    def dfs(node, min_val=float('-inf'), max_val=float('inf')):
        if not node:
            return True
        
        if not (min_val < node.data < max_val):
            return False
        
        return (dfs(node.left, min_val, node.data) and
                dfs(node.right, node.data, max_val))
    return dfs(root)