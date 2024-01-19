# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
class Solution:
    def kthSmallest(self, root: TreeNode, k: int) -> int:
        lst=[0,None]
        def traverse(root):
            if not root:
                return 
            traverse(root.left)
            lst[0]+=1
            if lst[0]==k:
                lst[1]=root.val
                return               
            traverse(root.right)
        traverse(root)
        return lst[1]      
        