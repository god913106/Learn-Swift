import UIKit

func majorityElement(_ nums: [Int]) -> Int {
    
    guard nums.count > 0 else {
        return 0
    }
    
    var res:Int = 0
    var counts:Int = 0
    
    
    for n in nums
    {
        if counts == 0
        {
            res = n

            counts = 1
        }
            
        else if res == n
        {
            counts += 1
        }
            
        else
        {
            counts -= 1
        }
    }
    return res
}



