import UIKit

final class BinaryTreeNode<T> {
    var value: T  //存儲當前節點的值
    var leftChild: BinaryTreeNode? //左子節點
    var rightChild: BinaryTreeNode? //右子節點
    
    init(_ value: T) {
        self.value = value
    }
    
    //二叉樹的遍歷算法有三種：1）中序遍歷；2）前序遍歷；3）後序遍歷。
    
    //1）中序遍歷 左根右
    func traverseInOrder(_ closure: (T) -> Void) {
        leftChild?.traverseInOrder(closure)
        closure(value)
        rightChild?.traverseInOrder(closure)
    }
    
    //2）前序遍歷 根左右
    func traversePreOrder(_ closure: (T) -> Void) {
        closure(value)
        leftChild?.traversePreOrder(closure)
        rightChild?.traversePreOrder(closure)
    }
    
    //3）後序遍歷 左右根
    func traversePostOrder(_ closure: (T) -> Void) {
        leftChild?.traversePostOrder(closure)
        rightChild?.traversePostOrder(closure)
        closure(value)
    }
    
}

//建立一個二叉樹
let zero = BinaryTreeNode(0)
let one = BinaryTreeNode(1)
let two = BinaryTreeNode(2)
let three = BinaryTreeNode(3)
let four = BinaryTreeNode(4)
let five = BinaryTreeNode(5)
let six = BinaryTreeNode(6)

three.leftChild = one
three.rightChild = five

one.leftChild = zero
one.rightChild = two

five.leftChild = four
five.rightChild = six

print("===中序遍歷 左根右===")
three.traverseInOrder { print($0) }
print("===前序遍歷 根左右===")
three.traversePreOrder { print($0) }
print("===後序遍歷 左右根===")
three.traversePostOrder { print($0) }
