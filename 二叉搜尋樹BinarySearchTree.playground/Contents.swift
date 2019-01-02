import UIKit

/*
 二叉搜尋樹 (BST)可以提高查找、插入和删除的效率，時間復雜度都為O(log n)。成為二叉搜索樹必須滿足下面兩個條件：
 
 左子節點的值必須小於它的父節點的值
 右子節點的值必須大於或等於它的父節點的值
 */
final class BinaryTreeNode<T> {
    var value: T  //存儲當前節點的值
    var leftChild: BinaryTreeNode? //左子節點
    var rightChild: BinaryTreeNode? //右子節點
    
    init(_ value: T) {
        self.value = value
    }
    
    //1）中序遍歷 左根右
    func traverseInOrder(_ closure: (T) -> Void) {
        leftChild?.traverseInOrder(closure)
        closure(value)
        rightChild?.traverseInOrder(closure)
    }
}

struct BinarySearchTree<Element: Comparable> {
    private(set) var root: BinaryTreeNode<Element>?
    init() {  }
}

//查找
extension BinarySearchTree {
    func contains(_ value: Element) -> Bool {
        var current = root
        while let node = current {
            if node.value == value {
                return true
            }
            if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }
        return false
    }
}



//插入
extension BinarySearchTree {
    mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }
    
    private func insert(from node: BinaryTreeNode<Element>?,
                        value: Element) -> BinaryTreeNode<Element> {
        guard let node = node else {
            return BinaryTreeNode(value)
        }
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }
        return node
    }
}

var bst1 = BinarySearchTree<Int>()
bst1.insert(0)
bst1.insert(2)
bst1.insert(3)
bst1.insert(5)
bst1.insert(7)
bst1.insert(9)

var bst2 = BinarySearchTree<Int>()
bst2.insert(4)
bst2.insert(2)
bst2.insert(6)
bst2.insert(1)
bst2.insert(3)
bst2.insert(5)
bst2.insert(7)

//移除
extension BinaryTreeNode {
    var minNode: BinaryTreeNode {
        return leftChild?.minNode ?? self
    }
}

extension BinarySearchTree {
    mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }
    
    private func remove(node: BinaryTreeNode<Element>?,
                        value: Element) -> BinaryTreeNode<Element>? {
        
        guard let node = node else { return nil }
        
        if node.value == value {
            // 左右子節點都為空
            if node.leftChild == nil && node.rightChild == nil {
                return nil
            }
            // 左右子節點中，有其中一个為空
            if node.leftChild == nil {
                return node.rightChild
            }
            if node.rightChild == nil {
                return node.leftChild
            }
            // 左右子節點都不為空
            node.value = node.rightChild!.minNode.value // 把當前 "node" 的值更新為右子節點的最小值
            node.rightChild = remove(node: node.rightChild, value: node.value) // 把右子節點的最小值刪除
            
        } else if value < node.value {
            node.leftChild = remove(node: node.leftChild, value: value)
        } else {
            node.rightChild = remove(node: node.rightChild, value: value)
        }
        
        return node
    }
}

var bst = BinarySearchTree<Int>()
(0...12).forEach {
    bst.insert($0)
}
bst.remove(3) //移除 3
bst.root?.traverseInOrder { print($0) }
/*
 结果
 0
 1
 2
 4
 5
 6
 7
 8
 9
 10
 11
 12
 */

/*
 總結
 二叉搜尋樹是一個非常強大的數據結構，在處理有序的數據時有很高的效率。查找、插入和移除的時間復雜度都為O(log n)。
 */
