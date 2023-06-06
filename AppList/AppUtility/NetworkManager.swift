//
//  NetworkManager.swift
//  AppList
//
//  Created by iOS on 13/01/23.
//

import Foundation

enum UserError:Error{
    case NoDataAvailable
    case CanNotProcessData
}


class NetworkManager  {
    
    static let shared = NetworkManager()
    let session = URLSession.shared
    
    let strUrl = "https://itunes.apple.com/us/rss/toppaidapplications/limit=200/json"
    
    func getAppDlist<T: Decodable>(for: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        let requestUrl = URL(string: strUrl)!
        
    
        let task = session.dataTask(with: requestUrl){ (data, response, error) in

            guard let data = data else {
                completion(.failure(error!))
                return
            }

            let result = Result {
                try JSONDecoder().decode(T.self, from: data)
            }
            completion(result)
        }
        task.resume()
    }

    
}

