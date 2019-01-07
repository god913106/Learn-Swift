import UIKit

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
final class AdjacencyList<T> {
    private var adjacencies: [Vertex<T>: [Edge<T>]] = [:]
    init() { }
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


extension AdjacencyList: Graph {
    func createVertex(value: T) -> Vertex<T> {
        let vertex = Vertex(index: adjacencies.count, value: value)
        adjacencies[vertex] = []
        return vertex
    }
    
    func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencies[source]?.append(edge)
    }
    
    func edges(from source: Vertex<T>) -> [Edge<T>] {
        return adjacencies[source] ?? []
    }
    
    func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
        return edges(from: source)
            .first { $0.destination == destination }?
            .weight
    }
}
extension AdjacencyList: CustomStringConvertible {
    var description: String {
        var result = ""
        for (vertex, edges) in adjacencies {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index < edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) --> [ \(edgeString) ]\n")
        }
        return result
    }
}
extension Graph {
    // 在兩個頂點中添加無向的邊，也就相當於在兩個頂點之間互相添加有向圖
    func addUndirectedEdge(between source: Vertex<Element>,
                           and destination: Vertex<Element>,
                           weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    // 根據邊的類型在兩個頂點中添加邊，可以直接根據邊的類型調用協議裡的其他方法來實現
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
extension Heap {
    mutating func removePeek() -> Element? {
        guard !isEmpty else { return nil }
        elements.swapAt(0, count - 1)
        
        return elements.removeLast()
    }
    
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else { return nil }
        
        if index == elements.count - 1 {
            return elements.removeLast()
        } else {
            elements.swapAt(index, elements.count - 1)
            
            return elements.removeLast()
        }
    }
    
    mutating func insert(_ element: Element) {
        elements.append(element)
    }
}

extension Heap: CustomStringConvertible {
    var description: String {
        return elements.description
    }
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


//Dijkstra算法，中文叫迪克斯特拉算法，在地圖中尋找兩個地點之間的最短或者最快路徑非常有用。
//迪克斯特拉算法是一個貪婪算法，也就是在處理過程中每一步都選擇最佳路徑。
//在實現過程中，我們要用到優先隊列，這裡我們用最小優先隊列，這樣每次從隊列中取出的元素都是目前總權重最小的頂點。

enum Visit<T: Hashable> {
    case start // 頂點是起點
    case edge(Edge<T>) // 頂點關聯著通往它的邊
}

class Dijkstra<T: Hashable> {
    typealias Graph = AdjacencyList<T>
    
    let graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }
    
    /// 找出從某個頂點開始的所有路徑
    func paths(from start: Vertex<T>) -> [Vertex<T>: Visit<T>] {
        // 用一個字典來記錄每一步的數據，
        // key 是頂點，value 是頂點類型或者是關聯著通往這個頂點的邊
        var paths: [Vertex<T>: Visit<T>] = [start: .start]
        // 創建最小優先隊列，`order` 閉包隊列中元素排序的條件，總權重最小的優先
        var priorityQueue = PriorityQueue<Vertex<T>>(order: {
            self.distance(to: $0, with: paths) <
                self.distance(to: $1, with: paths)
        })
        priorityQueue.enqueue(start)
        
        while let vertex = priorityQueue.dequeue() { // 取出隊列當前最小權重的頂點
            for edge in graph.edges(from: vertex) { // 遍歷從這個頂點出發的邊
                guard let weight = edge.weight else {
                    continue
                }
                // 如果邊的終點不在字典中，
                // 或者從當前頂點出發達到邊的終點總權重小於之前的路徑，
                // 更新路徑，並把鄰居加入到隊列中
                if paths[edge.destination] == nil ||
                    distance(to: vertex, with: paths) + weight <
                    distance(to: edge.destination, with: paths) {
                    
                    paths[edge.destination] = .edge(edge)
                    priorityQueue.enqueue(edge.destination)
                }
            }
        }

        return paths
    }
    
    /// 根據記錄著每一步數據的字典，找到到達某個終點的最小路徑，
    // 返回由邊組成的有序數組
    func shortestPath(to destination: Vertex<T>,
                      with paths: [Vertex<T>: Visit<T>]) -> [Edge<T>] {
        var vertex = destination
        var path: [Edge<T>] = []
        while let visit = paths[vertex], case .edge(let edge) = visit {
            path = [edge] + path
            vertex = edge.source
        }
        return path
    }
    
    // MARK: - Private
    
    // 根据记录着每一步数据的字典中的数据，计算到达某一个终点的总权重
    private func distance(to destination: Vertex<T>,
                          with paths: [Vertex<T>: Visit<T>]) -> Double {
        let path = shortestPath(to: destination, with: paths)
        return path.compactMap { $0.weight }
            .reduce(0, +)
    }
}

let graph = AdjacencyList<String>()

let a = graph.createVertex(value: "A")
let b = graph.createVertex(value: "B")
let c = graph.createVertex(value: "C")
let d = graph.createVertex(value: "D")
let e = graph.createVertex(value: "E")
let f = graph.createVertex(value: "F")
let g = graph.createVertex(value: "G")
let h = graph.createVertex(value: "H")

graph.addDirectedEdge(from: a, to: b, weight: 1)
graph.addDirectedEdge(from: a, to: d, weight: 9)
graph.addDirectedEdge(from: a, to: c, weight: 2)
graph.addDirectedEdge(from: b, to: d, weight: 2)
graph.addDirectedEdge(from: c, to: d, weight: 8)
graph.addDirectedEdge(from: c, to: f, weight: 5)
graph.addDirectedEdge(from: d, to: g, weight: 9)
graph.addDirectedEdge(from: d, to: e, weight: 7)
graph.addDirectedEdge(from: e, to: d, weight: 5)
graph.addUndirectedEdge(between: e, and: f, weight: 4)
graph.addDirectedEdge(from: e, to: h, weight: 3)

let dijkstra = Dijkstra(graph: graph)
let pathsFromA = dijkstra.paths(from: a)
let path = dijkstra.shortestPath(to: e, with: pathsFromA)
for edge in path {
    print("\(edge.source) -- \(edge.weight ?? 0) -- > \(edge.destination)")
}

// 结果
//0: A -- 1.0 --> 1: B
//1: B -- 2.0 --> 3: D
//3: D -- 7.0 --> 4: E
