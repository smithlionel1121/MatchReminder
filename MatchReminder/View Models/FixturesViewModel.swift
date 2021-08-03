//
//  FixturesViewModel.swift
//  MatchReminder
//
//  Created by Lionel Smith on 30/07/2021.
//

import Foundation

class FixturesViewModel {
    let apiClient = ApiClient(session: URLSession.shared, resourcePath: "competitions/PL/matches")
    
    var matches: [Match]?

    init() {}
    
    func loadFixtures() {
        var request = URLRequest(url: apiClient.resourceURL)
        request.addValue(ApiKey, forHTTPHeaderField: "X-Auth-Token")
        
        let dataTask = apiClient.session.dataTask(with: request) { data, response, error in

            if let jsonData = data {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let response = try? jsonDecoder.decode(MatchesResponse.self, from: jsonData) {
                    self.matches = response.matches
                    print(response.matches[0])
                } else {
                    print("Failed")
                }
            
            }
        }
        dataTask.resume()
            
    }
}
