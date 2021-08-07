//
//  ApiClient.swift
//  MatchReminder
//
//  Created by Lionel Smith on 23/07/2021.
//

import Foundation

class ApiClient {
    
    let session: URLSession
    let baseURL = "https://api.football-data.org/v2/"
    var resourceURL: URL
    
    init(session: URLSession, resourcePath: String?) {
        self.session = session
        
        guard let resourceURL = URL(string: baseURL) else {
            fatalError()
        }
        
        if let resourcePath = resourcePath {
            self.resourceURL = resourceURL.appendingPathComponent(resourcePath)
        } else {
            self.resourceURL = resourceURL
        }
        
    }
    
    func fetchResource<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        var request = URLRequest(url: resourceURL)
        request.addValue(ApiKey, forHTTPHeaderField: "X-Auth-Token")
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let jsonData = data {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let response = try? jsonDecoder.decode(T.self, from: jsonData) {
                    completion(.success(response))
                } else {
                    print("Failed")
                }
            
            }
        }
        dataTask.resume()
    }

}
