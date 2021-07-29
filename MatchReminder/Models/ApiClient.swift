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
}
