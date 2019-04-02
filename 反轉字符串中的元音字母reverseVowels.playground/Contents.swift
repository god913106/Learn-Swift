import UIKit

func reverseVowels(_ s: String) -> String {
    
    //應該先遍歷過每個字 放進array裡
    var array = Array(s)
    
    //還要知道這字串的多長   i = 0, j = array的count-1
    var i = 0, j = array.count - 1
    
    
    //設定指針 如果不是元音 (postion) i就+1 或 j就-1
    while i < j {
        if !isVowel(array[i]){
            i += 1
        }else if !isVowel(array[j]){
            j -= 1
        }else {
            //找到後 array[i] array[j] = array[i] array[j] 互換位置
            (array[i], array[j]) = (array[j], array[i])
            
            //再繼續找下一個
            i += 1
            j -= 1
        }
    }
    
    
    return String(array)
}


func isVowel(_ c:Character) -> Bool{
    //遇到"a","e","i","o","u",",A","E","I","O","U"
    switch c {
    case "a","e","i","o","u","A","E","I","O","U":
        return true
    default:
        return false
    }
}

reverseVowels("hello")
