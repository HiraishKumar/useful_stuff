# Definition for a binary tree node.

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right    
        
        
class Solution:
    def isValidBST(self, root: TreeNode) -> bool:
        def verify(root,left,right):
            if root is None:
                return True 
            if not (left < root.val < right):
                return False
            return verify(root.right ,root.val,right) and verify(root.left,left,root.val)
        return verify(root,float("-inf"),float("inf")) 