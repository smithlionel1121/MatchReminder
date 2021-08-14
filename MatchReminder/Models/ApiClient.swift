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
    var resourceURL: URLComponents
    
    var path: String? {
        didSet {
            if let path = path {
                resourceURL.path = "/v2/" + path
            }
        }
    }
    
    var queryParams: [URLQueryItem]? {
        didSet {
            if let queryParams = queryParams {
                resourceURL.queryItems = queryParams
            }
        }
    }
    
    init(session: NetworkSession, resourcePath: String = "") {
        self.session = session
        
        guard let url = URLComponents(string: baseURL + resourcePath) else {
            fatalError()
        }
        
        resourceURL = url
    }
    
    func fetchResource<T>(completion: @escaping (Result<T, ApiError>) -> Void) where T: Decodable {
        guard let url = resourceURL.url else { return }
        
        var request = URLRequest(url: url)
        request.addValue(ApiKey, forHTTPHeaderField: "X-Auth-Token")
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            if let _ = error as? URLError {
                completion(.failure(.couldNotConnectToHost))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(.jsonError))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let resource = try jsonDecoder.decode(T.self, from: jsonData)
                completion(.success(resource))
            } catch {
                let bodyString = String(data: data!, encoding: .utf8)
                print("error \(String(describing: bodyString ))")
                completion(.failure(.serverError))
            }
            
        }
        dataTask.resume()
    }

}
