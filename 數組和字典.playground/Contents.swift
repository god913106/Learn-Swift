import UIKit

var persons = ["Lebron", "Love", "JR", "Korver"]

persons[0]
persons.append("Chris")
print(persons)


/*
 數組 O(n) append的元素都會在最後一位
 */

var dict = ["雪碧": 10, "可樂": 10]

// 插入新元素
dict["薯片"] = 10
print(dict)

/*
 字典的元素是無序的，也不能插入到指定的位置；字典中的鍵必須遵循Hashable。
 
 因為是無序的，所有新元素插入到字典中所有的時間是常量時間O(1)。
 */
