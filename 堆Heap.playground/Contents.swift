import UIKit

//堆，其實是一個完整的二叉樹（除了父節點外，其他節點都有左右子節點）。堆有以下兩種形式：

/*
最大堆：根部元素的值最大，越往下，值越小。例如：
    10
   /   \
  7     9
 / \   / \
6   4 5   3
 
最小堆：根部元素的值最小，越往下，值越大。例如：
    10
   /   \
  7     9
 / \   / \
6   4 5   3
*/

/*
實現
 
雖然堆本質上是屬於二叉樹，但是我们不使用節點來實現，而是使用數組。
因為堆中的元素有一定的優先級順序，可以用數組來存儲元素；
並且在元素的添加移除等過程中需要頻繁訪問特定的位置的元素，數組正適合我們的需求。
 */

struct Heap<Element: Equatable> {
    private(set) var elements: [Element] = []
    private let order: (Element, Element) -> Bool

    init(order: @escaping (Element, Element) -> Bool) {
        self.order = order
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    var peek: Element? {
        return elements.first
    }
}

extension Heap: CustomStringConvertible {
    var description: String {
        return elements.description
    }
    
    /*
     
     從下圖我們可以總結出，如果給定一個元素的索引 i，那麼：
     
     這個元素的左子節點索引為 2 * i + 1，
     這個元素的右子節點索引為 2 * i + 2。
     這個元素的父節點索引為 (i - 1) / 2。
     所以，添加獲取左右子節點和父節點索引的方法，如下：
     
     */
    
    func leftChildIndex(ofParentAt index: Int) -> Int {
        return 2 * index + 1
    }
    
    func rightChildIndex(ofParentAt index: Int) -> Int {
        return 2 * index + 2
    }
    
    func parentIndex(ofChildAt index: Int) -> Int {
        return (index - 1) / 2
    }
    
}

/*
考慮到堆有兩種形式，所以定義了一個 order 閉包，後續的相關操作可以根據它來判斷堆的類型。(最大堆/最小堆)
另外還添加了一些常用屬性和實現了 CustomStringConvertible 協議。
*/
/*
數組如何表示堆層
 
假設我們有以下堆數據結構：
      10       第一層
 -----------------------
     /   \
    7     9    第二層
 -----------------------
   / \   / \
  6   4 5   3  第三層
 -----------------------
 /
 2             第四層
 -----------------------
 
用數組可以表示如下：
索引
    0      1     2     3     4     5     6     7
 +-------------------------------------------------+
 |  10  |  7  |  9  |  6  |  4  |  5  |  3  |  2   |
 +-------------------------------------------------+
 
 |第一層 |   第二層   |         第三層         |第四層 |
 |------|-----------|-----------------------|------|
 
 */


/*
移除元素
 
元素的移除分兩種情況：1）移除根部元素；2）移除任意位置的元素。
 
1）移除根部元素：
以上面的最大堆為例，移除根部元素10。
 
     +------+
     |  10  |
     +------+
      /   \
     7     9
    / \   / \
   6   4 5   3
  /
 2
 
為了移除這個根部元素，我們首先將根部元素與最後一个元素2的位置調換。
 
       +-----+
       |  2  |
       +-----+
        /   \
       7     9
      / \   / \
     6   4 5   3
    /
 +------+
 |  10  |
 +------+
 
調換成功後，就把最後一個元素10移除。
 
      2
    /   \
   7     9
  / \   / \
 6   4 5   3
 
這時需要檢查當前的結構是否符合堆的特性。很明顯，現在的根部元素是 2，
小於它的子節點，所以我們把根部元素和它的左右子節點的較大者 9 位置調換，變成：
 
      9
    /   \
   7     2
  / \   / \
 6   4 5   3
 
再繼續往下比較，這時2又比它的左右子節點小，繼續把 2 和它的左右子節點的較大者位置 5 調換，變成：
 
      9
    /   \
   7     5
  / \   / \
 6   4 2   3

2 下面沒有子節點了，所以這棵樹最終調整完成，符合最大堆的要求。
*/

extension Heap {
    mutating func removePeek() -> Element? {
        guard !isEmpty else { return nil }
        elements.swapAt(0, count - 1)
        defer {
            validateDown(from: 0)
        }
        return elements.removeLast()
    }
    
    private mutating func validateDown(from index: Int) {
        var parentIndex = index
        while true {
            let leftIndex = leftChildIndex(ofParentAt: parentIndex)
            let rightIndex = rightChildIndex(ofParentAt: parentIndex)
            var targetParentIndex = parentIndex
            
            if leftIndex < count &&
                order(elements[leftIndex], elements[targetParentIndex]) {
                targetParentIndex = leftIndex
            }
            
            if rightIndex < count &&
                order(elements[rightIndex], elements[targetParentIndex]) {
                targetParentIndex = rightIndex
            }
            
            if targetParentIndex == parentIndex {
                return
            }
            
            elements.swapAt(parentIndex, targetParentIndex)
            parentIndex = targetParentIndex
        }
    }
    
    
    
}

/*
removePeek()：
 
首先判斷堆是否為空，如果是直接返回 nil。
調換根元素和最後一個元素
移除最後一個元素
validateDown(from: 0) 驗證堆是否符合要求
validateDown(from index: Int)，while 循環裡面：
 
首先得到左右子節點的索引
targetParentIndex 用於記錄最終需要跟父節點索引調換的索引
如果左子節點存在，並且左子節點的值大於當前父節點的值，則更新 targetParentIndex 為 leftIndex
 
如果右子節點存在，並且右子節點的值大於當前父節點的值，則更新 targetParentIndex 為 rightIndex
 
如果 targetParentIndex 還是 parentIndex，意味著此時已經符合堆的特性，直接返回退出循環，
否則替換 parentIndex 和 targetParentIndex 對應的值，
並且把 parentIndex 替換為 targetParentIndex，繼續循環。
*/

/*
移除任意元素
 
移除任意元素與移除根元素的思路類似，同樣是把要移除的元素跟最後一個元素調換，然後再驗證是否符合堆的特性。
*/
extension Heap {
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else { return nil }
        
        if index == elements.count - 1 {
            return elements.removeLast()
        } else {
            elements.swapAt(index, elements.count - 1)
            defer {
                validateDown(from: index)
                validateUp(from: index)
            }
            return elements.removeLast()
        }
    }
    
    private mutating func validateUp(from index: Int) {
        var childIndex = index
        var parentIndex = self.parentIndex(ofChildAt: childIndex)
        
        while childIndex > 0 &&
            order(elements[childIndex], elements[parentIndex]) {
                elements.swapAt(childIndex, parentIndex)
                childIndex = parentIndex
                parentIndex = self.parentIndex(ofChildAt: childIndex)
        }
    }
    
/*
remove(at index: Int)：
     
首先判斷要移除的索引是否在數組範圍内
如果要移除的是最後一個元素，則直接移除
如果是其他位置的元素，首先跟最後一個元素調換位置，接著移除最後一個元素
最後從上下兩個方向進行驗證是否符合堆的特性
validateUp(from index: Int)：
     
因為是向上驗證，所以傳入的 index 是一個子節點的索引，首先獲得 parentIndex
在 while 循環的條件中，只有當子節點的索引存在，並且子節點的優先級高於父節點時，才需要調換子節點和父節點的值；
在循環裡面，先調換子節點和父節點的值，然後更新 childIndex 和 parentIndex 的值，進入下一次循環
*/

//插入元素：直接把插入的元素拼接到最後面，然後再向上驗證堆的合法性就可以了。
    mutating func insert(_ element: Element) {
        elements.append(element)
        validateUp(from: elements.count - 1)
    }
}


//搜尋元素
extension Heap {
    func index(of element: Element,
               searchingFrom index: Int = 0) -> Int? {
        if index >= count {
            return nil
        }
        if order(element, elements[index]) {
            return nil
        }
        if element == elements[index] {
            return index
        }
        
        let leftIndex = leftChildIndex(ofParentAt: index)
        if let i = self.index(of: element,
                              searchingFrom: leftIndex) {
            return i
        }
        
        let rightIndex = rightChildIndex(ofParentAt: index)
        if let i = self.index(of: element,
                              searchingFrom: rightIndex) {
            return i
        }
        
        return nil
    }
}
/*
首先判斷要查找的 index 是否在數組範圍内，如果不在，直接返回 nil
因為搜尋的實現要用到遞歸，所以方法中有一個 searchingFrom 參數，這個意思是告訴方法從哪個位置開始往後搜尋。
所以我们用 order(element, elements[index]) 判斷要查找的元素是否高於當前 index 對應元素的優先級，
如果是，那麼要查找的元素肯定不在後面，直接返回 nil
如果當前 index 對應的值等於要查找的值，則返回 index
從左分支用遞歸繼續查找，如果找到則返回對應的索引
從右分支用遞歸繼續查找，如果找到則返回對應的索引
以上步驟都沒有找到，說明要查找的元素不存在，返回 nil
*/
var heap = Heap<Int>(order: >)
for i in 1...7 {
    heap.insert(i)
}
print(heap)

// 结果
//[7, 4, 6, 1, 3, 2, 5]

//移除根部元素
while !heap.isEmpty {
    print(String(describing: heap.removePeek()))
}
// 结果
//Optional(7)
//Optional(6)
//Optional(5)
//Optional(4)
//Optional(3)
//Optional(2)
//Optional(1)

//移除任意元素
let index = heap.index(of: 3) ?? 0
print(String(describing: heap.remove(at: index)))
print(heap)

// 结果
//Optional(3)
//[7, 5, 6, 1, 4, 2]


/*

總結
 
堆(Heap)數據結構非常適合用來跟踪最大值或者最小值，
因為獲取 peek 的時間複雜度為 O(1)。
在搜尋性能方面，時間複雜度為O(n)，
比二叉搜尋樹的 O(log n) 要差很多。
另外堆的插入和移除的時間複雜度為 O(log n)。

*/
