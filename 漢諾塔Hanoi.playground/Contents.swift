import UIKit

public class Stack<T>: CustomStringConvertible {
    
    private var container: [T] = [T]()
    
    public var description: String {return container.description}
    
    public func push(_ thing: T){return container.append(thing)}
    public func pop() -> T {return container.removeLast()}
    
}

/*
 (1)以塔c為終點，將上面的n-1個盤子從塔a移到塔b
 (2)將底部的盤子從塔a移到塔c
 (3)再將n-1個盤子從塔b移到塔c
 */
func hanoi(from: Stack<Int>, to: Stack<Int>, temp: Stack<Int>, n: Int) {
    if n == 1 {
        to.push(from.pop())  //只有一個盤子就直接從塔a到塔c
    }else {
        //遞歸
        hanoi(from: from, to: temp, temp: to, n: n-1)
        hanoi(from: from, to: to, temp: temp, n: 1)
        hanoi(from: temp, to: to, temp: from, n: n-1)
    }
}

var numDiscs = 3
var towerA = Stack<Int>()
var towerB = Stack<Int>()
var towerC = Stack<Int>()
for i in 1...numDiscs{
    towerA.push(i)
}


hanoi(from: towerA, to: towerC, temp: towerB, n: numDiscs)

print(towerA)
print(towerB)
print(towerC)
