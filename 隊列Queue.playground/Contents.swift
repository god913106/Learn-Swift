import UIKit

/*
 隊列在生活中非常常見。排隊等位吃飯、在火車站買票、通過高速路口等，這些生活中的現象很好的描述了隊列的特點：先進先出 (FIFO, first in first out)，排在最前面的先出来，後面來的只能排在最後面。
 */

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

/*
 用數组實現隊列比較簡單：
 
 1) 用數组存儲所有隊列的元素
 2) 常用的一些屬性: count、isEmpty、peek (訪問第一個元素)
 3) enqueue(_:): 在隊列最後添加元素
 4) dequeue(): 移除隊列的第一個元素
 5) 遵循 CustomStringConvertible，直接使用elements的description
 */

var queue = Queue<Int>()
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)
queue.enqueue(4)

print(queue)

queue.dequeue()

print(queue)

// 结果
//[1, 2, 3, 4]
//[2, 3, 4]

/*
 入隊的時間復雜度為O(1)，如果隊列比较大，可能造成剛開始開辟的内存不夠用，需要重新開辟内存空間。重新開辟空間的時間復雜度為O(n)，因為要把元素復制到新的内存。但是 Swift 在每次增加内存空间时，都会增加到原来的两倍，重新開辟内存操作的次數一般比较少，所以我们還是認為入隊的時間復雜度為O(1)。
 而出隊為O(n)，因為在内存中，移除數组的第一個元素之後，後面的元素要往前移動（就像排隊付款，前面的付完款之後，後面的往前走），所以造成時間復雜度為O(n)。
 */
/*
 總結
 
 用數组来實現隊列是非常簡單的，但是dequeue()的時間復雜度是O(n)，有沒有辦法可以讓解決這個缺點呢？有，我们可以使用雙向鏈表來實現隊列，但是雙向鏈表的節點要記錄前後節點的地址，所以占用的内存比較大。所以在實際使用中，要根據情況來選擇。
 */
