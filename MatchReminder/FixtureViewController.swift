//
//  FixtureViewController.swift
//  MatchReminder
//
//  Created by Lionel Smith on 23/07/2021.
//

import UIKit

class FixtureViewController: UIViewController {
    
    let apiClient = ApiClient(session: URLSession.shared, resourcePath: "competitions/PL/matches")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFixtures()
    }
    
    func loadFixtures() {
        var request = URLRequest(url: apiClient.resourceURL)
        request.addValue(ApiKey, forHTTPHeaderField: "X-Auth-Token")
        
        let dataTask = apiClient.session.dataTask(with: request) { data, response, error in

            if let jsonData = data {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let response = try? jsonDecoder.decode(MatchesResponse.self, from: jsonData) {
                    print(response.matches[0])
                } else {
                    print("Failed")
                }
            
            }
        }
        dataTask.resume()
            
    }

}

