//
//  ApiClient.swift
//  MatchReminder
//
//  Created by Lionel Smith on 23/07/2021.
//

import Foundation

class ApiClient {
    
    let session: NetworkSession
    let baseURL = "https://api.football-data.org/v2/"
    var resourceURL: URL
    
    var path: String? {
        didSet {
            if let path = path, let url = URL(string: baseURL)?.appendingPathComponent(path) {
                resourceURL = url
            }
        }
    }
    
    init(session: NetworkSession, resourcePath: String?) {
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
                    if let error = error {
                        completion(.failure(error))
                    }
                    print("Failed")
                }
            
            }
        }
        dataTask.resume()
    }

}
