import UIKit

func quickSort(_ array: [Int]) -> [Int]{
    
    guard array.count > 1 else {
        return array
    }
    
    let pivot = array[array.count / 2]
    let left = array.filter { $0 < pivot }
    let mid = array.filter { $0 == pivot }
    let right = array.filter { $0 > pivot }
    
    
    return quickSort(left) + mid + quickSort(right)
}

var list = [13, 2, 5, 8, 10, 32, 10]

quickSort(list)
print("\(quickSort(list))")
//結果 [2, 5, 8, 10, 10, 13, 32]
