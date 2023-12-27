# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
#         self.right = right
class Solution:
    def isBalanced(self, root: [TreeNode]) -> bool:
        if root is None:
            return True  # An empty tree is considered balanced

        # Check the balance condition
        if abs(self.height(root.left) - self.height(root.right)) > 1:
            return False

        # Recursively check the balance for left and right subtrees
        return self.isBalanced(root.left) and self.isBalanced(root.right)



    
    def height(self, root:[TreeNode])-> int:
        if not root:
            return 0
        return 1 + max(self.height(root.left),self.height(root.right))