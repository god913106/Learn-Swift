import UIKit

/*

 二分搜索是高效搜索算法中的一員，時間複雜度為O(log n)。使用搜索算法前，需要滿足兩個條件：
 
 集合中的元素必須可以使用索引直接訪問，在 Swift 中，這個集合必須是RandomAccessCollection類型。
 集合中的元素必須是有序的
*/

// 實現
/*
 假設要查找的元素為 A，集合從小到大的順序排列，二分查找的步驟如下：
 
 首先找到中間元素
 拿 A與中間元素對比，如果 A 等于中間元素，直接返回索引，否则繼續下列步驟
 如果 A 小于中間元素，則用所有左邊元素组成的集合進行遞歸；如果 A 大于中間元素，則用所有有邊元素组成的集合進行遞歸
 實現代碼如下：

*/

extension RandomAccessCollection where Element: Comparable {
    func binarySearch(for value: Element,
                      in range: Range<Index>? = nil) -> Index? {
        
        let range = range ?? startIndex..<endIndex
        guard range.lowerBound < range.upperBound else { return nil }
        
        let size = distance(from: range.lowerBound, to: range.upperBound)
        let middle = index(range.lowerBound, offsetBy: size / 2)
        let middleValue = self[middle]
        
        if middleValue == value {
            return middle
            
        } else if value < middleValue {
            return binarySearch(for: value, in: range.lowerBound..<middle)
            
        } else {
            return binarySearch(for: value, in: middle..<range.upperBound)
        }
    }
    
}

//代碼解析
/*

(1)上面已經提到，要使用二分法的必須是 RandomAccessCollection 類型，
所以我们通過擴展這個協議來實現二分查找，並且 Element 必須是 Comparable
 
(2)因為我們要使用遞歸，所以方法中需要 range 參數
 
(3)定義 range 變量，如果 range 為空，則默認是原來數组的整個範圍
 
(4)判斷傳入的範圍中，是否包含至少一個元素，如果不包含直接返回 nil
 
(5)讀取中間元素的值
 
(6)中間元素和要查找的值進行對比，如果相等，直接返回中間索引；
 如果要查找的值小于中間元素，用左邊的範圍繼續查找；如果要查找的值大于中間元素，用右邊的範圍繼續查找

*/

let array = [0, 9, 13, 20, 21, 25, 35, 120, 250]

let indexOf = array.index(of: 20)
let binarySearchFor = array.binarySearch(for: 20)

print("index(of:): \(String(describing: indexOf))")
print("binarySearch(for:): \(String(describing: binarySearchFor))")

// 结果
//index(of:): Optional(3)
//binarySearch(for:): Optional(3)
