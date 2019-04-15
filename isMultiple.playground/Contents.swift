import UIKit

/*
 問題描述
 
 透過一個 fizzBuzz 函式，裡面代入參數 num：
 會輸出從 1 ~ num 的數值
 但若這個輸出的數值是 3 的倍數，則輸出 fizz
 但若這個輸出的數值是 5 的倍數，則輸出 buzz
 但若這個輸出的數值同時是 3 和 5 的倍數，則輸出 fizzBuzz
 
 */
// 1.How to solve FizzBuzz algorithm with new isMultiple(of: x) function?
// 2.Solve this like a PRO using a Switch Statement

// 1. 第1版
//(0...100).forEach { (num) in
//
//    if num % 0 == 0 {
//
//    }
////    使用 isMultiple 會讓上面這類 error 不再發生 不會造成崩潰
//
//    if num % 3 == 0 && num % 5 == 0 {
//
//        print("\(num): fizzbuzz")
//
//    }else if num % 3 == 0 {
//            print("\(num): fizz")
//    }else if num % 5 == 0 {
//            print("\(num): buzz")
//    }else {
//        print(num)
//    }
//
//}

// 2. 第2版
//(0...100).forEach { (num) in
//    if num.isMultiple(of: 0){
//
//    }
//
//    if num.isMultiple(of: 15){
//        print("\(num): fizzbuzz")
//    }else if num.isMultiple(of: 3){
//        print("\(num): fizz")
//    }else if num.isMultiple(of: 5){
//        print("\(num): buzz")
//    }else {
//        print(num)
//    }
//}

// 3. 第3版

//(0...100).forEach { (num) in
//    switch (num.isMultiple(of: 3) , num.isMultiple(of: 5)) {
//    case (true, true):
//        print("\(num): fizzbuzz")
//    case (true, false):
//        print("\(num): fizz")
//    case (false, true):
//        print("\(num): buzz")
//    default:
//        print(num)
//    }
//}

// 4. 第4版 best way of doing this

(0...100).forEach { (num) in
    
    switch num {
    case let x where x.isMultiple(of: 15):
        print("\(num): fizzbuzz")
    case let x where x.isMultiple(of: 3):
        print("\(num): fizz")
    case let x where x.isMultiple(of: 5):
        print("\(num): buzz")
    default:
        print(num)
    }
    
}
