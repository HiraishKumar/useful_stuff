class TreeNode:
    def __init__(self, data):
        self.data = data
        self.children = []

    def add_child(self, child):
        self.children.append(child)

class Tree:
    def __init__(self):
        self.root = None

    def is_empty(self):
        return self.root is None

    def add_root(self, data):
        if self.is_empty():
            self.root = TreeNode(data)
        else:
            print("Tree already has a root")

    def add_child(self, parent, data):
        if not self.is_empty():
            self._add_child(self.root, parent, data)
        else:
            print("Cannot add child. Tree is empty.")

    def _add_child(self, node, parent, data):
        if node.data == parent:
            node.add_child(TreeNode(data))
        else:
            for child in node.children:
                self._add_child(child, parent, data)

    def traverse(self):
        if not self.is_empty():
            self._traverse(self.root)

    def _traverse(self, node):
        print(node.data)
        for child in node.children:
            self._traverse(child)