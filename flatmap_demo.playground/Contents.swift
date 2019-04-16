import UIKit

// https://www.youtube.com/watch?v=EUtTU4lW2QI
// How to use compactMap

// Store

struct Store {
    
    let name: String
    let electronicHardware: [String]?
    
}

// find all of the electronic items sold in the area?

let target = Store(name: "Target", electronicHardware: [
    "iPhone", "iPad", "Flatscreen TVs"
    ])

let bestBuys = Store(name: "Best Buy", electronicHardware: [
    "Laptops", "Big Fridges"
    ])

let bedBathAndBeyond = Store(name: "Bed Bath & Beyond", electronicHardware: [])

//Value of optional type'[String]?' must be unwrapped to a value of type '[String]'
/*
 當struct 的electronicHardware: [String] 改成 electronicHardware: [String]?
 
 多了optional
 
 items的每個數組相加就無法使用，必須unwarpped
 
 但看看items2 items3 items4 就沒這樣的問題
 */

//let items = target.electronicHardware + bestBuys.electronicHardware + bedBathAndBeyond.electronicHardware
let items = target.electronicHardware! + bestBuys.electronicHardware! + bedBathAndBeyond.electronicHardware!

let items2 = [target, bestBuys, bedBathAndBeyond].map({$0.electronicHardware})

// 提醒 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
let items3 = [target, bestBuys, bedBathAndBeyond].flatMap({$0.electronicHardware})

// Swift4.1 引入了一個"新"函數 compactMap(_:)
// items4 經由 compactMap後的 只是先把三個數組相加，如果要過濾掉空數組，就要在後面加flatMap{&0}
let items4 = [target, bestBuys, bedBathAndBeyond].compactMap({$0.electronicHardware}).flatMap({$0})

print("items: \(items)")
// items: ["iPhone", "iPad", "Flatscreen TVs", "Laptops", "Big Fridges"]
print("items2 (map): \(items2)")
// items2 (map): [Optional(["iPhone", "iPad", "Flatscreen TVs"]), Optional(["Laptops", "Big Fridges"]), Optional([])]
print("items3 (flatMap): \(items3)")
// items3 (flatMap): [["iPhone", "iPad", "Flatscreen TVs"], ["Laptops", "Big Fridges"], []]
print("items4 (compactMap): \(items4)")
// items4 (compactMap): ["iPhone", "iPad", "Flatscreen TVs", "Laptops", "Big Fridges"]
