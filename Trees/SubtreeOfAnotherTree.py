class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
class Solution:
    def isSubtree(self, root: TreeNode, subRoot: TreeNode) -> bool:
        def search(lnode, rnode) -> bool:
            if lnode is not None and rnode is not None:
                return lnode.val == rnode.val and search(lnode.left, rnode.left) and search(lnode.right, rnode.right)
            elif lnode is None and rnode is None:
                return True
            else:
                return False
        if not root:
            return False
        if search(root,subRoot):
            return True
        return self.isSubtree(root.left,subRoot) or self.isSubtree(root.right,subRoot) 