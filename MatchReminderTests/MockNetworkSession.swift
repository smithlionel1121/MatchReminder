//
//  MockNetworkSession.swift
//  MatchReminderTests
//
//  Created by Lionel Smith on 08/08/2021.
//

import XCTest
@testable import MatchReminder

class MockNetworkSession: NetworkSession {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "MatchesResponse", withExtension: "json") else {
            XCTFail("missing file MatchesResponse.json")
            return MockNetworkTask()
        }
        let json = try! Data(contentsOf: url)
        completion(json, nil, nil)
        return MockNetworkTask()
    }
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        return MockNetworkTask()
    }
    
}


class MockNetworkTask: NetworkTask {
    func resume() {}
}
