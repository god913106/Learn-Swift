import UIKit

//stack 棧 後進先出 最後push進來的資料 一定是最新的 所以隨時可以存取最新數據來看 其實相當便利

struct Stack<Element> {
    private var elements : [Element] = []
    init() { }
}

extension Stack: CustomStringConvertible {
    var description: String {
        let topDivider = "====top====\n"
        let bottomDivider = "\n====bottom====\n"
        let stackElements = elements
            .reversed()
            .map { "\($0)" }
            .joined(separator: "\n")
        return topDivider + stackElements + bottomDivider
    }
    
    var top: Element? {
        return elements.last
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
}

extension Stack {
    mutating func push(_ element: Element) {
        elements.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        return elements.popLast()
    }
}

var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)
stack.push(4)


print(stack)
print(stack.count)
stack.pop()

print(stack)
print(stack.count)
