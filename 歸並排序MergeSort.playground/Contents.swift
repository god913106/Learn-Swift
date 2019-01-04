import UIKit

// mergeSort方法：利用遞歸把數組分割到最小，然后調用 merge方法
func mergeSort<Element: Comparable>(_ array: [Element]) -> [Element] {
    guard array.count > 1 else {
        return array
    }
    let middle = array.count / 2
    let left = mergeSort(Array(array[..<middle]))
    let right = mergeSort(Array(array[middle...]))
    return merge(left, right)
}

private func merge<Element: Comparable>(_ left: [Element],
                                        _ right: [Element]) -> [Element] {
    var leftIndex = 0
    var rightIndex = 0
    var result: [Element] = []
    
    while leftIndex < left.count && rightIndex < right.count {
        let leftElement = left[leftIndex]
        let rightElement = right[rightIndex]
        
        if leftElement < rightElement {
            result.append(leftElement)
            leftIndex += 1
        } else if leftElement > rightElement {
            result.append(rightElement)
            rightIndex += 1
        } else {
            result.append(leftElement)
            leftIndex += 1
            result.append(rightElement)
            rightIndex += 1
        }
    }
    
    if leftIndex < left.count {
        result.append(contentsOf: left[leftIndex...])
    }
    if rightIndex < right.count {
        result.append(contentsOf: right[rightIndex...])
    }
    
    return result
}


/*
 merge方法：
 
 (1)leftIndex 和 rightIndex 記錄左右兩個子數組當前索引；result 用於存儲左右兩個子數組合並的结果
 (2)while 循環裡面，判斷當前左右子索引對應元素的大小，誰小就先把誰添加到 result 中，如果一樣大，两個都添加
 (3)while 循環结束後，如果左右子數組還有剩下的元素，則直接添加到最後面。
 
*/

let ints = [4,5,5467,73,234,678,87,989]
let sortedInts = mergeSort(ints)
print(sortedInts)

// 结果
//[4, 5, 73, 87, 234, 678, 989, 5467]
