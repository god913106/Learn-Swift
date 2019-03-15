import UIKit

class Rect {
    var width: Int = 10 {
        
        willSet {
            //新的寬不可能是0
            if newValue <= 0 {
                print("illegal value")
            }
        }
        
        didSet {
            if width <= 0 {
                width = oldValue
            }
        }
        
    }
    var height: Int = 10
}

var rect = Rect()

rect.width = -1
print("\(rect.width)") // illegal value

print("===================")

rect.width = 20
print("\(rect.width)")// 20


