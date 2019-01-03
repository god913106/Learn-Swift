import Foundation

/*
優先隊列是根據優先級的高低來決定出隊的順序，堆的這個特點非常適合用來實現優先隊列。
採用堆實現優先隊列比較簡單，直接给出實現代碼如下：
*/

struct PriorityQueue<Element: Equatable> {
    private var heap: Heap<Element>
    
    init(order: @escaping (Element, Element) -> Bool) {
        heap = Heap(order: order)
    }
    
    var isEmpty: Bool {
        return heap.isEmpty
    }
    
    var peek: Element? {
        return heap.peek
    }
    
    mutating func enqueue(_ element: Element) {
        heap.insert(element)
    }
    
    mutating func dequeue() -> Element? {
        return heap.removePeek()
    }
}

extension PriorityQueue: CustomStringConvertible {
    var description: String {
        return heap.description
    }
}

//下面我們來測試一下
var priorityQueue = PriorityQueue<Int>(order: >)
for i in 1...7 {
    priorityQueue.enqueue(i)
}

while !priorityQueue.isEmpty {
    print(String(describing: priorityQueue.dequeue()))
}

// 结果
//Optional(7)
//Optional(6)
//Optional(5)
//Optional(4)
//Optional(3)
//Optional(2)
//Optional(1)
