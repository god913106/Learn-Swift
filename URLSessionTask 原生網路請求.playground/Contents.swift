import UIKit

struct Course: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    let number_of_lessons: Int
}

// completion handler 必須標明 @escaping，因為它總是在api請求之後才執行，也就是說方法已經返回了才completion handler，經典的逃逸閉包

func fetchCoursesJson(completion: @escaping (Result<[Course],Error>) -> ()){
    
    let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses"
    
    guard let url = URL(string: urlString) else {
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
        
        //請求失敗
        if let err = err {
            completion(.failure(err))
        }
        
        //請求成功
        do{
            
            let courses = try JSONDecoder().decode([Course].self, from: data!)
            completion(.success(courses))
            
        }catch let jsonError{
            completion(.failure(jsonError))
        }
        
    }.resume()
}

fetchCoursesJson { (result) in
    
    switch result {
    case .success(let courses):
        courses.forEach({ (course) in
            print(course.name)
        })
        
    case .failure(let error):
        print("failed", error)
    }
    
}

/*
 
 URLSessionTask 原生網路請求
 
 (1) 產生URLSessionTask 物件。
 
 (2) URLSessionTask 呼叫 resume() ，開始下載或上傳資料。
 
 一定要記得呼叫resume()，URLSessionTask才會開始下載或上傳資料。
 所以順利的網路請求都是resume()開始任務，然後等任務完成時，才會執行當初產生task時傳入的closure{}程式碼。
 
 可以把產生 URLSessionTask 物件 想成產生一個下載或上傳資料的任務。
 但它只是產生任務，並沒有開始執行，要等到呼叫 resume() 才會開始執行這個任務。
 
 */

