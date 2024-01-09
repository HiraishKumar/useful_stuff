# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
class Solution:
    def isSameTree(self, p:TreeNode, q:TreeNode) -> bool:
        def search(lnode, rnode) -> bool:
            if lnode is not None and rnode is not None:
                return lnode.val == rnode.val and search(lnode.left, rnode.left) and search(lnode.right, rnode.right)
            elif lnode is None and rnode is None:
                return True
            else:
                return False
        return search(p, q)