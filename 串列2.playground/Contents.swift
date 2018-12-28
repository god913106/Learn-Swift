import UIKit

final class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    
    init(value: T, next: LinkedListNode? = nil) {
        self.value = value
        self.next = next
    }
}
extension LinkedListNode: CustomStringConvertible {
    var description: String {
        guard let next = next else { return "\(value)" }
        return "\(value) -> \(String(describing: next)) "
    }
}

struct LinkedList<T> {
    var head: LinkedListNode<T>?
    var tail: LinkedListNode<T>?
    init() { }
  
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        guard let head = head else { return "Empty list" }
        return String(describing: head)
    }
}

extension LinkedList {
    var isEmpty: Bool {
        return head == nil
    }
}

extension LinkedList {
    
    mutating func copyNodes() {
        guard !isKnownUniquelyReferenced(&head) else { return }
        guard var oldNode = head else { return }
        
        head = LinkedListNode(value: oldNode.value)
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            let nextNewNode = LinkedListNode(value: nextOldNode.value)
            newNode?.next = nextNewNode
            newNode = nextNewNode
            oldNode = nextOldNode
        }
        
        tail = newNode
    }
    
    
    mutating func append(_ value: T) {
        copyNodes()
        
        guard !isEmpty else {
            let node = LinkedListNode(value: value)
            head = node
            tail = node
            return
        }
        let next = LinkedListNode(value: value)
        tail?.next = next
        tail = next
    }
    
    mutating func insert(_ value: T, after node: LinkedListNode<T>) {
        guard tail !== node else { append(value); return }
        node.next = LinkedListNode(value: value, next: node.next)
    }
}



var list1 = LinkedList<Int>()
list1.append(1)
list1.append(2)
list1.append(3)

let list2 = list1

print("list1: \(list1)")
print("list2: \(list2)")

print("========分割線========")

list1.append(4)

print("list1: \(list1)")
print("list2: \(list2)")

// 结果
//list1: 1 -> 2 -> 3
//list2: 1 -> 2 -> 3
//========分割線========
//list1: 1 -> 2 -> 3 -> 4
//list2: 1 -> 2 -> 3 -> 4
