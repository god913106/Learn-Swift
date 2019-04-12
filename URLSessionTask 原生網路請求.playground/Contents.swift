import UIKit

struct Course: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
    let number_of_lessons: Int
}

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
