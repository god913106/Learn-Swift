import UIKit

final class TreeNode<T> {
    var value: T
    private(set) var children: [TreeNode] = []
    
    init(_ value: T) {
        self.value = value
    }
    
    func addChild(_ child: TreeNode) {
        children.append(child)
    }
    
    //Depth-First 深度優先
    func traverseDepthFirst(_ closure: (TreeNode) -> Void) {
        closure(self)
        children.forEach {
            $0.traverseDepthFirst(closure)
        }
    }
    //Breadth-First 廣度優先
    func traverseLevelOrder(_ closure: (TreeNode) -> Void) {
        closure(self)
        var queue = Queue<TreeNode>()
        children.forEach { queue.enqueue($0) }
        while let node = queue.dequeue() {
            closure(node)
            node.children.forEach { queue.enqueue($0) }
        }
    }
}

struct Queue<Element> {
    
    private var elements: [Element] = []
    
    init() { }
    
    // MARK: - Getters
    
    var count: Int {
        return elements.count
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var peek: Element? {
        return elements.first
    }
    
    // MARK: - Enqueue & Dequeue
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }
    
    @discardableResult
    mutating func dequeue() -> Element? {
        return isEmpty ? nil : elements.removeFirst()
    }
}

extension Queue: CustomStringConvertible {
    var description: String {
        return elements.description
    }
}

let products = TreeNode("Products") //父節點

let phone = TreeNode("Phone")
let computer = TreeNode("Computer")
//幫Products 加子節點
products.addChild(phone)
products.addChild(computer)

//幫phone 加子節點
let iPhone8 = TreeNode("iPhone 8")
let iPhone8Plus = TreeNode("iPhone 8 Plus")
let iPhoneX = TreeNode("iPhone X")
phone.addChild(iPhone8)
phone.addChild(iPhone8Plus)
phone.addChild(iPhoneX)

//幫computer 加子節點
let macBookPro = TreeNode("MacBook Pro")
let iMac = TreeNode("iMac")
let iMacPro = TreeNode("iMacPro")
computer.addChild(macBookPro)
computer.addChild(iMac)
computer.addChild(iMacPro)

print("======Depth-First 深度優先======")
products.traverseDepthFirst { print($0.value) }
print("======Breadth-First 廣度優先======")
products.traverseLevelOrder { print($0.value) }


