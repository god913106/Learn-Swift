import UIKit

//圖是由頂點和頂點之間邊組成的一種數據結構。
//A graph is a data structure consisting of edges between vertices and vertices.

//因為圖有頂點和邊組成，我們首先定義好頂點和邊。
//Because the graph has vertices and edges, we first define the vertices and edges.

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
/*
 Vertex 定義為泛型，index 為頂點被添加到圖中的先後順序，value 為頂點所包含的值。
 因為在後面的實現中，頂點要作為字典中的 key，所以實現了 Hashable 協議。
 最後實現了 CustomStringConvertible。
 */

//邊Edge
struct Edge<T> {
    let source: Vertex<T>  //邊的源頭
    let destination: Vertex<T> //邊的終點
    let weight: Double? //邊的權重
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

//鄰接表
final class AdjacencyList<T> {
    private var adjacencies: [Vertex<T>: [Edge<T>]] = [:]
    init() { }
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

//最後是實現了 CustomStringConvertible 協議，在打印的時候以這種格式顯示出來：頂點 --> [ 從頂點出發的所有終點 ]

let graph = AdjacencyList<String>()

let taiPei = graph.createVertex(value: "台北")
let taoYuan = graph.createVertex(value: "桃園")
let taiChung = graph.createVertex(value: "台中")
let taiNan = graph.createVertex(value: "台南")
let kaohSiung = graph.createVertex(value: "高雄")
let newYork = graph.createVertex(value: "紐約")

graph.addEdge(.undirected, from: taiPei, to: taoYuan, weight: 300)
graph.addEdge(.undirected, from: taiPei, to: taiChung, weight: 500)
graph.addEdge(.undirected, from: taoYuan, to: taiChung, weight: 700)
graph.addEdge(.undirected, from: taoYuan, to: taiNan, weight: 600)
graph.addEdge(.undirected, from: taiChung, to: taiNan, weight: 1000)
graph.addEdge(.undirected, from: taiChung, to: kaohSiung, weight: 200)
graph.addEdge(.undirected, from: taiNan, to: newYork, weight: 6000)
graph.addEdge(.undirected, from: kaohSiung, to: newYork, weight: 5000)

print(graph)

//結果
//0: 台北 --> [ 1: 桃園, 2: 台中 ]
//4: 高雄 --> [ 2: 台中, 5: 紐約 ]
//3: 台南 --> [ 1: 桃園, 2: 台中, 5: 紐約 ]
//2: 台中 --> [ 0: 台北, 1: 桃園, 3: 台南, 4: 高雄 ]
//1: 桃園 --> [ 0: 台北, 2: 台中, 3: 台南 ]
//5: 纽约 --> [ 3: 台南, 4: 高雄 ]
