import UIKit
import Foundation
/*

廣度優先搜尋和深度優先搜尋是在圖的基礎上來討論的，都是圖頂點的遍歷方式。
下面我們一個個來研究一下。
*/

//頂點Vertex
struct Vertex<T> {
    let index: Int
    let value: T
}

extension Vertex: Hashable {
    var hashValue: Int {
        return index.hashValue
    }

    static func == (lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
        return lhs.index == rhs.index
    }
}

extension Vertex: CustomStringConvertible {
    var description: String {
        return "\(index): \(value)"
    }
}

//邊Edge
struct Edge<T> {
    let source: Vertex<T>  //邊的源頭
    let destination: Vertex<T> //邊的終點
    let weight: Double? //邊的權重
}
extension Edge: Equatable {
    static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        return lhs.source == rhs.source &&
            lhs.destination == rhs.destination &&
            lhs.weight == rhs.weight
    }
}

//Graph 協議
enum EdgeType {
    case directed //有向
    case undirected //無向
}
protocol Graph {
    associatedtype Element
    
    // 創建頂點
    func createVertex(value: Element) -> Vertex<Element>
    
    // 在兩個頂點中添加有向的邊
    func addDirectedEdge(from source: Vertex<Element>,
                         to destination: Vertex<Element>,
                         weight: Double?)
    
    // 在兩個頂點中添加無向的邊
    func addUndirectedEdge(between source: Vertex<Element>,
                           and destination: Vertex<Element>,
                           weight: Double?)
    
    // 根據邊的類型在兩個頂點中添加邊
    func addEdge(_ edge: EdgeType,
                 from source: Vertex<Element>,
                 to destination: Vertex<Element>,
                 weight: Double?)
    
    // 返回從某個頂點發出去的所有邊
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    
    // 返回從一個頂點到另個頂點的邊的權重
    func weight(from source: Vertex<Element>,
                to destination: Vertex<Element>) -> Double?
}

extension Graph {
    func addUndirectedEdge(between source: Vertex<Element>,
                           and destination: Vertex<Element>,
                           weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    func addEdge(_ edge: EdgeType,
                 from source: Vertex<Element>,
                 to destination: Vertex<Element>,
                 weight: Double?) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }
}


//請永遠記住：BFS的實現用循環(配合隊列)，DFS的實現用遞歸。

//BFS的實現用循環(配合隊列)
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

//DFS的實現用棧
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

//廣度優先搜尋
//廣度優先搜尋可以用來解決這些問題：1）生成最小生成樹；2）尋找頂點之間所有可能的路徑；3）尋找頂點之間的最短路徑。

extension Graph {
    func breathFirstSearch(from source: Vertex<Element>) -> [Vertex<Element>] {
        // 存儲即將遍歷的頂點
        var queue = Queue<Vertex<Element>>()
        // 存儲已經入隊的頂點
        var enqueued: Set<Vertex<Element>> = []
        // 存儲已經遍歷過的頂點
        var visited: [Vertex<Element>] = []
        
        queue.enqueue(source)
        enqueued.insert(source)
        
        while let vertex = queue.dequeue() { // 取出隊列的頂點
            visited.append(vertex)
            let neighborEdges = edges(from: vertex)
            for edge in neighborEdges
                where !enqueued.contains(edge.destination) {
                    // 把沒有入隊的鄰居加入隊列中
                    queue.enqueue(edge.destination)
                    enqueued.insert(edge.destination)
            }
        }
        
        return visited
    }
}








//深度優先搜尋
extension Graph {
    func depthFirstSearch(from source: Vertex<Element>) -> [Vertex<Element>] {
        // 存儲即將遍歷的頂點
        var stack = Stack<Vertex<Element>>()
        // 存儲已經入棧的頂點
        var pushed: Set<Vertex<Element>> = []
        // 存儲已經遍歷過的頂點
        var visited: [Vertex<Element>] = []
        
        stack.push(source)
        pushed.insert(source)
        visited.append(source)
        
        outer: while let vertex = stack.top { // 判斷棧頂的頂點是否為空
            let neighborEdges = edges(from: vertex)
            guard !neighborEdges.isEmpty else {
                // 如果當前頂點沒有鄰居，把棧頂頂點取出
                stack.pop()
                continue
            }
            for edge in neighborEdges {
                if !pushed.contains(edge.destination) { //  當前頂點的鄰居沒遍歷過
                    stack.push(edge.destination)
                    pushed.insert(edge.destination)
                    visited.append(edge.destination)
                    // 繼續執行外部的 while 循環，嘗試往更深的一層繼續遍歷
                    continue outer
                }
            }
            // 沒有其他沒有遍歷過的鄰居，把棧頂頂點取出
            stack.pop()
        }
        
        return visited
    }
}


