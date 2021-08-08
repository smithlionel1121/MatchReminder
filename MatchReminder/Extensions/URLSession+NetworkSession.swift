//
//  URLSession+NetworkSession.swift
//  MatchReminder
//
//  Created by Lionel Smith on 08/08/2021.
//

import Foundation

protocol NetworkTask {
    func resume()
}

extension URLSessionDataTask: NetworkTask {}

protocol NetworkSession {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
}

extension URLSession: NetworkSession {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        return dataTask(with: request, completionHandler: completion)
    }
    
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        return dataTask(with: url, completionHandler: completion)
    }
}

