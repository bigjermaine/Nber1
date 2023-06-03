//
//  AuthManager.swift
//  Nber
//
//  Created by Apple on 02/06/2023.
//

import Foundation
import Firebase


struct Constants {
  static let clientID = "q0-yx9ufXgzONJZoTXm5ZpsRYkdH7SXR"
  static let sharedSecret = "NAu-4reof6FeycctNDgNTgPL5HJdviGRAkjUq-4v"
  static let tokenApiUrl = "https://login.uber.com/oauth/v2/token"
  
}


class AuthManager {
  
     static let  shared =  AuthManager()
    
    private var refreshingToken = false
    public var signedURL: URL? {
        let redirectuli = "https://www.iosacademy.io"
        let baseUrl = "https://login.uber.com/oauth/v2/authorize"
        let string = "\(baseUrl)?response_type=code&client_id=\(Constants.clientID)&redirect_uri=\(redirectuli)"
        return URL(string: string)
    }
    
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
      private var accessToken:String? {
          return   UserDefaults.standard.string(forKey: "access_token")
      }
    
    
    private var refreshToken:String? {
        return   UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    
    private var tokenExpirationDate:Date? {
        return  UserDefaults.standard.object(forKey:"expires_in") as? Date
    }
    
    
    
   public var shouldRefreshToken:Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
            
        }
        let currentDate = Date()
        let fiveMinutes:TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    private var onRefreshBlocks = [((String)-> Void)]()
    
     func withvalidtoken(completion:@escaping(String)->Void) {
        
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if  shouldRefreshToken {
            
            refreshIfNeeded { [weak self]  sucess in
                if let token = self?.accessToken,sucess {
                    completion(token)
                }
            }
            
            
        }else if let token = accessToken {
            completion(token)
        }
    }
    
    
   func refreshIfNeeded(completion:((Bool)->Void)?){
        guard !refreshingToken else {return}
        guard shouldRefreshToken else {
            completion?(true)
            return}

        guard let refreshToken =  self.refreshToken else {return}
        guard let url = URL(string:Constants.tokenApiUrl) else {return}
        
         refreshingToken = true
        var components = URLComponents()
        components.queryItems = [
        URLQueryItem(name: "grant_type", value: "refresh_token"),
        URLQueryItem(name: "refresh_token", value:refreshToken),
        
        
        
        ]
        var request = URLRequest(url: url)
       
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.sharedSecret
        let data = basicToken.data(using: .utf8)
        let base64String = data?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data , error == nil else {
                
                completion?(false)
                return}
            do {
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("sucess")
                self?.onRefreshBlocks.forEach{($0(result.access_token))}
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)

            }catch{
                completion?(false)
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    
    
    public func exchangeCodeForToken(code:String,completion:@escaping(Bool)->Void) {
        guard let url = URL(string:Constants.tokenApiUrl) else {return}
        
         
        var components = URLComponents()
        components.queryItems = [
        URLQueryItem(name: "grant_type", value: "authorization_code"),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "redirect_uri", value:"https://www.iosacademy.io"),
        
        
        
        ]
        var request = URLRequest(url: url)
       
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.sharedSecret
        let data = basicToken.data(using: .utf8)
        let base64String = data?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data , error == nil else {
                
                completion(false)
                return}
            do {
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
                
                let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                print("\(json)")
            }catch{
                completion(false)
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    
    
    private func cacheToken(result:AuthResponse) {
        UserDefaults().set(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults().set(refresh_token, forKey: "refresh_token")
        }
        UserDefaults().set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")
    }
    
    public func signOut(completion:(Bool)->Void) {
        UserDefaults().set(nil, forKey: "access_token")
     
        UserDefaults().set(nil, forKey: "refresh_token")
      
        UserDefaults().set(nil, forKey: "expires_in")
        completion(true)
    }
    ///Signin
    public  func signin(email:String,password:String,completion: @escaping (Bool) -> Void ) {
        
         Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                completion(false)
                return
            }
            UserDefaults.standard.set(email, forKey: "email")
            completion(true)
           
        }
    }
    
    
    ///Signup
   public func signup(email:String,password:String,completion: @escaping (Bool) -> Void ) {
        
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
                   guard error == nil else {
                   completion(false)
                return
            }
            UserDefaults.standard.set(email, forKey: "email")
            completion(true)
           
        }
    }
    //signout
    public func signout( completion: @escaping (Bool)-> Void ){
       
       do {
           try  Auth.auth().signOut()
           completion(true)
       }catch{
           completion(false)
       }
       
   }

}
