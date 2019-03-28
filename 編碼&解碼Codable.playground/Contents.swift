import UIKit

enum Gender: String , Codable {
    case Male = "Male" //男
    case Female = "Female" //女
}

class User: Codable {
    let name: String
    let age:Int
    let gender: Gender
    
    init(name:String, age:Int, gender:Gender) {
        self.name = name
        self.age = age
        self.gender = gender
    }
}

let userJsonString = """
{
"name": "Chris",
"age": 33,
"gender": "Male"
}
"""


//從JSON 解碼到 實例
if let userJSONData = userJsonString.data(using: .utf8) {
    let userDecode = try? JSONDecoder().decode(User.self, from: userJSONData)
    
    //Optional(__lldb_expr_10.User)
}


//從實例 編碼到 JSON
let userEncode = User(name: "Chris", age: 33, gender: .Male)
let userEncodedData = try? JSONEncoder().encode(userEncode)

//Optional(41 bytes)
