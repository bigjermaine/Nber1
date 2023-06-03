//
//  ApiCaller.swift
//  Nber
//
//  Created by Apple on 02/06/2023.
//

import Foundation

class APICaller {
    
    
    static let shared = APICaller()
    
    
    private init() {}
    
    struct Constants {
        static let baseaAPIURL = "https://api.uber.com/v1.2/"
      
    }
    
    enum APIError:Error {
        case failedToGetData
    }
    
    enum HTTPMethod:String {
        case GET
        case POST
        case Delete
        
    }
    func createRequest(with url:URL?, type:HTTPMethod, completion: @escaping(URLRequest)-> Void) {
        AuthManager.shared.withvalidtoken { token in
            guard let apiURL = url else {return}
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            request.setValue("en_US", forHTTPHeaderField: "Accept-Language")
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpMethod = type.rawValue
            
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    public func getNewRelaseses(completion:@escaping((Result<String,Error>))-> Void ) {
        createRequest(with: URL(string:"https://api.uber.com/v1.2/products?latitude=37.7752315&longitude=-122.418075"), type: .GET) {  request in
            
            
            let tasks = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {return
                    completion(.failure(APIError.failedToGetData))
                }
                do {
                    
//                      let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
//                       completion(.success(result))
                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print(json)
                }catch {
                    completion(.failure(APIError.failedToGetData))
                    print(error.localizedDescription)
                }
            }
            tasks.resume()
          
        }
      
    }
    
}
